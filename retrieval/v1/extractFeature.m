function [SC_feats] = extractFeature(articu_cont)
featGlobalVar;

%% ���� SC ����(��� IDSC �㷨�� bTangent Ԥ����ʹ���������� ��ת������) 
%SC_feats���������߱�ʾ���idx���������߱�ʾΪSC������ά�ȡ� M*N��M������ά�ȣ�N��sample��ĸ��� 
[SC_feats, euclid_dist_mat, ang_mat] = compu_contour_SC( articu_cont, n_dist, n_theta, bTangent);

%%

end