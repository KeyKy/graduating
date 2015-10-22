function offLineFeatures(path)
% path 投影图图片的绝对路径
BASE_PATH = 'D:\\projections\\test\\';
files = dir(BASE_PATH);
total_feats = [];
total_n_contsamp = [];
total_n_contsamp_of_conn_cont_mat = {};

for i = 3 : length(files)
    projImgPath = sprintf('%s%s', BASE_PATH, files(i).name);
    [the_feats, the_n_contsamp, the_n_contsamp_of_conn_cont_mat] = featExtractSingle(projImgPath);
    total_feats = [total_feats the_feats];
    total_n_contsamp = [total_n_contsamp the_n_contsamp];
    total_n_contsamp_of_conn_cont_mat{end+1} = the_n_contsamp_of_conn_cont_mat;
    if length(the_n_contsamp_of_conn_cont_mat) ~= 1
        printf('the length of the_n_contsamp_of_conn_cont_mat ' + num2str(i) + ' is not equal to 1');
        return;
    end
end

% k-means
methodName = 'kmeans'; parms{1} = 10; designMatrix = total_feats';
[dictionary, assignment, others] = runClusterMethod(designMatrix, methodName, parms);

% need evalution cluster method
% evaluateCluster();

% bag-of-feature
[histograms] = genBOFBatch(dictionary, assignment, total_n_contsamp, total_n_contsamp_of_conn_cont_mat);
end


function [histograms] = genBOFBatch(center, assignment, total_n_contsamp, total_n_contsamp_of_conn_cont_mat)
start = 1; histograms = {};
for i = 1 : size(total_n_contsamp,2)
    [the_histogram] = quantify(center, assignment(start:start+total_n_contsamp(i)-1));
    start = start + total_n_contsamp(i);
    histograms{end+1} = the_histogram;
end
end