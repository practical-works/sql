/*Définition et mise à jour des données- Base de données EMPRUNTS
    1. Créez toutes les tables avec les contraintes d’intégrité PK et FK, et ajouter un enregistrement par table.
    2. Ajouter une contraint strictement positif (>) pour Montant.
    3. Modifier la valeur Null des Montants par la valeur 0
    4. Modifier les villes des Clients en minuscule
    5. Augmenter le solde de tous les clients habitant “Rabat” de “0,5%”
    6. Afficher la Liste des clients dont le nom se termine par E et le quatrième caractère est un A.
    7. Afficher la Liste des agences ayant des emprunts-clients.
    8. Afficher la liste des clients ayant un emprunt à “Casa”
    9. Afficher la liste des clients ayant un compte et un emprunt à “Casa”
    10. Afficher la liste des clients ayant un emprunt à la ville où ils habitent.
    11. Afficher la liste des clients ayant un compte et emprunt dans la même agence
    12. Afficher l'emprunt moyenne des clients dans chaque agence
    13. Afficher le totale emprunté par client
    14. Afficher Le client qui a le moins des totaux emprunts
    15. Afficher les clients ayant un compte dans toutes les agences de “Rabat”
*/

--Q1
create database EMPRUNTS
go
use EMPRUNTS

create table AGENCE(Num_Ag int primary key,Nom_Ag varchar(30),Ville_Ag varchar(30))
create table CLIENT(Num_Cl int primary key,Nom_Cl varchar(30),Prenom_Cl varchar(30),Ville_Cl varchar(30))
create table COMPTE(Num_Cp int primary key,Num_Cl int foreign key references CLIENT(Num_Cl),Num_Ag int foreign key references AGENCE(Num_Ag),Solde float)
create table EMPRUNT(Num_Ep int primary key,Num_Cl int foreign key references CLIENT(Num_Cl),Num_Ag int foreign key references AGENCE(Num_Ag),Montant float)

insert into AGENCE values(1,'AGENCE1','Casa')
insert into CLIENT values(1,'NOM1','PRENOM1','Rabat')
insert into COMPTE values(1,1,1,25000)
insert into EMPRUNT values(1,1,1,600000)

--Q2
alter table EMPRUNT add constraint montant_positif check(Montant>=0)
exec sp_helpconstraint EMPRUNT

--Q3
update EMPRUNT
set Montant=0
where Montant is null

--Q4
update CLIENT
set Ville_Cl=LOWER(Ville_Cl)

--Q5
update COMPTE
set Solde=Solde+Solde*0.5/100
where Num_Cl in
(
select Num_Cl
from CLIENT
where Ville_Cl='rabat'
)

--Q6
select *
from CLIENT
where Nom_Cl like '___A%E'

--Q7
select distinct a.*
from EMPRUNT e inner join AGENCE a on e.Num_Ag=a.Num_Ag

--Q8
select distinct c.*
from EMPRUNT e inner join AGENCE a on e.Num_Ag=a.Num_Ag inner join CLIENT c on e.Num_Cl=c.Num_Cl
where a.Ville_Ag='casa'

--Q9
select *
from CLIENT
where Num_Cl in
(
select distinct Num_Cl 
from EMPRUNT e inner join AGENCE a on e.Num_Ag=a.Num_Ag
where a.Ville_Ag='casa'
)
and Num_Cl in
(
select distinct Num_Cl 
from COMPTE c inner join AGENCE a on c.Num_Ag=a.Num_Ag
where a.Ville_Ag='casa'
)

--Q10
select  distinct c.*
from EMPRUNT e inner join AGENCE a on e.Num_Ag=a.Num_Ag inner join CLIENT c on e.Num_Cl=c.Num_Cl
where a.Ville_Ag=c.Ville_Cl

--Q11
select distinct c.*
from CLIENT c inner join EMPRUNT e on c.Num_Cl=e.Num_Cl inner join COMPTE cp on c.Num_Cl=cp.Num_Cl 
where e.Num_Ag=cp.Num_Ag


--Q12
select Num_Ag,AVG(Montant) as "Moyenne des Emprunts"
from EMPRUNT
group by Num_Ag

--Q13
select c.Num_Cl,c.Nom_Cl,c.Prenom_Cl,SUM(e.Montant) as "Total des Emprunts"
from EMPRUNT e inner join CLIENT c on e.Num_Cl=c.Num_Cl
group by c.Num_Cl,c.Nom_Cl,c.Prenom_Cl


--Q14
select top 1 c.Num_Cl,c.Nom_Cl,c.Prenom_Cl,SUM(e.Montant) as "Total des Emprunts"
from EMPRUNT e inner join CLIENT c on e.Num_Cl=c.Num_Cl
group by c.Num_Cl,c.Nom_Cl,c.Prenom_Cl
order by "Total des Emprunts"

--Q14--2
select c.Num_Cl,c.Nom_Cl,c.Prenom_Cl,c.Ville_Cl
from EMPRUNT e inner join CLIENT c on e.Num_Cl=c.Num_Cl
group by c.Num_Cl,c.Nom_Cl,c.Prenom_Cl,c.Ville_Cl
having SUM(e.Montant)= 
(
select MIN(m.Total) 
from 
(
select c.Num_Cl,SUM(e.Montant) as "Total"
from EMPRUNT e inner join CLIENT c on e.Num_Cl=c.Num_Cl
group by c.Num_Cl
)m
)

--Q15
select c.Num_Cl,Nom_Cl,Prenom_Cl,Ville_Cl
from CLIENT c inner join COMPTE cp on c.Num_Cl=cp.Num_Cl inner join AGENCE a on a.Num_Ag=cp.Num_Ag
where a.Ville_Ag='rabat'
group by c.Num_Cl,Nom_Cl,Prenom_Cl,Ville_Cl
having COUNT(distinct a.Num_Ag)=(select COUNT(*) from AGENCE where Ville_Ag='Rabat')