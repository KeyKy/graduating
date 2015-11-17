function [ ] = M2_offHistogram( )
% 根据z_total_data下生成的字典，对所有的25410张投影图生成BOF直方图，返回的是all_total_struct保存的是the_fileName和the_histograms
copyfile('F:\dict\z_total_data\dictionary.mat', 'F:\dict\z_total_all_data\dictionary.mat');
copyfile('F:\dict\z_total_data\eigvector.mat', 'F:\dict\z_total_all_data\eigvector.mat');

basePath = 'F:\\graduating\\';
files = dir(basePath);
load 'F:\\dict\\z_total_all_data\\dictionary.mat' dictionary
load 'F:\\dict\\z_total_all_data\\eigvector.mat' eigvector
all_total_struct = {};
dst = 'F:\\dict\\z_total_all_data\\all_total_struct.mat';
all_total_model_struct = cell(1,1815);
for i = 1 : 1815
    modelHistStruct.the_viewName = {};
    modelHistStruct.the_histograms = [];
    all_total_model_struct{i} = modelHistStruct;
end
for i = 3 : length(files)
    folderName = files(i).name;
    structPath = sprintf('%s%s\\total_struct.mat',basePath, folderName);
    disp(structPath);
    stru_a = load(structPath);
    total_struct = stru_a.total_struct;
    for j = 1 : length(total_struct)
        feats = total_struct{j}.the_feats;
        reduced = feats' * eigvector;
        the_histograms = assign_(dictionary, reduced);
        total_struct{j}.the_histogram = the_histograms;
        
        structHist.the_fileName = total_struct{j}.the_fileName;
        structHist.the_histograms = the_histograms;
        all_total_struct{end+1} = structHist;
        
        
        splited = splitStr(structHist.the_fileName, '_');
        modelName = splited{1}; modelIdx = str2num(modelName(2:end))+1;
        tmp = sprintf('%s_%s',splited{2}, splited{3});
        viewName = tmp(1:end-4);
        all_total_model_struct{modelIdx}.the_viewName = [all_total_model_struct{modelIdx}.the_viewName viewName];
        all_total_model_struct{modelIdx}.the_histograms = [all_total_model_struct{modelIdx}.the_histograms; the_histograms];
        
    end
end
save(dst, 'all_total_struct');
save('F:\\dict\\z_total_all_data\\all_total_model_struct', 'all_total_model_struct');
end

