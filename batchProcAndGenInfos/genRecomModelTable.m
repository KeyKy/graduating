function [  ] = genRecomModelTable(  )
load 'F:\\dict\\genRecomTable.mat' genRecomTable
load 'F:\\dict\\sketchInfos.mat' sketchInfos
userNames = genRecomTable.the_userNames; n_user = length(userNames); n_model = 1815;
modelSketInfos = containers.Map();

for i = 1 : n_model
    keyName = sprintf('m%d',i-1);
    modelSketInfos(keyName) = cell(n_user,1);
end

for i = 1 : length(sketchInfos)
    the_userName = sketchInfos{i}.the_userName;
    the_modelName = sketchInfos{i}.the_modelName;
    userId = 0;
    for j = 1 : n_user
        if strcmp(the_userName, userNames{j}) == 1
            userId = j;
        end
    end
    if modelSketInfos.isKey(the_modelName)
        tmp = modelSketInfos(the_modelName);
        tmp{userId}{end+1} = sketchInfos{i};
        modelSketInfos(the_modelName) = tmp;
    else
        error('non existed model');
    end
end
save 'F:\\dict\\modelSketInfos.mat' modelSketInfos
distBetweenModel = 9999*ones(n_model, n_model) - 9999*eye(n_model,n_model);

for i = 1 : n_model
    m_first = sprintf('m%d', i-1); m_first_doesDraw = doesDrawed(modelSketInfos, m_first);
    m_first_infos = modelSketInfos(m_first);
    for j = i+1 : n_model
        m_sec = sprintf('m%d', j-1); m_sec_doesDraw = doesDrawed(modelSketInfos, m_sec);
        m_sec_infos = modelSketInfos(m_sec);
        both_draw = m_first_doesDraw & m_sec_doesDraw;
        bothDrawIdx = find(both_draw == 1);
        if ~isempty(bothDrawIdx)
            dist = calcModelDist(m_first_infos, m_sec_infos, bothDrawIdx);
            distBetweenModel(i, j) = dist;
            distBetweenModel(j, i) = dist;
        end
    end
end

genRecomModelTable.dist = distBetweenModel;
save 'F:\\dict\\genRecomModelTable.mat' genRecomModelTable

end

