function [ CornerCoord ] = findHarrisCorner( fixExpandImg, harris_k )
Image = fixExpandImg;

dx = [-1 0 1;-1 0 1;-1 0 1];
Ix2 = filter2(dx, Image).^2;
Iy2 = filter2(dx',Image).^2;
Ixy = filter2(dx, Image) .* filter2(dx', Image);

h = fspecial('gaussian', 9, 2);

A = filter2(h, Ix2);
B = filter2(h, Iy2);
C = filter2(h, Ixy);

[nrow, ncol] = size(Image);
Corner = Image;

CRF = zeros(nrow, ncol);
CRFmax = 0;
k = harris_k; boundary = 2;
for i = boundary : nrow-boundary+1
    for j = boundary : ncol-boundary+1
        if Corner(i,j) == 1
            M = [A(i,j) C(i,j);
                 C(i,j) B(i,j)];
             CRF(i,j) = det(M) - k*(trace(M))^2;
             if CRF(i,j) > CRFmax
                 CRFmax = CRF(i,j);
             end
        end
    end
end

count = 0;  factor = 0.01;
for i = boundary : nrow-boundary+1
    for j = boundary : ncol-boundary+1
        if Corner(i,j) == 1
            if CRF(i,j) > factor*CRFmax && ...
               CRF(i,j) > CRF(i-1,j-1) && CRF(i,j) > CRF(i-1,j) && CRF(i,j) > CRF(i-1,j) && ...
               CRF(i,j) > CRF(i, j-1) && CRF(i,j) > CRF(i, j+1) && ...
               CRF(i,j) > CRF(i+1,j-1) && CRF(i,j) > CRF(i+1,j) && CRF(i,j) > CRF(i+1,j+1)
                count = count + 1;
            else
                Corner(i,j) = 0;
            end
            
        end
    end
end

CornerCoord = [];
for i = boundary : nrow-boundary+1
    for j = boundary : ncol-boundary+1
        col_avg = 0; row_avg = 0; cnt = 0;
        if Corner(i,j) == 1
            for delta_x = i-3 : i+3
                for delta_y = j-3 : j+3
                    if Corner(delta_x, delta_y) == 1
                        col_avg = col_avg + delta_y;
                        row_avg = row_avg + delta_x;
                        cnt = cnt + 1;
                    end
                end
            end
        end
        if cnt > 0
            new_c = col_avg/cnt; new_r = row_avg/cnt;
            CornerCoord = [CornerCoord;new_r new_c]; 
        end
    end
end

end

