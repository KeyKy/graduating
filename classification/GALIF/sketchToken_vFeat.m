function [ ] = sketchToken_vFeat( )
%仅适合我们自己搜集的数据
load 'F:\SCRecomDict\10\sketchInfos.mat' sketchInfos
[ kernel ] = gaborKernelLoad();
infosStruct = sketchInfos;
for i = 1 : length(infosStruct)
    [~,~,img] = imread(infosStruct{i}.the_png_path);
    disp(infosStruct{i}.the_png_path);
    resp = gaborConv(img, kernel);
    [n_row, n_col] = size(resp{1});
    for j = 1 : length(resp)
        tmp = zeros(n_row+40, n_col+40);
        tmp(20:20+n_row-1,20:20+n_col-1) = resp{j};
        resp{j} = tmp;
    end
    the_cont = infosStruct{i}.the_articu_cont+19;
    [ samp_galif ] = compu_contour_GALIF( resp, the_cont );
    infosStruct{i}.the_galif_feats = samp_galif;
end
save 'F:\gabor\10\infosStruct.mat' infosStruct
end

