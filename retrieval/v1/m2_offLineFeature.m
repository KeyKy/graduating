function m2_offLineFeature()

basePath = 'F:\projections\BOF\';
classes = dir(basePath);
for i = 3 : length(classes)
    className = classes(i).name;
    [total_feats, total_articu_cont, total_n_contsamp, ...
        total_n_contsamp_of_conn_cont_mat, total_filesName, multiContour] = genFeatBatchSingleFolder(basePath, className);
end

if 0
load 'F:\\graduating\\basePlate_data\\total_feats.mat' total_feats; %load from matrix
load 'F:\graduating\basePlate_data\total_n_contsamp.mat' total_n_contsamp;


disp('begin reduction');
designMatrix = total_feats'; 
options.PCARatio = 0.7;
[reducedDesignMatrix,eigvector] = dimReduction(designMatrix, 'pca', options);
save 'F:\\graduating\\basePlate_data\\eigvector.mat' eigvector %save transformation


%reducedDesignMatrix = total_feats';
disp('begin clustring'); % k-means
methodName = 'kmeans-euclidean'; parms{1} = 25; clusterDesignMatrix = reducedDesignMatrix;
[dictionary, assignment, others] = runClusterMethod(clusterDesignMatrix, methodName, parms);
save 'F:\\graduating\\basePlate_data\\dictionary.mat' dictionary 
save 'F:\\graduating\\basePlate_data\\assignment.mat' assignment 

disp('begin BOF');
load 'F:\\graduating\\basePlate_data\\assignment.mat' assignment 
load 'F:\\graduating\\basePlate_data\\dictionary.mat' dictionary
[histograms] = genBOFBatch(dictionary, assignment, total_n_contsamp); % bag-of-feature
save 'F:\\graduating\\basePlate_data\\histograms.mat' histograms
end
end

function [total_feats, total_articu_cont, total_n_contsamp, total_n_contsamp_of_conn_cont_mat, total_filesName, multiContour] = genFeatBatch(path)
files = dir(path);
globalVar;
sample_step = SAMPLE_STEP;
imgEdgeLength = IMAGE_EDGE_LENGTH;

total_filesName = {};
total_feats = [];
total_n_contsamp = [];
total_n_contsamp_of_conn_cont_mat = {};
total_articu_cont = [];
multiContour = {};
total_struct = {};

