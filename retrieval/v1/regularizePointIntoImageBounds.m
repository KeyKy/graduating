function [xi yi] = regularizePointIntoImageBounds(rowMax, colMax, xi, yi)

if xi < 2
    xi = 2;
end

if yi < 2
    yi = 2;
end

if xi > colMax - 2
    xi = colMax - 2;
end

if yi > rowMax - 2
    yi = rowMax - 2;
end

end