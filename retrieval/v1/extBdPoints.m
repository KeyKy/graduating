function points = extBdPoints(boundries)
points = [];
for i = 1 : length(boundries)
    points = [points; boundries{i}(:,2) boundries{i}(:,1)];
end

end