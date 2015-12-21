function [ outImage ] = drawSvgImage( totalStroke )
outImage = zeros(2000,2000);
for i = 1 : length(totalStroke)
    outr = totalStroke{i};
    for j = 1 : size(outr, 2) - 1
        outImage = DrawLineImage(outImage, outr(1,j), outr(2,j), outr(1,j+1), outr(2,j+1));
    end
end
end

