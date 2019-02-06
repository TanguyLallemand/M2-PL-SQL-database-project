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
where date_retour IS NULL)


-- II - 9
select titre from ouvrage;

-- II - 10
select ISBN, ID_membre
from details join (select ID_membre, ID_emprunt from emprunts
where Etat_emprunt = 'EC' and cree_le < sysdate-14) test
on details.ID_emprunt = test.ID_emprunt