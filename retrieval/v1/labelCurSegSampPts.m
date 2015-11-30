function samp_pts_label_x_y_mat = labelCurSegSampPts(cur_seg_pts_idx_arr,sel_label, samp_pts_label_x_y_mat, sket_articu_cont)
cur_seg_pts_num = length(cur_seg_pts_idx_arr);

for arr_idx = 1 : cur_seg_pts_num
    p_idx = cur_seg_pts_idx_arr(arr_idx);
    
    cur_p_x = cell2mat(samp_pts_label_x_y_mat(p_idx, 2));
    cur_p_y = cell2mat(samp_pts_label_x_y_mat(p_idx, 3));
    if cur_p_x == sket_articu_cont(p_idx, 1)  &&  cur_p_y == sket_articu_cont(p_idx, 2)
        samp_pts_label_x_y_mat(p_idx, 1) = {sel_label};
    else
        error('sample point coordinate dismatch at index %d', p_idx);
    end

end