--update book's quality

--NEUF < 11
--11<BON<25
--25<MOYEN<60
-->60 MAUVAIS delete


/* WORK IN PROGRESS, NEED TO CREATE A PACKAGE APPARENTLY)*/
/*WORKING ON CASES*/

--CURSEUR
DECLARE
    -- curseur avec la liste des membres expirés
    CURSOR liste_exemplaire
        IS SELECT *
        FROM EXEMPLAIRE
        FOR UPDATE;
    champ_isbn EXEMPLAIRE.ISBN%TYPE;
    champ_num_ex EXEMPLAIRE.Numero_exemplaire%TYPE;
--TRIGGER
CREATE OR REPLACE TRIGGER book_update AFTER INSERT ON DETAILS
FOR EACH ROW;
     --OPTIONNAL: IF INSERTION IN DETAILS, ACTIVATE TRIGGER. HIGH RESSOURCE COST
     --BEFORE LOGOFF ON DATABASE --ACTIVATE TRIGGER WHEN THE USER LOGOFF TO LEAVE HIS WORK INSUFFICIENT PRIVILEGES AGAIN
BEGIN
    BEGIN
     OPEN liste_exemplaire;
     FOR LIGNE IN liste_exemplaire LOOP
       number_uses = utils.number_uses_book(LIGNE.champ_isbn,LIGNE.champ_num_ex);
       CASE
         WHEN number_uses<11 THEN UPDATE EXEMPLAIRE SET Etat = ''Neuf'' WHERE ISBN = LIGNE.champ_isbn AND Numero_exemplaire = LIGNE.champ_num_ex;
         WHEN number_uses>11 AND number_uses<25 THEN UPDATE EXEMPLAIRE SET Etat = ''Bon'' WHERE ISBN = LIGNE.champ_isbn AND Numero_exemplaire = LIGNE.champ_num_ex;
         WHEN number_uses>25 AND number_uses<60 THEN UPDATE EXEMPLAIRE SET Etat = ''Moyen'' WHERE ISBN = LIGNE.champ_isbn AND Numero_exemplaire = LIGNE.champ_num_ex;
         WHEN number_uses>60 THEN DELETE EXEMPLAIRE WHERE ISBN = LIGNE.champ_isbn AND Numero_exemplaire = LIGNE.champ_num_ex;
         ELSE ''12''
     END as liste_exemplaire
     FROM OUVRAGE;
     END LOOP;
     CLOSE liste_exemplaire;
 END;
/

INSERT INTO Details VALUES (20,3,'2203314168',1,DEFAULT);

/*@langage_de_definition_de_donnees/update_book_quality.sql;
*/
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
