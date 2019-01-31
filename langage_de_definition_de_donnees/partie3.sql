-- III - 1
SELECT Isbn, Numero_exemplaire, Count(*),
Decode(Isbn,
2203314168, 'LEFRANC-Lultimatum',
2746021285, 'HTML – entraînez-vous pour maîtriser le code source',
2746026090, 'Oracle 10g SQL, PL/SQL, SQL*Plus',
2266085816, 'Pantagruel',
2266091611, 'Voyage au centre de la terre',
2253010219, 'Le crime de l’Orient Express',
2070400816, 'Le Bourgois gentilhomme',
2070397177, 'Le curé de Tours',
2080720872, 'Boule de suif',
2877065073, 'La gloire de mon père',
2020549522, 'L’aventure des manuscrits de la mer morte',
2253006327, 'Vingt mille lieues sous les mers',
2038704015, 'De la terre à la lune') Titre
FROM Details
GROUP BY ROLLUP (Isbn, Numero_exemplaire);
    -- TODO : Faire fonction qui va chercher les titre en fonction des ISBN (pas en dur quoi)

-- III - 2
SELECT Isbn, Numero_exemplaire, Max(Date_retour)
FROM Details
WHERE Add_months(Sysdate, -3) > Date_retour
GROUP BY ROLLUP (Isbn, Numero_exemplaire);

-- III - 3
SELECT Unique(Isbn)
FROM Exemplaire
WHERE Etat != 'neuf'
GROUP BY Isbn, Etat;

-- III - 4
SELECT Titre
FROM Ouvrage
WHERE Titre LIKE '%mer%';

-- III - 5
SELECT Auteur
FROM Ouvrage
WHERE Auteur LIKE '% de %';

-- III - 6
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
SELECT *
FROM User_tab_comments;

-- III - 9 -- TODO : pas compris

-- III - 10
DROP TABLE Details CASCADE CONSTRAINTS;

-- III - 11 -- TODO : marche en live oracle mais a tester à la fac
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
