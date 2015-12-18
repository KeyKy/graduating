function [ ] = sketchToken_cluster( )
% load 'F:\gabor\10\infosStruct.mat' infosStruct
% designMatrix = [];
% for i = 1 : length(infosStruct)
%     batch_data = infosStruct{i}.the_galif_feats';
%     designMatrix = [designMatrix; batch_data];
% end
% save 'F:\gabor\10\designMatrix.mat' designMatrix

load 'F:\gabor\10\designMatrix.mat' designMatrix
parms = {150};
[center, assignment, others] = runClusterMethod(designMatrix, 'kmeans-euclidean', parms);
save 'F:\gabor\10\center.mat' center
save 'F:\gabor\10\assignment.mat' assignment
save 'F:\gabor\10\others.mat' others

end

