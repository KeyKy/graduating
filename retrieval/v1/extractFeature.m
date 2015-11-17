function [SC_feats] = extractFeature(articu_cont, eight_conn_pixel_points, n_poins_each_boundry, fixExpandImg)
featGlobalVar;

%% 计算 SC 特征(借鉴 IDSC 算法的 bTangent 预处理，使得特征满足 旋转不变性) 
%SC_feats是沿着列走表示点的idx，沿着行走表示为SC特征的维度。 M*N，M是特征维度，N是sample点的个数 
[SC_feats, euclid_dist_mat, ang_mat] = compu_contour_SC( articu_cont, n_dist, n_theta, bTangent);

%% 计算平均欧式距离、均方欧式距离、欧氏距离方差和第10、第20、...第90分为点的距离值作为12维特征向量。
%[AED_feats] = compu_contour_AED(euclid_dist_mat, n_contsamp);

%% 计算每个点到质心的距离(Samples To Mass Center)
%[S2MC_feats] = compu_contour_S2MC(articu_cont);

%% 计算该点的连通分量的比重(Connected Component Weight)
%[CCW_feats] = compu_contour_CCW(eight_conn_pixel_points, n_poins_each_boundry);

%% 计算傅里叶描述子(Fourier Descriptor)
%[FD_feats] = compu_contour_FD(eight_conn_pixel_points, sizeOfFD);

%% 计算费尔曼链码(Freeman Chain Code)
%FCC_feats = []; start = 1;
%for i = 1 : length(n_poins_each_boundry)
%    points = eight_conn_pixel_points(start:start+n_poins_each_boundry(i)-1,:);
%    [FCC] = compu_contour_FCC(points);
%    FCC_feats = [FCC_feats FCC.diffmm];
%    start = start + n_poins_each_boundry(i);
%end

%% Z矩 统计矩（Zernike Moments)
%[ZM_feats] = compu_contour_ZM(fixExpandImg);

%% 视觉可达性（Visible Connect)
%[VC_feats] = compu_contour_VC(articu_cont, eight_conn_pixel_points);
end