function [ userName ] = extractUserName( path )
tmp = splitStr(path, '\');
txtName = tmp{end};
tmp = splitStr(txtName, '_');
userName = tmp{1,3};
end

