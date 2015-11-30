function [ output_args ] = cornerPointsSCMatchingWithProj( input_args )
globalVar;
addpath('E:\graduating\retrieval\v1\');
sketch_png_path = 'F:\SCSket2Proj\test.png'; sketch_txt_path = 'F:\SCSket2Proj\test.txt';
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
fig1 = figure(1); imshow(1 - bwSket); hold on;
for i = 1 : size(cornerA, 1)
    plot(cornerA(i,2), cornerA(i,1), 'k.'); hold on;
    text(cornerA(i,2), cornerA(i,1), num2str(i), 'Color', 'blue'); hold on;
end

addedPoints = [cornerA(1:end,2) cornerA(1:end,1)];
corner_points_ferats = [];
for i = 1 : size(addedPoints, 1)
    tmp_cont = [sket_articu_cont; addedPoints(i,:)];
    [tmp_feats] = extractFeature(tmp_cont);
    corner_points_ferats = [corner_points_ferats tmp_feats(:,end)];
end

proj_path = 'F:\SCSket2Proj\m49_6_0.png';
[image, boundImg, rescaleImg, rescaleBinaryImg, fixExpandImg, filledFixExpandImg] = preprocessProjImage(proj_path);
[Contours, the_articu_cont, the_n_contsamp, the_n_contsamp_of_conn_cont_mat, adjacencyList] = downSampleContour(filledFixExpandImg);
the_articu_cont(:,2) = the_articu_cont(:,2);
[proj_feats] = extractFeature(the_articu_cont, fixExpandImg);

[total_dist, assignment, distanceMat] = assignDistanceA2B(corner_points_ferats, proj_feats);

fig2 = figure(2); imshow(filledFixExpandImg); hold on; 
plot(the_articu_cont(:,1), the_articu_cont(:,2), 'r*'); hold on;
idxStr = {}; 
for i = 1 : length(assignment)
    idxStr{end+1} = num2str(i);
end
plot(the_articu_cont(assignment(:),1), the_articu_cont(assignment(:),2), 'r*'); hold on;
text(the_articu_cont(assignment(:),1), the_articu_cont(assignment(:),2), idxStr, 'Color', 'green'); hold on;




end
