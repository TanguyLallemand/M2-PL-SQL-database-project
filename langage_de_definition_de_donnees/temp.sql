
--Partie VI Q8
CREATE OR REPLACE FUNCTION AnalyseActivite_emprunt (
  v_util IN VARCHAR2 DEFAULT NULL, v_date IN DATE DEFAULT NULL)
  RETURN NUMBER
  IS
  v_nb_emprunts NUMBER := 0;

  BEGIN
    IF (v_util IS NULL AND v_date IS NOT NULL) THEN
      SELECT count(*) INTO v_nb_emprunts
      FROM Emprunts
      WHERE Cree_le = v_date;
      dbms_output.put_line(v_date);
      RETURN v_nb_emprunts;
    END IF;

    IF (v_util IS NOT NULL AND v_date IS NULL) THEN
      SELECT count(*) INTO v_nb_emprunts
      FROM Emprunts
      WHERE Cree_par = v_util;

      RETURN v_nb_emprunts;
    END IF;

    IF (v_util IS NOT NULL AND v_date IS NOT NULL) THEN
      SELECT count(*) INTO v_nb_emprunts
      FROM Emprunts
      WHERE Cree_par = v_util
      AND Cree_le = v_date;

      RETURN v_nb_emprunts;
    END IF;
  END;
/

CREATE OR REPLACE FUNCTION AnalyseActivite_detail (
  v_util IN VARCHAR2 DEFAULT NULL, v_date IN DATE DEFAULT NULL)
  RETURN NUMBER
  IS
  v_nb_retour NUMBER := 0;

  BEGIN
    IF (v_util IS NULL AND v_date IS NOT NULL) THEN

      SELECT count(*) INTO v_nb_retour
      FROM Details
      WHERE Date_retour = v_date;

      RETURN v_nb_retour;
    END IF;

    IF (v_util IS NOT NULL AND v_date IS NULL) THEN

      SELECT count(*) INTO v_nb_retour
      FROM Details
      WHERE Termine_par = v_util;

      RETURN v_nb_retour;
    END IF;

    IF (v_util IS NOT NULL AND v_date IS NOT NULL) THEN

      SELECT count(*) INTO v_nb_retour
      FROM Details
      WHERE Termine_par = v_util
      AND Date_retour = v_date;

      RETURN v_nb_retour;
    END IF;
  END;
/

CREATE OR REPLACE FUNCTION AnalyseActivite (
  v_util IN VARCHAR2 DEFAULT NULL, v_date IN DATE DEFAULT NULL)
  RETURN NUMBER
  IS
    v_nb_emprunts NUMBER := 0;
    v_nb_retour NUMBER := 0;
  BEGIN
    IF (v_util IS NOT NULL AND v_date IS NOT NULL) THEN
      v_nb_emprunts := AnalyseActivite_emprunt(v_util, v_date);
      v_nb_retour := AnalyseActivite_detail(v_util, v_date);

      RETURN v_nb_emprunts + v_nb_retour;
    END IF;

    IF (v_util IS NOT NULL AND v_date IS NULL) THEN
      v_nb_emprunts := AnalyseActivite_emprunt(v_util);
      v_nb_retour := AnalyseActivite_detail(v_util);

      RETURN v_nb_emprunts + v_nb_retour;
    END IF;

    IF (v_util IS NULL AND v_date IS NOT NULL) THEN
      v_nb_emprunts := AnalyseActivite_emprunt(v_date);
      v_nb_retour := AnalyseActivite_detail(v_date);

      RETURN v_nb_emprunts + v_nb_retour;
    END IF;
  END;
/


SET serveroutput ON size 30000;

DECLARE
util VARCHAR2(4) := 'BIO3';
date_ DATE := sysdate;
nb NUMBER;
BEGIN
  nb := AnalyseActivite_emprunt(NULL,sysdate);
  dbms_output.put_line(nb);
END;
/
