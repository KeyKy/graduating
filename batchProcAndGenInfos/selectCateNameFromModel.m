function [ modelSubInfos , idx] = selectCateNameFromModel( modelInfos, modelName )
modelSubInfos = {};
idx = [];
for i = 1 : length(modelInfos)
    if strcmp(modelInfos{i}.modelName, modelName) == 1
        modelSubInfos{end+1} = modelInfos{i};
        idx = [idx i];
    end
end

end

