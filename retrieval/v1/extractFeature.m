function [SC_feats] = extractFeature(articu_cont, eight_conn_pixel_points, n_poins_each_boundry)
featGlobalVar;

%% ���� SC ����(��� IDSC �㷨�� bTangent Ԥ����ʹ���������� ��ת������) 
%SC_feats���������߱�ʾ���idx���������߱�ʾΪSC������ά�ȡ� M*N��M������ά�ȣ�N��sample��ĸ��� 
[SC_feats, euclid_dist_mat, ang_mat] = compu_contour_SC( articu_cont, n_dist, n_theta, bTangent);

%% ����ƽ��ŷʽ���롢����ŷʽ���롢ŷ�Ͼ��뷽��͵�10����20��...��90��Ϊ��ľ���ֵ��Ϊ12ά����������
[AED_feats] = compu_contour_AED(euclid_dist_mat, n_contsamp);

%% ����ÿ���㵽���ĵľ���(Samples To Mass Center)
[S2MC_feats] = compu_contour_S2MC(articu_cont);

%% ����õ����ͨ�����ı���(Connected Component Weight)
[CCW_feats] = compu_contour_CCW(eight_conn_pixel_points, n_poins_each_boundry);

%% ���㸵��Ҷ������
[FD_feats] = compu_contour_FD(eight_conn_pixel_points, sizeOfFD);

%% ����Freeman Chain Code FFC_feats.diffmm��һ����Сֵ�����֣�1-by-np)
[FCC_feats] = compu_contour_FCC(eight_conn_pixel_points);

%% ����LBP��Local Binary Pattern)
[LBP_feats] = compu_contour_LBP();

%% Hu�� ͳ�ƾ�

%% 
end