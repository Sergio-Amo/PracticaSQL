/* Create a new schema */
create schema flota;

/* Create all tables */
-- grupos
create table flota.grupos_vehiculos(
	id serial primary key,
	grupo VARCHAR(50) not null
);
-- marcas
create table flota.marcas_vehiculos(
	id serial primary key,
	id_grupo INT not null,
	marca VARCHAR(50) not null
);
-- modelos
create table flota.modelos_vehiculo(
	id serial primary key,
	id_marca INT not null,
	modelo VARCHAR(50) not null
);

--Aseguradoras
create table flota.aseguradoras(
	id serial primary key,
	aseguradora VARCHAR(50) not null
);
-- polizas
create table flota.polizas(
	n_poliza INT primary key,
	id_aseguradora INT not null,
	fecha_alta DATE not null
);

--moneda
create table flota.moneda(
	id serial primary key,
	moneda VARCHAR(30) not null
);
--revision
create table flota.revision(
	id serial primary key,
	matricula VARCHAR(7) not null,
	id_moneda INT not null,
	fecha DATE not null,
	kms INT not null,
	importe_revision DECIMAL(10,2)
);

--Colores
create table flota.colores(
	id serial primary key,
	color VARCHAR(30) not null
);

-- vehiculo de flota
create table flota.vehiculo(
	matricula VARCHAR(7) primary key,
	id_modelo INT not null,
	id_color INT not null,
	n_poliza INT not null,
	fecha_compra DATE not null,
	kms_totales INT not null
);

/* Create constrains */
alter table flota.vehiculo add constraint pk_modelos_vehiculo foreign key (id_modelo) references flota.modelos_vehiculo(id);
alter table flota.vehiculo add constraint pk_polizas foreign key (n_poliza) references flota.polizas(n_poliza);
alter table flota.vehiculo add constraint pk_colores foreign key (id_color) references flota.colores(id);
alter table flota.revision add constraint pk_revision foreign key (matricula) references flota.vehiculo(matricula);
alter table flota.revision add constraint pk_moneda foreign key (id_moneda) references flota.moneda(id);
alter table flota.polizas add constraint pk_polizas foreign key (id_aseguradora) references flota.aseguradoras(id);
alter table flota.modelos_vehiculo add constraint pk_marcas_vehiculos foreign key (id_marca) references flota.marcas_vehiculos(id);
alter table flota.marcas_vehiculos add constraint pk_grupos_vehiculos foreign key (id_grupo) references flota.grupos_vehiculos(id);

/* Populate tables from csv imorted table */
/*--grupo
insert into flota.grupos_vehiculos (grupo) select grupo from flota.coches c group by grupo;
--marca
insert into flota.marcas_vehiculos (marca, id_grupo)
select 
	c.marca, gv.id
from flota.coches c  
inner join flota.grupos_vehiculos gv on c.grupo = gv.grupo
group by c.grupo, c.marca, gv.id
order by gv.id, c.marca;
--modelo
insert into flota.modelos_vehiculo (modelo, id_marca)
select 
	c.modelo, mv.id
from flota.coches c 
inner join flota.marcas_vehiculos mv on c.marca = mv.marca  
group by c.marca, c.modelo, mv.id
order by mv.id, c.modelo;
--aseguradoras
insert into flota.aseguradoras (aseguradora) select aseguradora from flota.coches c group by aseguradora;
--polizas
insert into flota.polizas (n_poliza,fecha_alta,id_aseguradora)
select n_poliza,TO_DATE(c.fecha_alta_seguro, 'YYYY/MM/DD'), a.id from flota.coches c
inner join flota.aseguradoras a on c.aseguradora = a.aseguradora 
group by a.id, n_poliza, a.aseguradora, c.fecha_alta_seguro
order by a.id;
--moneda
insert into flota.moneda (moneda) select moneda from flota.coches c group by moneda order by moneda;
--colores
insert into flota.colores (color) select color from flota.coches c group by color;
--vehiculo
insert into flota.vehiculo (matricula, id_modelo, id_color, n_poliza, fecha_compra, kms_totales)
select DISTINCT on (c.matricula)
	c.matricula,
	mv.id,
	c2.id,
	p.n_poliza,
	TO_DATE(c.fecha_compra, 'YYYY/MM/DD'),
	c.kms_totales 
from flota.coches c 
inner join flota.modelos_vehiculo mv on c.modelo = mv.modelo 
inner join flota.colores c2 on c.color = c2.color 
inner join flota.polizas p  on c.n_poliza  = p.n_poliza 
group by matricula, fecha_compra, kms_totales, mv.id, c2.id, p.n_poliza;
--revision
insert into flota.revision (matricula, id_moneda, fecha, kms, importe_revision)
select 
	c.matricula,
	m.id,
	TO_DATE(c.fecha_revision, 'YYYY/MM/DD'),
	c.kms_revision,
	c.importe_revision
from flota.coches c
inner join flota.moneda m on c.moneda = m.moneda 
*/
/* Populate tables */
INSERT INTO flota.aseguradoras (aseguradora) VALUES
	 ('Mapfre'),
	 ('Axa'),
	 ('Allianz'),
	 ('Generali');
