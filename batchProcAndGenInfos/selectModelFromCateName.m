function [ modelSubInfos, idx ] = selectModelFromCateName( modelInfos,cateName )
modelSubInfos = {};
idx = [];
for i = 1 : length(modelInfos)
    if strcmp(modelInfos{i}.cateName, cateName) == 1
        modelSubInfos{end+1} = modelInfos{i};
        idx = [idx i];
    end
end

end

