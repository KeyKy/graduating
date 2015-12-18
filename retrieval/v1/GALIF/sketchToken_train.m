function [ ] = sketchToken_train( )
load 'F:\gabor\10\infosStruct.mat' infosStruct
% classifyDesignMatrix = []; target = [];
% targetCluster = 'ant';
% for i = 1 : length(infosStruct)
%     if strcmp(infosStruct{i}.the_tag, targetCluster) == 1
%         classifyDesignMatrix = [classifyDesignMatrix; infosStruct{i}.the_bag_galif_feats];
%         n_point = size(infosStruct{i}.the_bag_galif_feats,2);
%         target = [target; 1];
%     else
%         classifyDesignMatrix = [classifyDesignMatrix; infosStruct{i}.the_bag_galif_feats];
%         n_point = size(infosStruct{i}.the_bag_galif_feats,2);
%         target = [target; 0];
%     end
% end
% save 'F:\gabor\10\classifyDesignMatrix.mat' classifyDesignMatrix
% save 'F:\gabor\10\target.mat' target

load 'F:\gabor\10\classifyDesignMatrix.mat' classifyDesignMatrix
load 'F:\gabor\10\target.mat' target
svmTokenStruct = svmtrain(classifyDesignMatrix,target);
[pred, prob] = svmclassify(svmTokenStruct, infosStruct{4}.the_bag_galif_feats);
end