INSERT INTO flota.colores (color) VALUES
	 ('Negro'),
	 ('Azul'),
	 ('Gris Plateado'),
	 ('Rojo'),
	 ('Verde'),
	 ('Blanco');
INSERT INTO flota.grupos_vehiculos (grupo) VALUES
	 ('Renault-Nissan-Mitsubishi Alliance'),
	 ('Hyundai Motor Group'),
	 ('PSA Peugeot S.A.');
INSERT INTO flota.marcas_vehiculos (id_grupo,marca) VALUES
	 (1,'Dacia'),
	 (1,'Nissan'),
	 (1,'Renault'),
	 (2,'Hyundai'),
	 (2,'Kia'),
	 (3,'Citroën'),
	 (3,'Peugeot');
INSERT INTO flota.modelos_vehiculo (id_marca,modelo) VALUES
	 (1,'Duster'),
	 (1,'Lodgy'),
	 (2,'Leaf'),
	 (2,'Qashqai'),
	 (3,'Clio'),
	 (3,'Kangoo'),
	 (3,'Megane'),
	 (4,'i30'),
	 (4,'Tucson'),
	 (5,'Ceed');
INSERT INTO flota.modelos_vehiculo (id_marca,modelo) VALUES
	 (5,'Rio'),
	 (6,'Berlingo'),
	 (6,'DS4'),
	 (7,'206'),
	 (7,'5008');
INSERT INTO flota.moneda (moneda) VALUES
	 ('Dólar'),
	 ('Euro'),
	 ('Peso Colombiano'),
	 ('Peso Mexicano');
INSERT INTO flota.polizas (n_poliza,id_aseguradora,fecha_alta) VALUES
	 (116398,1,'2008-09-16'),
	 (85225,1,'2013-04-01'),
	 (194490,1,'2003-07-13'),
	 (183813,1,'2013-03-06'),
	 (142266,1,'2011-07-19'),
	 (163498,1,'2015-10-24'),
	 (117329,1,'2018-06-05'),
	 (8307,1,'2017-09-15'),
	 (92532,1,'2012-11-08'),
	 (172309,1,'2006-01-22');
INSERT INTO flota.polizas (n_poliza,id_aseguradora,fecha_alta) VALUES
	 (192389,1,'2018-04-19'),
	 (50387,1,'2008-05-10'),
	 (89394,1,'2004-10-12'),
	 (91503,1,'2008-05-16'),
	 (55403,1,'2006-10-17'),
	 (173686,1,'2016-03-07'),
	 (172754,1,'2006-03-23'),
	 (48113,1,'2008-04-29'),
	 (51353,1,'2008-04-02'),
	 (12534,1,'2020-04-13');
INSERT INTO flota.polizas (n_poliza,id_aseguradora,fecha_alta) VALUES
	 (161701,1,'2010-10-16'),
	 (182094,1,'2019-01-02'),
	 (170914,1,'2004-09-22'),
	 (115392,1,'2002-01-17'),
	 (172625,1,'2009-10-26'),
	 (35103,1,'2000-11-24'),
	 (9482,1,'2017-08-27'),
	 (104210,1,'2017-07-06'),
	 (84213,1,'2017-10-11'),
	 (54681,1,'2008-04-29');
INSERT INTO flota.polizas (n_poliza,id_aseguradora,fecha_alta) VALUES
	 (54632,1,'2007-02-27'),
	 (66942,1,'2020-05-11'),
	 (126578,1,'2004-01-30'),
	 (88106,1,'2002-04-06'),
	 (151249,1,'2010-04-21'),
	 (124027,1,'2012-04-19'),
	 (135515,1,'2001-04-05'),
	 (89739,1,'2018-06-03'),
	 (39780,2,'2004-03-13'),
	 (105112,2,'1999-03-14');
INSERT INTO flota.polizas (n_poliza,id_aseguradora,fecha_alta) VALUES
	 (179156,2,'2014-06-28'),
	 (161477,2,'2007-12-07'),
	 (172546,2,'2003-04-10'),
	 (82585,2,'2014-10-11'),
	 (136600,2,'2015-03-29'),
	 (116336,2,'2007-06-25'),
	 (75790,2,'2007-06-06'),
	 (105002,2,'2016-10-04'),
	 (117439,2,'2017-11-21'),
	 (113718,2,'2008-11-19');
