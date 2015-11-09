function batchExtractContour()
globalVar;

fileDir = '1500-1814';
dstDir = 'contour-1500-1814';
batchPath = sprintf('%s%s', BASE_PATH, fileDir);
dst = sprintf('%s%s', BASE_PATH, dstDir);

files = dir(batchPath);
numOfFile = length(files);

for i = 3 : numOfFile
    fileName = files(i).name;
    src = sprintf('%s\\%s', batchPath, fileName);
    [image, boundImg, rescaleImg, rescaleBinaryImg, fixExpandImg, filledFixExpandImg] = preprocessProjImage(src,200);
    contour = bwperim(filledFixExpandImg);
    imwrite(contour, sprintf('%s\\%s', dst, fileName));
end


end

