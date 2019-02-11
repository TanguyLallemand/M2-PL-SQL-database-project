-- II - 1
--CF partie 2

-- II - 2
--CF partie 2

-- II - 3
--CF partie 2

-- II - 4
-- pas utile dans le global
SELECT * FROM Ouvrage;
SELECT * FROM Exemplaire;
SELECT * FROM Membre;
SELECT * FROM Emprunts;
SELECT * FROM Details;
SELECT * FROM Genre;

-- II - 5
--CF partie 1

-- II - 6
-- colonne ajoutée
-- fonction MAJ_etat_emprunt du package Maintenance
UPDATE Emprunts
SET Etat_emprunt = 'RE'
WHERE Id_emprunt NOT IN (SELECT Id_emprunt
FROM Details
WHERE Date_retour IS NULL);

-- II - 7
--CF partie 4 question 6

-- II - 8
-- mis dans le TRIGGER supprimer_exemplaire_en_mauvais_etat
DELETE FROM Exemplaire WHERE Etat='Mauvais';

-- II - 9 function infos.lister_ouvrages TODO creer une vue serait pas mieux?
SELECT Titre FROM Ouvrage;

-- II - 10 view créé
select nom, prenom, titre, ouvrage.isbn, numero_exemplaire
from (Select ID_emprunt, isbn, numero_exemplaire
    from details
    where date_retour is not null) livre_non_rendus,
    ouvrage,
    membre,
    emprunts
where ouvrage.isbn = livre_non_rendus.isbn and emprunts.ID_membre = membre.ID_membre and emprunts.ID_emprunt = livre_non_rendus.ID_emprunt

-- II - 11
SELECT Genre, Count(*) AS Nbr_ouvrage
FROM Ouvrage
GROUP BY Genre;

-- II - 12 views.sql
SELECT Nom, Prenom, M.Id_membre, Sum(Date_retour-Cree_le)/Count(*) AS Temps_moyen_emprunt
FROM Emprunts C, Details T, Membre M
WHERE C.Id_emprunt = T.Id_emprunt AND M.Id_membre = C.Id_membre
GROUP BY M.Id_membre, M.Nom, M.Prenom
ORDER BY Id_membre;

-- II - 13
SELECT Genre, Sum(Date_retour-Cree_le)/Count(*)
FROM Emprunts, Details, Ouvrage
WHERE Emprunts.Id_emprunt = Details.Id_emprunt AND Ouvrage.Isbn = Details.Isbn
GROUP BY Ouvrage.Genre;

-- II - 14
SELECT Details.Isbn, Ouvrage.Titre, Count(*) Nombre_emprunts
FROM Details, Ouvrage
WHERE Round(Months_between(Sysdate,Details.Date_retour))<='12' AND Ouvrage.Isbn = Details.Isbn
GROUP BY Details.Isbn, Ouvrage.Titre
HAVING Count(*) > 10;

-- II - 15 views.sql
SELECT O.Isbn, E.Numero_exemplaire
FROM Ouvrage O, Exemplaire E
WHERE O.Isbn = E.Isbn
ORDER BY O.Isbn;

-- II - 16 views.sql
CREATE OR REPLACE VIEW Nbr_ouvrage AS
SELECT E.Id_membre, Count(E.Id_emprunt) AS Nbr_emprunt
FROM Emprunts E, Details D
WHERE E.Id_emprunt = D.Id_emprunt AND D.Date_retour IS NULL
GROUP BY E.Id_membre;

-- II - 17 views.sql
CREATE OR REPLACE VIEW Nbr_emprunt AS
SELECT Isbn, Count(*) AS Nbr_emprunt_en_cours
FROM Details
GROUP BY Isbn;

-- II - 18 views.sql
SELECT *
FROM Membre
ORDER BY Nom, Prenom ASC;

-- II - 19

CREATE GLOBAL TEMPORARY TABLE Emprunts_titre(
Isbn Char(13),
Exemplaire number,
Nbr_emprunts_exemplaire number,
Nbr_emprunts_ouvrage number)
ON COMMIT PRESERVE ROWS;

INSERT INTO Emprunts_titre(
Isbn, Exemplaire, Nbr_emprunts_exemplaire)
SELECT Isbn, Numero_exemplaire, Count(*)
FROM Details
GROUP BY Isbn, Numero_exemplaire;

DECLARE
CURSOR C_emprunts_ouvrage IS
SELECT Isbn,Sum(Emprunts_titre.Nbr_emprunts_exemplaire) Emprunts_ouvrage
FROM Emprunts_titre
GROUP BY Isbn;
Nbr_emprunts_cursor C_emprunts_ouvrage%Rowtype;

BEGIN
FOR Ligne IN C_emprunts_ouvrage
    LOOP
    UPDATE Emprunts_titre SET Nbr_emprunts_ouvrage=Ligne.Emprunts_ouvrage WHERE Emprunts_titre.Isbn=Ligne.Isbn;
    END LOOP;
END;
/

-- II - 20 views.sql
SELECT * FROM Genre;
SELECT O.Genre, O.Titre FROM Ouvrage O ORDER BY O.Genre, O.Titre;
