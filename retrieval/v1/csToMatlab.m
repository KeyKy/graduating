function [ proc_sket ] = csToMatlab( sket )
[x, y] = find(sket);
proc_sket = 255 - sket;
for i = 1 : length(x)
    r = x(i);
    c = y(i);
    proc_sket(r, c) = 0;
end
proc_sket = binarization(proc_sket, 0);
end
