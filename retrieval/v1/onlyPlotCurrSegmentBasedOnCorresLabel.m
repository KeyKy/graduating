function onlyPlotCurrSegmentBasedOnCorresLabel(cur_seg_pts_idx_arr, sel_label, label_to_color_map, sket_articu_cont)

num_of_points = length(cur_seg_pts_idx_arr);
if num_of_points == 0
    return 
else
    cur_color = label_to_color_map(sel_label);
    for arr_idx = 1 : num_of_points
        cur_x = sket_articu_cont(cur_seg_pts_idx_arr(arr_idx), 1);
        cur_y = sket_articu_cont(cur_seg_pts_idx_arr(arr_idx), 2);
        plot(cur_x, cur_y, '*', 'Color', cur_color); hold on;
    end
end

end