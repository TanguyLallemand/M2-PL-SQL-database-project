-- II - 4
SELECT * FROM Ouvrage;
SELECT * FROM Exemplaire;
SELECT * FROM Membre;
SELECT * FROM Emprunts;
SELECT * FROM Details;
SELECT * FROM Genre;

-- II - 6
update emprunts
set Etat_emprunt = 'RE'
where Id_emprunt not in (select Id_emprunt
from details
where date_retour IS NULL);


-- II - 9
select titre from ouvrage;

-- II - 10
select ISBN, ID_membre
from details join (select ID_membre, ID_emprunt from emprunts
where Etat_emprunt = 'EC' and cree_le < sysdate-14) test
on details.ID_emprunt = test.ID_emprunt;

-- II - 11
select genre, count(*) as nbr_ouvrage
from ouvrage
group by genre

-- II - 12
SELECT nom, prenom, M.ID_membre, SUM(Date_retour-Cree_le)/COUNT(*) as temps_moyen_emprunt
FROM emprunts C, details T, membre M
WHERE C.ID_EMPRUNT = T.ID_EMPRUNT and M.ID_membre = C.ID_membre
group by M.ID_membre, M.nom, M.prenom
order by ID_membre

-- II - 13
select genre, SUM(Date_retour-Cree_le)/COUNT(*)
from emprunts, details, ouvrage
where emprunts.ID_EMPRUNT = details.ID_EMPRUNT and ouvrage.ISBN = details.ISBN
group by ouvrage.genre;

-- II - 14
SELECT COUNT(ID_EMPRUNT) AS nbr_pret, ID_EMPRUNT FROM details
WHERE ROUND(MONTHS_BETWEEN(SYSDATE,date_retour))<='12'
GROUP BY ID_EMPRUNT
HAVING COUNT(ID_EMPRUNT) > 1
ORDER BY ID_EMPRUNT;
-- en cours
select details.isbn, ouvrage.titre
from details, ouvrage
WHERE ROUND(MONTHS_BETWEEN(SYSDATE,details.date_retour))<='12' and ouvrage.isbn = details.isbn
group by details.isbn
HAVING COUNT(*) > 4

-- II - 15
SELECT O.ISBN, E.Numero_exemplaire
FROM ouvrage O, exemplaire E
WHERE O.ISBN = E.ISBN
ORDER BY O.ISBN;
-- fait plus ou moins le job, on pourrait essayer d'avoir les numeros d'exemplaire dans la même case.

-- II - 16
CREATE OR REPLACE VIEW nbr_ouvrage AS
SELECT E.ID_membre, count(E.ID_emprunt) as nbr_emprunt
FROM emprunts E, details D
WHERE E.ID_emprunt = D.ID_emprunt AND D.Date_retour is NULL
GROUP BY E.ID_membre;

-- II - 17
CREATE or replace view nbr_emprunt as
select ISBN, count(*) as nbr_emprunt_en_cours
from details
group by ISBN;

-- II - 18
select *
from membre
order by nom, prenom asc;

-- II - 19

-- II - 20
select Libelle
from genre;
--TODO
