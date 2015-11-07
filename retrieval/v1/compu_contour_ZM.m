function [ZM_feats] = compu_contour_ZM(fixExpandImg)
N = [3, 4, 5, 6, 7, 8, 9, 10];
M = [1, 2, 3, 4, 5, 6, 7, 8 ];
ZM_feats = zeros(1,length(N));
for i = 1 : length(N);
    [~, AOH, PhiOH] = Zernikmoment(fixExpandImg,N(i),M(i));
    ZM_feats(1, i) = AOH; 
end

end