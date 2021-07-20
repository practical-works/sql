/*Définition et mise à jour des données- Base de données VOYAGES
    1. Créer les tables en spécifiant les clés primaires et étrangères et en respectant les règles suivantes :
        a. Le noclient de la table client commence de 1 est s’incrémente automatiquement de 1.
        b. La date d’inscription prend la date d'aujourd’hui par défaut.
        c. le numéro de téléphone contient 10 chiffres et doit être unique et le code postal contient 5 chiffres.
    2. Introduire quelques données pour tester.
    3. Afficher le nombre d'inscriptions entre le 11/02/2015 et 14/02/2015.
    4. Afficher pour chaque client (nom du client), le numéro de voyage, la date d’inscription, la date de voyage, le prix du voyage, la destination et la durée du voyage auquel il participe.
    5. Afficher pour chaque voyage (novoyage) le nombre de places libres restantes.
    6. Afficher pour chaque client (nom du client) le montant total qu’il a payé pour tous les voyages auxquels il a participé.
    7. Diminuer le prix de 10% et augmenter le nombre maximal de place de 20% pour les voyages dont le nombre de participants est égal au nombre maximal de places.
    8. Supprimer les clients qui ne sont pas inscrit dans un voyage depuis 3 ans.
*/

create database VOYAGES
go
use VOYAGES

--Q1
create table CLIENT (noclient int primary key identity(1,1),nom varchar(30),prenom varchar(30),tel varchar(10) unique, adresse varchar(50),codepostal varchar(5),constraint c1 check(tel like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),constraint c2 check(codepostal like '[0-9][0-9][0-9][0-9][0-9]'))
create table CIRCUIT(nocircuit int primary key, destination varchar(30),duree float)
create table VOYAGE(novoyage int primary key,datev date,prix float,nbplacemax int,nocircuit int foreign key references CIRCUIT(nocircuit))
create table INSCRIPTION (noclient int foreign key references CLIENT(noclient),novoyage int foreign key references VOYAGE(novoyage),date_inscription date default GETDATE(),primary key (noclient,novoyage))

--Q2
insert into CLIENT values('NOM1','PRENOM1','0611111111','ADR1','11111')
insert into CLIENT values('NOM2','PRENOM2','0622222222','ADR2','22222')
insert into CLIENT values('NOM3','PRENOM3','0633333333','ADR3','33333')

insert into CIRCUIT values(1,'DES1',4)
insert into CIRCUIT values(2,'DES2',5)
insert into CIRCUIT values(3,'DES3',4)


insert into VOYAGE values(1,'1/1/2016',1200,50,1)
insert into VOYAGE values(2,'1/6/2016',1200,50,1)
insert into VOYAGE values(3,'1/1/2016',1200,50,2)

insert into INSCRIPTION values(8,2,'1/3/2015')
insert into INSCRIPTION values(9,1,'1/12/2015')
insert into INSCRIPTION values(10,1,'1/12/2015')
insert into INSCRIPTION values(8,3,'10/3/2015')

--Q3
select COUNT(noclient) as "Nombre de clients"
from INSCRIPTION
where date_inscription between '11/02/2015' and '11/03/2015'

--Q4
select c.nom,c.prenom,v.novoyage,i.date_inscription,v.datev,v.prix,r.destination,r.duree
from CLIENT c inner join INSCRIPTION i on c.noclient=i.noclient inner join VOYAGE v on i.novoyage=v.novoyage inner join CIRCUIT r on v.nocircuit=r.nocircuit

--Q5
select v.novoyage,v.nbplacemax - COUNT(noclient) as "Nombre de places libres"
from INSCRIPTION i inner join VOYAGE v on i.novoyage=v.novoyage
group by v.novoyage,v.nbplacemax

--Q6
select c.noclient,c.nom,c.prenom, SUM(v.prix) as "montant total"
from CLIENT c inner join INSCRIPTION i on c.noclient=i.noclient inner join VOYAGE v on i.novoyage=v.novoyage inner join CIRCUIT r on v.nocircuit=r.nocircuit
group by c.noclient,c.nom,c.prenom

--Q7
update VOYAGE
set prix=prix+prix*10/100,nbplacemax=nbplacemax+nbplacemax*20/100
where novoyage in (
	select v.novoyage
	from INSCRIPTION i inner join VOYAGE v on i.novoyage=v.novoyage
	group by v.novoyage,v.nbplacemax 
	having COUNT(noclient)=v.nbplacemax
)

--Q8
delete from CLIENT
where noclient in (
	select noclient
	from INSCRIPTION
	group by noclient
	--having MAX(date_inscription)<cast(DATEADD(year,-3,GETDATE()) as DATE)
	having DATEDIFF(year,MAX(date_inscription),GETDATE())>3
)
