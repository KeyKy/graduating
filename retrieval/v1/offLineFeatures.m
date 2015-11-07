function offLineFeatures(path)
% path 投影图图片的绝对路径

%提取特征
BASE_PATH = 'D:\\projections\\test\\';
[total_feats, total_articu_cont, total_n_contsamp, total_n_contsamp_of_conn_cont_mat, total_filesName, multiContour] = genFeatBatch(BASE_PATH); % calc feats

%saveInDatabase(total_feats, total_articu_cont, total_n_contsamp,total_filesName); % save in database

%save 'E:\\graduating\\data\\total_feats.mat' total_feats  %save in matrix
%save 'E:\\graduating\\data\\total_n_contsamp.mat' total_n_contsamp
%save 'E:\\graduating\\data\\total_n_contsamp_of_conn_cont_mat.mat' total_n_contsamp_of_conn_cont_mat
%save 'E:\\graduating\\data\\total_filesName.mat' total_filesName
%save 'E:\\graduating\\data\\multiContour.mat' multiContour


if 0
%降维 
disp('begin reduction');
load 'E:\\graduating\\data\\total_feats.mat' total_feats %load from matrix
load 'E:\\graduating\\data\\total_n_contsamp.mat' total_n_contsamp
load 'E:\\graduating\\data\\total_n_contsamp_of_conn_cont_mat.mat' total_n_contsamp_of_conn_cont_mat
load 'E:\\graduating\\data\\total_filesName.mat' total_filesName

designMatrix = total_feats'; 
options.PCARatio = 0.7;
[reducedDesignMatrix,eigvector] = dimReduction(designMatrix, 'pca', options);

save 'E:\\graduating\\data\\eigvector.mat' eigvector %save transformation

disp('begin clustring'); % k-means
methodName = 'kmeans-euclidean'; parms{1} = 8; clusterDesignMatrix = reducedDesignMatrix;
%methodName = 'kmeans-cosine'; parms{1} = 8; parms{2} = 'distance'; parms{3} = 'cosine'; clusterDesignMatrix = reducedDesignMatrix;
[dictionary, assignment, others] = runClusterMethod(clusterDesignMatrix, methodName, parms); %for kmeans others={smud, D};

%disp('begin evaluate');
%evaluateCluster(clusterDesignMatrix, assignment); % need evalution cluster method

save 'E:\\graduating\\data\\dictionary.mat' dictionary 
save 'E:\\graduating\\data\\assignment.mat' assignment 

%形成词袋模型
disp('begin BOF');
load 'E:\\graduating\\data\\dictionary.mat' dictionary 
load 'E:\\graduating\\data\\assignment.mat' assignment 
[histograms] = genBOFBatch(dictionary, assignment, total_n_contsamp, total_n_contsamp_of_conn_cont_mat); % bag-of-feature

disp('save in table model');
saveFeatureInDatabase(histograms,total_filesName);
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

for i = 3 : length(files)
    projImgPath = sprintf('%s%s', path, files(i).name);
    disp(files(i).name);
    total_filesName{end+1} = files(i).name;
    
    %特征提取包括三部分预处理、采样点提取、特征提取
    [image, boundImg, rescaleImg, rescaleBinaryImg, fixExpandImg, filledFixExpandImg] = preprocessProjImage(projImgPath, imgEdgeLength);
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
        disp(sprintf('%s%s%s','the length of the_n_contsamp_of_conn_cont_mat ', files(i).name, ' is not equal to 1'));
        multiContour{end+1} = files(i).name;
    end
end
end

function [histograms] = genBOFBatch(center, assignment, total_n_contsamp, total_n_contsamp_of_conn_cont_mat)
start = 1; histograms = {};
for i = 1 : size(total_n_contsamp,2)
    [the_histogram] = quantify(center, assignment(start:start+total_n_contsamp(i)-1));
    start = start + total_n_contsamp(i);
    histograms{end+1} = the_histogram;
end
end