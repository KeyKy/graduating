function [perimImg] = getPerim(fixExpandImg)
img = zeros(size(fixExpandImg));
[boundries] = bwboundaries(fixExpandImg);
for i = 1 : length(boundries)
    set_rc = boundries{i};
    for j = 1 : size(set_rc, 1)
        img(set_rc(j,1), set_rc(j,2)) = 1;
    end
end

perimImg = bwperim(img);
imshow(perimImg);

end