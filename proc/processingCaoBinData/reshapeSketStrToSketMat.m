function [ sketMat, compressedMatStr ] = reshapeSketStrToSketMat(sketStr, height, width)
sketStr = sketStr(1:end-1);
sketArray = str2num(sketStr);
sketMat = reshape(sketArray, width, height)';
compressedMatStr = '';
for i = 1 : height
    for j = 1 : width
        if sketMat(i,j) ~= 0
            compressedMatStr = sprintf('%s;%d,%d',compressedMatStr,i,j);
        end
    end
end
compressedMatStr = compressedMatStr(2:end);
end

