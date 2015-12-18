function [  ] = genRecomTable( )
%计算用户与用户之间的相似度
load 'F:\\SCRecomDict\\15\\userSketInfos.mat' userSketInfos
userInfos = userSketInfos;
userName = userInfos.keys();
n_user = length(userName);
distBetweenUser = 999*ones(n_user, n_user) - 999*eye(n_user,n_user);
for i = 1 : n_user
    user1_doesDraw = doesDrawed(userInfos, userName{i});
    u1Info = userInfos(userName{i});
    for j = i+1 : n_user
        u2Info = userInfos(userName{j});
        user2_doesDraw = doesDrawed(userInfos, userName{j});
        u1_u2BothDraw = user1_doesDraw & user2_doesDraw;
        bothDrawModelIdx = find(u1_u2BothDraw == 1);
        if length(bothDrawModelIdx) > 4 %共同画了4张以上才计算相似度
            dist = calcUserDist(u1Info, u2Info, bothDrawModelIdx);
            distBetweenUser(i,j) = dist;
            distBetweenUser(j,i) = dist;
        end
    end
end
genRecomTable.the_userNames = userName;
genRecomTable.dist = distBetweenUser;
save 'F:\\SCRecomDict\\15\\genRecomTable.mat' genRecomTable
end

