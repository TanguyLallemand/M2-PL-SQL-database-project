-- Partie VI Q2
CREATE OR REPLACE TRIGGER valid_emprunt BEFORE INSERT ON Emprunts
FOR EACH ROW

DECLARE
date_fin_mb DATE;

BEGIN
  SELECT add_months(Date_adhesion, Duree) INTO date_fin_mb FROM Membre
  WHERE Id_membre = :new.Id_membre;
  IF (date_fin_mb < Sysdate) THEN
    RAISE_APPLICATION_ERROR(-20001, 'Ce membre nest pas a jour dans ses cotisations');
  END IF;
END;
/


-- Partie VI Q3
CREATE OR REPLACE TRIGGER modif_mb_emprunt BEFORE UPDATE ON Emprunts
FOR EACH ROW
WHEN (new.Id_membre != old.Id_membre)

BEGIN
  RAISE_APPLICATION_ERROR(-20002, 'Impossible de modifier le membre d''un emprunt');
  END;
/

-- Partie VI Q4
CREATE OR REPLACE TRIGGER mod_ref_emprunt BEFORE UPDATE ON Details
FOR EACH ROW
WHEN ((new.Isbn != old.Isbn) OR (new.Numero_exemplaire != old.Numero_exemplaire))

BEGIN
  RAISE_APPLICATION_ERROR(-20003, 'Impossible de modifier la référence d''un ouvrage emprunté, il faut le rendre puis effectuer une nouvelle location.');
END;
/
