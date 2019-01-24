-- lucidchart entité-association https://www.lucidchart.com/documents/edit/1efa825f-05fa-4494-a611-318297c0b8b5/0
-- I) Langage de Définition de Données :


CREATE SEQUENCE uniq_ID_membre
MINVALUE 1
START WITH 1
INCREMENT BY 1
NOCACHE; -- NOCACHE  Specify NOCACHE to indicate that values of the sequence are not preallocated. If you omit both CACHE and NOCACHE, the database caches 20 sequence numbers by default.

CREATE TABLE OUVRAGE
(
	ISBN VARCHAR2(13) NOT NULL, -- Use last version of ISBN named GENCOD and composed by 13 char
	Titre VARCHAR2(100) NOT NULL,
	Auteur VARCHAR2(40), -- can be null because data are not always known
    Genre VARCHAR2(20) NOT NULL,
	Editeur VARCHAR2(40), -- can be null because data are not always known
	CONSTRAINT pk_Ouvrage PRIMARY KEY (ISBN)
);

create table EXEMPLAIRE
(
	ISBN VARCHAR2(13) NOT NULL,
	Numero_exemplaire NUMBER(2) NOT NULL,
	Etat VARCHAR2(8) DEFAULT 'Neuf' CHECK( Etat IN('Mauvais', 'Moyen', 'Bon', 'Neuf')),
	CONSTRAINT ISBN_Ouvrage FOREIGN KEY(ISBN) REFERENCES OUVRAGE (ISBN),
	CONSTRAINT pk_Exemplaire PRIMARY KEY (Numero_exemplaire,ISBN)
);

create table MEMBRE
(
	ID_membre NUMBER(6) DEFAULT uniq_ID_membre.nextval NOT NULL,
	Nom VARCHAR2(40) NOT NULL,
	Prenom VARCHAR2(40) NOT NULL,
	Adresse VARCHAR2(50) NOT NULL,
	Telephone VARCHAR2(10) NOT NULL,
	Date_adhesion DATE NOT NULL,
	Duree NUMBER(2) CHECK( Duree IN(1, 3, 6, 12)) NOT NULL,
	CONSTRAINT pk_Membre PRIMARY KEY (ID_membre),
	CONSTRAINT Tel_unique UNIQUE (Telephone),
	CONSTRAINT commence_comme_un_telephone CHECK (SUBSTR(Telephone,1,2) IN ('01','02','03','04','05','06','07')),
	CONSTRAINT pas_de_doublon UNIQUE (Nom,Prenom,Telephone)
);

create table EMPRUNTS
(
	ID_emprunt NUMBER(6) NOT NULL,
	ID_membre NUMBER(6) NOT NULL,
	Cree_le DATE DEFAULT SYSDATE, -- date du jour comme date par defaut
	CONSTRAINT ID_membre_Membre FOREIGN KEY(ID_membre) references Membre (ID_membre),
	CONSTRAINT pk_emprunt PRIMARY KEY (ID_emprunt)
);

create table DETAILS
(
	ID_emprunt NUMBER(6) NOT NULL,
	numero_livre_emprunt NUMBER(6) NOT NULL, -- TODO je sais pas comment l'appeler
	ISBN VARCHAR2(13) NOT NULL, -- Use last version of ISBN named GENCOD and composed by 13 char
	Numero_exemplaire NUMBER(2) NOT NULL,
    Date_retour DATE DEFAULT NULL,
	CONSTRAINT ID_emprunt_Emprunt FOREIGN KEY(ID_emprunt) references EMPRUNTS(ID_emprunt) ON DELETE CASCADE
);

create table GENRE
(
	Code VARCHAR2(3) NOT NULL,
	Libelle VARCHAR2(40) NOT NULL
);


-- QUESTION 7:
-- faire une fonction

-- QUESTION 9:
--CREATE SYNONYM ABONNES FOR MEMBRE; CASSE TOUT

-- Partie 2: Langage de Manipulation de Données
-- QUESTION 4:

SELECT * FROM OUVRAGE;
SELECT * FROM EXEMPLAIRE;
SELECT * FROM MEMBRE;
SELECT * FROM EMPRUNTS;
SELECT * FROM DETAILS;
SELECT * FROM GENRE;

-- QUESTION 5:
--  Allows to use Flashback command following next example:
-- SQL> DELETE FROM CITY_OFFICES WHERE OFFICE_NUMBER = 1;
-- 1 row deleted.
-- SQL> COMMIT;
-- Commit complete.
-- SQL> FLASHBACK TABLE CITY_OFFICES
--   2    TO TIMESTAMP (SYSTIMESTAMP - INTERVAL '05' minute);
-- FLASHBACK TABLE CITY_OFFICES

ALTER TABLE MEMBRE ENABLE ROW MOVEMENT;

ALTER TABLE DETAILS ENABLE ROW MOVEMENT;

-- QUESTION 6:NOT DONE Mettez à jour l’état de chaque fiche de location en le faisant passer à RE (rendue) si tous les ouvrages empruntés par le membre ont été restitués à la bibliothèque.

ALTER TABLE EMPRUNTS
ADD(
	Etat_Emprunt VARCHAR2(10) DEFAULT 'EC'
	CHECK( Etat_Emprunt IN ('EC', 'RE'))
);

-- Drop tables
/*
DROP TABLE OUVRAGE CASCADE CONSTRAINTS;
DROP TABLE EXEMPLAIRE CASCADE CONSTRAINTS;
DROP TABLE MEMBRE CASCADE CONSTRAINTS;
DROP TABLE EMPRUNTS CASCADE CONSTRAINTS;
DROP TABLE GENRE CASCADE CONSTRAINTS;
DROP TABLE DETAILS CASCADE CONSTRAINTS;
DROP SYNONYM ABONNES;
*/

/*EXECUTE SCRIPT

@langage_de_definition_de_donnees/script_creation.sql
@langage_de_definition_de_donnees/script_insertion_donnees.sql

*/
--
