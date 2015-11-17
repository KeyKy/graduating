function dist = calcModelDist(m_first_infos, m_sec_infos, bothDrawIdx)
dist = 0;
n_bothDraw = length(bothDrawIdx);
for i = 1 : n_bothDraw
    m1_sketchStruct = m_first_infos{bothDrawIdx(i)}{1};
    m2_sketchStruct = m_sec_infos{bothDrawIdx(i)}{1};
    dist = dist + sum((m1_sketchStruct.the_histogram - m2_sketchStruct.the_histogram).^2);
    
end
dist = dist / n_bothDraw;
end