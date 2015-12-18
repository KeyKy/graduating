function [ output_args ] = cornerDetVis( input_args )
addpath('E:\graduating\retrieval\v1\');
sketch_png_path = 'F:\sketch\total\m95_y4_0.png'; sketch_txt_path = 'F:\sketch\total\m95_y4_0.txt';

[sketch, strokeSeq] = loadSketch(sketch_png_path, sketch_txt_path); [~,~,image1] = imread(sketch_png_path);
[fixExpandImg, sket_articu_cont] = preproc_extractCont(sketch, strokeSeq);
[sket_feats, sket_dist_mat, sket_ang_mat] = extractFeature(sket_articu_cont);

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

%cornerShi_Tomasi = corner(bwImg1, 'Harris', 8, 'SensitivityFactor', 0.1);
cornerShi_Tomasi = corner(bwImg1, 'MinimumEigenvalue', 20);
fig2 = figure(2); imshow(1-bwImg1); hold on;
plot(cornerShi_Tomasi(:,1), cornerShi_Tomasi(:,2), 'g.'); hold on;

[~, ~, cornerSift] = sift(image1);
fig3 = figure(3); imshow(255 - image1); hold on;
plot(cornerSift(:,2), cornerSift(:,1), 'g.'); hold on;

[cornerFast] = fast9(bwImg1, 0.5, 1);
fig4 = figure(4); imshow(255 - image1); hold on;
plot(cornerFast(:,1), cornerFast(:,2), 'g.'); hold on;
end

