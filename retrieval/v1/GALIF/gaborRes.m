function [ resp ] = gaborRes( img, kernel )
n_kernel = length(kernel);
resp = {};
for i = 1 : n_kernel
    F_img = fft2(img);
    F_img_centered = fftshift(F_img);
    F_img_centered_filtered = F_img_centered .* kernel{i};
    F_img_centered_filtered_uncentered = ifftshift(F_img_centered_filtered);
    filter_response = ifft2(F_img_centered_filtered_uncentered);
    resp{end+1} = filter_response;
end

end

