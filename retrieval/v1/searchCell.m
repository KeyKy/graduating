function [ o1 ] = searchCell(c, c1, c2 )
o1 = [];
for i = 1 : length(c)
    if strcmp(c{i}, c1) || strcmp(c{i}, c2)
        o1 = [o1 i];
    end
end

end

