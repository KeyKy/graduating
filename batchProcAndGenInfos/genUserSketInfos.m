function [ userSketInfos ] = genUserSketInfos( )
% 计算用户-草图信息矩阵，是一个Map，Key是用户名，Value是1815-by-N的cell数组，N是在模型下画的草图的SketchInfo的数目
%sketchInfos = genSketchInfos();
load 'F:\\dict\\sketchInfos.mat' sketchInfos
userSketInfos = containers.Map();
for i = 1 : length(sketchInfos)
    the_userName = sketchInfos{i}.the_userName;
    splited = splitStr(sketchInfos{i}.the_modelName,'_');
    modelIdx = str2num(splited{1}(2:end))+1;
    if userSketInfos.isKey(the_userName) == 1
        tmp = userSketInfos(the_userName);
        tmp{modelIdx}{end+1} = sketchInfos{i};
        userSketInfos(the_userName) = tmp;
    else
        tmp = cell(1815,1);
        tmp{modelIdx} = {};
        tmp{modelIdx}{end+1} = sketchInfos{i};
        userSketInfos(the_userName) = tmp;
    end

end
save 'F:\\dict\\userSketInfos.mat' userSketInfos
end

