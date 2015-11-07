function [VC_feats] = compu_contour_VC(articu_cont, eight_conn_pixel_points)
sm = sparse(eight_conn_pixel_points(:,2), eight_conn_pixel_points(:,1), 1);
n_points = size(articu_cont,1);
VC_feats = zeros(n_points, n_points);
for i = 1 : n_points
    point1 = [articu_cont(i, 2) articu_cont(i, 1)];
    for j = i+1 : n_points
        point2 = [articu_cont(j, 2) articu_cont(j, 1)];
        [row, col] = bresenham(point1(1), point1(2), point2(1), point2(2));
        visable = 0;
        for k = 1 : length(row)
            if full(sm(row(k), col(k))) == 1
                visable = visable + 1;
            end
        end
        VC_feats(i, j) = visable;
        VC_feats(j, i) = visable;
    end
end


end