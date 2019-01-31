-- III - 1
SELECT ISBN, Numero_exemplaire, count(*),
DECODE(ISBN,
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
2038704015, 'De la terre à la lune') TITRE
FROM details
GROUP BY rollup (ISBN, Numero_exemplaire);
    -- TODO : Faire fonction qui va chercher les titre en fonction des ISBN (pas en dur quoi)

-- III - 2
SELECT ISBN, Numero_exemplaire, max(date_retour)
FROM details
WHERE ADD_MONTHS(sysdate, -3) > date_retour
GROUP BY rollup (ISBN, Numero_exemplaire);

-- III - 3
SELECT unique(ISBN)
FROM EXEMPLAIRE
WHERE etat != 'neuf'
GROUP BY ISBN, etat;

-- III - 4
SELECT Titre
FROM OUVRAGE
WHERE Titre LIKE '%mer%';

-- III - 5
SELECT Auteur
FROM OUVRAGE
WHERE Auteur LIKE '% de %';

-- III - 6
SELECT Titre, Auteur, Genre,
    CASE
        WHEN Genre='BD' THEN 'Jeunesse'
        WHEN Genre='INF' THEN 'Professionnel'
        WHEN Genre='POL' THEN 'Adulte'
        WHEN Genre='REC' OR Genre ='ROM' OR Genre ='THE' THEN 'Tous'
        ELSE 'public inconnu'
    END as type_de_public
FROM OUVRAGE;

-- III - 7
COMMENT ON TABLE Membre IS 'Descriptifs des membres. Possède le synonymes Abonnes';
COMMENT ON TABLE Genre IS 'Descriptifs des genres possibles des ouvrages';
COMMENT ON TABLE Ouvrage IS 'Descriptifs des ouvrages référencés par la bibliothèque';
COMMENT ON TABLE Exemplaire IS 'Définition précise des livres présents dans la bibliothèque';
COMMENT ON TABLE Emprunts IS 'Fiche d’emprunt de livres, toujours associée à un et un seul membre';
COMMENT ON TABLE Details IS 'Chaque ligne correspond à un livre emprunté';

-- III - 8
SELECT *
FROM user_tab_comments;

-- III - 9 -- TODO : pas compris

-- III - 10
DROP TABLE DETAILS CASCADE CONSTRAINTS;

-- III - 11 -- TODO : marche en live oracle mais a tester à la fac
FLASHBACK TABLE DETAILS TO BEFORE DROP;
-- III - 13
SELECT Titre, Auteur,
    CASE
        WHEN compte=0 THEN 'Aucun'
        WHEN compte<2 THEN 'Peu'
        WHEN compte<5 THEN 'Normal'
        ELSE 'Beaucoup'
    END as type_de_public
FROM ouvrage o join (select ISBN, count(*) as compte
                    from exemplaire
                    group by ISBN) sel
on o.ISBN = sel.ISBN;
