function [sket_articu_cont, idx] = interestPoints(points)
sket_articu_cont = []; idx = [];
n_points = length(points);
for i = 1 : n_points
    if points{i,1} == '!'
        sket_articu_cont = [sket_articu_cont; [points{i,2} points{i,3}]];
        idx = [idx; i];
    end
end

end