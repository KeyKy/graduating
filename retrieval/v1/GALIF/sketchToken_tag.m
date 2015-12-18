function [ output_args ] = sketchToken_tag( input_args )
load 'F:\gabor\10\infosStruct.mat' infosStruct
base_path = 'F:\projections\category\';
[ p2s_rel, s2p_rel ] = relevantSet( base_path );
for i = 1 : length(infosStruct)
    the_modelName = infosStruct{i}.the_modelName;
    the_tag = s2p_rel(the_modelName);
    infosStruct{i}.the_tag = the_tag;
end
save 'F:\gabor\10\infosStruct.mat' infosStruct
end

