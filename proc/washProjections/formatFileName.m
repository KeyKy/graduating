% ��ҵ�������Ϊģ�ͱ��-�ӽ�-��������ڸ�Ϊģ�ͱ��_�ӽ�_���
% ���룺washPath
% ������޸ĺ���ļ����֣��޸ĺ���ļ���ͬһĿ¼�£��������ļ���rename
%
function formatFileName()
globalVar;
washPath = PATH_1251_1499; %����Ҫ�޸ĵ�·��
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

