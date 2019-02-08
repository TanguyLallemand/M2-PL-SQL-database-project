-- Projet de gestion de base de données
-- Fresnais Louison, Courtin François, Lallemand Tanguy, Cruard Jonathan

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

-- Table référençant les différents exemplaires de chaque ouvrage
CREATE TABLE Exemplaire
(
	Isbn Varchar2(13) NOT NULL,
	Numero_exemplaire Number(2) NOT NULL,
	Etat Varchar2(8) DEFAULT 'Neuf'
	CONSTRAINT constraint_check_etat Check( Etat IN('Mauvais', 'Douteux', 'Moyen', 'Bon', 'Neuf')),
	CONSTRAINT Isbn_ouvrage FOREIGN Key(Isbn) REFERENCES Ouvrage (Isbn),
	CONSTRAINT Pk_exemplaire PRIMARY KEY (Numero_exemplaire,Isbn)
);

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
	CONSTRAINT Commence_comme_un_telephone CHECK (REGEXP_LIKE(Telephone, '^((01)|(02)|(03)|(04)|(05)|(06)|(07))(\d){8}?$')),
	CONSTRAINT Pas_de_doublon UNIQUE (Nom,Prenom,Telephone)
);
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
-- permet de restaurer la table
ALTER TABLE Details ENABLE ROW Movement;

-- noms complets des genre auquels appartiennent les ouvrages
CREATE TABLE Genre
(
	Code Varchar2(3) NOT NULL,
	Libelle Varchar2(40) NOT NULL
);

-- efface automatiquement les exemplaire en mauvais état
CREATE OR REPLACE TRIGGER supprimer_exemplaire_en_mauvais_etat AFTER UPDATE ON EXEMPLAIRE
FOR EACH ROW
WHEN (new.Etat = 'Mauvais')

BEGIN
  DELETE FROM Exemplaire WHERE isbn = new.isbn and Numero_exemplaire = new.Numero_exemplaire;
END;
/