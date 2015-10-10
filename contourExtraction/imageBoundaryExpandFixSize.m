function expandImg = imageBoundaryExpandFixSize(resizedImg, fixHeight, fixWidth)
[height,width] = size(resizedImg);
expandX = floor((fixWidth - width) / 2.0);
expandY = floor((fixHeight - height) / 2.0);
expandImg = ones([fixHeight, fixWidth]);
expandImg(expandY:(expandY+height-1), expandX:(expandX+width-1)) = resizedImg;
expandImg = 1 - expandImg;
end
