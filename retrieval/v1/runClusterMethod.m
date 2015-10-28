function [center, assignment, others] = runClusterMethod(designMatrix, methodName, parms)
switch methodName
    case {'kmeans-euclidean'}
        [center, assignment, others] = runKmeans(designMatrix, parms);
    case {'kmeans-cosine'}
        [center, assignment, others] = runKmeans_cosine(designMatrix, parms);
    otherwise
        center = []; assignment = []; others =[];
end

end