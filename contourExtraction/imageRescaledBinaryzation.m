function rescaleBinaryImg = imageRescaledBinaryzation(rescaledImg, up_f)
[height,width] = size(rescaledImg);
for idxH = 1:height
    for idxW = 1:width
        if rescaledImg(idxH,idxW) > up_f
            rescaledImg(idxH,idxW) = 1;
        else
            rescaledImg(idxH,idxW) = 0;
        end
    end
end
rescaleBinaryImg = rescaledImg;
end
