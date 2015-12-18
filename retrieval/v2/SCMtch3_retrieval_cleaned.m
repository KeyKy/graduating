function [ sorted_final_idx ] = SCMtch3_retrieval_cleaned( sketchOrPath, strokeSeq, userName )
addpath('E:\graduating\retrieval\v1\');
addpath('E:\graduating\retrieval\v1\visualization\');
if ~exist('sketchOrPath', 'var')
    %sketchOrPath = 'F:\SCSket2Proj\test.png';  %输入手绘图
    %fid = fopen('F:\SCSket2Proj\test.txt');    %输入手绘图的Txt文件
    sketchOrPath = 'F:\sketch\total\m49_fangyuan_0.png';
    fid = fopen('F:\sketch\total\m49_fangyuan_0.txt');
    strokeSeq = fgetl(fid);
    fclose(fid);
    userName = 'fangyuan';  %输入用户名
end

if isstr(sketchOrPath)
    [~,~,sketch] = imread(sketchOrPath);
end

load 'F:\SCDict_unRota\15\all_total_model_struct.mat' all_total_model_struct

bwSket = im2bw(sketch, 0); %% 提取角点
opts.isPlot = 0; opts.harris_k = 0.12;
[cornerA] = findInterestPoints(bwSket, opts);
assignment = DBSCAN(cornerA, 2, 4); need_delete = [];
max_v = max(assignment); 
for i = 1 : max_v
    idx = find(assignment == i);
    need_delete = [need_delete, idx];
    sim_points = cornerA(idx,:);
    avg_sim_pts = mean(sim_points, 1);
    cornerA(end+1,:) = avg_sim_pts;
end
cornerA(need_delete,:) = [];
cornerA = unique(cornerA, 'rows'); 
[~, sket_articu_cont] = preproc_extractCont(sketch, strokeSeq); %%提取采样点

[sket_feats, sket_dist_mat, sket_ang_mat] = extractFeature(sket_articu_cont);
[corner_points_feats] = compu_corner_SC(cornerA, sket_articu_cont, sket_dist_mat, sket_ang_mat);

distance = zeros(1, length(all_total_model_struct));

for model_idx = 1 : length(all_total_model_struct)
    min_dist = 99999;
    for view_idx = 1 : length(all_total_model_struct{model_idx}.viewName)
        [dist_sket_2_proj, ~, ~] = assignDistanceA2B(corner_points_feats, all_total_model_struct{model_idx}.the_feats{view_idx});
        [dist_projCorner_2_sket, ~, ~] = assignDistanceA2B(all_total_model_struct{model_idx}.the_corner_feats{view_idx}, sket_feats);
        dist = dist_sket_2_proj + dist_projCorner_2_sket;
        if min_dist > dist
            min_dist = dist;
        end
    end
distance(1, model_idx) = min_dist;
disp(model_idx);
end

[sorted_final_score, sorted_final_idx] = sort(distance, 'ascend');
figure;
for i = 1 : 25
    subplot(5,5,i); img = imread(sprintf('%sm%d_thumb.jpg','F:\projections\result\',sorted_final_idx(i)-1)); imshow(img);
end

end

