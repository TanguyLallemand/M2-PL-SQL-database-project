-- II - 4
SELECT * FROM Ouvrage;
SELECT * FROM Exemplaire;
SELECT * FROM Membre;
SELECT * FROM Emprunts;
SELECT * FROM Details;
SELECT * FROM Genre;

-- II - 6
UPDATE Emprunts
SET Etat_emprunt = 'RE'
WHERE Id_emprunt NOT IN (SELECT Id_emprunt
FROM Details
WHERE Date_retour IS NULL);

-- II - 8

DELETE FROM Exemplaire where Etat='MA';

-- II - 9
SELECT Titre FROM Ouvrage;

-- II - 10
SELECT Isbn, Id_membre
FROM Details JOIN (SELECT Id_membre, Id_emprunt FROM Emprunts
WHERE Etat_emprunt = 'EC' AND Cree_le < Sysdate-14) Test
ON Details.Id_emprunt = Test.Id_emprunt;

-- II - 11
SELECT Genre, Count(*) AS Nbr_ouvrage
FROM Ouvrage
GROUP BY Genre

-- II - 12
SELECT Nom, Prenom, M.Id_membre, Sum(Date_retour-Cree_le)/Count(*) AS Temps_moyen_emprunt
FROM Emprunts C, Details T, Membre M
WHERE C.Id_emprunt = T.Id_emprunt AND M.Id_membre = C.Id_membre
GROUP BY M.Id_membre, M.Nom, M.Prenom
ORDER BY Id_membre

-- II - 13
SELECT Genre, Sum(Date_retour-Cree_le)/Count(*)
FROM Emprunts, Details, Ouvrage
WHERE Emprunts.Id_emprunt = Details.Id_emprunt AND Ouvrage.Isbn = Details.Isbn
GROUP BY Ouvrage.Genre;

-- II - 14
SELECT Count(Id_emprunt) AS Nbr_pret, Id_emprunt FROM Details
WHERE Round(Months_between(Sysdate,Date_retour))<='12'
GROUP BY Id_emprunt
HAVING Count(Id_emprunt) > 1
ORDER BY Id_emprunt;
-- en cours
SELECT Details.Isbn, Ouvrage.Titre
FROM Details, Ouvrage
WHERE Round(Months_between(Sysdate,Details.Date_retour))<='12' AND Ouvrage.Isbn = Details.Isbn
GROUP BY Details.Isbn
HAVING Count(*) > 4

-- II - 15
SELECT O.Isbn, E.Numero_exemplaire
FROM Ouvrage O, Exemplaire E
WHERE O.Isbn = E.Isbn
ORDER BY O.Isbn;
-- fait plus ou moins le job, on pourrait essayer d'avoir les numeros d'exemplaire dans la même case.

-- II - 16
CREATE OR REPLACE VIEW Nbr_ouvrage AS
SELECT E.Id_membre, Count(E.Id_emprunt) AS Nbr_emprunt
FROM Emprunts E, Details D
WHERE E.Id_emprunt = D.Id_emprunt AND D.Date_retour IS NULL
GROUP BY E.Id_membre;

-- II - 17
CREATE OR REPLACE VIEW Nbr_emprunt AS
SELECT Isbn, Count(*) AS Nbr_emprunt_en_cours
FROM Details
GROUP BY Isbn;

-- II - 18
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

-- II - 20
SELECT * FROM Genre;
SELECT O.Genre, O.Titre FROM Ouvrage O ORDER BY O.Genre, O.Titre;

--Ca reponds à la question en vrai !
