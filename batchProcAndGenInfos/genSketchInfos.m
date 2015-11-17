function [ sketchInfos ] = genSketchInfos( )
%计算所有sketch的直方图特征，所画的Model名字，用户名字，PNG路径，TXT路径，草图名字，存在F:\dict\sketchInfos下
load 'F:\\dict\\z_total_all_data\\dictionary.mat' dictionary
load 'F:\\dict\\z_total_all_data\\eigvector.mat' eigvector
path = 'F:\\sketch\\png\\';
txtPath = 'F:\\sketch\\txt\\';
sketches = dir(path);
sketchInfos = {};

for i = 3 : length(sketches)
    splited = splitStr(sketches(i).name, '_');
    disp(sketches(i).name);
    the_modelName = splited{1};
    the_userName = splited{2};
    the_png_path = sprintf('%s%s',path, sketches(i).name);
    the_txt_path = sprintf('%s%s.txt',txtPath, sketches(i).name(1:end-4));
    sketchInfo.the_modelName = the_modelName;
    sketchInfo.the_userName = the_userName;
    sketchInfo.the_png_path = the_png_path;
    sketchInfo.the_txt_path = the_txt_path;
    sketchInfo.the_sketchName = sketches(i).name;
    
    [fixExpandImg, Contours, sket_feats] = proprecessing(sketchInfo);
    reduced_sket_feats = sket_feats' * eigvector;
    [sket_histogram] = assign_(dictionary, reduced_sket_feats);
    sketchInfo.the_histogram = sket_histogram;
    
    sketchInfos{end+1} = sketchInfo;
end

save 'F:\\dict\\sketchInfos.mat' sketchInfos

end

