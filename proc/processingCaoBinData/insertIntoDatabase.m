function insertIntoDatabase(conn, userName, frontSket, sideSket, topSket, selectModels)
tableName = 'DataCollection';
columnNames = {'userName', 'frontSket', 'sideSket', 'topSket', 'selectModels'};
insertData = [{userName}, {frontSket}, {sideSket}, {topSket}, {selectModels}];
fastinsert(conn, tableName, columnNames, insertData);

end
