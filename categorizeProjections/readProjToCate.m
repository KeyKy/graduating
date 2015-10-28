function [ modelNameToCate, cateToModelName ] = readProjToCate()
CATE_BASE_PATH = 'D:\\projections\\category\\';
cateDirs = dir(CATE_BASE_PATH);
modelNameToCate = containers.Map();
cateToModelName = containers.Map();
for i = 3 : length(cateDirs)
    cateName = cateDirs(i).name;
    modelFiles = dir(sprintf('%s%s',CATE_BASE_PATH,cateName));
    models = {};
    for j = 3 : length(modelFiles)
        splited = splitStr(modelFiles(j).name, '_');
        modelName = splited{1};
        modelNameToCate(modelName) = cateName;
        models{end+1} = modelName;
    end
    cateToModelName(cateName) = models;
end

end

