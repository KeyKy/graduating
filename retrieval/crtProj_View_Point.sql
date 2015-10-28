create table Proj_View_Point(
	id int identity,
	projName varchar(255),
	vName varchar(255),
	pIdx int,
	pCoor varchar(255),
	feats text,
	Primary Key(projName, vName, pIdx)
	);