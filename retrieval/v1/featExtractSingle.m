function [feats, n_contsamp, n_contsamp_of_conn_cont_mat] = featExtractSingle(path)
globalVar;
sample_step = SAMPLE_STEP;
imgEdgeLength = IMAGE_EDGE_LENGTH;
% preprocess
[image, boundImg, rescaleImg, rescaleBinaryImg, fixExpandImg, filledFixExpandImg] = preprocessProjImage(path, imgEdgeLength);
% sample points
[Contours, articu_cont, n_contsamp, n_contsamp_of_conn_cont_mat, adjacencyList] = downSampleContour(filledFixExpandImg, sample_step);
% features based on sample points
[feats] = extractFeature(articu_cont);
end