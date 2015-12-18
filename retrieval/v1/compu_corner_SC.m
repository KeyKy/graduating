function [sc] = compu_corner_SC(corners, sket_cont, sket_dis_mat, sket_ang_mat)
%根据采样点来计算角点的SC，也就是一个角点一个角点加入到采样点中计算，取最后一行作为角点的SC特征
featGlobalVar;
n_corner = size(corners, 1);
n_samp = size(sket_cont, 1);

corner_x = corners(:,2);
corner_y = corners(:,1);
sket_cont_x = sket_cont(:,1);
sket_cont_y = sket_cont(:,2);

corner_X = repmat(corner_x, 1, n_samp);
sket_cont_X = repmat(sket_cont_x', n_corner, 1);

corner_Y = repmat(corner_y, 1, n_samp);
sket_cont_Y = repmat(sket_cont_y', n_corner, 1);

c2s_dX = corner_X - sket_cont_X;
c2s_dY = corner_Y - sket_cont_Y;

c2s_dist_mat = sqrt(c2s_dX.^2 + c2s_dY.^2);
c2s_ang_mat = atan2(c2s_dY,c2s_dX);
c2s_ang_mat2 = atan2(-c2s_dY,-c2s_dX);

dis_mat = zeros(n_samp+1, n_samp+1);
dis_mat(1:n_samp, 1:n_samp) = sket_dis_mat;

ang_mat = zeros(n_samp+1, n_samp+1);
ang_mat(1:n_samp, 1:n_samp) = sket_ang_mat;


n_pt = n_samp + 1;
dists_c2s		= zeros(n_pt-1,n_pt);		% distance and orientation matrix, the i-th COLUMN contains
angles_c2s		= zeros(n_pt-1,n_pt);		% dist and angles from i-th point to all other points
id_gd		= setdiff(1:n_pt*n_pt, 1:(n_pt+1):n_pt*n_pt);
sc = zeros(n_dist*n_theta, n_corner);
for i = 1 : n_corner
	tmp_dist = [c2s_dist_mat(i,:) 0];
	dis_mat(n_samp+1,:) = tmp_dist;
	dis_mat(:, n_samp+1) = tmp_dist';
	
	tmp_ang = [c2s_ang_mat(i,:) 0];
    tmp_ang2 = [c2s_ang_mat2(i,:) 0];
	ang_mat(n_samp+1, :) = tmp_ang;
	ang_mat(:, n_samp+1) = tmp_ang2';
	
	dists_c2s(:)	= dis_mat(id_gd);
	angles_c2s(:)	= ang_mat(id_gd);
	[tmp_sc]		= comp_sc_hist(dists_c2s,angles_c2s,n_dist,n_theta);
	sc(:,i) = tmp_sc(:,end);
end

end