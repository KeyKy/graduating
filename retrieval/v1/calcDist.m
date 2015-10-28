function distance = calcDist(feat1, feat2, options)
if isfield(options, 'method')
    switch options.method
        case {'euclidean'}
            distance = sum((feat1 - feat2).^2);
        case {'cosine'}
            distance = 1 - (dot(feat1,feat2) / (sqrt(feat1*feat1') * sqrt(feat2*feat2')));
        otherwise
            distance = 0;
    end
end

end