function [sket_histogram] = assign_(dictionary, sket_feats)
n_c = size(dictionary, 1);
sket_histogram = zeros(1, n_c);
[np,~] = size(sket_feats);
for i = 1 : np
%     min = 999999; midx = 1;
%     for j = 1 : n_c
%         tmp = sum((dictionary(j,:) - sket_feats(i,:)).^2);
%         if tmp < min
%             min = tmp;
%             midx = j;
%         end
%     end
%     sket_histogram(1,midx) = sket_histogram(1,midx) + 1;
    f1 = sket_feats(i,:);
    rep_f1 = repmat(f1, [n_c, 1]);
    dist = sum((rep_f1 - dictionary).^2, 2);
    [~, I] = min(dist);
    sket_histogram(1, I) = sket_histogram(1, I) + 1;
end
sket_histogram = sket_histogram / np;
end