function [center, assignment, others] = runKmeans_cosine(designMatrix, parms)
[assignment, center, sumd, D] = kmeans(designMatrix, parms{1}, parms{2}, parms{3});
others = {};
others{1} = sumd;
others{2} = D;
end