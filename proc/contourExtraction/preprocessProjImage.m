function [image, boundImg, rescaleImg, rescaleBinaryImg, fixExpandImg, filledFixExpandImg] = preprocessProjImage(fullFilenameWithPath, imgEdgeLength)

image = imread(fullFilenameWithPath);        %   txt格式的视图读取
img = im2bw(image, 0);       % 此二值化步骤：为了包围盒而进行的预处理，不单列出模块计入整体流程中
%figure(1); imshow(img); hold on;
img = 1-img;                 % 此反色步骤：  为了包围盒而进行的预处理，不单列出模块计入整体流程中
boundImg = imageBoxBounding(img);
%figure(2); imshow(boundImg); hold on;
rescaleImg = imageResize(boundImg);
%figure(3); imshow(rescaleImg); hold on;
rescaleBinaryImg = imageRescaledBinaryzation(rescaleImg, 0.8);
%figure(4); imshow(rescaleBinaryImg); hold on;
fixExpandImg = imageBoundaryExpandFixSize(rescaleBinaryImg, imgEdgeLength, imgEdgeLength);
%figure(5); imshow(fixExpandImg); hold on;
filledFixExpandImg = bwfill(fixExpandImg, 'holes');
%figure(6); imshow(filledFixExpandImg); hold on;
%keyboard;
