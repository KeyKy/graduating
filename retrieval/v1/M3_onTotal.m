function [  ] = M3_onTotal(  )
% 输入投影图，检索25410张图，所用的是利用z_total中生成的字典
load 'F:\\dict\\z_total_data\\dictionary.mat' dictionary 
load 'F:\\dict\\z_total_data\\eigvector.mat' eigvector 
load 'F:\\dict\\z_total_all_data\\all_total_struct.mat' all_total_struct

filledFixExpandImgPath = 'F:\projections\BOF\animal\m105_2_1.png';
fixExpandImgPath = 'F:\projections\fixExpandImg\m105_2_1.png';
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
for model_idx = 1 : length(all_total_struct)
    distance = [distance calcDist(all_total_struct{model_idx}.the_histograms, sket_histogram, options)];
end

[score, sorted_m_distance_idx_arr] = sort(distance, 'ascend');
sorted_m_name_cells = all_total_struct(sorted_m_distance_idx_arr);
figure(2);
for i = 1 : 25
    subplot(5,5,i); img = imread(sprintf('%s%s','F:\projections\filledFixExpandImg\',sorted_m_name_cells{i}.the_fileName)); imshow(img);
end

end