for i = 3 : length(files)
    projImgPath = sprintf('%s%s', path, files(i).name);
    total_filesName{end+1} = files(i).name; 
    disp(files(i).name);
    
    %特征提取包括三部分预处理、采样点提取、特征提取
    %[image, boundImg, rescaleImg, rescaleBinaryImg, fixExpandImg, filledFixExpandImg] = preprocessProjImage(projImgPath, imgEdgeLength);
    fixExpandImgPath = sprintf('%s%s',FIX_BASE_PATH,files(i).name); filledFixExpandImgPath = projImgPath;
    fixExpandImg = imread(fixExpandImgPath); filledFixExpandImg = imread(filledFixExpandImgPath);
    perimeter = bwperim(filledFixExpandImg);  boundries = bwboundaries(perimeter, 'noholes'); %boundries是N-by-2的数据结构，其中列1是行号，列2是列号
    [eight_conn_pixel_points, n_points_each_boundry] = extBdPoints(boundries); % eight_conn_pixel_points是N-by-2的数据结构，其中列1是列号，列2是行号
    
    [Contours, the_articu_cont, the_n_contsamp, the_n_contsamp_of_conn_cont_mat, adjacencyList] = downSampleContour(filledFixExpandImg, sample_step);
    the_articu_cont(:,2) = imgEdgeLength - the_articu_cont(:,2); %将坐标系转为图像的坐标系，左上角为原点，the_articu_cont原本是N-by-2的数据结构，其中第2列是坐标y
    [the_feats, the_FCC_feats] = extractFeature(the_articu_cont, eight_conn_pixel_points, n_points_each_boundry, fixExpandImg);
    
    total_feats = [total_feats the_feats];
    total_articu_cont = [total_articu_cont the_articu_cont'];
    total_n_contsamp = [total_n_contsamp the_n_contsamp];
    total_n_contsamp_of_conn_cont_mat{end+1} = the_n_contsamp_of_conn_cont_mat;
    if length(the_n_contsamp_of_conn_cont_mat) ~= 1
        %disp(sprintf('%s%s%s','the length of the_n_contsamp_of_conn_cont_mat ', files(i).name, ' is not equal to 1'));
        multiContour{end+1} = files(i).name;
    end
    modelStrut.the_feats = the_feats;
    modelStrut.the_fileName = files(i).name;
    modelStrut.the_articu_cont = the_articu_cont';
    modelStrut.the_n_contsamp = the_n_contsamp;
    modelStrut.the_n_contsamp_of_conn_cont_mat = the_n_contsamp_of_conn_cont_mat;
    total_struct{end+1} = modelStrut;
end

save 'F:\\graduating\\boat_data\\total_feats.mat' total_feats  %save in matrix
save 'F:\\graduating\\boat_data\\total_n_contsamp.mat' total_n_contsamp
save 'F:\\graduating\\boat_data\\total_n_contsamp_of_conn_cont_mat.mat' total_n_contsamp_of_conn_cont_mat
save 'F:\\graduating\\boat_data\\total_filesName.mat' total_filesName
save 'F:\\graduating\\boat_data\\multiContour.mat' multiContour
save 'F:\\graduating\\boat_data\\total_struct.mat' total_struct

end

function [total_feats, total_articu_cont, total_n_contsamp, total_n_contsamp_of_conn_cont_mat, total_filesName, multiContour] = genFeatBatchSingleFolder(base_path, className)
path = sprintf('%s%s\\', base_path, className);
files = dir(path);
globalVar;
sample_step = SAMPLE_STEP;
imgEdgeLength = IMAGE_EDGE_LENGTH;

total_filesName = {};
total_feats = [];
total_n_contsamp = [];
total_n_contsamp_of_conn_cont_mat = {};
total_articu_cont = [];
multiContour = {};
total_struct = {};

for i = 3 : length(files)
    projImgPath = sprintf('%s%s', path, files(i).name);
    
    total_filesName{end+1} = files(i).name;
    disp(files(i).name);
    %特征提取包括三部分预处理、采样点提取、特征提取
    %[image, boundImg, rescaleImg, rescaleBinaryImg, fixExpandImg, filledFixExpandImg] = preprocessProjImage(projImgPath, imgEdgeLength);
    fixExpandImgPath = sprintf('%s%s',FIX_BASE_PATH,files(i).name); filledFixExpandImgPath = projImgPath;
    fixExpandImg = imread(fixExpandImgPath); filledFixExpandImg = imread(filledFixExpandImgPath);
    perimeter = bwperim(filledFixExpandImg);  boundries = bwboundaries(perimeter, 'noholes'); %boundries是N-by-2的数据结构，其中列1是行号，列2是列号

    [eight_conn_pixel_points, n_points_each_boundry] = extBdPoints(boundries); % eight_conn_pixel_points是N-by-2的数据结构，其中列1是列号，列2是行号

    [Contours, the_articu_cont, the_n_contsamp, the_n_contsamp_of_conn_cont_mat, adjacencyList] = downSampleContour(filledFixExpandImg, sample_step);
    the_articu_cont(:,2) = imgEdgeLength - the_articu_cont(:,2); %将坐标系转为图像的坐标系，左上角为原点，the_articu_cont原本是N-by-2的数据结构，其中第2列是坐标y
    [the_feats] = extractFeature(the_articu_cont, eight_conn_pixel_points, n_points_each_boundry, fixExpandImg);
    
    total_feats = [total_feats the_feats];
    total_articu_cont = [total_articu_cont the_articu_cont'];
    total_n_contsamp = [total_n_contsamp the_n_contsamp];
    total_n_contsamp_of_conn_cont_mat{end+1} = the_n_contsamp_of_conn_cont_mat;
    if length(the_n_contsamp_of_conn_cont_mat) ~= 1
        %disp(sprintf('%s%s%s','the length of the_n_contsamp_of_conn_cont_mat ', files(i).name, ' is not equal to 1'));
        multiContour{end+1} = files(i).name;
    end
    modelStrut.the_feats = the_feats;
    modelStrut.the_fileName = files(i).name;
    modelStrut.the_articu_cont = the_articu_cont';
    modelStrut.the_n_contsamp = the_n_contsamp;
    modelStrut.the_n_contsamp_of_conn_cont_mat = the_n_contsamp_of_conn_cont_mat;
    
    total_struct{end+1} = modelStrut;
end
folderName = sprintf('%s%s_data\\','F:\\graduating\\',className);
mkdir(folderName);
save (sprintf('%s%s',folderName,'total_feats.mat'), 'total_feats');  %save in matrix
save (sprintf('%s%s',folderName,'total_n_contsamp.mat'), 'total_n_contsamp');
save (sprintf('%s%s',folderName,'total_n_contsamp_of_conn_cont_mat.mat'), 'total_n_contsamp_of_conn_cont_mat');
save (sprintf('%s%s',folderName,'total_filesName.mat'), 'total_filesName');
save (sprintf('%s%s',folderName,'multiContour.mat'), 'multiContour');
save (sprintf('%s%s',folderName,'total_struct.mat'), 'total_struct');


end

function [histograms] = genBOFBatch(center, assignment, total_n_contsamp)
start = 1; histograms = {};
for i = 1 : size(total_n_contsamp,2)
    [the_histogram] = quantify(center, assignment(start:start+total_n_contsamp(i)-1));
    start = start + total_n_contsamp(i);
    histograms{end+1} = the_histogram;
end
end