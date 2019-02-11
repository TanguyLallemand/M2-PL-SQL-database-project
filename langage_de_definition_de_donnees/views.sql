-- affiche les membres qui ont emprunté un ouvrage depuis 2 semaine et le titre
CREATE OR replace VIEW ouvrage_emprunte_depuis_2_sem
AS select nom, prenom, titre, ouvrage.isbn, numero_exemplaire
from (Select ID_emprunt, isbn, numero_exemplaire
    from details
    where date_retour is null) livre_non_rendus,
    ouvrage,
    membre,
    emprunts
where ouvrage.isbn = livre_non_rendus.isbn and emprunts.ID_membre = membre.ID_membre and emprunts.ID_emprunt = livre_non_rendus.ID_emprunt;

-- affiche la liste des membres et le nombres de livres qu'ils ont actuellement empruntés
CREATE OR REPLACE VIEW Nbr_ouvrage AS
SELECT E.Id_membre, Count(E.Id_emprunt) AS Nbr_emprunt
FROM Emprunts E, Details D
WHERE E.Id_emprunt = D.Id_emprunt AND D.Date_retour IS NULL
GROUP BY E.Id_membre;

-- liste les genres et le nombre d'ouvrage qui y appartiennent
CREATE OR REPLACE VIEW Nbr_ouvrage_par_genre AS
SELECT Genre, Count(*) AS Nbr_ouvrage
FROM Ouvrage
GROUP BY Genre;

-- liste les ouvrages et leurs nombre d'emprunts
CREATE OR REPLACE VIEW Nbr_emprunt AS
SELECT Isbn, Count(*) AS Nbr_emprunts
FROM Details
GROUP BY Isbn;

-- liste les ouvrages et les numeros d'exemplaires disponibles
CREATE OR REPLACE VIEW lister_ouvrages_et_exemplaires AS
SELECT O.Isbn, E.Numero_exemplaire
FROM Ouvrage O, Exemplaire E
WHERE O.Isbn = E.Isbn
ORDER BY O.Isbn;

-- affiche les membres en les triants par ordre alphabétique
CREATE OR REPLACE VIEW membre_ordre_alpha AS
SELECT *
FROM Membre
ORDER BY Nom, Prenom ASC;

-- liste les ouvrage par genre
CREATE OR REPLACE VIEW ouvrages_par_genre AS
SELECT O.Genre, O.Titre
FROM Ouvrage O
ORDER BY O.Genre, O.Titre;

-- affiche le nom de chaque membre et le temps moyen des emprunts qu'il réalise
CREATE OR REPLACE VIEW Temps_moyen_emprunt_membre AS
SELECT Nom, Prenom, M.Id_membre, Sum(Date_retour-Cree_le)/Count(*) AS Temps_moyen_emprunt
FROM Emprunts C, Details T, Membre M
WHERE C.Id_emprunt = T.Id_emprunt AND M.Id_membre = C.Id_membre
GROUP BY M.Id_membre, M.Nom, M.Prenom
ORDER BY Id_membre;

-- affiche le temps moyen des emprunts en fonction du genre
CREATE OR REPLACE VIEW Temps_moyen_emprunt_genre AS
SELECT Genre, Sum(Date_retour-Cree_le)/Count(*)
FROM Emprunts, Details, Ouvrage
WHERE Emprunts.Id_emprunt = Details.Id_emprunt AND Ouvrage.Isbn = Details.Isbn
GROUP BY Ouvrage.Genre;

-- affiche la liste des titres d'ouvrage
CREATE OR REPLACE VIEW liste_des_ouvrages AS
SELECT Titre FROM Ouvrage;

-- affiche les ouvrages empruntés plus de 10 fois sur les 12 derniers mois
CREATE OR REPLACE VIEW ouvrage_les_plus_populaire_12mois AS
SELECT Details.Isbn, Ouvrage.Titre, Count(*) Nombre_emprunts
FROM Details, Ouvrage
WHERE Round(Months_between(Sysdate,Details.Date_retour))<='12' AND Ouvrage.Isbn = Details.Isbn
GROUP BY Details.Isbn, Ouvrage.Titre
HAVING Count(*) > 10
ORDER BY Nombre_emprunts;

-- affiche la liste des ouvrages qui n'ont pas étés empruntés depuis 3 mois
CREATE OR REPLACE VIEW ouvrage_les_moins_populaire_3mois AS
SELECT Isbn, Numero_exemplaire, Max(Date_retour)
FROM Details
WHERE Add_months(Sysdate, -3) > Date_retour
GROUP BY ROLLUP (Isbn, Numero_exemplaire);

-- affiche les ouvrages dont aucun exemplaire neuf n'est disponible
CREATE OR REPLACE VIEW ouvrage_sans_neuf AS
select *
from ouvrage
where ISBN not in (SELECT Isbn
                FROM Exemplaire
                where Etat='Neuf');

-- affiche le public visé par chaque ouvrage
CREATE OR REPLACE VIEW ouvrage_avec_public AS
SELECT Titre, Auteur, Genre,
    CASE
        WHEN Genre='BD' THEN 'Jeunesse'
        WHEN Genre='INF' THEN 'Professionnel'
        WHEN Genre='POL' THEN 'Adulte'
        WHEN Genre='REC' OR Genre ='ROM' OR Genre ='THE' THEN 'Tous'
        ELSE 'public inconnu'
    END AS Type_de_public
FROM Ouvrage;
