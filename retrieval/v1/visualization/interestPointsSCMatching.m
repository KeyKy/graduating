function [  ] = interestPointsSCMatching( )
addpath('../retrieval/v1/');
sketch_png_path = 'F:\sketch\total\m77_kangyang_0.png'; sketch_txt_path = 'F:\sketch\total\m77_kangyang_0.txt';

[sketch, strokeSeq] = loadSketch(sketch_png_path, sketch_txt_path); image = csToMatlab(sketch);
[fixExpandImg, sket_articu_cont] = preproc_extractCont(sketch, strokeSeq);

sketch2_png_path = 'F:\sketch\total\m3_fangyuan_0.png'; sketch2_txt_path = 'F:\sketch\total\m3_fangyuan_0.txt';
[sketch2, strokeSeq2] = loadSketch(sketch2_png_path, sketch2_txt_path); image2 = csToMatlab(sketch2);
[fixExpandImg2, sket_articu_cont2] = preproc_extractCont(sketch2, strokeSeq2);

sket_articu_cont2(:,2) = 200 - sket_articu_cont2(:,2);
[sket_feats2] = extractFeature(sket_articu_cont2);

[points] = selectPointsUI(image, sket_articu_cont);
[~, interestIdx] = interestPoints(points);
interest_points_coords = sket_articu_cont(interestIdx,:);
sket_articu_cont(:,2) = 200 - sket_articu_cont(:,2);
[sket_feats] = extractFeature(sket_articu_cont);
interest_points_feats = sket_feats(:,interestIdx);

fig1 = figure(1); imshow(image); hold on; plot(interest_points_coords(:,1), interest_points_coords(:,2), 'r*'); hold on;
plot(sket_articu_cont(:,1), 200-sket_articu_cont(:,2), 'r*');
for i = 1 : size(interest_points_coords,1)
    text(interest_points_coords(i,1), interest_points_coords(i,2), num2str(i)); hold on;
end

fig2 = figure(2); imshow(image2); hold on; plot(sket_articu_cont2(:,1), 200-sket_articu_cont2(:,2), 'r*'); hold on;
[total_dist, assignment, distanceMat] = assignDistanceA2B(interest_points_feats, sket_feats2);
for i = 1 : length(assignment)
    plot(sket_articu_cont2(assignment(i),1), 200 - sket_articu_cont2(assignment(i),2), 'r*'); hold on;
    text(sket_articu_cont2(assignment(i),1), 200 - sket_articu_cont2(assignment(i),2), num2str(i)); hold on;
end

fig3 = figure(3); imshow(image2); hold on; plot(sket_articu_cont2(:,1), 200-sket_articu_cont2(:,2), 'r*'); hold on;
for i = 1 : size(sket_articu_cont2, 1)
    text(sket_articu_cont2(i,1), 200-sket_articu_cont2(i,2), num2str(i));
end

[C, T] = hungarian(distanceMat); min_n_point = min(size(interest_points_coords,1), size(sket_articu_cont2,1)); 
C = C(1:min_n_point);
fig4 = figure(4);imshow(image2); hold on; plot(sket_articu_cont2(:,1), 200-sket_articu_cont2(:,2), 'r*'); hold on;
for i = 1 : length(C)
    plot(sket_articu_cont2(C(i),1), 200 - sket_articu_cont2(C(i),2), 'r*'); hold on;
    text(sket_articu_cont2(C(i),1), 200 - sket_articu_cont2(C(i),2), num2str(i)); hold on;
end

id_point = 1;
fig5 = figure(5);
feat1 = interest_points_feats(:,id_point); ff1 = reshape(feat1, 5, 12);
dispSCMatrix(ff1);
fig6 = figure(6);
feat2 = sket_feats2(:,C(id_point));  ff2 = reshape(feat2, 5, 12);
dispSCMatrix(ff2);
fig7 = figure(7);
feat3 = sket_feats2(:,assignment(id_point)); ff3 = reshape(feat3, 5, 12);
dispSCMatrix(ff3);




end