function M3_onLineRetrieval( sketchOrPath, strokeSeq )
% 输入手绘图，检索的是basePlate下的投影图，用的字典也是根据basePlate_data中生成的，这样的做法已经废弃
if ~exist('sketchOrPath', 'var')
    sketchOrPath = 'F:\sketch\inputForTest\animal\m109_kangyang_0.png';
    fid = fopen('F:\sketch\inputForTest\animal\m109_kangyang_0.txt');
    strokeSeq = fgetl(fid);
    fclose(fid);
end

if isstr(sketchOrPath)
    [~,~,sketch] = imread(sketchOrPath);
end

load 'F:\\graduating\\basePlate_data\\dictionary.mat' dictionary 
load 'F:\\graduating\\basePlate_data\\eigvector.mat' eigvector 
load 'F:\\graduating\\basePlate_data\\histograms.mat' histograms
load 'F:\\graduating\\basePlate_data\\total_filesName.mat' total_filesName

image = csToMatlab(sketch);
boundImg = imageBoxBounding(image);
rescaleImg = imageResizeWithNearest(boundImg);
rescaleBinaryImg = imageRescaledBinaryzation(rescaleImg, 0.8);
fixExpandImg = imageBoundaryExpandFixSize(rescaleBinaryImg, 200, 200);

Contours = downSampleSketCont(strokeSeq);
[sket_articu_cont, sket_n_contsamp, sket_n_contsamp_of_conn_cont_mat, sket_adjacencyList, sket_cont] = articulateSketContour(Contours, 5);
plot(sket_articu_cont(:,1), sket_articu_cont(:,2), '.');

[sket_feats] = extractFeature(sket_articu_cont);

reduced_sket_feats = sket_feats' * eigvector;
%reduced_sket_feats = sket_feats';
[sket_histogram] = assign_(dictionary, reduced_sket_feats);

distance = []; options.method = 'euclidean';
for model_idx = 1 : length(histograms)
    distance = [distance calcDist(histograms{model_idx}', sket_histogram, options)];
end
[score, sorted_m_distance_idx_arr] = sort(distance, 'ascend');
sorted_m_name_cells = total_filesName(sorted_m_distance_idx_arr);
figure(2);
for i = 1 : 25
    subplot(5,5,i); img = imread(sprintf('%s%s','F:\projections\filledFixExpandImg\',sorted_m_name_cells{i})); imshow(img);
end
end

