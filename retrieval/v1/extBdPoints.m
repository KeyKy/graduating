function [eight_conn_pixel_points, n_points_each_boundry] = extBdPoints(boundries)
eight_conn_pixel_points = [];
n_points_each_boundry = [];
for i = 1 : length(boundries)
    eight_conn_pixel_points = [eight_conn_pixel_points; boundries{i}(:,2) boundries{i}(:,1)];
    n_points_each_boundry = [n_points_each_boundry size(boundries{i}, 1)];
end

end