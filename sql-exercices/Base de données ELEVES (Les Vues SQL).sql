/* Les Vues SQL - Base de données ELEVES
1. Créer les tables en précisant les clés primaires et étrangères.
2. Créer les contraintes qui imposent que l’âge de l’élève soit entre 17 et 23 et que la note du contrôle soit entre 0 et 20.
3. Insérer des lignes dans les tables.
4. Afficher le nombre de contrôles passés par élève en mathématiques.
5. Créer une vue V_Moyenne_Matière qui permet d’afficher la moyenne de chaque élève (Id,Nom,Prénom) Par matière (NomMat, Coef).
6. Créer une vue V_Moyenne_Générale qui permet d’afficher la moyenne générale de chaque élève (Id,Nom,Prénom). 
*/

--Q1
create database ELEVES
go
use ELEVES

create table Eleve(Id_Eleve int primary key,Nom varchar(30),Prenom varchar(30),Age int)
create table Matiere(Code_Matiere varchar(30) primary key,Nom_Matiere varchar(30),Coef_Matiere int)
create table Controle(Id_Eleve int foreign key references Eleve(Id_Eleve),Code_Matiere varchar(30) foreign key references Matiere(Code_Matiere),Date_Controle Date,Note float,primary key (Id_Eleve,Code_Matiere,Date_Controle))
drop table Controle

--Q2
alter table Eleve add constraint age_eleve check(Age between 17 and 23)
alter table Controle add constraint note_eleve check(Note between 0 and 20)

--Q3
insert into Eleve values(1,'NOM1','PRENOM1',18)
insert into Eleve values(2,'NOM2','PRENOM2',18)
insert into Eleve values(3,'NOM3','PRENOM3',20)

insert into Matiere values('M1','MATIERE1',2)
insert into Matiere values('M2','MATIERE2',3)
insert into Matiere values('M3','MATIERE3',4)

insert into Controle values(1,'M1','1/2/2016',15)
insert into Controle values(1,'M2','1/2/2016',14)
insert into Controle values(1,'M3','1/2/2016',9)
insert into Controle values(1,'M1','1/5/2016',13)
insert into Controle values(2,'M1','1/5/2016',13)

--Q4
select c.Id_Eleve,COUNT(m.Code_Matiere) as "Nombre de controles"
from Controle c inner join Matiere m on c.Code_Matiere=m.Code_Matiere
where m.Nom_Matiere='MATH'
group by Id_Eleve

--Q5
create view V_Moyenne_Matiere as
select e.Id_Eleve,e.Nom,e.Prenom,m.Nom_Matiere,m.Coef_Matiere,SUM(c.Note)/COUNT(c.Note)  as "Moyenne_Matiere"
from Controle c inner join Eleve e on c.Id_Eleve=e.Id_Eleve inner join Matiere m on c.Code_Matiere=m.Code_Matiere
group by e.Id_Eleve,e.Nom,e.Prenom,m.Nom_Matiere,m.Coef_Matiere

select * from V_Moyenne_Matiere

--Q6
create view V_Moyenne_Genrale as
select Id_Eleve,Nom,Prenom,SUM(Coef_Matiere*Moyenne_Matiere)/(select SUM(Coef_Matiere) from Matiere) as "Moyenne Générale"
from V_Moyenne_Matiere
group by Id_Eleve,Nom,Prenom

select * from V_Moyenne_Genrale