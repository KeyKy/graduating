function [ proc_img ] = preprocessSketImage( Image )
globalVar;

image = csToMatlab(Image);
boundImg = imageBoxBounding(image);
rescaleImg = imageResizeWithNearest(boundImg);
rescaleBinaryImg = imageRescaledBinaryzation(rescaleImg, FACTOR_OF_RESCALE_BINARYZATION);
proc_img = imageBoundaryExpandFixSize(rescaleBinaryImg, IMAGE_EDGE_LENGTH, IMAGE_EDGE_LENGTH);
end

