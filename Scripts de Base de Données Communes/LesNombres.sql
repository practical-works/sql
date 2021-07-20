--*-----------------------------------------------------------------------------------*--
--					♠~♣ LES NOMBRES EN SQL-SERVER ♣~♠
--*-----------------------------------------------------------------------------------*--
drop database _test1;
create database _test1;
use _test1;
--*-----------------------------------------------------------------------------------*--
--♦ Conditions requise pour créer une colonne identité :
--*-----------------------------------------------------------------------------------*--
--Il n'est autorisé qu'une seule colonne identité par table.
create table t (
	a int identity(1,1),
	b int identity(1,1) -- /!\ Deuxième colonne Identité non autorisé !
);
--La colonne identité doit avoir le type de données 
--int, bigint, smallint, tinyint, decimal ou numeric 
--avec une échelle = 0 (chiffres après la virgule), 
--et être contrainte à ne pas accepter les valeurs NULL.
create table t (
	a float identity(1,1) -- /!\ Type de données non autorisé !
);
create table t (
	a int identity(1,1) null -- /!\ Valeurs null non autorisés !
);

--*-----------------------------------------------------------------------------------*--
--♦ Précision, échelle et longueur :
--*-----------------------------------------------------------------------------------*--
--	• La précision est le nombre de chiffres qui composent un nombre.
--Par exemple, le nombre 123,45 a une précision de 5 (chiffres). 
--	• L'échelle est le nombre de chiffres à droite du séparateur décimal dans un nombre. 
--Par exemple, le nombre 123,45 a une échelle de 2 (chiffres après la virgule).
--	• La longueur d'un nombre est le nombre d'octets utilisés pour stocker le nombre.
--♦ La longueur concerne aussi d'autre types de données :
--	• La longueur d'une chaîne de caractères ou Unicode est le nombre de caractères. 
--  • La longueur de binaire, varbinary, et image est le nombre d’octets.
--Par exemple, un type de données int peut contenir 10 chiffres, 
--est stocké sur 4 octets et n’accepte pas de décimales. 
--Le  type de données int a donc : 
--	◙ une précision de 10 (chiffres). 
--	◙ une échelle de 0 (chiffres après la virgule).
--	◙ une longueur de 4 (octets).
--PS. Dans SQL Server, la précision maximale par défaut des types de données
--numérique et décimal est de 38. Dans les versions antérieures, elle est de 28.
--*-----------------------------------------------------------------------------------*--

--*-----------------------------------------------------------------------------------*--
--♦ Insértion
--*-----------------------------------------------------------------------------------*--
drop table t;
create table t (
	a int identity(1,1),
	b int
);
select * from t;
--Une valeur explicite de la colonne identité ne peut être spécifiée que 
--si la liste des colonnes est utilisée et si IDENTITY_INSERT est défini sur ON.
insert into t values (1, 20), (2, 20), (3, 20); -- /!\ Valeur identité explicite non autorisé !
insert into t values (20), (20), (20);
set IDENTITY_INSERT t ON;
insert into t values (7, 20), (8, 20), (9, 20); -- /!\ Liste des colonnes requise !
insert into t (a, b) values (7, 20), (8, 20), (9, 20);
--*-----------------------------------------------------------------------------------*--
--♦ 
--*-----------------------------------------------------------------------------------*--
select * from t;