function SCMtch0_offFeature()
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
imgEdgeLength = IMAGE_EDGE_LENGTH;

multiContour = {};
total_struct = {};

for i = 3 : length(files)
    projImgPath = sprintf('%s%s', path, files(i).name);
    
    disp(files(i).name);
    %������ȡ����������Ԥ������������ȡ��������ȡ
    %[image, boundImg, rescaleImg, rescaleBinaryImg, fixExpandImg, filledFixExpandImg] = preprocessProjImage(projImgPath, imgEdgeLength);
    fixExpandImgPath = sprintf('%s%s',FIX_BASE_PATH,files(i).name); filledFixExpandImgPath = projImgPath;
    fixExpandImg = imread(fixExpandImgPath); filledFixExpandImg = imread(filledFixExpandImgPath);
    perimeter = bwperim(filledFixExpandImg);  boundries = bwboundaries(perimeter, 'noholes'); %boundries��N-by-2�����ݽṹ��������1���кţ���2���к�

    [eight_conn_pixel_points, n_points_each_boundry] = extBdPoints(boundries); % eight_conn_pixel_points��N-by-2�����ݽṹ��������1���кţ���2���к�

    [Contours, the_articu_cont, the_n_contsamp, the_n_contsamp_of_conn_cont_mat, adjacencyList] = downSampleContour(filledFixExpandImg, sample_step);
    %fig = figure; plot(the_articu_cont(:,1), the_articu_cont(:,2), '.'); print(fig, sprintf('%s%s','F:\debug\step20_projections\',files(i).name),'-dpng');
    %close(fig);
    [the_feats, the_AED_feats, the_S2MC_feats] = extractFeature(the_articu_cont, fixExpandImg, eight_conn_pixel_points, n_points_each_boundry);
    
    if length(the_n_contsamp_of_conn_cont_mat) ~= 1
        %disp(sprintf('%s%s%s','the length of the_n_contsamp_of_conn_cont_mat ', files(i).name, ' is not equal to 1'));
        multiContour{end+1} = files(i).name;
    end
    
    modelStrut.the_feats = the_feats;
    modelStrut.the_AED_feats = the_AED_feats;
    modelStrut.the_S2MC_feats = the_S2MC_feats;
    modelStrut.the_fileName = files(i).name;
    modelStrut.the_articu_cont = the_articu_cont;
    modelStrut.the_n_contsamp = the_n_contsamp;
    modelStrut.the_n_contsamp_of_conn_cont_mat = the_n_contsamp_of_conn_cont_mat;
    
    total_struct{end+1} = modelStrut;
end
outputDir = sprintf('%s%s\\', 'F:\\SCMatching_unRota\\', num2str(sample_step));
folderName = sprintf('%s%s_data\\',outputDir,className);
mkdir(folderName);
save (sprintf('%s%s',folderName,'multiContour.mat'), 'multiContour');
save (sprintf('%s%s',folderName,'total_struct.mat'), 'total_struct');


end
