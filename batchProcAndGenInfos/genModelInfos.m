function modelInfos = genModelInfos()
path = 'F:\\sketch\\ModelInfos\\';
files = dir(path);
modelInfos = {};
cateInfos = genCateInfo();
for i = 3 : length(files)
    cateName = files(i).name;
    modelPath = sprintf('%s%s\\',path, cateName);
    models = dir(modelPath);
    for j = 3 : length(models)
       splited = splitStr(models(j).name, '_');
       modelName = splited{1};
       modelInfo.cateName = cateName;
       modelInfo.className = cateInfos(cateName);
       modelInfo.modelName = modelName;
       modelInfo.cateIdx = i - 2;
       modelInfos{end+1} = modelInfo;
    end
end

end

