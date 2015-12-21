function [ ] = sketchToken_BOFGALIF( )
load 'F:\gabor\10\infosStruct.mat' infosStruct
load 'F:\gabor\10\center.mat' center
for i = 1 : length(infosStruct)
    the_galif_feats = infosStruct{i}.the_galif_feats;
    the_bag_galif_feats = assign_(center, the_galif_feats');
    infosStruct{i}.the_bag_galif_feats = the_bag_galif_feats;
end
save 'F:\gabor\10\infosStruct.mat' infosStruct
end

