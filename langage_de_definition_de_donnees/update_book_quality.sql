--update book's quality

--NEUF < 11
--11<BON<25
--25<MOYEN<60
-->60 MAUVAIS delete


/* WORK IN PROGRESS, NEED TO CREATE A PACKAGE APPARENTLY)*/
/*WORKING ON CASES*/

--CURSEUR
DECLARE
  CURSOR liste_exemplaire IS
   SELECT * FROM EXEMPLAIRE;
   champ_isbn EXEMPLAIRE.ISBN%TYPE;
   champ_num_ex EXEMPLAIRE.Numero_exemplaire%TYPE;
BEGIN

END;

--TRIGGER
DECLARE
  number_uses = NUMBER
CREATE TRIGGER update_quality
AFTER UPDATE ON EXEMPLAIRE OF Etat

BEGIN
OPEN liste_exemplaire;
FOR LIGNE IN liste_exemplaire LOOP
  number_uses = utils.number_uses_book(liste_exemplaire.ISBN,liste_exemplaire.Numero_exemplaire);
  CASE
    WHEN number_uses<11 THEN UPDATE EXEMPLAIRE SET Etat = 'NEUF' WHERE ISBN = liste_exemplaire.ISBN, Numero_exemplaire = liste_exemplaire.Numero_exemplaire;
    WHEN number_uses>11 AND number_uses<25 THEN UPDATE EXEMPLAIRE SET Etat = 'BON' WHERE ISBN = liste_exemplaire.ISBN, Numero_exemplaire = liste_exemplaire.Numero_exemplaire;
    WHEN number_uses>25 AND number_uses<60 THEN UPDATE EXEMPLAIRE SET Etat = 'MOYEN' WHERE ISBN = liste_exemplaire.ISBN, Numero_exemplaire = liste_exemplaire.Numero_exemplaire;
    ELSE 'public inconnu'
END as type_de_public
FROM OUVRAGE;
END LOOP;
CLOSE liste_exemplaire;
END;

SELECT *
FROM EXEMPLAIRE
WHERE ISBN = book_ISBN, Numero_exemplaire = number_exemp;

BEGIN
  IF
END;
/
