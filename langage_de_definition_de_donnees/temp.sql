-- PARTIE V Q1
CREATE OR REPLACE FUNCTION FinValidite (numadhe IN NUMBER)
  RETURN DATE
  IS
  v_datedeb MEMBRE.Date_adhesion%TYPE;
  v_duree MEMBRE.Duree%TYPE;
  v_finval DATE;
  BEGIN
    SELECT Duree INTO v_duree FROM MEMBRE
    WHERE ID_membre = numadhe;
    SELECT Date_adhesion INTO v_datedeb FROM MEMBRE
    WHERE ID_membre = numadhe;
    v_finval := ADD_MONTHS(v_datedeb, v_duree);
    dbms_output.put_line(v_finval);
    RETURN v_finval;
  END;
/
--CODE POUR TESTER LA FONCTION
--DECLARE
--  d DATE;
--BEGIN
--  d := FinValidite(4);
--  dbms_output.put_line(d);
--END;
--/

-- PARTIE V Q2
CREATE OR REPLACE FUNCTION AdhesionAjour (numadhe IN NUMBER)
  RETURN BOOLEAN
  IS
  v_datefin DATE;
  BEGIN
    v_datefin := FinValidite(numadhe);
    IF v_datefin > sysdate THEN
      RETURN 1;
    ELSE
      RETURN 0;
    END IF;
  END;
/--CODE POUR TESTER LA FONCTION
DECLARE
  d BOOLEAN;
BEGIN
  d := AdhesionAjour(3);
  dbms_output.put_line(d);
END;
/
