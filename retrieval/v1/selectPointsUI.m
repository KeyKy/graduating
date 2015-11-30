function [samp_pts_label_x_y_mat] = selectPointsUI(image, sket_articu_cont)
status_color = containers.Map();
status_color('?') = [1 0 0]; status_color('!') = [0 1 0]; status_color('*') = [0 0 1];
[rowMax colMax] = size(image);
polygon_boundingbox_mat = zeros([rowMax colMax]); start_drawing_polygon_boundingbox = false;
n_contsamp = size(sket_articu_cont, 1);
samp_pts_label_x_y_mat = cell(n_contsamp, 3);
for i = 1 : n_contsamp
    samp_pts_label_x_y_mat(i, :) = [{'*'} {sket_articu_cont(i,1)} {sket_articu_cont(i,2)}]; %2是x轴，3是y轴
end

fig = printSampPointOnFixExpandImg(image, sket_articu_cont, status_color);
opts.method = 'euclidean'; closingDistThreshold = 10.0;
while true
    [xi yi button] = ginput(1);
    if button == 1
        [xi, yi] = regularizePointIntoImageBounds(rowMax, colMax, xi, yi);
        plot(xi, yi, '.m'); hold on;
        if start_drawing_polygon_boundingbox == false
            plot(xi, yi, 'oc'); hold on;
            polygon_boundingbox_mat = zeros([rowMax colMax]);
            start_drawing_polygon_boundingbox = true;
            starting_coord_x = xi; starting_coord_y = yi;
        elseif sqrt(calcDist([xi yi], [starting_coord_x starting_coord_y], opts)) > closingDistThreshold
            polygon_boundingbox_mat = drawWideLineInMatrix(polygon_boundingbox_mat, xi, yi, last_coord_x, last_coord_y);
            plot([last_coord_x, xi],[last_coord_y, yi], 'color', 'm');
        else
            plot([last_coord_x, xi],[last_coord_y, yi], 'color', 'm');
            plot([starting_coord_x, xi], [starting_coord_y, yi], 'color', 'm');
            polygon_boundingbox_mat = drawWideLineInMatrix(polygon_boundingbox_mat, xi, yi, last_coord_x, last_coord_y);
            polygon_boundingbox_mat = drawWideLineInMatrix(polygon_boundingbox_mat, xi, yi, starting_coord_x, starting_coord_y);
            filled_polygon_boundingbox_mat = imfill(polygon_boundingbox_mat, 'holes');
            filled_polygon_boundingbox_mat = 1 - filled_polygon_boundingbox_mat;
            
            [cur_seg_pts_idx_arr] = labelSampPointsWithinBoundingBox(filled_polygon_boundingbox_mat, samp_pts_label_x_y_mat);
            onlyPlotCurrSegmentBasedOnCorresLabel(cur_seg_pts_idx_arr, '?', status_color, sket_articu_cont);
            
            while true
                [xi, yi, button] = ginput(1);
                if button == 'y'
                    samp_pts_label_x_y_mat = labelCurSegSampPts(cur_seg_pts_idx_arr, '!', samp_pts_label_x_y_mat, sket_articu_cont);
                    onlyPlotCurrSegmentBasedOnCorresLabel(cur_seg_pts_idx_arr, '!', status_color, sket_articu_cont);
                    break; % 感叹号label 对应红色，用于突出显示当前段                      
                elseif button == 'n'
                    onlyPlotCurrSegmentBasedOnCorresLabel(cur_seg_pts_idx_arr, '*', status_color, sket_articu_cont);
                    cur_seg_pts_idx_arr = [];
                    break;
                else
                    continue;
                end
            end
            start_drawing_polygon_boundingbox = false;
        end
        last_coord_x = xi;
        last_coord_y = yi;
    elseif button == 'g'
        close(fig); break; 
    end
end
    
end