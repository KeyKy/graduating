function [image, boundImg, rescaleImg, rescaleBinaryImg, fixExpandImg, filledFixExpandImg] = preprocessProjImage(fullFilenameWithPath, imgEdgeLength)
globalVar;
if ~exist('imgEdgeLength', 'var')
    imgEdgeLength = IMAGE_EDGE_LENGTH;
end
image = imread(fullFilenameWithPath);        %   txt��ʽ����ͼ��ȡ
img = im2bw(image, 0);       % �˶�ֵ�����裺Ϊ�˰�Χ�ж����е�Ԥ���������г�ģ���������������
%figure(1); imshow(img); hold on;
img = 1-img;                 % �˷�ɫ���裺  Ϊ�˰�Χ�ж����е�Ԥ���������г�ģ���������������
boundImg = imageBoxBounding(img);
%figure(2); imshow(boundImg); hold on;
rescaleImg = imageResize(boundImg);
%figure(3); imshow(rescaleImg); hold on;
rescaleBinaryImg = imageRescaledBinaryzation(rescaleImg, FACTOR_OF_RESCALE_BINARYZATION);
%figure(4); imshow(rescaleBinaryImg); hold on;
fixExpandImg = imageBoundaryExpandFixSize(rescaleBinaryImg, imgEdgeLength, imgEdgeLength);
%figure(5); imshow(fixExpandImg); hold on;
filledFixExpandImg = bwfill(fixExpandImg, 'holes');
%figure(6); imshow(filledFixExpandImg); hold on;
%keyboard;
