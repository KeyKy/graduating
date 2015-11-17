function [  ] = genRecomTable( )

userInfos = genUserSketInfos();
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
        if length(bothDrawModelIdx) ~= 0
            dist = calcUserDist(u1Info, u2Info, bothDrawModelIdx);
            distBetweenUser(i,j) = dist;
            distBetweenUser(j,i) = dist;
        end
    end
end
genRecomTable.the_userNames = userName;
genRecomTable.dist = distBetweenUser;
save 'F:\\dict\\genRecomTable.mat' genRecomTable
end

