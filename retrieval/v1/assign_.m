function [sket_histogram] = assign_(dictionary, sket_feats)
n_c = size(dictionary, 1);
sket_histogram = zeros(1, n_c);
[np,nFeat] = size(sket_feats);
for i = 1 : np
    min = 999999; midx = 1;
    for j = 1 : n_c
        tmp = sum((dictionary(j,:) - sket_feats(i,:)).^2);
        if tmp < min
            min = tmp;
            midx = j;
        end
    end
    sket_histogram(1,midx) = sket_histogram(1,midx) + 1;
end
sket_histogram = sket_histogram / np;
end