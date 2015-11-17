function [SC_feats] = extractFeature(articu_cont, eight_conn_pixel_points, n_poins_each_boundry, fixExpandImg)
featGlobalVar;

%% ���� SC ����(��� IDSC �㷨�� bTangent Ԥ����ʹ���������� ��ת������) 
%SC_feats���������߱�ʾ���idx���������߱�ʾΪSC������ά�ȡ� M*N��M������ά�ȣ�N��sample��ĸ��� 
[SC_feats, euclid_dist_mat, ang_mat] = compu_contour_SC( articu_cont, n_dist, n_theta, bTangent);

%% ����ƽ��ŷʽ���롢����ŷʽ���롢ŷ�Ͼ��뷽��͵�10����20��...��90��Ϊ��ľ���ֵ��Ϊ12ά����������
%[AED_feats] = compu_contour_AED(euclid_dist_mat, n_contsamp);

%% ����ÿ���㵽���ĵľ���(Samples To Mass Center)
%[S2MC_feats] = compu_contour_S2MC(articu_cont);

%% ����õ����ͨ�����ı���(Connected Component Weight)
%[CCW_feats] = compu_contour_CCW(eight_conn_pixel_points, n_poins_each_boundry);

%% ���㸵��Ҷ������(Fourier Descriptor)
%[FD_feats] = compu_contour_FD(eight_conn_pixel_points, sizeOfFD);

%% ����Ѷ�������(Freeman Chain Code)
%FCC_feats = []; start = 1;
%for i = 1 : length(n_poins_each_boundry)
%    points = eight_conn_pixel_points(start:start+n_poins_each_boundry(i)-1,:);
%    [FCC] = compu_contour_FCC(points);
%    FCC_feats = [FCC_feats FCC.diffmm];
%    start = start + n_poins_each_boundry(i);
%end

%% Z�� ͳ�ƾأ�Zernike Moments)
%[ZM_feats] = compu_contour_ZM(fixExpandImg);

%% �Ӿ��ɴ��ԣ�Visible Connect)
%[VC_feats] = compu_contour_VC(articu_cont, eight_conn_pixel_points);
end