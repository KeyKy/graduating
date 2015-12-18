function [ ] = genSketchInfos( )
%计算所有sketch的采样点的形状上下文特征，角点的形状上下文特征
%统计所有sketch所画的Model名字，用户名字，PNG路径，TxT路径，草图名字
%将所有信息存于sketchInfos结构体下
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
    
    %if strcmp(sketches(i).name, 'm1044_y5_0.png') == 1
    %    start = start + 1;
    %end
    
    [~,~,sketchImg] = imread(the_png_path);
    bwSket = im2bw(sketchImg, 0); %% 提取角点
    opts.isPlot = 0; opts.harris_k = 0.12;
    [cornerA] = findInterestPoints(bwSket, opts);
    assignment = DBSCAN(cornerA, 2, 4); need_delete = [];
    max_v = max(assignment); 
    for j = 1 : max_v
        idx = find(assignment == j);
        need_delete = [need_delete, idx];
        sim_points = cornerA(idx,:);
        avg_sim_pts = mean(sim_points, 1);
        cornerA(end+1,:) = avg_sim_pts;
    end
    cornerA(need_delete,:) = [];
    cornerA = unique(cornerA, 'rows');
    sketchInfo.the_corner = cornerA;
    fid = fopen(the_txt_path);
    strokeSeq = fgetl(fid);
    fclose(fid);
    
    [fixExpandImg, sket_articu_cont] = preproc_extractCont(sketchImg, strokeSeq); %%提取采样点
    sketchInfo.the_articu_cont = sket_articu_cont;
    [feats, sket_dist_mat, sket_ang_mat] = extractFeature(sket_articu_cont);
    %imshow(bwSket); hold on; plot(sket_articu_cont(:,1), sket_articu_cont(:,2), 'r.');
    sketchInfo.the_feats = feats;

    corner_points_feats = compu_corner_SC(cornerA, sket_articu_cont, sket_dist_mat, sket_ang_mat);
    sketchInfo.the_corner_feats = corner_points_feats;
    
    sketchInfos{end+1} = sketchInfo;
end

save 'F:\\SCRecomDict\\20\\sketchInfos.mat' sketchInfos
end

