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
