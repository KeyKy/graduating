function [  ] = modeFilledByCell( input )
dst = 'F:\projections\BOF\';
srt = 'F:\projections\filledFixExpandImg\';

modelInfos = genModelInfos();
for i = 1 : length(input)
    modelNameFull = input{i};
    splited = splitStr(modelNameFull, '_');
    modelName = splited{1};
    for j = 1 : length(modelInfos)
        if strcmp(modelName, modelInfos{i}.modelName) == 1
            className = modelInfos{j}.className;
            srtPath = sprintf('%s%s', srt, modelNameFull);
            dstPath = sprintf('%s%s\\%s', dst, className, modelNameFull);
            copyfile(srtPath, dstPath);
        end
    end

end