INSERT INTO flota.polizas (n_poliza,id_aseguradora,fecha_alta) VALUES
	 (112290,2,'2020-09-21'),
	 (191842,2,'2017-08-09'),
	 (7094,2,'2007-11-15'),
	 (127909,2,'2020-09-18'),
	 (118686,2,'2021-09-02'),
	 (110761,2,'2011-08-23'),
	 (117277,2,'2015-12-19'),
	 (40977,2,'2013-11-03'),
	 (71232,2,'2007-03-13'),
	 (190383,2,'1999-06-06');
INSERT INTO flota.polizas (n_poliza,id_aseguradora,fecha_alta) VALUES
	 (56264,2,'2015-10-31'),
	 (161471,2,'2015-10-15'),
	 (121129,2,'2008-05-01'),
	 (169829,2,'2011-12-01'),
	 (173030,2,'2013-02-18'),
	 (85627,2,'2008-02-12'),
	 (144573,2,'2015-04-01'),
	 (86600,2,'2016-01-24'),
	 (163789,3,'2016-01-31'),
	 (190446,3,'2015-09-03');
INSERT INTO flota.polizas (n_poliza,id_aseguradora,fecha_alta) VALUES
	 (187586,3,'2004-05-18'),
	 (139949,3,'2003-03-02'),
	 (189152,3,'2016-04-14'),
	 (108872,3,'2018-05-12'),
	 (131987,3,'2015-10-03'),
	 (145462,3,'2007-03-31'),
	 (96770,3,'2017-09-18'),
	 (63946,3,'2011-09-17'),
	 (195443,3,'2010-04-17'),
	 (136882,3,'2014-01-28');
INSERT INTO flota.polizas (n_poliza,id_aseguradora,fecha_alta) VALUES
	 (79203,3,'2007-08-30'),
	 (62061,3,'2004-01-15'),
	 (189761,3,'2020-08-03'),
	 (121919,3,'2008-08-21'),
	 (20640,3,'2005-08-23'),
	 (190418,3,'2008-05-10'),
	 (184039,3,'2020-09-06'),
	 (25786,3,'2009-06-01'),
	 (79841,3,'2008-03-03'),
	 (112320,3,'1999-09-30');
INSERT INTO flota.polizas (n_poliza,id_aseguradora,fecha_alta) VALUES
	 (4341,3,'2008-07-30'),
	 (119373,3,'2016-11-27'),
	 (144448,3,'2016-11-16'),
	 (111429,3,'2004-05-29'),
	 (94565,3,'2003-04-08'),
	 (67577,3,'2017-10-10'),
	 (73097,3,'2007-08-02'),
	 (26976,3,'2012-09-29'),
	 (41930,3,'2006-03-04'),
	 (34218,3,'2019-04-10');
INSERT INTO flota.polizas (n_poliza,id_aseguradora,fecha_alta) VALUES
	 (16848,3,'2006-07-13'),
	 (177717,3,'2000-05-01'),
	 (96367,3,'2002-11-12'),
	 (174298,4,'2018-03-19'),
	 (8576,4,'2014-05-19'),
	 (102441,4,'2003-03-27'),
	 (196487,4,'2019-01-14'),
	 (64092,4,'2001-03-14'),
	 (126373,4,'2000-01-12'),
	 (109846,4,'2019-03-11');
INSERT INTO flota.polizas (n_poliza,id_aseguradora,fecha_alta) VALUES
	 (6062,4,'2001-02-09'),
	 (125045,4,'2012-10-01'),
	 (159753,4,'2012-10-22'),
	 (73547,4,'2004-06-21'),
	 (118284,4,'2008-06-23'),
	 (181054,4,'2014-12-04'),
	 (146739,4,'2019-04-16'),
	 (174969,4,'2011-12-19'),
	 (82043,4,'2007-01-31'),
	 (176268,4,'2007-01-07');
INSERT INTO flota.polizas (n_poliza,id_aseguradora,fecha_alta) VALUES
	 (137325,4,'2009-10-14'),
	 (187526,4,'2014-07-14'),
	 (174043,4,'2020-03-02'),
	 (157749,4,'2009-03-12'),
	 (19347,4,'2016-12-03'),
	 (45918,4,'2019-03-24'),
	 (131978,4,'2021-12-21'),
	 (186297,4,'2016-08-24'),
	 (32844,4,'2009-01-23'),
	 (167291,4,'2014-05-02');
