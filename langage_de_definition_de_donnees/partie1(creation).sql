-- lucidchart entité-association https://www.lucidchart.com/documents/edit/1efa825f-05fa-4494-a611-318297c0b8b5/0
-- I) Langage de Définition de Données :


CREATE SEQUENCE Uniq_id_membre
MINVALUE 0
START WITH 0
INCREMENT BY 1
CACHE 100;
-- NOCACHE  Specify NOCACHE to indicate that values of the sequence are not preallocated. If you omit both CACHE and NOCACHE, the database caches 20 sequence numbers by default.

CREATE SEQUENCE Uniq_id_emprunt
MINVALUE 0
START WITH 0
INCREMENT BY 1
CACHE 100;

CREATE TABLE Ouvrage
(
	Isbn Varchar2(13) NOT NULL, -- Use last version of ISBN named GENCOD and composed by 13 char
	Titre Varchar2(100) NOT NULL,
	Auteur Varchar2(40), -- can be null because data are not always known
  	Genre Varchar2(20) NOT NULL,
	Editeur Varchar2(40), -- can be null because data are not always known
	CONSTRAINT Pk_ouvrage PRIMARY KEY (Isbn)
);

CREATE TABLE Exemplaire
(
	Isbn Varchar2(13) NOT NULL,
	Numero_exemplaire Number(2) NOT NULL,
	Etat Varchar2(8) DEFAULT 'Neuf' Check( Etat IN('Mauvais', 'Moyen', 'Bon', 'Neuf')),
	CONSTRAINT Isbn_ouvrage FOREIGN Key(Isbn) REFERENCES Ouvrage (Isbn),
	CONSTRAINT Pk_exemplaire PRIMARY KEY (Numero_exemplaire,Isbn)
);

CREATE TABLE Membre
(
	Id_membre Number(6) NOT NULL,
	Nom Varchar2(40) NOT NULL,
	Prenom Varchar2(40) NOT NULL,
	Adresse Varchar2(50) NOT NULL,
	Telephone Varchar2(10) NOT NULL,
	Date_adhesion DATE NOT NULL,
	Duree Number(2) Check( Duree IN(1, 3, 6, 12)) NOT NULL,
	CONSTRAINT Pk_membre PRIMARY KEY (Id_membre),
	CONSTRAINT Tel_unique UNIQUE (Telephone),
	CONSTRAINT Commence_comme_un_telephone CHECK (Telephone LIKE ('^((01)|(02)|(03)|(04)|(05)|(06)|(07))[0-9]{8}$')),
	CONSTRAINT Pas_de_doublon UNIQUE (Nom,Prenom,Telephone)
);

CREATE TABLE Emprunts
(
	Id_emprunt Number(6) NOT NULL,
	Id_membre Number(6),
	Cree_le DATE DEFAULT Sysdate, -- date du jour comme date par defaut
	Etat_emprunt Varchar2(2) DEFAULT 'EC' Check( Etat_emprunt IN ('EC', 'RE')),
	CONSTRAINT Id_membre_membre FOREIGN Key(Id_membre) REFERENCES Membre (Id_membre),
	CONSTRAINT Pk_emprunt PRIMARY KEY (Id_emprunt)
);

CREATE TABLE Details
(
	Id_emprunt Number(6) NOT NULL,
	Numero_livre_emprunt Number(6) NOT NULL, -- TODO je sais pas comment l'appeler
	Isbn Varchar2(13) NOT NULL, -- Use last version of ISBN named GENCOD and composed by 13 char
	Numero_exemplaire Number(10) NOT NULL,
    Date_retour DATE DEFAULT NULL,
	CONSTRAINT Id_emprunt_emprunt FOREIGN Key(Id_emprunt) REFERENCES Emprunts(Id_emprunt) ON DELETE CASCADE
);

CREATE TABLE Genre
(
	Code Varchar2(3) NOT NULL,
	Libelle Varchar2(40) NOT NULL
);


-- QUESTION 7:
-- faire une fonction

-- QUESTION 9:
--CREATE SYNONYM ABONNES FOR MEMBRE; CASSE TOUT

-- Partie 2: Langage de Manipulation de Données
-- QUESTION 4:

SELECT * FROM Ouvrage;
SELECT * FROM Exemplaire;
SELECT * FROM Membre;
SELECT * FROM Emprunts;
SELECT * FROM Details;
SELECT * FROM Genre;

-- QUESTION 5:
--  Allows to use Flashback command following next example:
-- SQL> DELETE FROM CITY_OFFICES WHERE OFFICE_NUMBER = 1;
-- 1 row deleted.
-- SQL> COMMIT;
-- Commit complete.
-- SQL> FLASHBACK TABLE CITY_OFFICES
--   2    TO TIMESTAMP (SYSTIMESTAMP - INTERVAL '05' minute);
-- FLASHBACK TABLE CITY_OFFICES

ALTER TABLE Membre ENABLE ROW Movement;
ALTER TABLE Details ENABLE ROW Movement;

-- Drop tables

-- DROP TABLE OUVRAGE CASCADE CONSTRAINTS;
-- DROP TABLE EXEMPLAIRE CASCADE CONSTRAINTS;
-- DROP TABLE MEMBRE CASCADE CONSTRAINTS;
-- DROP TABLE EMPRUNTS CASCADE CONSTRAINTS;
-- DROP TABLE GENRE CASCADE CONSTRAINTS;
-- DROP TABLE DETAILS CASCADE CONSTRAINTS;
-- DROP SYNONYM ABONNES;


-- EXECUTE SCRIPT
--
-- @langage_de_definition_de_donnees/script_creation.sql;
-- @langage_de_definition_de_donnees/script_insertion_donnees.sql;
-- @langage_de_definition_de_donnees/script_drop.sql;

--
