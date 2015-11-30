function fig = printSampPointOnFixExpandImg(image, sket_articu_cont, status_color)
fig = figure; imshow(image); hold on;

for i = 1 : size(sket_articu_cont, 1)
    plot(sket_articu_cont(i,1), sket_articu_cont(i,2), '*', 'Color', status_color('*'));
    hold on;
end

end