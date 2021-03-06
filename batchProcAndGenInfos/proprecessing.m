function [fixExpandImg, Contours, sket_feats] = proprecessing(u1_sketchStruct)
addpath('E:\\graduating\\retrieval\\v1\\');
[~,~,sketch] = imread(u1_sketchStruct.the_png_path);
fid = fopen(u1_sketchStruct.the_txt_path);
strokeSeq = fgetl(fid);
fclose(fid);

image = csToMatlab(sketch);
boundImg = imageBoxBounding(image);
rescaleImg = imageResizeWithNearest(boundImg);
rescaleBinaryImg = imageRescaledBinaryzation(rescaleImg, 0.8);
fixExpandImg = imageBoundaryExpandFixSize(rescaleBinaryImg, 200, 200);

Contours = downSampleSketCont(strokeSeq);
[sket_articu_cont, sket_n_contsamp, sket_n_contsamp_of_conn_cont_mat, sket_adjacencyList] = articulateSketContour(Contours, 5);

fig1 = figure;
plot(sket_articu_cont(:,1), 200 - sket_articu_cont(:,2), '.');
print(fig1, sprintf('%s%s','F:\\sketch\\sket_articu_cont\\',u1_sketchStruct.the_sketchName), '-dpng');

[sket_feats] = extractFeature(sket_articu_cont);

end