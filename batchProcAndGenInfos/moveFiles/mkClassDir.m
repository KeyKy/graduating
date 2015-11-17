function [  ] = mkClassDir(  )
path = 'F:\sketch\inputForTest\';
[~,classInfos] = genCateInfo();
for i = 1 : length(classInfos)
    mkdir(sprintf('%s%s',path, classInfos{i}));
end

end