INSERT INTO flota.polizas (n_poliza,id_aseguradora,fecha_alta) VALUES
	 (187973,4,'2015-06-19'),
	 (40647,4,'2006-07-24'),
	 (124038,4,'2002-12-12');
INSERT INTO flota.vehiculo (matricula,id_modelo,id_color,n_poliza,fecha_compra,kms_totales) VALUES
	 ('0007HHR',11,5,131987,'2014-03-30',37686),
	 ('0326HRM',15,3,179156,'2014-06-28',105374),
	 ('0366CKQ',15,3,111429,'2003-04-10',118687),
	 ('0390DRK',13,5,121129,'2007-03-27',38651),
	 ('0393DWY',15,4,73097,'2007-08-02',41340),
	 ('0827DBB',7,3,40647,'2006-07-24',39061),
	 ('0922JVF',15,1,104210,'2017-07-06',97321),
	 ('1323DQL',6,1,172309,'2006-01-22',107492),
	 ('1567JPK',10,3,19347,'2016-12-03',54278),
	 ('1621CSY',13,4,89394,'2004-10-12',42218);
INSERT INTO flota.vehiculo (matricula,id_modelo,id_color,n_poliza,fecha_compra,kms_totales) VALUES
	 ('1970BLH',3,4,102441,'2002-04-18',47354),
	 ('2066BYF',12,3,105112,'1999-03-14',57697),
	 ('2428HYB',7,5,161471,'2014-12-04',87006),
	 ('2430FDP',12,1,118284,'2008-06-23',91570),
	 ('2438GSV',13,3,110761,'2010-04-17',52349),
	 ('2633GJF',14,4,124027,'2011-02-19',41129),
	 ('2684FZV',13,1,50387,'2008-05-10',36859),
	 ('2835JQN',6,4,108872,'2016-11-16',61510),
	 ('2874BRD',8,2,115392,'2000-10-01',46794),
	 ('2890DSR',10,3,16848,'2006-07-13',28530);
INSERT INTO flota.vehiculo (matricula,id_modelo,id_color,n_poliza,fecha_compra,kms_totales) VALUES
	 ('2907GNT',8,1,92532,'2012-11-08',51508),
	 ('3122DZN',1,6,113718,'2007-12-01',50250),
	 ('3187KKM',8,4,189761,'2019-01-14',69946),
	 ('3212HJW',11,3,117277,'2014-08-04',28986),
	 ('3230KTX',4,1,127909,'2019-04-16',69200),
	 ('3242GQG',7,4,183813,'2013-03-06',77662),
	 ('3272JJJ',11,5,89739,'2018-06-03',27503),
	 ('3274CYM',4,1,39780,'2004-03-13',31210),
	 ('3306GYM',3,5,173030,'2011-12-19',76024),
	 ('3313GGW',13,4,85225,'2013-04-01',35823);
INSERT INTO flota.vehiculo (matricula,id_modelo,id_color,n_poliza,fecha_compra,kms_totales) VALUES
	 ('3883DSH',5,6,54632,'2007-02-27',35949),
	 ('3960JYB',6,1,8307,'2017-09-15',30810),
	 ('4221JXR',11,2,109846,'2018-03-19',50166),
	 ('4315JKL',1,3,9482,'2017-08-27',46145),
	 ('4325KMF',13,6,12534,'2020-04-13',49476),
	 ('4366GZX',9,5,40977,'2013-11-03',44510),
	 ('4389KSN',14,4,112290,'2019-02-14',30862),
	 ('4761CVL',9,4,94565,'2003-04-08',35224),
	 ('4896HCC',4,1,8576,'2014-05-19',45887),
	 ('4916HJG',4,2,136600,'2015-03-29',64638);
INSERT INTO flota.vehiculo (matricula,id_modelo,id_color,n_poliza,fecha_compra,kms_totales) VALUES
	 ('5022JZD',8,5,173686,'2016-03-07',63426),
	 ('5047FJK',13,6,161701,'2009-10-26',90641),
	 ('5188DWK',8,2,157749,'2007-12-07',74494),
	 ('5205DFJ',10,3,41930,'2006-03-04',50972),
	 ('5303DCG',13,3,79203,'2007-08-30',35530),
	 ('5426HDG',10,1,144573,'2015-04-01',46759),
	 ('5572DHP',11,6,75790,'2007-06-06',42143),
	 ('5648JTZ',10,5,117439,'2016-04-14',61124),
	 ('5751FCL',10,4,4341,'2008-07-30',40662),
	 ('5851CSB',8,3,73547,'2004-06-21',39717);
