-- Projet de gestion de base de données
-- Fresnais Louison, Courtin François, Lallemand Tanguy, Cruard Jonathan

--Augmente le buffer afin de permettre les dbms_output
SET Serveroutput ON SIZE 30000;

--------------------------------------------------------------------------------
-- Création de séquences
--------------------------------------------------------------------------------

-- sequence utilisé pour donner un ID unique à chaque membre lors de l'inscription
CREATE SEQUENCE Uniq_id_membre
MINVALUE 0
START WITH 0
INCREMENT BY 1
CACHE 100;

-- sequence utilisé pour donner un ID unique à chaque emprunt lors de sa création
CREATE SEQUENCE Uniq_id_emprunt
MINVALUE 0
START WITH 0
INCREMENT BY 1
CACHE 100;

--------------------------------------------------------------------------------
-- Création des tables
--------------------------------------------------------------------------------

-- Table référençant l'ensemble des ouvrage de la bibliothèque
CREATE TABLE Ouvrage
(
	Isbn Varchar2(13) NOT NULL, -- Use last version of ISBN named GENCOD and composed by 13 char
	Titre Varchar2(100) NOT NULL,
	Auteur Varchar2(40), -- can be null because data are not always known
  	Genre Varchar2(20) NOT NULL,
	Editeur Varchar2(40), -- can be null because data are not always known
	CONSTRAINT Pk_ouvrage PRIMARY KEY (Isbn)
);
COMMENT ON TABLE Ouvrage IS 'Descriptifs des ouvrages référencés par la bibliothèque';

-- Table référençant les différents exemplaires de chaque ouvrage
CREATE TABLE Exemplaire
(
	Isbn Varchar2(13) NOT NULL,
	Numero_exemplaire Number(2) NOT NULL,
	Etat Varchar2(2) DEFAULT 'Neuf'
	CONSTRAINT Constraint_check_etat Check( Etat IN('MA', 'DO', 'MO', 'BO', 'NE')),
	CONSTRAINT Isbn_ouvrage FOREIGN Key(Isbn) REFERENCES Ouvrage (Isbn),
	CONSTRAINT Pk_exemplaire PRIMARY KEY (Numero_exemplaire,Isbn)
);
COMMENT ON TABLE Exemplaire IS 'Définition précise des livres présents dans la bibliothèque';

-- Table stockant les informations sur les membres ou "Abonnes" de la bibliothèque
CREATE TABLE Membre
(
	Id_membre Number(6) NOT NULL,
	Nom Varchar2(40) NOT NULL,
	Prenom Varchar2(40) NOT NULL,
	Adresse Varchar2(50) NOT NULL,
	Telephone Varchar2(10) NOT NULL,
	Date_adhesion DATE DEFAULT Sysdate NOT NULL ,
	Duree Number(2) Check(Duree IN(1, 3, 6, 12)) NOT NULL,
	CONSTRAINT Pk_membre PRIMARY KEY (Id_membre),
	CONSTRAINT Tel_unique UNIQUE (Telephone),
	CONSTRAINT Commence_comme_un_telephone CHECK (Regexp_like(Telephone, '^((01)|(02)|(03)|(04)|(05)|(06)|(07))(\d){8}?$')),
	CONSTRAINT Pas_de_doublon UNIQUE (Nom,Prenom,Telephone)
);
COMMENT ON TABLE Membre IS 'Descriptifs des membres. Possède le synonymes Abonnes';
-- permet de restaurer la table
ALTER TABLE Membre ENABLE ROW Movement;

-- Stocke les informations des emprunts, le membre qui l'a fait et à quelle date
CREATE TABLE Emprunts
(
	Id_emprunt Number(6) NOT NULL,
	Id_membre Number(6),
	Cree_le DATE DEFAULT Sysdate NOT NULL, -- date du jour comme date par defaut
	Etat_emprunt Varchar2(2) DEFAULT 'EC' Check( Etat_emprunt IN ('EC', 'RE')),
	CONSTRAINT Id_membre_membre FOREIGN Key(Id_membre) REFERENCES Membre (Id_membre),
	CONSTRAINT Pk_emprunt PRIMARY KEY (Id_emprunt)
);
COMMENT ON TABLE Emprunts IS 'Fiche d’emprunt de livres, toujours associée à un et un seul membre';

-- stocke les détails des emprunts quels livres ont été empruntés et quand ils ont été rendus
CREATE TABLE Details
(
	Id_emprunt Number(6) NOT NULL,
	Numero_livre_emprunt Number(6) NOT NULL,
	Isbn Varchar2(13) NOT NULL,
	Numero_exemplaire Number(10) NOT NULL,
    Date_retour DATE DEFAULT NULL,
	CONSTRAINT Id_emprunt_emprunt FOREIGN Key(Id_emprunt) REFERENCES Emprunts(Id_emprunt) ON DELETE CASCADE
);
COMMENT ON TABLE Details IS 'Chaque ligne correspond à un livre emprunté';
-- permet de restaurer la table
ALTER TABLE Details ENABLE ROW Movement;

-- noms complets des genre auquels appartiennent les ouvrages
CREATE TABLE Genre
(
	Code Varchar2(3) NOT NULL,
	Libelle Varchar2(40) NOT NULL
);
COMMENT ON TABLE Genre IS 'Descriptifs des genres possibles des ouvrages';

--------------------------------------------------------------------------------
-- Appel des scripts du projet
--------------------------------------------------------------------------------
@partie2_insertion.Sql
@package_infos.Sql
@package_livre.Sql
@package_maintenance.Sql
@triggers.Sql
@views.Sql

BEGIN
	Maintenance.Maj_etat_emprunt;
	Maintenance.Purge_membre;
END;
/
