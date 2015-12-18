function [ output_args ] = lookingForDiff( input_args )
txtPath = 'F:\sketch\txt\';
pngPath = 'F:\sketch\png\';
txt = dir(pngPath);
for i = 3 : length(txt)
    fileName = txt(i).name;
    fileNameWithoutTxt = fileName(1:end-4);
    if ~exist(sprintf('%s%s.txt',txtPath,fileNameWithoutTxt), 'file')
        disp(fileNameWithoutTxt);
    end
end


end

