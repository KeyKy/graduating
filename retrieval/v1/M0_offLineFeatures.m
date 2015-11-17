function M0_offLineFeatures(path)
% path 投影图图片的绝对路径
if 0
%提取特征
BASE_PATH = 'F:\\projections\\filledFixExpandImg\\';
[total_feats, total_articu_cont, total_n_contsamp, total_n_contsamp_of_conn_cont_mat, total_filesName, multiContour] = genFeatBatch(BASE_PATH); % calc feats

%saveInDatabase(total_feats, total_articu_cont, total_n_contsamp,total_filesName); % save in database

save 'F:\\graduating\\data\\total_feats.mat' total_feats  %save in matrix
save 'F:\\graduating\\data\\total_n_contsamp.mat' total_n_contsamp
save 'F:\\graduating\\data\\total_n_contsamp_of_conn_cont_mat.mat' total_n_contsamp_of_conn_cont_mat
save 'F:\\graduating\\data\\total_filesName.mat' total_filesName
save 'F:\\graduating\\data\\multiContour.mat' multiContour
end
 


load 'F:\\graduating\\data\\total_feats_800.mat' total_feats; %load from matrix
%load 'F:\\graduating\\data\\total_n_contsmp_800.mat' total_n_contsamp
%load 'F:\\graduating\\data\\total_n_contsamp_of_conn_cont_mat_800.mat' total_n_contsamp_of_conn_cont_mat
%load 'F:\\graduating\\data\\total_filesName_800.mat' total_filesName


%降维
disp('begin reduction');
designMatrix = total_feats'; 
options.PCARatio = 0.9;
[reducedDesignMatrix,eigvector] = dimReduction(designMatrix, 'pca', options);

save 'F:\\graduating\\data\\eigvector.mat' eigvector %save transformation


disp('begin clustring'); % k-means
methodName = 'kmeans-euclidean'; parms{1} = 20; clusterDesignMatrix = reducedDesignMatrix;
%methodName = 'kmeans-cosine'; parms{1} = 8; parms{2} = 'distance'; parms{3} = 'cosine'; clusterDesignMatrix = reducedDesignMatrix;
[dictionary, assignment, others] = runClusterMethod(clusterDesignMatrix, methodName, parms); %for kmeans others={smud, D};

%disp('begin evaluate');
%evaluateCluster(clusterDesignMatrix, assignment); % need evalution cluster method

save 'F:\\graduating\\data\\dictionary.mat' dictionary 
save 'F:\\graduating\\data\\assignment.mat' assignment 


%形成词袋模型

disp('begin BOF');
load 'F:\\graduating\\data\\dictionary.mat' dictionary
stru_a = load('F:\\graduating\\data\\total_feats.mat');
full_total_feats = stru_a.total_feats;
stru_b = load('F:\\graduating\\data\\total_filesName.mat');
full_total_filesName = stru_b.total_filesName;
stru_c = load('F:\\graduating\\data\\total_n_contsamp.mat');
full_total_n_contsamp = stru_c.total_n_contsamp;
load 'F:\\graduating\\data\\eigvector.mat' eigvector
%load 'F:\\graduating\\data\\assignment.mat' assignment 
%[histograms] = genBOFBatch(dictionary, assignment, total_n_contsamp, total_n_contsamp_of_conn_cont_mat); % bag-of-feature

histograms = {}; start = 1;
for i = 1 : length(full_total_filesName)
    feats = full_total_feats(:,start:start+full_total_n_contsamp(i)-1)'*eigvector;
    the_histograms = assign_(dictionary, feats);
    start = start + full_total_n_contsamp(i);
    histograms{end+1} = the_histograms';
end
save 'F:\\graduating\\data\\histograms.mat' histograms
disp('save in table model');
%saveFeatureInDatabase(histograms,full_total_filesName);

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
    %projImgPath = sprintf('%s%s', path, files(i).name);
    if mod(i, 100) == 0
        saveMat1 = sprintf('%s_%d%s', 'F:\\graduating\\data\\total_feats',i, '.mat');
        saveMat2 = sprintf('%s_%d%s', 'F:\\graduating\\data\\total_n_contsamp',i, '.mat');
        saveMat3 = sprintf('%s_%d%s', 'F:\\graduating\\data\\total_n_contsamp_of_conn_cont_mat',i, '.mat');
        saveMat4 = sprintf('%s_%d%s', 'F:\\graduating\\data\\total_filesName',i, '.mat');
        saveMat5 = sprintf('%s_%d%s', 'F:\\graduating\\data\\multiContour',i, '.mat');
        
        save(saveMat1, 'total_feats');
        save(saveMat2, 'total_n_contsamp');
        save(saveMat3, 'total_n_contsamp_of_conn_cont_mat');
        save(saveMat4, 'total_filesName');
        save(saveMat5, 'multiContour');
    end
    total_filesName{end+1} = files(i).name;
    
    %特征提取包括三部分预处理、采样点提取、特征提取
    %[image, boundImg, rescaleImg, rescaleBinaryImg, fixExpandImg, filledFixExpandImg] = preprocessProjImage(projImgPath, imgEdgeLength);
    %imwrite(fixExpandImg, sprintf('%s%s', 'F:\\projections\\fixExpandImg\\', files(i).name));
    %imwrite(filledFixExpandImg, sprintf('%s%s', 'F:\\projections\\filledFixExpandImg\\', files(i).name));
    filledFixExpandImg = imread(sprintf('%s%s', path, files(i).name));
    fixExpandImg = imread(sprintf('%s%s', FIX_BASE_PATH, files(i).name));
    %disp(files(i).name);
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