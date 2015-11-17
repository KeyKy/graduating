function [ result ] = doesDrawed( userInfos, userName )
drawInfos = userInfos(userName);
n_model_draw = length(drawInfos);
result = zeros([n_model_draw, 1]);
for i = 1 : n_model_draw
    if length(drawInfos{i}) >= 1
        result(i,1) = 1;
    end
end

end

