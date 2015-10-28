function saveFeatureInDatabase(histograms, total_filesName)
conn = database('SDDB', 'kangy1', '123456');
if strcmp(conn.AutoCommit, 'on') ~= 1           % 如果未正常连接，则报错并终止程序
    error('DB Not Connected: conn.Message = %s!',conn.Message);
end
exec(conn, 'DELETE FROM [SDDB].[dbo].[model]');
tableName = 'model';
columnNames = {'fileName', 'viewName', 'bofFeat', 'score'};
for i = 1 : length(total_filesName)
    splited = splitStr(total_filesName{i}(1:end-4), '_');
    projName = splited{1,1};
    viewName = sprintf('%s_%s', splited{1,2}, splited{1,3});
    featStr = '';
    for j = 1 : length(histograms{i})-1
        featStr = sprintf('%s%f,', featStr, histograms{i}(j,1));
    end
    featStr = sprintf('%s%f', featStr, histograms{i}(length(histograms{i}),1));
    data = [{projName}, {viewName}, {featStr}, {0}];
    fastinsert(conn, tableName, columnNames, data);
end
close(conn);
end