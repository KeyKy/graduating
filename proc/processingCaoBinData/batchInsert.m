function batchInsert()
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
conn = connToDatabase();
for files_idx = 3 : front_files_names_num
    frontFilePath = sprintf('%s%s',frontPath, cell2mat(frontFilesNamesArr(files_idx)));
    sideFilePath = sprintf('%s%s',sidePath, cell2mat(sideFilesNamesArr(files_idx)));
    topFilePath = sprintf('%s%s',topPath, cell2mat(topFilesNamesArr(files_idx)));
    
    userName = extractUserName(frontFilePath);
    
    frontOriginalStr = readTxtToOriginalStr(frontFilePath);
    sideOriginalStr = readTxtToOriginalStr(sideFilePath);
    topOriginalStr = readTxtToOriginalStr(topFilePath);
    
    [frontSelectModels, frontSketStr] = splitModelAndSket(frontOriginalStr);
    [~, sideSketStr] = splitModelAndSket(sideOriginalStr);
    [~, topSketStr] = splitModelAndSket(topOriginalStr);
    
    [~, frontCompressedMatStr] = reshapeSketStrToSketMat(frontSketStr, CANVAS_HEIGHT, CANVAS_WIDTH);
    [~, sideCompressedMatStr] = reshapeSketStrToSketMat(sideSketStr, CANVAS_HEIGHT, CANVAS_WIDTH);
    [~, topCompressedMatStr] = reshapeSketStrToSketMat(topSketStr, CANVAS_HEIGHT, CANVAS_WIDTH);
    
    insertIntoDatabase(conn, userName, frontCompressedMatStr, sideCompressedMatStr, topCompressedMatStr, frontSelectModels);
    
    disp(sprintf('%s%s','saving into database...', frontFilePath));
end
closeDatabase(conn);

end

