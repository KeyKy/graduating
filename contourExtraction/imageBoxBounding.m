function boxingImg = imageBoxBounding(binaryImg)
[height,width] = size(binaryImg);
minx = width+1;
maxx = -1;
miny = height+1;
maxy = -1;
for idxH = 1:height
    for idxW = 1:width
        if binaryImg(idxH, idxW) == 0
            if idxW < minx
                minx = idxW;
            end
            if idxW > maxx
                maxx = idxW;
            end
            if idxH < miny
                miny = idxH;
            end
            if idxH > maxy
                maxy = idxH;
            end
        end
    end
end
boxingImg = binaryImg(miny:maxy, minx:maxx);
end