INSERT INTO flota.vehiculo (matricula,id_modelo,id_color,n_poliza,fecha_compra,kms_totales) VALUES
	 ('5865JKB',9,2,86600,'2016-01-24',30495),
	 ('5899CLW',9,5,187586,'2003-03-02',35922),
	 ('5954DWX',4,1,121919,'2007-10-25',39775),
	 ('6010JXB',10,1,117329,'2017-06-30',46520),
	 ('6016FWX',2,3,54681,'2008-04-29',27713),
	 ('6231KKQ',1,4,34218,'2019-04-10',39563),
	 ('6335BFK',1,5,177717,'1999-06-06',53657),
	 ('6532KNR',8,2,45918,'2019-03-24',35831),
	 ('6640FPQ',15,2,85627,'2008-02-12',38454),
	 ('6642GZP',9,5,151249,'2010-04-21',97183);
INSERT INTO flota.vehiculo (matricula,id_modelo,id_color,n_poliza,fecha_compra,kms_totales) VALUES
	 ('6708BTB',6,4,124038,'2001-07-17',44027),
	 ('6743DYG',11,3,116336,'2007-06-25',76387),
	 ('6756GXW',14,1,142266,'2011-07-19',112881),
	 ('6788DRX',8,6,7094,'2007-11-15',36066),
	 ('6850KZW',10,6,66942,'2020-05-11',25227),
	 ('7136BCS',14,6,6062,'2001-02-09',43363),
	 ('7221BJG',10,6,112320,'1999-09-30',70197),
	 ('7224FDF',15,1,48113,'2008-04-29',28796),
	 ('7295DHG',3,2,55403,'2006-10-17',34938),
	 ('7343FRT',5,4,25786,'2009-06-01',47644);
INSERT INTO flota.vehiculo (matricula,id_modelo,id_color,n_poliza,fecha_compra,kms_totales) VALUES
	 ('7457BFT',4,1,35103,'2000-11-24',39949),
	 ('7466DMG',5,3,145462,'2007-03-31',85722),
	 ('7489HBJ',6,4,82585,'2014-10-11',37783),
	 ('7561CND',8,6,170914,'2004-09-22',71901),
	 ('7631GCM',13,1,63946,'2011-09-17',31372),
	 ('7710HMZ',14,5,190446,'2014-04-09',45773),
	 ('7764GTD',9,5,125045,'2012-10-01',54522),
	 ('7792CKF',9,5,126578,'2003-03-02',59984),
	 ('7905HMT',8,2,56264,'2015-10-31',38622),
	 ('7938HXH',9,3,105002,'2015-10-24',53342);
INSERT INTO flota.vehiculo (matricula,id_modelo,id_color,n_poliza,fecha_compra,kms_totales) VALUES
	 ('7987FXL',11,6,32844,'2009-01-23',24726),
	 ('8177JPM',5,3,119373,'2016-11-27',77082),
	 ('8217BCW',13,4,194490,'2001-12-18',43385),
	 ('8540DXG',9,3,71232,'2007-03-13',27722),
	 ('8563JCM',3,2,84213,'2017-10-11',45745),
	 ('8627FRY',9,6,51353,'2008-04-02',30083),
	 ('8706FTV',9,5,91503,'2008-05-16',53733),
	 ('8718CJT',4,1,20640,'2005-08-23',46682),
	 ('8802GQX',1,6,167291,'2013-04-23',34941),
	 ('8926GPQ',1,6,26976,'2012-09-29',42989);
INSERT INTO flota.vehiculo (matricula,id_modelo,id_color,n_poliza,fecha_compra,kms_totales) VALUES
	 ('9024CVP',4,5,62061,'2004-01-15',25161),
	 ('9157JVM',12,6,96770,'2017-09-18',41539),
	 ('9209KGR',15,4,118686,'2020-03-02',58260),
	 ('9281BNK',9,3,88106,'2002-04-06',35517),
	 ('9314JHS',4,1,67577,'2017-10-10',41064),
	 ('9412DTS',13,1,82043,'2007-01-31',54013),
	 ('9428BCQ',10,5,96367,'2002-11-12',33451),
	 ('9666FZC',3,6,79841,'2008-03-03',39533),
	 ('9729KXJ',7,5,131978,'2020-09-06',76972),
	 ('9775BVC',8,3,64092,'2001-03-14',29962);
