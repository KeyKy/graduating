function batchFilterSketUI()
addConstVar;

basePath = BASE_PATH;
prefix = 'userSketch';
postfix = '_chooseModel\';
frontPath = sprintf('%s%s%s%s',basePath, prefix, 'front', postfix);
sidePath = sprintf('%s%s%s%s',basePath, prefix, 'side', postfix);
topPath = sprintf('%s%s%s%s',basePath, prefix, 'top', postfix);

frontFilesDirsArr = struct2cell(dir(frontPath))';
frontFilesNamesArr = frontFilesDirsArr(:,1);
front_files_names_num = size(frontFilesNamesArr);

sideFilesDirsArr = struct2cell(dir(sidePath))';
sideFilesNamesArr = sideFilesDirsArr(:,1);

topFilesDirsArr = struct2cell(dir(topPath))';
topFilesNamesArr = topFilesDirsArr(:,1);

for files_idx = 3 : front_files_names_num
    frontFilePath = sprintf('%s%s',frontPath, cell2mat(frontFilesNamesArr(files_idx)));
    sideFilePath = sprintf('%s%s',sidePath, cell2mat(sideFilesNamesArr(files_idx)));
    topFilePath = sprintf('%s%s',topPath, cell2mat(topFilesNamesArr(files_idx)));

    frontFileName = extractFileNameFromPath(frontFilePath);
    sideFileName = extractFileNameFromPath(sideFilePath);
    topFileName = extractFileNameFromPath(topFilePath);
    
    frontOriginalStr = readTxtToOriginalStr(frontFilePath);
    sideOriginalStr = readTxtToOriginalStr(sideFilePath);
    topOriginalStr = readTxtToOriginalStr(topFilePath);
    
    [~, frontSketStr] = splitModelAndSket(frontOriginalStr);
    [~, sideSketStr] = splitModelAndSket(sideOriginalStr);
    [~, topSketStr] = splitModelAndSket(topOriginalStr);
    
    [frontSketMat, ~] = reshapeSketStrToSketMat(frontSketStr, CANVAS_HEIGHT, CANVAS_WIDTH);
    [sideSketMat, ~] = reshapeSketStrToSketMat(sideSketStr, CANVAS_HEIGHT, CANVAS_WIDTH);
    [topSketMat, ~] = reshapeSketStrToSketMat(topSketStr, CANVAS_HEIGHT, CANVAS_WIDTH);

    subplot(1,3,1); imshow(frontSketMat); 
    subplot(1,3,2); imshow(sideSketMat); 
    subplot(1,3,3); imshow(topSketMat); hold on;
    set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1]);
    [xi, yi, button] = ginput(1);
    if button == 'r'
        movefile(frontFilePath, sprintf('%s%s',FILTERED_PATH, frontFileName));
        movefile(sideFilePath, sprintf('%s%s',FILTERED_PATH, sideFileName));
        movefile(topFilePath, sprintf('%s%s',FILTERED_PATH, topFileName));
    end
    hold off;
end

hold off;
end

