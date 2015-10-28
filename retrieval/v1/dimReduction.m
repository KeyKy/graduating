function [reducedDesignMatrix,eigvector] = dimReduction(designMatrix, method ,options)
if strcmp(method, 'pca')
[eigvector, eigvalue] = PCA(designMatrix, options);
reducedDesignMatrix = designMatrix * eigvector;
else

end

end