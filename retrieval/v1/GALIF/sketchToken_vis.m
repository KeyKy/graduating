function [ ] = sketchToken_vis( )
load 'F:\gabor\10\infosStruct.mat' infosStruct
load 'F:\gabor\10\assignment.mat' assignment
max_idx = max(assignment); 
tokenPath = 'F:\gabor\token\';
for i = 1 : max_idx
    eachTokenClusterDirPath = sprintf('%s%d',tokenPath, i);
    mkdir(eachTokenClusterDirPath);
end
start = 1;
for i = 1 : length(infosStruct)
    the_png_path = infosStruct{i}.the_png_path;
    [~,~,img] = imread(the_png_path);
    [n_row, n_col] = size(img);
    tmp = zeros(n_row+40, n_col+40);
    tmp(20:20+n_row-1,20:20+n_col-1) = img;
    
    the_cont = infosStruct{i}.the_articu_cont+19;
    for j = 1 : size(the_cont, 1)
        samp_x = the_cont(j,1); samp_y = the_cont(j,2);
        patch = tmp(samp_y-18:samp_y+17,samp_x-18:samp_x+17);
        clusterIdx = assignment(start);
        imwrite(patch,sprintf('%s%d\\%d.png',tokenPath, clusterIdx,start));
        start = start + 1;
    end
    disp(the_png_path);
end

