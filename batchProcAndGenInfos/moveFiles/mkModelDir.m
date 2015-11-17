function [ ] = mkModelDir( )
path = 'F:\\sketch\\sketchBelowEachModel\\';
for i = 1 : 1815
    dirName = sprintf('%sm%s\\', path, num2str(i-1));
    mkdir(dirName);
end
end

