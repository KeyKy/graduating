function [ rank ] = onLineRetrieval( sketchOrPath )
if ~exist('sketchOrPath', 'var')
    sketchOrPath = 'E:\graduating\data\sket1.png';
end

if isstr(sketchOrPath)
    [~,~,sketch] = imread(sketchOrPath);
end

load 'E:\\graduating\\data\\dictionary.mat' dictionary 
load 'E:\\graduating\\data\\eigvector.mat' eigvector 

conn = database('SDDB', 'kangy1', '123456');
if strcmp(conn.AutoCommit, 'on') ~= 1         % 如果未正常连接，则报错并终止程序
    error('DB Not Connected: conn.Message = %s!',conn.Message);
end

models = {};
model_sql_str = sprintf('select * from SDDB.dbo.model');
model_curs = exec(conn, model_sql_str);
model_curs = fetch(model_curs);
for model_idx = 1 : size(model_curs.data, 1)
    model_row = model_curs.data(model_idx, :);
    modelStruct.fileName = strtrim(cell2mat(model_row(2)));
    modelStruct.viewName = strtrim(cell2mat(model_row(3)));
    
    bofFeatStr = cell2mat(model_row(4));
    splited = splitStr(bofFeatStr, ',');
    bofFeat = [];
    for feat_idx = 1 : length(splited)
        bofFeat = [bofFeat str2num(splited{feat_idx})];
    end
    modelStruct.bofFeat = bofFeat;
    
    modelStruct.score = cell2mat(model_row(5));
    models{end+1} = modelStruct;
end
close(conn);

image = csToMatlab(sketch);
boundImg = imageBoxBounding(image);
rescaleImg = imageResizeWithNearest(boundImg);
rescaleBinaryImg = imageRescaledBinaryzation(rescaleImg, 0.8);
fixExpandImg = imageBoundaryExpandFixSize(rescaleBinaryImg, 200, 200);
filledFixExpandImg = bwfill(fixExpandImg, 'holes');
reverseFilledFixExpandImg = 1 - filledFixExpandImg;

[sket_contours, sket_articu_cont, sket_n_contsamp, sket_n_contsamp_of_conn_cont_mat, sket_adjacencyList] = downSampleContour(filledFixExpandImg, 10);
[sket_feats] = extractFeature(sket_articu_cont);
reduced_sket_feats = sket_feats' * eigvector;
[sket_histogram] = assign_(dictionary, reduced_sket_feats);

distance = []; options.method = 'cosine';
for model_idx = 1 : length(models)
    distance = [distance calcDist(models{model_idx}.bofFeat, sket_histogram, options)];
end

[~, sorted_m_distance_idx_arr] = sort(distance, 'ascend');
sorted_m_name_cells = models(sorted_m_distance_idx_arr);
rank = cell(0,1);
for model_idx = 1 : length(models)
    rank{end+1,1} = sprintf('%s_%s', sorted_m_name_cells{model_idx}.fileName, ...
                                    sorted_m_name_cells{model_idx}.viewName);
end

end

