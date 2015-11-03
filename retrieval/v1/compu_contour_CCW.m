function [CCW_feats] = compu_contour_CCW(eight_conn_pixel_points, n_points_each_boundry)
[n_pixel] = size(eight_conn_pixel_points, 1);
CCW_feats = zeros(n_pixel, 1);
n_boundries = length(n_points_each_boundry);
accu = [n_points_each_boundry(1)];
for j = 2 : n_boundries
    accu(j) = accu(j-1) + n_points_each_boundry(j); 
end

for i = 1 : n_pixel
    for j = 1 : n_boundries
        if i <= accu(j)
            CCW_feats(i, 1) = n_points_each_boundry(j) / n_pixel;
            break;
        end
    end
end


end