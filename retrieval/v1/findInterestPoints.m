function [ cornerCoord ] = findInterestPoints(fixExpandImg , opts )

if ~exist('opts', 'var') || ~isfield(opts, 'method')
    opts.method = 'harris';
end

if ~isfield(opts, 'harris_k')
    opts.harris_k = 0.15;
end

if ~isfield(opts, 'isPlot')
    opts.isPlot = 0;
end

switch opts.method
    case{'harris'}
        cornerCoord = findHarrisCorner(fixExpandImg, opts.harris_k);
    otherwise
        cornerCoord = [];
end

if opts.isPlot
    imshow(fixExpandImg); hold on;
    plot(cornerCoord(:,2), cornerCoord(:,1), 'g.');
end

end

