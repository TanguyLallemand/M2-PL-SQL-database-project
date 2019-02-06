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