INSERT INTO flota.revision (matricula,id_moneda,fecha,kms,importe_revision) VALUES
	 ('7343FRT',3,'2020-07-07',29564,1076030.00),
	 ('2438GSV',1,'2010-05-13',12028,734.70),
	 ('2438GSV',2,'2016-05-17',28312,460.00),
	 ('9666FZC',3,'2017-12-13',19543,344330.00),
	 ('7221BJG',3,'2000-05-18',12066,1162120.00),
	 ('7221BJG',2,'2008-05-24',41764,800.00),
	 ('6756GXW',3,'2012-01-19',21955,3615470.00),
	 ('6756GXW',1,'2012-04-02',50738,697.50),
	 ('6756GXW',4,'2012-06-28',74499,11869.20),
	 ('6756GXW',4,'2013-06-24',94670,3579.60);
INSERT INTO flota.revision (matricula,id_moneda,fecha,kms,importe_revision) VALUES
	 ('9314JHS',4,'2019-09-04',24441,14695.20),
	 ('7987FXL',2,'2021-12-04',11140,730.00),
	 ('4325KMF',4,'2022-07-08',20410,7912.80),
	 ('3883DSH',2,'2014-05-16',19245,570.00),
	 ('3242GQG',1,'2014-02-10',16209,120.90),
	 ('3242GQG',2,'2014-04-27',27845,80.00),
	 ('3242GQG',4,'2014-06-07',38072,1695.60),
	 ('3242GQG',4,'2021-11-30',49153,16767.60),
	 ('4315JKL',4,'2017-11-02',20263,15825.60),
	 ('5426HDG',1,'2015-09-27',16879,437.10);
INSERT INTO flota.revision (matricula,id_moneda,fecha,kms,importe_revision) VALUES
	 ('5426HDG',3,'2019-08-24',34964,2883770.00),
	 ('6231KKQ',1,'2021-04-04',13755,632.40),
	 ('7457BFT',2,'2018-09-24',16226,90.00),
	 ('5205DFJ',4,'2022-05-24',23043,14883.60),
	 ('3212HJW',2,'2023-04-14',14526,170.00),
	 ('3313GGW',4,'2017-12-13',17187,1884.00),
	 ('6642GZP',3,'2011-01-06',21563,3228100.00),
	 ('6642GZP',1,'2011-05-04',49405,83.70),
	 ('6642GZP',4,'2023-03-11',69454,1507.20),
	 ('3306GYM',3,'2012-04-17',18060,1463400.00);
INSERT INTO flota.revision (matricula,id_moneda,fecha,kms,importe_revision) VALUES
	 ('3306GYM',4,'2013-01-10',37513,16767.60),
	 ('3306GYM',4,'2019-06-16',58378,14883.60),
	 ('5303DCG',4,'2022-05-31',14181,11492.40),
	 ('0827DBB',1,'2019-02-23',24407,325.50),
	 ('5047FJK',4,'2010-02-22',18053,5086.80),
	 ('5047FJK',1,'2010-05-03',40390,399.90),
	 ('5047FJK',3,'2010-12-08',63099,2324230.00),
	 ('4366GZX',1,'2017-08-27',21132,306.90),
	 ('7561CND',4,'2006-01-18',13171,12622.80),
	 ('7561CND',3,'2006-02-27',29474,2926810.00);
INSERT INTO flota.revision (matricula,id_moneda,fecha,kms,importe_revision) VALUES
	 ('7561CND',1,'2021-04-19',42110,74.40),
	 ('5954DWX',2,'2016-05-30',25110,440.00),
	 ('9157JVM',1,'2020-12-29',21421,390.60),
	 ('0366CKQ',4,'2003-04-28',24801,13941.60),
	 ('0366CKQ',2,'2003-07-26',51615,590.00),
	 ('0366CKQ',1,'2004-04-27',74997,83.70),
	 ('0366CKQ',1,'2009-06-04',90943,548.70),
	 ('2907GNT',1,'2016-03-09',25366,753.30),
	 ('2428HYB',1,'2014-12-09',17526,269.70),
	 ('2428HYB',2,'2015-09-05',40875,610.00);
INSERT INTO flota.revision (matricula,id_moneda,fecha,kms,importe_revision) VALUES
	 ('2428HYB',2,'2015-09-23',59896,290.00),
	 ('2428HYB',1,'2016-05-24',72001,399.90),
	 ('6743DYG',4,'2008-01-13',22761,8101.20),
	 ('6743DYG',4,'2008-03-17',34009,9608.40),
	 ('6743DYG',2,'2012-11-14',60377,450.00),
	 ('8706FTV',3,'2011-12-07',25843,3658510.00),
	 ('1567JPK',3,'2017-05-12',28259,301289.00),
	 ('8802GQX',2,'2015-06-15',22523,820.00),
	 ('0922JVF',3,'2018-11-25',25300,602578.00),
	 ('0922JVF',4,'2018-12-06',49167,6594.00);
