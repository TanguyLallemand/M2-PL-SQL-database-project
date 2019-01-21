-- I) Langage de Définition de Données :
-- QUESTION 1:

CREATE TABLE OUVRAGE
(
	ISBN VARCHAR2(13) NOT NULL, -- Use last version of ISBN named GENCOD and composed by 13 char
	Titre VARCHAR2(100) NOT NULL,
    Genre VARCHAR2(10) NOT NULL,
	Auteur VARCHAR2(20), -- can be null because not always known
	Editeur VARCHAR2(20), -- can be null because not always known
	CONSTRAINT Genre_Libelle FOREIGN KEY(Genre) REFERENCES Libelle_genre(Genre),
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
	ID NUMBER(6),
	Nom VARCHAR2(20) NOT NULL,
	Prenom VARCHAR2(20) NOT NULL,
	Adresse VARCHAR2(30) NOT NULL,
	Telephone VARCHAR2(10),
	Date_adhesion DATE NOT NULL,
	Duree NUMBER(2) CHECK( Duree IN(1, 3, 6, 12)) NOT NULL,
	CONSTRAINT pk_Membre PRIMARY KEY (ID),
	CONSTRAINT Tel_unique UNIQUE (Telephone)
);
