function [cur_seg_pts_idx_arr] = labelSampPointsWithinBoundingBox(filled_polygon_boundingbox_mat, samp_pts_label_x_y_mat)

[num_of_samp_p, ~] = size(samp_pts_label_x_y_mat);

cur_seg_pts_idx_arr = [];   %  �ǵ���գ�������ۼӳ���

for samp_p_idx = 1 : num_of_samp_p
    samp_p_x = cell2mat(samp_pts_label_x_y_mat(samp_p_idx, 2)); 
    samp_p_y = cell2mat(samp_pts_label_x_y_mat(samp_p_idx, 3));
    %����������������������Ϊ��ɫ(������ӦԪ��ֵΪ0)ʵ�ĵİ�Χ����
    if filled_polygon_boundingbox_mat(samp_p_y, samp_p_x) == 0      % ע������ϵ�任��y��Ӧrow�� x��Ӧcol
        cur_seg_pts_idx_arr = [cur_seg_pts_idx_arr; samp_p_idx];
    end
end

end