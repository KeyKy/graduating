function evaluateCluster(designMatrix, dictionary)
% silhouette(X,clust) plots cluster silhouettes for the n-by-p data matrix X, 
% with clusters defined by clust. Rows of X correspond to points, 
% columns correspond to coordinates.
% [s,h] = silhouette(X,clust) plots the silhouettes
% s = silhouette(X,clust) returns the silhouette values in the n-by-1 vector s,
[s,h] = silhouette(designMatrix, dictionary, 'Euclidean');


end