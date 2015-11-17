function [ ] = M3_onZTotal(sketchOrPath,strokeSeq)
% 输入投影图，检索z_total中的histograms的投影图，z_total中的histogram是根据'F:\projections\BOF2\'中生成

load 'F:\\dict\\z_total_data\\dictionary.mat' dictionary 
load 'F:\\dict\\z_total_data\\eigvector.mat' eigvector 
load 'F:\\dict\\z_total_data\\histograms.mat' histograms
load 'F:\\dict\\z_total_data\\total_filesName.mat' total_filesName

filledFixExpandImgPath = 'F:\projections\BOF\animal\m107_2_1.png';
fixExpandImgPath = 'F:\projections\fixExpandImg\m107_2_1.png';
fixExpandImg = imread(fixExpandImgPath); filledFixExpandImg = imread(filledFixExpandImgPath);
perimeter = bwperim(filledFixExpandImg);  boundries = bwboundaries(perimeter, 'noholes'); %boundries是N-by-2的数据结构，其中列1是行号，列2是列号
imshow(perimeter);
[eight_conn_pixel_points, n_points_each_boundry] = extBdPoints(boundries); % eight_conn_pixel_points是N-by-2的数据结构，其中列1是列号，列2是行号

[Contours, the_articu_cont, the_n_contsamp, the_n_contsamp_of_conn_cont_mat, adjacencyList] = downSampleContour(filledFixExpandImg, 5);
the_articu_cont(:,2) = 200 - the_articu_cont(:,2); %将坐标系转为图像的坐标系，左上角为原点，the_articu_cont原本是N-by-2的数据结构，其中第2列是坐标y
[the_feats] = extractFeature(the_articu_cont, eight_conn_pixel_points, n_points_each_boundry, fixExpandImg);

sket_feats = the_feats;

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