INSERT INTO flota.revision (matricula,id_moneda,fecha,kms,importe_revision) VALUES
	 ('0922JVF',4,'2023-05-08',76863,8478.00),
	 ('5022JZD',3,'2016-05-13',11715,430413.00),
	 ('5022JZD',1,'2021-04-19',35020,539.40),
	 ('8177JPM',3,'2017-01-24',19822,1678610.00),
	 ('8177JPM',1,'2017-11-25',41924,483.60),
	 ('8177JPM',3,'2021-05-04',57202,387372.00),
	 ('8627FRY',1,'2020-04-28',16181,120.90),
	 ('7938HXH',1,'2016-09-08',20157,186.00),
	 ('7938HXH',2,'2017-10-23',34833,590.00),
	 ('3230KTX',4,'2019-05-13',25879,4898.40);
INSERT INTO flota.revision (matricula,id_moneda,fecha,kms,importe_revision) VALUES
	 ('3230KTX',1,'2023-02-02',44068,688.20),
	 ('7710HMZ',4,'2022-08-28',22300,3391.20),
	 ('4221JXR',2,'2018-06-08',18380,50.00),
	 ('4221JXR',1,'2022-05-22',38809,204.60),
	 ('3272JJJ',2,'2022-10-04',11209,210.00),
	 ('2633GJF',3,'2023-07-13',25614,3055930.00),
	 ('5648JTZ',4,'2017-11-12',22988,16390.80),
	 ('5648JTZ',3,'2019-06-20',47336,946909.00),
	 ('1621CSY',4,'2022-08-18',29407,4898.40),
	 ('9428BCQ',4,'2022-05-03',14720,16956.00);
INSERT INTO flota.revision (matricula,id_moneda,fecha,kms,importe_revision) VALUES
	 ('9412DTS',1,'2015-05-30',24707,46.50),
	 ('9729KXJ',2,'2020-10-11',14348,110.00),
	 ('9729KXJ',1,'2021-09-13',36512,632.40),
	 ('9729KXJ',3,'2022-04-12',52881,3873720.00),
	 ('2890DSR',1,'2014-07-23',13864,213.90),
	 ('2066BYF',3,'1999-09-04',14097,1162120.00),
	 ('2066BYF',3,'2014-05-14',28378,559537.00),
	 ('7466DMG',2,'2007-06-16',19536,200.00),
	 ('7466DMG',1,'2007-09-26',39863,325.50),
	 ('7466DMG',2,'2018-10-08',56109,270.00);
INSERT INTO flota.revision (matricula,id_moneda,fecha,kms,importe_revision) VALUES
	 ('0390DRK',4,'2015-12-01',22339,6594.00),
	 ('6850KZW',4,'2023-03-05',15206,10173.60),
	 ('3960JYB',1,'2018-08-22',17211,158.10),
	 ('9209KGR',4,'2021-08-15',12808,2637.60),
	 ('9209KGR',2,'2023-08-16',31259,210.00),
	 ('1323DQL',3,'2006-02-11',26924,3012890.00),
	 ('1323DQL',2,'2006-12-02',49644,590.00),
	 ('1323DQL',3,'2007-01-03',62371,3701550.00),
	 ('1323DQL',3,'2007-11-23',90278,3572430.00),
	 ('2684FZV',1,'2008-06-07',17713,455.70);
INSERT INTO flota.revision (matricula,id_moneda,fecha,kms,importe_revision) VALUES
	 ('6010JXB',4,'2018-07-09',19345,8854.80),
	 ('9281BNK',4,'2003-10-06',15082,9043.20),
	 ('0393DWY',2,'2020-02-03',22765,50.00),
	 ('7792CKF',2,'2003-05-06',16746,560.00),
	 ('7792CKF',3,'2009-05-25',37787,3830680.00),
	 ('7905HMT',2,'2020-07-14',11937,590.00),
	 ('3274CYM',4,'2022-04-15',17619,11869.20),
	 ('5751FCL',1,'2010-08-06',16314,446.40),
	 ('9775BVC',3,'2001-04-27',11436,1936860.00),
	 ('3122DZN',4,'2022-05-06',27367,16202.40);
INSERT INTO flota.revision (matricula,id_moneda,fecha,kms,importe_revision) VALUES
	 ('7295DHG',2,'2009-06-01',20272,850.00),
	 ('2874BRD',1,'2021-12-22',27678,232.50),
	 ('8718CJT',2,'2005-09-11',25928,460.00),
	 ('8563JCM',2,'2018-05-24',17322,720.00),
	 ('6640FPQ',2,'2022-10-14',14565,350.00),
	 ('6788DRX',2,'2015-12-29',15306,840.00),
	 ('2430FDP',2,'2009-07-10',29114,530.00),
	 ('2430FDP',3,'2009-08-21',53723,3228100.00),
	 ('2430FDP',2,'2011-11-06',66643,770.00),
	 ('5851CSB',2,'2011-03-09',20756,780.00);
