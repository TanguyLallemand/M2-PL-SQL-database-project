-- III - 1 Nombre d’emprunts par ouvrage et par exemplaire
-- III - 1
SELECT Isbn,
Decode(Grouping(Numero_exemplaire),1,'Total',Numero_exemplaire) AS Numero_exemplaire,
Count(*) AS Nombre
FROM Details
GROUP BY ROLLUP (Isbn, Numero_exemplaire);

-- III - 2
-- la liste des exemplaires qui n’ont jamais été empruntés au cours des trois
-- derniers mois. Pour effectuer les calculs sur les trois derniers mois, c’est
--la date de retour de l’exemplaire qui est prise en compte.
SELECT Isbn, Numero_exemplaire, Max(Date_retour)
FROM Details
WHERE Add_months(Sysdate, -3) > Date_retour
GROUP BY ROLLUP (Isbn, Numero_exemplaire);

-- III - 3
-- la liste des ouvrages pour lesquels il n’existe pas d’exemplaires à l’état
-- neuf.
SELECT Unique(Isbn)
FROM Exemplaire
WHERE Etat != 'neuf'
GROUP BY Isbn, Etat;

-- III - 4
-- tous les titres qui contiennent le mot « mer » quelque soit sa place dans le
-- titre et la casse avec laquelle il est renseigné.
SELECT Titre
FROM Ouvrage
WHERE Titre LIKE '%mer%';

-- III - 5
-- une requête qui permet de connaître tous les auteurs dont le nom possède la
-- particule « de »
SELECT Auteur
FROM Ouvrage
WHERE Auteur LIKE '% de %';

-- III - 6
-- A partir des genres des livres, affichez le public de chaque ouvrage
SELECT Titre, Auteur, Genre,
    CASE
        WHEN Genre='BD' THEN 'Jeunesse'
        WHEN Genre='INF' THEN 'Professionnel'
        WHEN Genre='POL' THEN 'Adulte'
        WHEN Genre='REC' OR Genre ='ROM' OR Genre ='THE' THEN 'Tous'
        ELSE 'public inconnu'
    END AS Type_de_public
FROM Ouvrage;

-- III - 7
COMMENT ON TABLE Membre IS 'Descriptifs des membres. Possède le synonymes Abonnes';
COMMENT ON TABLE Genre IS 'Descriptifs des genres possibles des ouvrages';
COMMENT ON TABLE Ouvrage IS 'Descriptifs des ouvrages référencés par la bibliothèque';
COMMENT ON TABLE Exemplaire IS 'Définition précise des livres présents dans la bibliothèque';
COMMENT ON TABLE Emprunts IS 'Fiche d’emprunt de livres, toujours associée à un et un seul membre';
COMMENT ON TABLE Details IS 'Chaque ligne correspond à un livre emprunté';

-- III - 8
-- Interrogez les commentaires associés aux tables présentes
SELECT *
FROM User_tab_comments;

-- III - 9 -- Fais dans le script de création de la table membre

-- III - 10
-- Suppression de la table des détails
DROP TABLE Details CASCADE CONSTRAINTS;

-- III - 11 --
-- Annulez cette suppression de table
Flashback TABLE Details TO BEFORE DROP;
-- III - 13
SELECT Titre, Auteur,
    CASE
        WHEN Compte=0 THEN 'Aucun'
        WHEN Compte<2 THEN 'Peu'
        WHEN Compte<5 THEN 'Normal'
        ELSE 'Beaucoup'
    END AS Type_de_public
FROM Ouvrage O JOIN (SELECT Isbn, Count(*) AS Compte
                    FROM Exemplaire
                    GROUP BY Isbn) Sel
ON O.Isbn = Sel.Isbn;
