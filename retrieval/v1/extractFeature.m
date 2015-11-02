function [SC_feats] = extractFeature(articu_cont, eight_conn_pixel_points)
featGlobalVar;

%% ���� SC ����(��� IDSC �㷨�� bTangent Ԥ����ʹ���������� ��ת������) 
%SC_feats���������߱�ʾ���idx���������߱�ʾΪSC������ά�ȡ� M*N��M������ά�ȣ�N��sample��ĸ��� 
[SC_feats, euclid_dist_mat, ang_mat] = compu_contour_SC( articu_cont, n_dist, n_theta, bTangent);

%% ���㸵��Ҷ������
%[FD_feats] = compu_contour_FD(eight_conn_pixel_points, sizeOfFD);

%% ����Freeman Chain Code
[FCC_feats] = compu_contour_FCC(eight_conn_pixel_points);
end