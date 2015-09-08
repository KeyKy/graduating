CREATE TABLE DataCollection(
	[id] int identity(1,1) not null,
	[userName] nvarchar(255) not null,
	[frontSket] text not null,
	[sideSket] text not null,
	[topSket] text not null,
	[selectModels] text
);