function [center, assignment, others] = runKmeans_cosine(designMatrix, parms)

[assignment, center, sumd, D] = kmeans(designMatrix, parms{1}, 'distance', 'cosine');
others = {};
others{1} = sumd;
others{2} = D;
end