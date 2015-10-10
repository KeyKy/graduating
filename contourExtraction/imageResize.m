function resizedImg = imageResize(boxImg)
[height,width] = size(boxImg);
maximun = max([height,width]);
if maximun ~= 0
    scaleFactor = 150.0 / maximun;
    %resizedImg = imresize(boxImg, scaleFactor, 'nearest');
    resizedImg = imresize(boxImg, scaleFactor);
else
    resizedImg = imresize(boxImg, [200,200]);
end