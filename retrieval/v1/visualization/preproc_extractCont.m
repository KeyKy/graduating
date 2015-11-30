function [fixExpandImg, sket_articu_cont] = preproc_extractCont(sketch, strokeSeq)
globalVar;
image = csToMatlab(sketch);
boundImg = imageBoxBounding(image);
rescaleImg = imageResizeWithNearest(boundImg);
rescaleBinaryImg = imageRescaledBinaryzation(rescaleImg, FACTOR_OF_RESCALE_BINARYZATION);
fixExpandImg = imageBoundaryExpandFixSize(rescaleBinaryImg, IMAGE_EDGE_LENGTH, IMAGE_EDGE_LENGTH);
Contours = downSampleSketCont(strokeSeq);

[sket_articu_cont, sket_n_contsamp, sket_n_contsamp_of_conn_cont_mat, sket_adjacencyList] = articulateSketContour(Contours, SAMPLE_STEP);


end