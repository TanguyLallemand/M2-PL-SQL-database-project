--------------------------------------------------------------------------------
-- Création des triggers
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- efface automatiquement les exemplaires en mauvais état
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER supprimer_exemplr_mauvais AFTER UPDATE ON EXEMPLAIRE
FOR EACH ROW
WHEN (new.Etat = 'MA')

BEGIN
  DELETE FROM Exemplaire WHERE isbn = :new.isbn and Numero_exemplaire = :new.Numero_exemplaire;
END;
/

--------------------------------------------------------------------------------
-- Vérifie que le membre effectuant un emprunt est à jour dans ses cotisations
-- dans le cas contraire, empèche la réalisation de l'emprunt
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Empèche le changement de l'ID d'un membre sur une fiche d'emprunt
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER modif_mb_emprunt BEFORE UPDATE ON Emprunts
FOR EACH ROW
WHEN ((new.Id_membre != old.Id_membre) and (new.Id_membre != NULL))

BEGIN
  RAISE_APPLICATION_ERROR(-20002, 'Impossible de modifier le membre d''un emprunt');
  END;
/

--------------------------------------------------------------------------------
-- Partie Empèche le changement de référence d'un ouvrage emprunté (Etat 'EC')
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER mod_ref_emprunt BEFORE UPDATE ON Details
FOR EACH ROW
WHEN ((new.Isbn != old.Isbn) OR (new.Numero_exemplaire != old.Numero_exemplaire))

BEGIN
  RAISE_APPLICATION_ERROR(-20003, 'Impossible de modifier la référence d''un ouvrage emprunté, il faut le rendre puis effectuer une nouvelle location.');
END;
/

--------------------------------------------------------------------------------
--Met à jour l'état d'un exemplaire en fonction de sno nombre d'emprunt à chaque
-- modification du nombre d'emprunts
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER maj_etat_explr BEFORE UPDATE ON EXEMPLAIRE
FOR EACH ROW
WHEN (new.Nombre_emprunts != old.Nombre_emprunts)

BEGIN
  CASE
    WHEN :new.Nombre_emprunts <= 10 THEN :new.Etat := 'NE';
    WHEN :new.Nombre_emprunts <= 25 THEN :new.Etat := 'BO';
    WHEN :new.Nombre_emprunts <= 40 THEN :new.Etat := 'MO';
    WHEN :new.Nombre_emprunts <= 60 THEN :new.Etat := 'DO';
    ELSE :new.Etat :='MA';
  END CASE;
END;
/

--------------------------------------------------------------------------------
-- Vérifie que le nombre d'emprunts d'un exemplaire est correct à la suppression
-- du détail correspondant, met à jour le nombre d'emprunt en cas d'erreur
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Ajoute le créateur de l'emprunt et la date de création lors d'un nouvel
-- emprunt
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER info_create_emprunt
  BEFORE INSERT ON Emprunts
  FOR EACH ROW

  BEGIN
    :new.Cree_par := user();
    :new.Cree_le := sysdate;
  END;
/

--------------------------------------------------------------------------------
-- Ajoute l'utilisateur ayant modifié un emprunt et la date de la modification
-- lorsqu'un emprunt est modifié
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER info_modif_details
  BEFORE INSERT ON Details
  FOR EACH ROW

  BEGIN
    :new.Termine_par := user();
    :new.Date_retour := sysdate;
  END;
/

--------------------------------------------------------------------------------
-- Empèche l'ajout d'un détail pour un emprunt lorsque celui-ci n'est plus en cours
--------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER Venr_detail
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
