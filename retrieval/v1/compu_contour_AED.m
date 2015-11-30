function [ AED_feats ] = compu_contour_AED(euclid_dist_mat)
%   CALC_AED_FEATS Summary of this function goes here
%   计算11维Average Eculidean Distance平均欧式距离特征
n_contsamp = size(euclid_dist_mat, 1);
AED_feats = zeros(n_contsamp, 12);      % 每个采样点的特征占一行，每点的AED特征是12维的
for samp_point_idx = 1 : n_contsamp
    % AED 特征归一化处理！每个元素都统一除以 距离矩阵 中最大元素
    dist_mat_MAX_val = max(max(euclid_dist_mat));
    normalized_inner_dist_mat = euclid_dist_mat / dist_mat_MAX_val;
    % 对距离矩阵每一行从小到大排序，计算AGD分位点时用到
    sorted_norm_inner_dist_mat = sort( normalized_inner_dist_mat , 2);
    
    % 该点到自身距离为0，不占计数值，故除以(n_contsamp - 1)
    AGD = sum(sorted_norm_inner_dist_mat(samp_point_idx , : )) / (n_contsamp - 1);
    square_mean_GD = sum(sqrt(sorted_norm_inner_dist_mat(samp_point_idx , : ))) / (n_contsamp - 1);
    
    idx = [1:samp_point_idx-1 samp_point_idx+1:n_contsamp];
    AED_variance = var(normalized_inner_dist_mat(idx));
    % 将AED、均方ED、方差ED、第10、第20···第90分位点共同构成该采样点的AED特征，共12维
    AED_feats(samp_point_idx, 1 : 3) = [AGD  square_mean_GD AED_variance];
    for percentile_idx = 1 : 9
        perc_point_idx = ceil((percentile_idx / 10) * n_contsamp) ;  % 向量下标，向下取整
        AED_feats(samp_point_idx, 2 + percentile_idx) = sorted_norm_inner_dist_mat(samp_point_idx , perc_point_idx );
    end
end

end
