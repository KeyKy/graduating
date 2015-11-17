function [ filed ] = moveSketch(  )
% ½«SketchÒÆµ½inputForTestÖÐ
modelInfos = genModelInfos();
modelToClass = containers.Map();
srt = 'F:\sketch\total\';
filed = {};
dst = 'F:\sketch\inputForTest\';
sketches = dir(srt);
for i = 1 : length(modelInfos)
    modelToClass(modelInfos{i}.modelName) = modelInfos{i}.className;
end

for i = 3 : length(sketches)
    sketchNameFull = sketches(i).name;
    disp(sketchNameFull);
    splited = splitStr(sketchNameFull,'_');
    modelName = splited{1};
    className = modelToClass(modelName);
    srtPath = sprintf('%s%s',srt,sketchNameFull);
    dstPath = sprintf('%s%s\\%s',dst, className, sketchNameFull);
    try
        copyfile(srtPath, dstPath);
    catch
        filed{end+1} = sketchNameFull;
    end
end
    

end

