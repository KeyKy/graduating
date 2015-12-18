function [ p2s_rel, s2p_rel ] = relevantSet( base_path )
parant_layer = dir(base_path);
p2s_rel = containers.Map();
s2p_rel = containers.Map();

for i = 3 : length(parant_layer)
    parant_path = sprintf('%s%s\\', base_path, parant_layer(i).name);
    son_layer = dir(parant_path);
    temp = {};
    for j = 3 : length(son_layer)
        splited = splitStr(son_layer(j).name, '_');
        temp{end+1} = splited{1};
        s2p_rel(splited{1}) = parant_layer(i).name;
    end
    p2s_rel(parant_layer(i).name) = temp;
end

end

