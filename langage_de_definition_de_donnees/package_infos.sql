CREATE PACKAGE Infos AS
    PROCEDURE lister_ouvrages;


END Infos;
/

CREATE OR REPLACE PACKAGE BODY Infos AS

PROCEDURE lister_ouvrages AS
CURSOR c_liste_titres IS
    SELECT Titre FROM Ouvrage;
v_liste_titres c_liste_titres%ROWTYPE;
BEGIN
    Dbms_output.Put_line('Liste des ouvrages disponibles :');
    FOR v_liste_titres IN c_liste_titres LOOP
        Dbms_output.Put_line(v_liste_titres.Titre);
    END LOOP;
END;

END Infos;
/
