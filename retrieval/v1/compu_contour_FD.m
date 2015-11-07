function [FD_feats] = compu_contour_FD(eight_conn_pixel_points,sizeOfFD)
fx=eight_conn_pixel_points(:,1);
fy=eight_conn_pixel_points(:,2);
ii=sqrt(-1);
U = fx + fy*ii;
[F1]=extractFD(U);
[F2]=normaliseFD(F1);
FD_feats=resizeFD(F2, sizeOfFD);
end