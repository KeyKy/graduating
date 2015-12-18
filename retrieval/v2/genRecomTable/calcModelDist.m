function dist = calcModelDist(m_first_infos, m_sec_infos, bothDrawIdx)
dist = 0;
n_bothDraw = length(bothDrawIdx);
for i = 1 : n_bothDraw
    m1_sketchStruct = m_first_infos{bothDrawIdx(i)}{1};
    m2_sketchStruct = m_sec_infos{bothDrawIdx(i)}{1};
    
    [A2B_dist, A2B_assignment, ~] = assignDistanceA2B(m1_sketchStruct.the_corner_feats, m2_sketchStruct.the_feats);
    [B2A_dist, B2A_assignment, ~] = assignDistanceA2B(m2_sketchStruct.the_corner_feats, m1_sketchStruct.the_feats);
    
    dist = dist + A2B_dist + B2A_dist;
end
dist = dist / n_bothDraw;
end