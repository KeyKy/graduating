function [ ] = cornerPointsSCMatchingWithSket( )
addpath('E:\graduating\retrieval\v1\');
sketch_png_path = 'F:\sketch\total\m507_y7_0.png'; sketch_txt_path = 'F:\sketch\total\m507_y7_0.txt';

[sketch, strokeSeq] = loadSketch(sketch_png_path, sketch_txt_path); [~,~,image1] = imread(sketch_png_path);
[fixExpandImg, sket_articu_cont] = preproc_extractCont(sketch, strokeSeq);
[sket_feats, sket_dist_mat, sket_ang_mat] = extractFeature(sket_articu_cont);

sketch2_png_path = 'F:\sketch\total\m508_y7_0.png'; sketch2_txt_path = 'F:\sketch\total\m508_y7_0.txt';
[sketch2, strokeSeq2] = loadSketch(sketch2_png_path, sketch2_txt_path);  [~,~,image2] = imread(sketch2_png_path);
[fixExpandImg2, sket_articu_cont2] = preproc_extractCont(sketch2, strokeSeq2); 
[sket_feats2] = extractFeature(sket_articu_cont2);

opts.isPlot = 0; opts.harris_k = 0.1; bwImg1 = im2bw(image1, 0); 
[cornerA] = findInterestPoints(bwImg1, opts);

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
fig1 = figure(1); imshow(1-bwImg1); hold on;
plot(cornerA(:,2), cornerA(:,1), 'g.'); hold on;
%plot(sket_articu_cont(:,1), sket_articu_cont(:,2), 'r*');


%addedPoints = [cornerA(1:end,2) cornerA(1:end,1)];
%两种方式求角点的特征，一种是包括角点求特征，另一种是不包括角点求特征
% sket_articu_cont = [sket_articu_cont; addedPoints];
% sket_articu_cont(:,2) = sket_articu_cont(:,2);
% [sket_feats] = extractFeature(sket_articu_cont);
% 
% n_samps = size(sket_articu_cont, 1);
% n_corners = size(addedPoints,1);
% corner_points_ferats = sket_feats(:,end-n_corners+1:end);

%corner_points_ferats = sket_feats(:,1:n_samps-n_corners);
%cornerA = circshift(sket_articu_cont(1:n_samps-n_corners, :), [0,1]);

corner_points_ferats = compu_corner_SC(cornerA, sket_articu_cont, sket_dist_mat, sket_ang_mat);

fig2 = figure(2); imshow(255 - image2); hold on; plot(sket_articu_cont2(:,1), sket_articu_cont2(:,2), 'r*'); hold on;
[total_dist, assignment, distanceMat] = assignDistanceA2B(corner_points_ferats, sket_feats2);
for i = 1 : length(assignment)
    plot(sket_articu_cont2(assignment(i),1), sket_articu_cont2(assignment(i),2), 'r*'); hold on;
    text(sket_articu_cont2(assignment(i),1), sket_articu_cont2(assignment(i),2), num2str(i), 'Color', 'blue'); hold on;
end

fig3 = figure(3); imshow(1 - bwImg1); hold on;
for i = 1 : size(cornerA, 1)
    plot(cornerA(i,2), cornerA(i,1), 'k.'); hold on;
    text(cornerA(i,2), cornerA(i,1), num2str(i), 'Color', 'red'); hold on;
end

[total_dist, assignment, distanceMat] = assignDistanceA2B(sket_feats, sket_feats2); %是否仅仅使用角点
[cvec1, match_cost1] = mixDPMatching_C(distanceMat, 0, 100, 1);
fig4 = figure(4); imshow(255 - image2); hold on; plot(sket_articu_cont2(:,1), sket_articu_cont2(:,2), 'r*'); hold on;
for i = 1 : length(cvec1)
    plot(sket_articu_cont2(cvec1(i),1), sket_articu_cont2(cvec1(i),2), 'r*'); hold on;
    text(sket_articu_cont2(cvec1(i),1), sket_articu_cont2(cvec1(i),2), num2str(i), 'Color', 'red'); hold on;
end

fig5 = figure(5); imshow(1 - bwImg1); hold on;
for i = 1 : size(sket_articu_cont,1)
    plot(sket_articu_cont(i,1), sket_articu_cont(i,2), 'g.'); hold on;
    text(sket_articu_cont(i,1), sket_articu_cont(i,2), num2str(i), 'Color', 'red'); hold on;
end
fig6 = figure(6); imshow(255 - image2); hold on; 
for i = 1 : size(sket_articu_cont2,1)
    plot(sket_articu_cont2(i,1), sket_articu_cont2(i,2), 'r*'); hold on;
    text(sket_articu_cont2(i,1), sket_articu_cont2(i,2), num2str(i), 'Color', 'red'); hold on;
end
end

