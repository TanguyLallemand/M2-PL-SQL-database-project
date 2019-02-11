CREATE OR replace VIEW ouvrage_emprunte_depuis_2_sem
AS select nom, prenom, titre, ouvrage.isbn, numero_exemplaire
from (Select ID_emprunt, isbn, numero_exemplaire
    from details
    where date_retour is null) livre_non_rendus,
    ouvrage,
    membre,
    emprunts
where ouvrage.isbn = livre_non_rendus.isbn and emprunts.ID_membre = membre.ID_membre and emprunts.ID_emprunt = livre_non_rendus.ID_emprunt;


CREATE OR REPLACE VIEW Nbr_ouvrage AS
SELECT E.Id_membre, Count(E.Id_emprunt) AS Nbr_emprunt
FROM Emprunts E, Details D
WHERE E.Id_emprunt = D.Id_emprunt AND D.Date_retour IS NULL
GROUP BY E.Id_membre;

CREATE OR REPLACE VIEW Nbr_ouvrage_par_genre AS
SELECT Genre, Count(*) AS Nbr_ouvrage
FROM Ouvrage
GROUP BY Genre;

CREATE OR REPLACE VIEW Nbr_emprunt AS
SELECT Isbn, Count(*) AS Nbr_emprunt_en_cours
FROM Details
GROUP BY Isbn;

CREATE OR REPLACE VIEW lister_ouvrages_et_exemplaires AS
SELECT O.Isbn, E.Numero_exemplaire
FROM Ouvrage O, Exemplaire E
WHERE O.Isbn = E.Isbn
ORDER BY O.Isbn;

CREATE OR REPLACE VIEW membre_ordre_alpha AS
SELECT *
FROM Membre
ORDER BY Nom, Prenom ASC;

CREATE OR REPLACE VIEW ouvrages_par_genre AS
SELECT O.Genre, O.Titre FROM Ouvrage O ORDER BY O.Genre, O.Titre;

CREATE OR REPLACE VIEW Temps_moyen_emprunt_membre AS
SELECT Nom, Prenom, M.Id_membre, Sum(Date_retour-Cree_le)/Count(*) AS Temps_moyen_emprunt
FROM Emprunts C, Details T, Membre M
WHERE C.Id_emprunt = T.Id_emprunt AND M.Id_membre = C.Id_membre
GROUP BY M.Id_membre, M.Nom, M.Prenom
ORDER BY Id_membre;
