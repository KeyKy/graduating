function [ originalStr ] = readTxtToOriginalStr( path )
fid = fopen(path, 'r');
originalStr = fgetl(fid);
end

