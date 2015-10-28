function resizedImg = imageResizeWithNearest(boxImg)
[height,width] = size(boxImg);
maximun = max([height,width]);
if maximun ~= 0
    scaleFactor = 190.0 / maximun;
    %scaleFactor = 380.0 / maximun;
    resizedImg = imresize(boxImg, scaleFactor, 'nearest');
else
    resizedImg = imresize(boxImg, [200,200]);
    %resizedImg = imresize(boxImg, [400,400]);
end