function saveFeatureInDatabase(histograms)
conn = database('SDDB', 'kangy1', '123456');
if strcmp(conn.AutoCommit, 'on') ~= 1           % 如果未正常连接，则报错并终止程序
    error('DB Not Connected: conn.Message = %s!',conn.Message);
end
exec(conn, 'DELETE FROM [SDDB].[dbo].[Proj_View_Point]');
end