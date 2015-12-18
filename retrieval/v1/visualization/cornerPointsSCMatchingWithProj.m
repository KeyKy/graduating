function [ output_args ] = cornerPointsSCMatchingWithProj( input_args )
globalVar;
addpath('E:\graduating\retrieval\v1\');
load 'F:\SCDict_unRota\15\total_struct.mat' total_struct
%sketch_png_path = 'F:\SCSket2Proj\test.png'; sketch_txt_path = 'F:\SCSket2Proj\test.txt';
sketch_png_path = 'F:\sketch\total\m728_fangyuan_0.png'; sketch_txt_path = 'F:\sketch\total\m728_fangyuan_0.txt';
[sketch, strokeSeq] = loadSketch(sketch_png_path, sketch_txt_path); [~,~,sket] = imread(sketch_png_path);
[fixExpandImg, sket_articu_cont] = preproc_extractCont(sketch, strokeSeq);

opts.isPlot = 0; opts.harris_k = 0.1; bwSket = im2bw(sket, 0); 
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
%显示手绘图的角点
fig1 = figure(1); imshow(1 - bwSket); hold on;
for i = 1 : size(cornerA, 1)
    plot(cornerA(i,2), cornerA(i,1), 'b*'); hold on;
    text(cornerA(i,2), cornerA(i,1), num2str(i), 'Color', 'red'); hold on;
end

[sket_feats, sket_dist_mat, sket_ang_mat] = extractFeature(sket_articu_cont);
[corner_points_feats] = compu_corner_SC(cornerA, sket_articu_cont, sket_dist_mat, sket_ang_mat);


findIdx = 0;
for jj = 1 : length(total_struct)
    if strcmp('m725_6_0.png', total_struct{jj}.the_fileName) == 1
        findIdx = jj; break;
    end
end
the_struct = total_struct{findIdx};
the_articu_cont = the_struct.the_articu_cont;
fillFileName = sprintf('%s%s', 'F:\projections\filledFixExpandImg\', the_struct.the_fileName);
[proj_feats, proj_dist_mat, proj_ang_mat] = extractFeature(the_articu_cont);
cornerB = the_struct.the_corner;
filledFixExpandImg = imread(fillFileName);

%显示投影图的角点
fig2 = figure(2); imshow(filledFixExpandImg); hold on;
for i = 1 : size(cornerB, 1)
    plot(cornerB(i,2), cornerB(i,1), 'k.'); hold on;
    text(cornerB(i,2), cornerB(i,1), num2str(i), 'Color', 'blue'); hold on;
end

proj_corner_points_feats = compu_corner_SC(cornerB, the_articu_cont, proj_dist_mat, proj_ang_mat);

[total_dist, assignment, distanceMat] = assignDistanceA2B(corner_points_feats, proj_feats);
[total_dist2, assignment2, ~] = assignDistanceA2B(proj_corner_points_feats, sket_feats);

%直接计算距离，手绘图的角点匹配投影图的采样点
fig3 = figure(3); imshow(1 - bwperim(filledFixExpandImg)); hold on; 
plot(the_articu_cont(:,1), the_articu_cont(:,2), 'r*'); hold on;
idxStr = {}; 
for i = 1 : length(assignment)
    idxStr{end+1} = num2str(i);
end
plot(the_articu_cont(assignment(:),1), the_articu_cont(assignment(:),2), 'r*'); hold on;
text(the_articu_cont(assignment(:),1), the_articu_cont(assignment(:),2), idxStr, 'Color', 'blue'); hold on;

%直接计算距离，投影图的角点匹配手绘图的采样点
fig4 = figure(4); imshow(sketch); hold on; 
plot(sket_articu_cont(:,1), sket_articu_cont(:,2), 'r*'); hold on;
idxStr = {}; 
for i = 1 : length(assignment2)
    idxStr{end+1} = num2str(i);
end
plot(sket_articu_cont(assignment2(:),1), sket_articu_cont(assignment2(:),2), 'r*'); hold on;
text(sket_articu_cont(assignment2(:),1), sket_articu_cont(assignment2(:),2), idxStr, 'Color', 'green'); hold on;

%利用DP，手绘图的角点匹配投影图的角点
[total_dist, assignment, distanceMat] = assignDistanceA2B(corner_points_feats, proj_corner_points_feats);
[cvec1, match_cost1] = mixDPMatching_C(distanceMat, 0.0, 100, 1);
fig5 = figure(5); imshow(filledFixExpandImg); hold on; 
plot(the_articu_cont(:,1), the_articu_cont(:,2), 'r*'); hold on;
idxStr = {}; 
for i = 1 : length(cvec1)
    idxStr{end+1} = num2str(i);
end
plot(cornerB(cvec1(:),2), cornerB(cvec1(:),1), 'b*'); hold on;
text(cornerB(cvec1(:),2), cornerB(cvec1(:),1), idxStr, 'Color', 'green'); hold on;


end

