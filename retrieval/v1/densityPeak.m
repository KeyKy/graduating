function [ output_args ] = densityPeak( designMatrix )
distMat = calcDistMatrix(designMatrix);
parms = {}; parms{1} = 'lhbound'; parms{2} = 
end

function distMat = calcDistMatrix(designMatrix)
n_data = size(designMatrix,1);
distMat = zeros(n_data,n_data)
options.method = 'euclidean';
for i = 1 : n_data
    feat1 = distMat(i,:);
    for j = 1 : n_data
        if i==j
            continue;
        end
        feat2 = distMat(j,:);
        distMat(i,j) = calcDist(feat1,feat2,options);
    end
end
end

function dc = getDc(distMat, parms)
switch parms{1}
    case {'lhbound'}
        dc = getDcLHBound(distMat, parms);
    case {'percentile'}
        dc = getDcPercentile(distMat, parms);
    otherwise
        dc = 0.2;
end
end

function dc = getDcLHBound(distMat, parms)
n_data = size(distMat, 1);
n_low = parms{2} * n_data * n_data;
n_high = parms{3} * n_data * n_data;
dc = 0.0;
neighboors = 0;
while(neighboors < n_low || neighboors > n_high)
    neighboors = 0;
    flag = 0;
    for i = 1 : n_data - 1
        for j = 1 : n_data
            if(i == j) 
                continue;
            end
            if distMat(i,j) <= dc
                neighboors = neighboors + 1;
            end
            if neighboors > n_high
                flag = 1;
                break;
            end
        end
        if flag == 1
            break;
        end
    end
    if flag == 1
        dc = dc - 0.01;
    else
        dc = dc + 0.03;
    end
end
end

function dc = getDcPercentile(distMat, parms)
arr = [];
for i = 1 : n_data
    for j = i : n_data
        if i == j
            continue;
        end
        arr = [arr distMat(i,j)];
    end
end
sorted_arr = sort(arr);
N = length(arr);
position = round(N * parms{2} / 100);
dc = sorted_arr(position);
end