function conn = connToDatabase()
addConstVar;

conn = database(DATABASE_NAME, DATABASE_USERNAME, DATABASE_PASSWORD);
if strcmp(conn.AutoCommit, 'on') ~= 1           % ���δ�������ӣ��򱨴���ֹ����
    error('DB Not Connected: conn.Message = %s!',conn.Message);
end
exec(conn, 'DELETE FROM [RFDB].[dbo].[DataCollection]');


end

