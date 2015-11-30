function [cur_seg_pts_idx_arr] = labelSampPointsWithinBoundingBox(filled_polygon_boundingbox_mat, samp_pts_label_x_y_mat)

[num_of_samp_p, ~] = size(samp_pts_label_x_y_mat);

cur_seg_pts_idx_arr = [];   %  记得清空，否则会累加出错

for samp_p_idx = 1 : num_of_samp_p
    samp_p_x = cell2mat(samp_pts_label_x_y_mat(samp_p_idx, 2)); 
    samp_p_y = cell2mat(samp_pts_label_x_y_mat(samp_p_idx, 3));
    %如果采样点所在坐标在填充为黑色(矩阵相应元素值为0)实心的包围盒内
    if filled_polygon_boundingbox_mat(samp_p_y, samp_p_x) == 0      % 注意坐标系变换：y对应row， x对应col
        cur_seg_pts_idx_arr = [cur_seg_pts_idx_arr; samp_p_idx];
    end
end

end