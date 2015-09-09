function  fileName  = extractFileNameFromPath( path )
tmp = splitStr(path, '\');
fileName = tmp{1,end};
end

