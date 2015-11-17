function [  ] = moveSketchToModelDir(  )
path = 'F:\\sketch\\png\\';
dstBasePath = 'F:\\sketch\\sketchBelowEachModel\\';
sketchInfos = genSketchInfos();

for i = 1 : length(sketchInfos)
    the_modelName = sketchInfos{i}.the_modelName;
    srtDir = sketchInfos{i}.the_png_path;
    dstDir = sprintf('%s%s\\%s', dstBasePath, the_modelName, sketchInfos{i}.the_sketchName);
    copyfile(srtDir, dstDir);
end


end

