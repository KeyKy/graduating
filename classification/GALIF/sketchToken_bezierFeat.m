function [ ] = sketchToken_bezierFeat( )
load 'F:\SCRecomDict\10\sketchInfos.mat' sketchInfos
infosStruct = sketchInfos;
[ kernel ] = gaborKernelLoad();
for i = 1 : length(infosStruct)
    [~,~,img] = imread(infosStruct{i}.the_png_path);
    disp(infosStruct{i}.the_png_path);
    
    [n_row, n_col] = size(img);
    tmp = zeros(n_row+200, n_col+200);
    tmp(100:100+n_row-1,100:100+n_col-1) = img;
    the_cont = infosStruct{i}.the_articu_cont+99;
    
    samp_galif = [];
    for n_samp = 1 : size(the_cont, 1)
        samp_x = samp_cont(i,1); samp_y = samp_cont(i,2);
        conv_img = tmp(samp_y-100:samp_y+99,samp_x-100:samp_x+99);
        resp = gaborConv(conv_img, kernel);
        for j = 1 : length(resp)
            respMask = zeros(n_row+200, n_col+200);
            respMask(samp_y-100:samp_y+99,samp_x-100:samp_x+99) = resp{j};
            patch = respMask(samp_y-18:samp_y+17,samp_x-18:samp_x+17);
            the_ori_galif = tilePatch(patch, 4, 4);
            samp_galif = [samp_galif the_ori_galif];
        end
        samp_galif = samp_galif ./ norm(samp_galif, 2);
        the_galif_feats = [the_galif_feats samp_galif'];
    end
    infosStruct.the_galif_feats = the_galif_feats;
end
