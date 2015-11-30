function [ AED_feats ] = compu_contour_AED(euclid_dist_mat)
%   CALC_AED_FEATS Summary of this function goes here
%   ����11άAverage Eculidean Distanceƽ��ŷʽ��������
n_contsamp = size(euclid_dist_mat, 1);
AED_feats = zeros(n_contsamp, 12);      % ÿ�������������ռһ�У�ÿ���AED������12ά��
for samp_point_idx = 1 : n_contsamp
    % AED ������һ������ÿ��Ԫ�ض�ͳһ���� ������� �����Ԫ��
    dist_mat_MAX_val = max(max(euclid_dist_mat));
    normalized_inner_dist_mat = euclid_dist_mat / dist_mat_MAX_val;
    % �Ծ������ÿһ�д�С�������򣬼���AGD��λ��ʱ�õ�
    sorted_norm_inner_dist_mat = sort( normalized_inner_dist_mat , 2);
    
    % �õ㵽�������Ϊ0����ռ����ֵ���ʳ���(n_contsamp - 1)
    AGD = sum(sorted_norm_inner_dist_mat(samp_point_idx , : )) / (n_contsamp - 1);
    square_mean_GD = sum(sqrt(sorted_norm_inner_dist_mat(samp_point_idx , : ))) / (n_contsamp - 1);
    
    idx = [1:samp_point_idx-1 samp_point_idx+1:n_contsamp];
    AED_variance = var(normalized_inner_dist_mat(idx));
    % ��AED������ED������ED����10����20��������90��λ�㹲ͬ���ɸò������AED��������12ά
    AED_feats(samp_point_idx, 1 : 3) = [AGD  square_mean_GD AED_variance];
    for percentile_idx = 1 : 9
        perc_point_idx = ceil((percentile_idx / 10) * n_contsamp) ;  % �����±꣬����ȡ��
        AED_feats(samp_point_idx, 2 + percentile_idx) = sorted_norm_inner_dist_mat(samp_point_idx , perc_point_idx );
    end
end

end
