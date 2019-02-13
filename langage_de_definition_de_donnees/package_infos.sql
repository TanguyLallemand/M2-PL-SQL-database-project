CREATE PACKAGE Infos AS
    PROCEDURE Lister_ouvrages;
    PROCEDURE recherche_pattern (pattern_recherche IN VARCHAR2);
    FUNCTION AnalyseActivite_emprunt (v_util IN VARCHAR2 DEFAULT NULL, v_date IN DATE DEFAULT NULL);
        RETURN NUMBER
    FUNCTION AnalyseActivite_detail (v_util IN VARCHAR2 DEFAULT NULL, v_date IN DATE DEFAULT NULL);
        RETURN NUMBER
    FUNCTION AnalyseActivite (v_util IN VARCHAR2 DEFAULT NULL, v_date IN DATE DEFAULT NULL);
        RETURN NUMBER

END Infos;
/

CREATE OR REPLACE PACKAGE BODY Infos AS

PROCEDURE Lister_ouvrages AS
CURSOR C_liste_titres IS
    SELECT Titre FROM Ouvrage;
V_liste_titres C_liste_titres%Rowtype;
BEGIN
    Dbms_output.Put_line('Liste des ouvrages disponibles :');
    FOR V_liste_titres IN C_liste_titres LOOP
        Dbms_output.Put_line(V_liste_titres.Titre);
    END LOOP;
END;
-- Call this procedure giving him a regex. For example, to use it for question 3-5 please add this package and then call like following line:
-- begin
-- recherche_pattern('%de%');
-- end;
PROCEDURE recherche_pattern (pattern_recherche IN VARCHAR2) AS
CURSOR C_liste_titres IS
    SELECT Titre
    FROM Ouvrage
    WHERE Titre LIKE pattern_recherche;
V_liste_titres C_liste_titres%Rowtype;
  BEGIN
    Dbms_output.Put_line('Liste des ouvrages trouvés avec votre regexp ' || pattern_recherche || ' :');
    FOR V_liste_titres IN C_liste_titres LOOP
        Dbms_output.Put_line(V_liste_titres.Titre);
    END LOOP;
  END;


  FUNCTION AnalyseActivite_emprunt (
    v_util IN VARCHAR2 DEFAULT NULL, v_date IN DATE DEFAULT NULL)
    RETURN NUMBER
    IS
    v_nb_emprunts NUMBER := 0;

    BEGIN

      IF (v_util IS NOT NULL AND v_date IS NULL) THEN
        SELECT count(*) INTO v_nb_emprunts
        FROM Emprunts
        WHERE Cree_par = v_util;

        RETURN v_nb_emprunts;
      END IF;

      IF (v_util IS NULL AND v_date IS NOT NULL) THEN
        SELECT count(*) INTO v_nb_emprunts
        FROM Emprunts
        WHERE to_date(Cree_le, 'DD-MON-YY') = to_date(v_date, 'DD-MON-YY');
        dbms_output.put_line(v_date);
        RETURN v_nb_emprunts;
      END IF;

      IF (v_util IS NOT NULL AND v_date IS NOT NULL) THEN
        SELECT count(*) INTO v_nb_emprunts
        FROM Emprunts
        WHERE Cree_par = v_util
        AND to_date(Cree_le, 'DD-MON-YY') = to_date(v_date, 'DD-MON-YY');

        RETURN v_nb_emprunts;
      END IF;
    END;

  FUNCTION AnalyseActivite_detail (
    v_util IN VARCHAR2 DEFAULT NULL, v_date IN DATE DEFAULT NULL)
    RETURN NUMBER
    IS
    v_nb_retour NUMBER := 0;

    BEGIN
      IF (v_util IS NULL AND v_date IS NOT NULL) THEN

        SELECT count(*) INTO v_nb_retour
        FROM Details
        WHERE to_date(Date_retour, 'DD-MON-YY') = to_date(v_date, 'DD-MON-YY');

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
        AND to_date(Date_retour, 'DD-MON-YY') = to_date(v_date, 'DD-MON-YY');

        RETURN v_nb_retour;
      END IF;
    END;

  FUNCTION AnalyseActivite (
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

END Infos;
/
