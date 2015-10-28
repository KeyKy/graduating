function saveInDatabase(total_feats, total_articu_cont, total_n_contsamp, total_filesName)
conn = database('SDDB', 'kangy1', '123456');
if strcmp(conn.AutoCommit, 'on') ~= 1           % 如果未正常连接，则报错并终止程序
    error('DB Not Connected: conn.Message = %s!',conn.Message);
end
exec(conn, 'DELETE FROM [SDDB].[dbo].[Proj_View_Point]');
tableName = 'Proj_View_Point';
columnNames = {'projName', 'vName', 'pIdx', 'pCoor', 'feats'};
start = 1;
for i = 1 : length(total_filesName)
    splited = splitStr(total_filesName{i}(1:end-4), '_');
    projName = splited{1,1};
    viewName = sprintf('%s_%s', splited{1,2}, splited{1,3});
    for j = 1 : total_n_contsamp(i)
        pointCoor_x = num2str(total_articu_cont(1, start+j-1));
        pointCoor_y = num2str(total_articu_cont(2, start+j-1));
        pointCoor = sprintf('%s_%s', pointCoor_x, pointCoor_y);
        feats = total_feats(:,start+j-1);
        featStr = '';
        for k = 1 : size(feats, 1)-1
            featStr = sprintf('%s%f,', featStr, feats(k,1));
        end
        featStr = sprintf('%s%f', featStr, feats(size(feats,1),1));
        data = [{projName},{viewName},{j},{pointCoor},{featStr}];
        fastinsert(conn, tableName, columnNames, data);
    end
    start = start + total_n_contsamp(i);
end
close(conn);
end