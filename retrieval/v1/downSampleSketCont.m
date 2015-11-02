function [ Contours ] = downSampleSketCont( strokeStr )
segLines = splitStr(strokeStr(1:end-1), '#');
Contours = cell(0,1);
lenOfLines = length(segLines);
for i = 1 : lenOfLines
    xyCoorStr = splitStr(segLines{i}(1:end-1), ',');
    j = 1;
    points = [];
    while(j <= length(xyCoorStr))
        points = [points; str2num(xyCoorStr{j}) str2num(xyCoorStr{j+1})];
        j = j + 2;
    end
    Contours{end+1,1} = points';
end

end