INSERT INTO flota.revision (matricula,id_moneda,fecha,kms,importe_revision) VALUES
	 ('6708BTB',4,'2007-01-18',27720,7347.60),
	 ('4916HJG',2,'2015-12-22',17802,100.00),
	 ('4916HJG',3,'2015-12-27',28533,516496.00),
	 ('4916HJG',1,'2023-08-26',39243,46.50),
	 ('5899CLW',3,'2013-09-10',18724,2109020.00),
	 ('6016FWX',3,'2014-02-25',15657,817785.00),
	 ('0007HHR',3,'2021-02-22',23034,817785.00),
	 ('8540DXG',1,'2014-01-12',15249,530.10),
	 ('6335BFK',4,'1999-09-27',19109,9985.20),
	 ('6335BFK',1,'2009-04-14',34682,279.00);
INSERT INTO flota.revision (matricula,id_moneda,fecha,kms,importe_revision) VALUES
	 ('3187KKM',3,'2019-12-20',20293,602578.00),
	 ('3187KKM',3,'2020-01-25',33325,1979900.00),
	 ('3187KKM',4,'2021-01-15',43580,14318.40),
	 ('7631GCM',2,'2021-11-16',15837,830.00),
	 ('9024CVP',3,'2014-03-18',13470,2668560.00),
	 ('4761CVL',3,'2016-08-16',21369,2109020.00),
	 ('7489HBJ',1,'2019-08-02',22207,316.20),
	 ('5188DWK',3,'2008-06-16',23426,3572430.00),
	 ('5188DWK',2,'2008-09-25',37800,670.00),
	 ('5188DWK',4,'2023-08-20',60028,4898.40);
INSERT INTO flota.revision (matricula,id_moneda,fecha,kms,importe_revision) VALUES
	 ('7764GTD',2,'2013-10-25',16201,510.00),
	 ('7764GTD',3,'2015-03-30',39865,1162120.00),
	 ('7136BCS',1,'2003-10-29',22625,595.20),
	 ('2835JQN',4,'2018-05-05',18893,1695.60),
	 ('2835JQN',1,'2021-08-01',45588,669.60),
	 ('4896HCC',4,'2020-05-01',27814,7536.00),
	 ('5865JKB',2,'2016-07-17',11276,620.00),
	 ('8926GPQ',2,'2016-11-01',25569,330.00),
	 ('7224FDF',3,'2008-11-20',16890,3228100.00),
	 ('1970BLH',3,'2010-04-07',21660,2238150.00);
INSERT INTO flota.revision (matricula,id_moneda,fecha,kms,importe_revision) VALUES
	 ('8217BCW',2,'2020-05-08',25009,620.00),
	 ('0326HRM',1,'2015-05-30',20625,827.70),
	 ('0326HRM',1,'2015-06-11',46451,548.70),
	 ('0326HRM',2,'2015-06-18',62529,350.00),
	 ('0326HRM',1,'2016-08-25',90819,241.80),
	 ('6532KNR',4,'2022-03-26',19344,13753.20),
	 ('4389KSN',3,'2021-12-06',19885,559537.00),
	 ('5572DHP',1,'2014-05-29',22437,186.00);


/* SELECTS */
-- Nombre modelo, marca y grupo de coches (los nombre de todos)
-- Fecha de compra
-- Matricula
-- Nombre del color del coche
-- Total de kilómetros
-- Nombre empresa que está asegurado el coche
-- Numero de póliza
	
select  
    mv.modelo AS "Nombre modelo",
    mv2.marca AS "marca",
    gv.grupo AS "grupo",
    v.fecha_compra  AS "Fecha de compra",
    v.matricula AS "Matrícula",
    c.color AS "Nombre del color",
    v.kms_totales  AS "Total de kilómetros",
    a.aseguradora AS "Aseguradora",
    v.n_poliza  AS "Número de póliza"
from
	flota.vehiculo v
join flota.modelos_vehiculo mv ON v.id_modelo  = mv.id
join flota.marcas_vehiculos mv2 ON mv.id_marca  = mv2.id
join flota.grupos_vehiculos gv ON mv2.id_grupo = gv.id
join flota.colores c on v.id_color  = c.id 
join flota.polizas p on v.n_poliza = p.n_poliza 
JOIN flota.aseguradoras a ON p.id_aseguradora  = a.id;
