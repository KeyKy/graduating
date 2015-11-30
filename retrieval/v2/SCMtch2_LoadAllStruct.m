function [ ] = SCMtch2_LoadAllStruct( )
basePath = 'F:\\SCMatching_unRota\\25\\';
files = dir(basePath);
total_struct = {};
for i = 3 : length(files)
    fileName = files(i).name;
    structPath = sprintf('%s%s\\total_struct.mat',basePath, fileName);
    stru = load(structPath);
    the_total_struct = stru.total_struct;
    for j = 1 : length(the_total_struct)
        the_fileName = the_total_struct{j}.the_fileName;
        the_feats = the_total_struct{j}.the_feats;
        the_articu_cont = the_total_struct{j}.the_articu_cont;
        tmp.the_fileName = the_fileName;
        tmp.the_feats = the_feats;
        tmp.the_articu_cont = the_articu_cont;
        total_struct{end+1} = tmp;
    end
end
save 'F:\\SCDict_unRota\\25\\total_struct.mat' total_struct
end

