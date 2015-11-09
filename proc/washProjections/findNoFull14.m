% ���룺washPath, start, end_
% ���������ģ�ͱ�ţ�û�нس�14��ͼ��ģ�ͱ��
function [noFullIdx, noFullStatus] = findNoFull14()
globalVar;
washPath = PATH_1251_1499; %%�趨Ҫ������ļ��е����֣��Ǵ��ĸ�ģ�͵��ĸ�ģ��
start = 1251;             %%�趨��ʼģ�͵ı��
end_ = 1499;              %%�趨����ģ�͵ı��
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
noFullIdx = noFull + start - 1; %%����ģ�ͱ�ţ�û�нس�14��ͼ��ģ�ͱ��
noFullStatus = noFull(noFullIdx);
end

