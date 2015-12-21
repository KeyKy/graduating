function [  ] = visPoints( pts )
for i = 1 : length(pts);
    xy_coor = pts{i};
    x = xy_coor(1,:);
    y = xy_coor(2,:);
    plot(x,y, 'r.'); hold on;
end

end

