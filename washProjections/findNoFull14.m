% 输入：washPath, start, end_
% 输出：返回模型编号，没有截出14张图的模型编号
function [noFullIdx, noFullStatus] = findNoFull14()
globalVar;
washPath = PATH_1251_1499; %%设定要处理的文件夹的名字，是从哪个模型到哪个模型
start = 1251;             %%设定开始模型的编号
end_ = 1499;              %%设定结束模型的编号
filePath = sprintf('%s%s',BASE_PATH, washPath);
files = dir(filePath);
numOfFiles = length(files);
count = zeros(1, end_ - start + 1);
for i = 3 : numOfFiles
    fileName = files(i).name;
    splitedName = splitStr(fileName, '_');
    modelIdx = splitedName{1,1}(2:end);
    idx = str2double(modelIdx) - start + 1;
    count(idx) = count(idx) + 1;
end

noFull = find(count ~= 14);
noFullIdx = noFull + start - 1; %%返回模型编号，没有截出14张图的模型编号
noFullStatus = noFull(noFullIdx);
end

