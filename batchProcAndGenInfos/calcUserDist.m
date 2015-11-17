function dist = calcUserDist(u1Info, u2Info, bothDrawModelIdx)

dist = 0; 
n_bothDraw = length(bothDrawModelIdx);
for i = 1 : n_bothDraw
    u1_sketchStruct = u1Info{bothDrawModelIdx(i)}{1};
    u2_sketchStruct = u2Info{bothDrawModelIdx(i)}{1};
    %[u1_fixExpandImg, u1_Contours, u1_sket_feats] = proprecessing(u1_sketchStruct);
    %u1_reduced_sket_feats = u1_sket_feats' * eigvector;
    %[u1_sket_histogram] = assign_(dictionary, u1_reduced_sket_feats);
    
    %[u2_fixExpandImg, u2_Contours, u2_sket_feats] = proprecessing(u2_sketchStruct);
    %u2_reduced_sket_feats = u2_sket_feats' * eigvector;
    %[u2_sket_histogram] = assign_(dictionary, u2_reduced_sket_feats);
    dist = dist + sum((u1_sketchStruct.the_histogram - u2_sketchStruct.the_histogram).^2);
end
dist = dist / n_bothDraw;
end