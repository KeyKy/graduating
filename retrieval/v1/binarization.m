function binarizedImg = binarization( image , threshold )
[rows, cols] = size(image);
for i = 1:rows
    for j = 1:cols
        if image(i, j) > threshold
            image(i, j) = 1;
        end
    end
end
binarizedImg = double(image);
end

