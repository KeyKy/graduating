function [center, assignment, others] = runClusterMethod(designMatrix, methodName, parms)
if strcmp(methodName, 'kmeans') == 1
    [center, assignment, others] = runKmeans(designMatrix, parms{1});
else
end

end