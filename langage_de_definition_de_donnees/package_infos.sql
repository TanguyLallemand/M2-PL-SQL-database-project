CREATE PACKAGE Infos AS
    PROCEDURE Lister_ouvrages;
    PROCEDURE recherche_pattern (pattern_recherche IN VARCHAR2);

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

PROCEDURE recherche_pattern (pattern_recherche IN VARCHAR2) AS
CURSOR C_liste_titres IS
    SELECT Titre
    FROM Ouvrage
    WHERE Titre LIKE pattern_recherche;
V_liste_titres C_liste_titres%Rowtype;
  BEGIN
    Dbms_output.Put_line('Liste des ouvrages disponibles :');
    FOR V_liste_titres IN C_liste_titres LOOP
        Dbms_output.Put_line(V_liste_titres.Titre);
    END LOOP;
  END;

END Infos;
/
