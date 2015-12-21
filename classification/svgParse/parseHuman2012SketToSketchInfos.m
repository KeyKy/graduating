function [ output_args ] = parseHuman2012SketToSketchInfos( )
load 'F:\HowdoHumansSketchObject\sketches' D
base_path = 'F:\HowdoHumansSketchObject\svgToImage\';
[p2s_layer, s2p_layer] = psLayerRelationship('F:\HowdoHumansSketchObject\svg\');
h2012Sket = dir(base_path);
human2012SketStruct = {};
for i = 3 : length(h2012Sket)
    fileName = h2012Sket(i).name;
    idx = str2num(fileName(1:end-4));
    
    keyOfSket = sprintf('%d.svg', idx);
    tag = s2p_layer(keyOfSket);
    
    pts = parseOneSvgToPts(D{idx, 3});
    the_articu_cont = articulateBezierContour(pts, 10);
    h2012SketStruct.the_png_path = sprintf('%s%s',base_path, fileName);
    h2012SketStruct.the_articu_cont = the_articu_cont;
    h2012SketStruct.the_tag = tag;
    human2012SketStruct{end+1} = h2012SketStruct;
end

end

