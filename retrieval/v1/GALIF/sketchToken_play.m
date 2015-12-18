function [ ] = sketchToken_play( )
load 'F:\gabor\10\infosStruct.mat' infosStruct

input = infosStruct{1}.the_bag_galif_feats;
dist = []; options.method = 'euclidean';
for i = 1 : length(infosStruct)
    the_bag_galif_feats = infosStruct{i}.the_bag_galif_feats;
    distTmp = calcDist(input,the_bag_galif_feats,options);
    dist = [dist distTmp];
end
[sorted_dist, sorted_idx] = sort(dist, 'ascend');
sorted_output = infosStruct(sorted_idx);
end

