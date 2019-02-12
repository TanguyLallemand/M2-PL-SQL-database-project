-- III - 1 Nombre d’emprunts par ouvrage et par exemplaire
-- pas utilisable car on a un truc mieux après TODO verifier
SELECT Isbn,
Decode(Grouping(Numero_exemplaire),1,'Total',Numero_exemplaire) AS Numero_exemplaire,
Count(*) AS Nombre
FROM Details
GROUP BY ROLLUP (Isbn, Numero_exemplaire);

-- III - 2 views.sql
-- la liste des exemplaires qui n’ont jamais été empruntés au cours des trois
-- derniers mois. Pour effectuer les calculs sur les trois derniers mois, c’est
--la date de retour de l’exemplaire qui est prise en compte.
SELECT Isbn, Numero_exemplaire, Max(Date_retour)
FROM Details
WHERE Add_months(Sysdate, -3) > Date_retour
GROUP BY ROLLUP (Isbn, Numero_exemplaire);

-- III - 3 views.sql
-- la liste des ouvrages pour lesquels il n’existe pas d’exemplaires à l’état
-- neuf.
select *
from ouvrage
where ISBN not in (SELECT Isbn
                FROM Exemplaire
                where Etat='Neuf');

-- III - 4 TODO pas utile?
-- tous les titres qui contiennent le mot « mer » quelque soit sa place dans le
-- titre et la casse avec laquelle il est renseigné.
SELECT Titre
FROM Ouvrage
WHERE Titre LIKE '%mer%';

-- III - 5 TODO pas utile?
-- une requête qui permet de connaître tous les auteurs dont le nom possède la
-- particule « de »
SELECT Auteur
FROM Ouvrage
WHERE Auteur LIKE '% de %';

-- III - 6 views.sql
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

-- III - 7 comment ajoutés sous la déclaration de chaque table
COMMENT ON TABLE Membre IS 'Descriptifs des membres. Possède le synonymes Abonnes';
COMMENT ON TABLE Genre IS 'Descriptifs des genres possibles des ouvrages';
COMMENT ON TABLE Ouvrage IS 'Descriptifs des ouvrages référencés par la bibliothèque';
COMMENT ON TABLE Exemplaire IS 'Définition précise des livres présents dans la bibliothèque';
COMMENT ON TABLE Emprunts IS 'Fiche d’emprunt de livres, toujours associée à un et un seul membre';
COMMENT ON TABLE Details IS 'Chaque ligne correspond à un livre emprunté';

-- III - 8  TODO useless?
-- Interrogez les commentaires associés aux tables présentes
SELECT *
FROM User_tab_comments;

-- III - 9 -- Fais dans le script de création de la table membre TODO c'est vrai ça?

-- III - 10 TODO useless?
-- Suppression de la table des détails
DROP TABLE Details CASCADE CONSTRAINTS;

-- III - 11 TODO useless?
-- Annulez cette suppression de table
Flashback TABLE Details TO BEFORE DROP;

-- III - 13 views.sql
SELECT Titre, Auteur,
    CASE
        WHEN Compte=0 THEN 'Aucun'
        WHEN Compte<2 THEN 'Peu'
        WHEN Compte<5 THEN 'Normal'
        ELSE 'Beaucoup'
    END AS disponible
FROM Ouvrage O JOIN (SELECT Isbn, Count(*) AS Compte
                    FROM Exemplaire
                    GROUP BY Isbn) Sel
ON O.Isbn = Sel.Isbn;
