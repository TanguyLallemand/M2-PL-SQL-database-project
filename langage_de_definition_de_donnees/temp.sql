CREATE OR REPLACE TRIGGER sup_old AFTER UPDATE OF Etat ON EXEMPLAIRE FOR EACH ROW
WHEN (NEW.Etat = 'Mauvais')
BEGIN
  DELETE FROM EXEMPLAIRE WHERE :NEW.Etat = 'Mauvais';
END;
/
-- update EXEMPLAIRE SET Etat = 'Mauvais' WHERE ISBN = '2038704015';
-- @langage_de_definition_de_donnees/temp.sql;
