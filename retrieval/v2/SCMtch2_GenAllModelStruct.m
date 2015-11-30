function [  ] = SCMtch2_GenAllModelStruct(  )

load 'F:\\SCDict_unRota\\20\\total_struct.mat' total_struct
all_total_model_struct = cell(1,1815);
tmp.viewName = cell(1,0);
tmp.the_feats = cell(1,0);
tmp.the_articu_cont = cell(1,0);
for i = 1 : 1815
    all_total_model_struct{i} = tmp;
end

for i = 1 : length(total_struct)
    the_struct = total_struct{i};
    splited = splitStr(the_struct.the_fileName, '_');
    modelIdx = str2num(splited{1}(2:end));
    viewName = sprintf('%s_%s',splited{2}, splited{3}(1:end-4));
    feats = the_struct.the_feats;
    the_articu_cont = the_struct.the_articu_cont;
    all_total_model_struct{modelIdx+1}.viewName = [all_total_model_struct{modelIdx+1}.viewName viewName];
    all_total_model_struct{modelIdx+1}.the_feats = [all_total_model_struct{modelIdx+1}.the_feats feats];
    all_total_model_struct{modelIdx+1}.the_articu_cont = [all_total_model_struct{modelIdx+1}.the_articu_cont the_articu_cont];
end
save 'F:\\SCDict_unRota\\20\\all_total_model_struct.mat' all_total_model_struct
end

