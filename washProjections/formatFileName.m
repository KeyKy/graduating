% 大家的命名都为模型编号-视角-点击，现在改为模型编号_视角_点击
% 输入：washPath
% 输出：修改后的文件名字，修改后的文件在同一目录下，就是做文件的rename
%
function formatFileName()
globalVar;
washPath = PATH_1251_1499; %设置要修改的路径
files = dir(sprintf('%s%s', BASE_PATH, washPath));
numOfFiles = length(files);

for i = 3 : numOfFiles
    nameOfFile = files(i).name;
    originalPath = sprintf('%s%s\\\\%s',BASE_PATH,washPath,nameOfFile);
    splitedFile = splitStr(nameOfFile, '-');
    newNameOfFile = sprintf('%s_%s_%s',splitedFile{1,1}, splitedFile{1,2}, splitedFile{1,3});
    dstPath = sprintf('%s%s\\\\%s',BASE_PATH,washPath,newNameOfFile);
    movefile(originalPath, dstPath);
end


end

