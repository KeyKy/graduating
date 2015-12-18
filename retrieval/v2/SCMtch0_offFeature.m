function SCMtch0_offFeature()
addpath('E:\graduating\retrieval\v1\visualization\');
addpath('../v1/');
basePath = 'F:\projections\BOF\';
classes = dir(basePath);
for i = 3 : length(classes)
    className = classes(i).name;
    genFeatBatchSingleFolder(basePath, className);
end

end

function [] = genFeatBatchSingleFolder(base_path, className)
path = sprintf('%s%s\\', base_path, className);
files = dir(path);
globalVar;
sample_step = SAMPLE_STEP;

multiContour = {};
total_struct = {};

for i = 3 : length(files)
    projImgPath = sprintf('%s%s', path, files(i).name);
  
    disp(files(i).name);
        
    %特征提取包括三部分预处理、采样点提取、特征提取
    %[image, boundImg, rescaleImg, rescaleBinaryImg, fixExpandImg, filledFixExpandImg] = preprocessProjImage(projImgPath, imgEdgeLength);
    fixExpandImgPath = sprintf('%s%s',FIX_BASE_PATH,files(i).name); filledFixExpandImgPath = projImgPath;
    %fixExpandImg = imread(fixExpandImgPath); 
    filledFixExpandImg = imread(filledFixExpandImgPath);
    %perimeter = bwperim(filledFixExpandImg);  boundries = bwboundaries(perimeter, 'noholes'); %boundries是N-by-2的数据结构，其中列1是行号，列2是列号
    %[eight_conn_pixel_points, n_points_each_boundry] = extBdPoints(boundries); % eight_conn_pixel_points是N-by-2的数据结构，其中列1是列号，列2是行号

    [Contours, the_articu_cont, the_n_contsamp, the_n_contsamp_of_conn_cont_mat, adjacencyList] = downSampleContour(filledFixExpandImg, sample_step);
    %fig = figure; plot(the_articu_cont(:,1), the_articu_cont(:,2), '.'); print(fig, sprintf('%s%s','F:\debug\step20_projections\',files(i).name),'-dpng');
    %close(fig);
    %[the_feats, the_dist_mat, the_ang_mat] = extractFeature(the_articu_cont, fixExpandImg, eight_conn_pixel_points, n_points_each_boundry);
    [the_feats, the_dist_mat, the_ang_mat] = extractFeature(the_articu_cont);
    opts.isPlot = 0; opts.harris_k = 0.1;
    [cornerA] = findInterestPoints(filledFixExpandImg, opts); total_times = 1;
    while size(cornerA,1) <= 2 && total_times <= 5
        opts.isPlot = 0; opts.harris_k = opts.harris_k/2;
        [cornerA] = findInterestPoints(filledFixExpandImg, opts);
        total_times = total_times + 1;
    end
    if size(cornerA, 1) == 0
        cornerA = corner(filledFixExpandImg);
        cornerA = circshift(cornerA, [0,1]);
    end
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
    the_corner_feats = compu_corner_SC(cornerA, the_articu_cont, the_dist_mat, the_ang_mat);
    
    if length(the_n_contsamp_of_conn_cont_mat) ~= 1
        %disp(sprintf('%s%s%s','the length of the_n_contsamp_of_conn_cont_mat ', files(i).name, ' is not equal to 1'));
        multiContour{end+1} = files(i).name;
    end
    
    modelStrut.the_feats = the_feats;
    modelStrut.the_fileName = files(i).name;
    modelStrut.the_articu_cont = the_articu_cont;
    modelStrut.the_n_contsamp = the_n_contsamp;
    modelStrut.the_n_contsamp_of_conn_cont_mat = the_n_contsamp_of_conn_cont_mat;
    modelStrut.the_corner = cornerA;
    modelStrut.the_corner_feats = the_corner_feats;
    
    total_struct{end+1} = modelStrut;
end
outputDir = sprintf('%s%s\\', 'F:\\SCMatching_unRota\\', num2str(sample_step));
folderName = sprintf('%s%s_data\\',outputDir,className);
mkdir(folderName);
save (sprintf('%s%s',folderName,'multiContour.mat'), 'multiContour');
save (sprintf('%s%s',folderName,'total_struct.mat'), 'total_struct');


end
