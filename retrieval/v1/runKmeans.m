function [center, assignment, others] = runKmeans(designMatrix, parms)
% IDX = kmeans(X,k) partitions the points in the n-by-p data matrix X into k clusters.
% kmeans returns an n-by-1 vector IDX containing the cluster indices of each point.
% [IDX,C] = kmeans(X,k) returns the k cluster centroid locations in the k-by-p matrix C.
% [IDX,C,sumd] = kmeans(X,k) returns the within-cluster sums of point-to-centroid distances in the 1-by-k vector sumd.
% [IDX,C,sumd,D] = kmeans(X,k) returns distances from each point to every centroid in the n-by-k matrix D.
% Input X is n-by-p matrix where n is the number of data points and p is the
% dim of feature.
% Output others is statistics value. for kmeans is sumd, D and so on.

[assignment, center, sumd, D] = kmeans(designMatrix, parms{1});
others = {};
others{1} = sumd;
others{2} = D;
end