--------------------------------------------------------------------------------
-- Création des triggers
--------------------------------------------------------------------------------

-- efface automatiquement les exemplaires en mauvais état

CREATE OR REPLACE TRIGGER supprimer_exemplr_mauvais AFTER UPDATE ON EXEMPLAIRE
FOR EACH ROW
WHEN (new.Etat = 'MA')

BEGIN
  DELETE FROM Exemplaire WHERE isbn = :new.isbn and Numero_exemplaire = :new.Numero_exemplaire;
END;
/

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


-- Partie VI Q3 TODO a tester
CREATE OR REPLACE TRIGGER modif_mb_emprunt BEFORE UPDATE ON Emprunts
FOR EACH ROW
WHEN ((new.Id_membre != old.Id_membre) and (new.Id_membre != NULL))

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

--TODO Q5

-- Partie VI Q6
CREATE OR REPLACE TRIGGER check_expl AFTER DELETE ON Details
FOR EACH ROW

DECLARE
  v_date_crea Emprunts.Cree_le%TYPE;
  v_date_emprunt Exemplaire.Datecalculemprunt%TYPE;

BEGIN
   SELECT Cree_le INTO v_date_crea
   FROM Emprunts
   WHERE Emprunts.Id_emprunt = :old.Id_emprunt;

   SELECT Datecalculemprunt INTO v_date_emprunt
   FROM Exemplaire
   WHERE Exemplaire.Isbn = :old.Isbn
   AND Exemplaire.Numero_exemplaire = :old.Numero_exemplaire;

   IF (v_date_emprunt < v_date_crea) THEN
      UPDATE Exemplaire
      SET Nombre_emprunts = Nombre_emprunts + 1
      WHERE Exemplaire.Isbn = :old.Isbn
      AND Exemplaire.Numero_exemplaire = :old.Numero_exemplaire;
   END IF;
END;
/


CREATE OR REPLACE TRIGGER info_create_emprunt
  BEFORE INSERT ON Emprunts
  FOR EACH ROW

  BEGIN
    :new.Cree_par := user();
    :new.Cree_le := sysdate;
  END;
/

CREATE OR REPLACE TRIGGER info_modif_details
  BEFORE INSERT ON Details
  FOR EACH ROW

  BEGIN
    :new.Termine_par := user();
    :new.Date_retour := sysdate;
  END;
/

-- Partie VI Q9

CREATE OR REPLACE TRIGGER Ver_detail
  BEFORE INSERT ON Details
  FOR EACH ROW
DECLARE
  v_etat Emprunts.Etat_emprunt%TYPE;

BEGIN
  SELECT Etat_emprunt INTO v_etat
  FROM Emprunts
  WHERE Id_emprunt = :new.Id_emprunt;

  IF(v_etat != 'EC') THEN
    RAISE_APPLICATION_ERROR(-2012, 'Tous les exemplaires de cette emprunt ont été rendus, créer un nouvel emprunt');
  END IF;
END;
/
