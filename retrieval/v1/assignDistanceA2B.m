function [distance, assignment, distanceMat] = assignDistanceA2B(feat1, feat2)

[~, n_point1] = size(feat1);
[~, n_point2] = size(feat2);
assignDist = zeros(1, n_point1);
assignment = zeros(1, n_point1);
distanceMat = 999*ones(n_point1, n_point2);
for i = 1 : n_point1
    f1 = feat1(:,i);
    rep_f1 = repmat(f1, [1, n_point2]);
    dist = sum(       ( (rep_f1 - feat2).^2 ) ./ (rep_f1 + feat2 + 0.01)   ,                  1);
    %dist = sum( (rep_f1 - feat2).^2, 1);
    distanceMat(i,:) = dist;
    [D, I] = min(dist);
    assignDist(i) = D;
    assignment(i) = I;
end
distance = sum(assignDist) / (n_point1+0.01);
end