function [histogram] = quantify(center, assignment)
histogram = zeros(size(center,1), 1);
for i = 1 : size(assignment, 1)
    histogram(assignment(i,1),1) = histogram(assignment(i,1),1) + 1;
end
histogram = histogram / size(assignment,1);
end