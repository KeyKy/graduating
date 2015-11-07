function [ result ] = drawLine( img,row1,col1,row2,col2,colorP )
[row, col] = bresenham(row1, col1, row2, col2);
result = zeros(size(img));
for i = 1 : length(row)
    result(row(i), col(i)) = colorP;
end

end

