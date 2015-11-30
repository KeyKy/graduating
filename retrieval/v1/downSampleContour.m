function [Contours, articu_cont, n_contsamp, n_contsamp_of_conn_cont_mat, adjacencyList] = downSampleContour(filledFixExpandImg, samp_step_length)
globalVar;
if ~exist('samp_step_length', 'var')
    samp_step_length = SAMPLE_STEP;
end

im	= double(filledFixExpandImg);
[Contours] = boundary_extract_binary(im);
[articu_cont, n_contsamp, n_contsamp_of_conn_cont_mat, adjacencyList] = articulateContour(Contours, samp_step_length);
end