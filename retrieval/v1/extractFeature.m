function [SC_feats] = extractFeature(articu_cont, eight_conn_pixel_points, n_poins_each_boundry)
featGlobalVar;

%% 计算 SC 特征(借鉴 IDSC 算法的 bTangent 预处理，使得特征满足 旋转不变性) 
%SC_feats是沿着列走表示点的idx，沿着行走表示为SC特征的维度。 M*N，M是特征维度，N是sample点的个数 
[SC_feats, euclid_dist_mat, ang_mat] = compu_contour_SC( articu_cont, n_dist, n_theta, bTangent);

%% 计算平均欧式距离、均方欧式距离、欧氏距离方差和第10、第20、...第90分为点的距离值作为12维特征向量。
[AED_feats] = compu_contour_AED(euclid_dist_mat, n_contsamp);

%% 计算每个点到质心的距离(Samples To Mass Center)
[S2MC_feats] = compu_contour_S2MC(articu_cont);

%% 计算该点的连通分量的比重(Connected Component Weight)
[CCW_feats] = compu_contour_CCW(eight_conn_pixel_points, n_poins_each_boundry);

%% 计算傅里叶描述子
[FD_feats] = compu_contour_FD(eight_conn_pixel_points, sizeOfFD);

%% 计算Freeman Chain Code FFC_feats.diffmm是一阶最小值链码差分（1-by-np)
[FCC_feats] = compu_contour_FCC(eight_conn_pixel_points);

%% 计算LBP（Local Binary Pattern)
[LBP_feats] = compu_contour_LBP();

%% Hu矩 统计矩

%% 
end