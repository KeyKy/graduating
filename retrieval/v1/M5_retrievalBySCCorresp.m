function [ ] = M5_retrievalBySCCorresp( )
if ~exist('sketchOrPath', 'var')
    sketchOrPath = 'F:\sketch\total\m509_y7_0.png';  %输入手绘图
    fid = fopen('F:\sketch\total\m509_y7_0.txt');    %输入手绘图的Txt文件
    strokeSeq = fgetl(fid);
    fclose(fid);
    userName = 'kangyang';  %输入用户名
end

if isstr(sketchOrPath)
    [~,~,sketch] = imread(sketchOrPath);
end

load 'F:\\SCDict\\all_total_model_struct.mat' all_total_model_struct

image = csToMatlab(sketch);
boundImg = imageBoxBounding(image);
rescaleImg = imageResizeWithNearest(boundImg);
rescaleBinaryImg = imageRescaledBinaryzation(rescaleImg, 0.8);
fixExpandImg = imageBoundaryExpandFixSize(rescaleBinaryImg, 200, 200);
Contours = downSampleSketCont(strokeSeq);

[sket_articu_cont, sket_n_contsamp, sket_n_contsamp_of_conn_cont_mat, sket_adjacencyList] = articulateSketContour(Contours, 15);
[points] = selectPointsUI(image, sket_articu_cont);
[~, interestIdx] = interestPoints(points);
sket_articu_cont(:,2) = 200 - sket_articu_cont(:,2);
[sket_feats] = extractFeature(sket_articu_cont);
interest_points_feats = sket_feats(:,interestIdx);

distance = []; opts.method = 'assign';
for i = 1 : length(all_total_model_struct)
    minValue = 9999;
    for j = 1 : length(all_total_model_struct{i}.the_feats)
        tmp = calcDist(interest_points_feats, all_total_model_struct{i}.the_feats{j}, opts);
        if tmp < minValue
            minValue = tmp;
        end
    end
    distance = [distance minValue];
end

[sorted_final_score, sorted_final_idx] = sort(distance, 'ascend');
figure(2);
for i = 1 : 25
    subplot(5,5,i); img = imread(sprintf('%sm%d_thumb.jpg','F:\projections\result\',sorted_final_idx(i)-1)); imshow(img);
end

end

