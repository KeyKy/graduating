function [  ] = M3_onTotal(  )
% ����ͶӰͼ������25410��ͼ�����õ�������z_total�����ɵ��ֵ�
load 'F:\\dict\\z_total_data\\dictionary.mat' dictionary 
load 'F:\\dict\\z_total_data\\eigvector.mat' eigvector 
load 'F:\\dict\\z_total_all_data\\all_total_struct.mat' all_total_struct

filledFixExpandImgPath = 'F:\projections\BOF\animal\m105_2_1.png';
fixExpandImgPath = 'F:\projections\fixExpandImg\m105_2_1.png';
fixExpandImg = imread(fixExpandImgPath); filledFixExpandImg = imread(filledFixExpandImgPath);
perimeter = bwperim(filledFixExpandImg);  boundries = bwboundaries(perimeter, 'noholes'); %boundries��N-by-2�����ݽṹ��������1���кţ���2���к�
imshow(perimeter);
[eight_conn_pixel_points, n_points_each_boundry] = extBdPoints(boundries); % eight_conn_pixel_points��N-by-2�����ݽṹ��������1���кţ���2���к�

[Contours, the_articu_cont, the_n_contsamp, the_n_contsamp_of_conn_cont_mat, adjacencyList] = downSampleContour(filledFixExpandImg, 5);
the_articu_cont(:,2) = 200 - the_articu_cont(:,2); %������ϵתΪͼ�������ϵ�����Ͻ�Ϊԭ�㣬the_articu_contԭ����N-by-2�����ݽṹ�����е�2��������y
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

