function moveProj(projToCate)
BASE_PATH = 'D:\\projections\\0-250\\';
DST_PATH = 'D:\\projections\\category_proj\\';
projFiles = dir(BASE_PATH);
for i = 3 : length(projFiles)
    tmp = projFiles(i).name;
    splited = splitStr(tmp, '_');
    projName = splited{1};
    cateName = projToCate(projName);
    movefile(sprintf('%s%s',BASE_PATH,tmp), sprintf('%s%s\\%s',DST_PATH,cateName,tmp));
end

end

