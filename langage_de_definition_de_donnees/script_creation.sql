-- I) Langage de Définition de Données :
-- QUESTION 1:

CREATE TABLE OUVRAGE
(
	ISBN VARCHAR2(13) NOT NULL, -- Use last version of ISBN named GENCOD and composed by 13 char
	Titre VARCHAR2(100) NOT NULL,
    Genre VARCHAR2(20) NOT NULL,
	Auteur VARCHAR2(40), -- can be null because data are not always known
	Editeur VARCHAR2(40), -- can be null because data are not always known
	CONSTRAINT pk_Ouvrage PRIMARY KEY (ISBN)
);

create table EXEMPLAIRE
(
	ISBN VARCHAR2(13) NOT NULL,
	Numero NUMBER(2) NOT NULL,
	Etat VARCHAR2(8) CHECK( Etat IN('Mauvais', 'Moyen', 'Bon', 'Neuf'))  NOT NULL,
	CONSTRAINT ISBN_Ouvrage FOREIGN KEY(ISBN) REFERENCES OUVRAGE (ISBN),
	CONSTRAINT pk_Exemplaire PRIMARY KEY (Numero,ISBN)
);

create table MEMBRE
(
	ID_membre NUMBER(6) NOT NULL,
	Nom VARCHAR2(40) NOT NULL,
	Prenom VARCHAR2(40) NOT NULL,
	Adresse VARCHAR2(50) NOT NULL,
	Telephone VARCHAR2(10) NOT NULL,
	Date_adhesion DATE NOT NULL,
	Duree NUMBER(2) CHECK( Duree IN(1, 3, 6, 12)) NOT NULL,
	CONSTRAINT pk_Membre PRIMARY KEY (ID_membre),
	CONSTRAINT Tel_unique UNIQUE (Telephone)
);

create table EMPRUNTS
(
	ID_emprunt NUMBER(6) NOT NULL,
	ID_membre NUMBER(6) NOT NULL,
	Cree_le DATE NOT NULL,
	CONSTRAINT ID_membre_Membre FOREIGN KEY(ID_membre) references Membre (ID_membre),
	CONSTRAINT pk_emprunt PRIMARY KEY (ID_emprunt)
);

-- QUESTION 2:

CREATE SEQUENCE uniq_ID_membre
MINVALUE 1
START WITH 1
INCREMENT BY 1
NOCACHE; -- NOCACHE  Specify NOCACHE to indicate that values of the sequence are not preallocated. If you omit both CACHE and NOCACHE, the database caches 20 sequence numbers by default.

-- QUESTION 3:

ALTER TABLE MEMBRE
ADD CONSTRAINT
pas_de_doublon
UNIQUE (Nom,Prenom,Telephone);

-- QUESTION 4:

ALTER TABLE MEMBRE
ADD(Mobile VARCHAR2(10)
CONSTRAINT commence_comme_un_portable
CHECK (SUBSTR(Mobile,1,2) = '06'));

-- QUESTION 5:

-- Execute the request after office hours.
DELETE Telephone
FROM MEMBRE
WHERE((EXTRACT(HOUR FROM CAST(sysdate AS TIMESTAMP))<8) &&(EXTRACT(HOUR FROM CAST(sysdate AS TIMESTAMP))>20);

-- Drop tables

DROP TABLE OUVRAGE CASCADE CONSTRAINTS;
DROP TABLE EXEMPLAIRE CASCADE CONSTRAINTS;
DROP TABLE MEMBRE CASCADE CONSTRAINTS;
DROP TABLE EMPRUNTS CASCADE CONSTRAINTS;

--
