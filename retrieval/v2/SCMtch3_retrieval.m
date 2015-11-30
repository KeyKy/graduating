function [ output_args ] = SCMtch3_retrieval( sketchOrPath, strokeSeq, userName )
addpath('E:\graduating\retrieval\v1\');
addpath('E:\graduating\retrieval\v1\visualization\');
if ~exist('sketchOrPath', 'var')
    sketchOrPath = 'F:\test.png';  %输入手绘图
    fid = fopen('F:\test.txt');    %输入手绘图的Txt文件
    strokeSeq = fgetl(fid);
    fclose(fid);
    userName = 'y8';  %输入用户名
end

if isstr(sketchOrPath)
    [~,~,sketch] = imread(sketchOrPath);
end

load 'F:\SCDict_unRota\15\all_total_model_struct.mat' all_total_model_struct
proj_base_path = 'F:\projections\total_contour\';
match_png_path = 'F:\scDebug\match\';

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

% 显示角点提取情况
% fig1 = figure(1); imshow(bwSket); hold on;
% plot(cornerA(:,2), cornerA(:,1), 'g.'); hold on;
% print('F:\\scDebug\\corner', '-dpng', '-r0');
% close(fig1);
[fixExpandImg, sket_articu_cont] = preproc_extractCont(sketch, strokeSeq); %%提取采样点

% cornerPoints = [cornerA(1:end,2) cornerA(1:end,1)]; %拼接角点和采样点
% sket_articu_cont = [sket_articu_cont; cornerPoints];
% sket_articu_cont(:,2) = sket_articu_cont(:,2);
% [sket_feats] = extractFeature(sket_articu_cont); %提取特征
% corner_points_ferats = sket_feats(:,end-n_corners+1:end);

cornerPoints = [cornerA(1:end,2) cornerA(1:end,1)]; %拼接角点和采样点
corner_points_ferats = []; %不将角点加入SC计算中
for i = 1 : size(cornerPoints, 1)
    tmp_cont = [sket_articu_cont; cornerPoints(i,:)];
    [tmp_feats] = extractFeature(tmp_cont);
    corner_points_ferats = [corner_points_ferats tmp_feats(:,end)];
end

n_total_samps = size(sket_articu_cont, 1);
n_corners = size(cornerPoints,1);

distance = [];
for model_idx = 50 : length(all_total_model_struct)
    min_dist = 99999;
    for view_idx = 1 : length(all_total_model_struct{model_idx}.viewName)
        axes = zeros(1,2);
        [dist, assignment, distanceMat] = assignDistanceA2B(corner_points_ferats, all_total_model_struct{model_idx}.the_feats{view_idx});
        pngName = sprintf('m%d_%s',model_idx-1,all_total_model_struct{model_idx}.viewName{view_idx});
        pngPath = sprintf('%s%s.png', proj_base_path, pngName);
        pngImg = imread(pngPath); fig1 = figure(1); axes(1) = subplot(1,2,1); imshow(1-pngImg); hold on;
        the_articu_cont = all_total_model_struct{model_idx}.the_articu_cont{view_idx};
        [the_feats] = extractFeature(the_articu_cont); eps = sum(sum(abs(the_feats - all_total_model_struct{model_idx}.the_feats{view_idx})));
        
        
        if min_dist > dist
            min_dist = dist;
        end
        
        plot(the_articu_cont(:,1), 200-the_articu_cont(:,2), 'b.'); hold on;
        plot(the_articu_cont(assignment(:),1), 200 - the_articu_cont(assignment(:),2), 'g*'); hold on;
        idx = {};
        for ii = 1 : length(assignment)
            idx{end+1} = num2str(ii);
        end
        x = the_articu_cont(assignment(:),1); y = 200 - the_articu_cont(assignment(:),2);
        textfit(x, y, idx, 'Color', 'red', 'FontSize', 8); hold on;
        
        axes(2) = subplot(1,2,2); imshow(1 - bwSket); hold on;
        for i = 1 : size(cornerA, 1)
            plot(cornerA(i,2), cornerA(i,1), 'r.'); hold on;
            text(cornerA(i,2), cornerA(i,1), num2str(i), 'Color', 'green'); hold on;
        end
        plot(sket_articu_cont(1:n_total_samps, 1), sket_articu_cont(1:n_total_samps, 2), 'b.');
        print(sprintf('%s%s',match_png_path,pngName), '-dpng');
        close(fig1);
    end
distance = [distance min_dist];
end

end

