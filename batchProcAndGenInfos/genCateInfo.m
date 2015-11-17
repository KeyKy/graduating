function [ cateInfos , classInfos] = genCateInfo()
path = 'C:\MATLAB\category\';
classNames = dir(path);
cateInfos = containers.Map();
classInfos = {};
for i = 3 : length(classNames)
    catePath = sprintf('%s%s', path, classNames(i).name);
    cateNames = dir(catePath);
    classInfos{end+1} = classNames(i).name;
    for j = 3 : length(cateNames);
        cateInfos(cateNames(j).name) = classNames(i).name;
    end
end

end

