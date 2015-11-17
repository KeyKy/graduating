function [ filedFiles ] = moveFilled(  )
path = 'F:\projections\filledFixExpandImg\';
dstBasePath = 'F:\projections\BOF\';
filedFiles = {};
modelInfos = genModelInfos();
for i = 1 : length(modelInfos)
    className = modelInfos{i}.className;
    for j = 0 : 6
        for k = 0 : 1
            fileName = sprintf('%s_%s_%s.png',modelInfos{i}.modelName,num2str(j),num2str(k));
            disp(fileName);
            srt = sprintf('%s%s', path, fileName);
            dst = sprintf('%s%s\\%s', dstBasePath, className, fileName);
            try
                if exist(dst,'file')
                else
                    copyfile(srt,dst);
                end
            catch
                filedFiles{end+1} = fileName;
            end
        end
    end

end



end

