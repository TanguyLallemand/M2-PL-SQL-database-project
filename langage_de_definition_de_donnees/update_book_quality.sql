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
   SELECT * FROM EXEMPLAIRE WHERE ISBN = current;
   champ_isbn EXEMPLAIRE.ISBN%TYPE;
   champ_num_ex EXEMPLAIRE.Numero_exemplaire%TYPE;

BEGIN

 OPEN liste_exemplaire;
 FOR LIGNE IN liste_exemplaire LOOP
   number_uses = utils.number_uses_book(liste_exemplaire.ISBN,liste_exemplaire.Numero_exemplaire);
   CASE
     WHEN number_uses<11 THEN UPDATE EXEMPLAIRE SET Etat = ''NEUF'' WHERE ISBN = liste_exemplaire.ISBN, Numero_exemplaire = liste_exemplaire.Numero_exemplaire;
     WHEN number_uses>11 AND number_uses<25 THEN UPDATE EXEMPLAIRE SET Etat = ''BON'' WHERE ISBN = liste_exemplaire.ISBN, Numero_exemplaire = liste_exemplaire.Numero_exemplaire;
     WHEN number_uses>25 AND number_uses<60 THEN UPDATE EXEMPLAIRE SET Etat = ''MOYEN'' WHERE ISBN = liste_exemplaire.ISBN, Numero_exemplaire = liste_exemplaire.Numero_exemplaire;
     WHEN number_uses>60 THEN DELETE EXEMPLAIRE WHERE ISBN = liste_exemplaire.ISBN, Numero_exemplaire = liste_exemplaire.Numero_exemplaire;
     ELSE ''12''
 END as liste_exemplaire
 FROM OUVRAGE;
 END LOOP;
 CLOSE liste_exemplaire;
 END;
/
/*
BEGIN
OPEN liste_exemplaire;
FOR LIGNE IN liste_exemplaire LOOP
  number_uses = utils.number_uses_book(liste_exemplaire.ISBN,liste_exemplaire.Numero_exemplaire);
  CASE
    WHEN number_uses<11 THEN UPDATE EXEMPLAIRE SET Etat = 'NEUF' WHERE ISBN = liste_exemplaire.ISBN, Numero_exemplaire = liste_exemplaire.Numero_exemplaire;
    WHEN number_uses>11 AND number_uses<25 THEN UPDATE EXEMPLAIRE SET Etat = 'BON' WHERE ISBN = liste_exemplaire.ISBN, Numero_exemplaire = liste_exemplaire.Numero_exemplaire;
    WHEN number_uses>25 AND number_uses<60 THEN UPDATE EXEMPLAIRE SET Etat = 'MOYEN' WHERE ISBN = liste_exemplaire.ISBN, Numero_exemplaire = liste_exemplaire.Numero_exemplaire;
    WHEN number_uses>60 THEN DELETE EXEMPLAIRE WHERE ISBN = liste_exemplaire.ISBN, Numero_exemplaire = liste_exemplaire.Numero_exemplaire;
    ELSE '12'
END as liste_exemplaire
FROM OUVRAGE;
END LOOP;
CLOSE liste_exemplaire;
END;*/
