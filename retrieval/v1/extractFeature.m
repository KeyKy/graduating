function [SC_feats] = extractFeature(articu_cont, eight_conn_pixel_points)
featGlobalVar;

%% 计算 SC 特征(借鉴 IDSC 算法的 bTangent 预处理，使得特征满足 旋转不变性) 
%SC_feats是沿着列走表示点的idx，沿着行走表示为SC特征的维度。 M*N，M是特征维度，N是sample点的个数 
[SC_feats, euclid_dist_mat, ang_mat] = compu_contour_SC( articu_cont, n_dist, n_theta, bTangent);

%% 计算傅里叶描述子
%[FD_feats] = compu_contour_FD(eight_conn_pixel_points, sizeOfFD);

%% 计算Freeman Chain Code
[FCC_feats] = compu_contour_FCC(eight_conn_pixel_points);
end