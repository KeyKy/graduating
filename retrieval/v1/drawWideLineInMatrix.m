function  outputImage =  drawWideLineInMatrix(Image,x1,y1,x2,y2)
outputImage = Image;
[x,y] = bresenham(x1,y1,x2,y2);
for i = 1 : length(x)
    outputImage(y(i), x(i)) = 1;
end

end