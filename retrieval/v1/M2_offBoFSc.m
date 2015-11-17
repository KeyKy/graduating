function [ ] = M2_offBoFSc( )
% 根据'F:\projections\BOF2\'下的文件夹名读取相应'F:\\graduating\\'下的struct，合在一起并截取一部分形成一个大的struct
% path = 'F:\projections\BOF2\';
% files = dir(path);
% total_struct = {};
% for i = 3 : length(files)
%     className = files(i).name;
%     structPath = sprintf('%s%s_data\\total_struct.mat', 'F:\\graduating\\',className);
%     struct1 = load(structPath);
%     half = struct1.total_struct(1:floor(2*length(struct1.total_struct)/3));
%     total_struct = [total_struct half];
% end
% 
% total_feats = [];
% total_n_contsamp = [];
% total_filesName = {};
% for i = 1 : length(total_struct)
%     total_feats = [total_feats total_struct{i}.the_feats];
%     total_n_contsamp = [total_n_contsamp total_struct{i}.the_n_contsamp];
%     total_filesName = [total_filesName total_struct{i}.the_fileName];
% end
% save 'F:\\dict\\z_total_data\\total_feats.mat' total_feats
% save 'F:\\dict\\z_total_data\\total_filesName.mat' total_filesName
% save 'F:\\dict\\z_total_data\\total_n_contsamp.mat' total_n_contsamp
% save 'F:\\dict\\z_total_data\\total_struct.mat' total_struct


%if 0
load 'F:\\dict\\z_total_data\\total_feats.mat' total_feats

disp('begin reduction');
designMatrix = total_feats'; 
options.PCARatio = 0.7;
[reducedDesignMatrix,eigvector] = dimReduction(designMatrix, 'pca', options);
save 'F:\\dict\\z_total_data\\eigvector.mat' eigvector %save transformation

%reducedDesignMatrix = total_feats';
disp('begin clustring'); % k-means
methodName = 'kmeans-euclidean'; parms{1} = 55; clusterDesignMatrix = reducedDesignMatrix;
[dictionary, assignment, others] = runClusterMethod(clusterDesignMatrix, methodName, parms);
save 'F:\\dict\\z_total_data\\dictionary.mat' dictionary 
save 'F:\\dict\\z_total_data\\assignment.mat' assignment 
%end

%if 0
disp('begin BOF');
load 'F:\\dict\\z_total_data\\dictionary.mat' dictionary
stru_a = load('F:\\dict\\z_total_data\\total_feats.mat');
full_total_feats = stru_a.total_feats;
stru_b = load('F:\\dict\\z_total_data\\total_filesName.mat');
full_total_filesName = stru_b.total_filesName;
stru_c = load('F:\\dict\\z_total_data\\total_n_contsamp.mat');
full_total_n_contsamp = stru_c.total_n_contsamp;
load 'F:\\dict\\z_total_data\\eigvector.mat' eigvector

histograms = {}; start = 1;
for i = 1 : length(full_total_filesName)
    feats = full_total_feats(:,start:start+full_total_n_contsamp(i)-1)'*eigvector;
    %feats = full_total_feats(:,start:start+full_total_n_contsamp(i)-1)';
    the_histograms = assign_(dictionary, feats);
    start = start + full_total_n_contsamp(i);
    histograms{end+1} = the_histograms';
end
save 'F:\\dict\\z_total_data\\histograms.mat' histograms
%end

end

