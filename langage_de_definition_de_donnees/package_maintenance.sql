-- Add functions and procedure signatures
CREATE OR REPLACE PACKAGE Maintenance AS
    PROCEDURE MAJ_etat_emprunt;

    PROCEDURE purge_membre;

END Maintenance;
/

CREATE OR REPLACE PACKAGE BODY Maintenance AS

-- passe l'etat de l'emprunt à RE si tout les livres correspondants sont rendus
PROCEDURE MAJ_etat_emprunt AS
BEGIN
    UPDATE Emprunts
    SET Etat_emprunt = 'RE'
    WHERE Id_emprunt NOT IN (SELECT Id_emprunt
    FROM Details
    WHERE Date_retour IS NULL);
    COMMIT;
END;

-- supprime les membres dont l’adhésion a expiré depuis plus de 2 ans et dont les emprunts sont soldés
PROCEDURE purge_membre AS
    -- curseur avec la liste des membres expirés
    CURSOR C_membre_expi
        IS SELECT *
        FROM Membre
        WHERE Add_months(Date_adhesion, Duree) < Add_months(Sysdate, (-2*12)) FOR UPDATE;
    -- variable temp pour les membres de la liste
    V_membre_expi C_membre_expi%Rowtype;

    -- curseur pour les emprunts des membres expirés
    CURSOR C_emprunts_en_cours(V_id_membre Emprunts.Id_membre%TYPE := NULL)
        IS SELECT count(*) as coun
        FROM Emprunts
        WHERE Id_membre = V_id_membre and etat_emprunt = 'EC';
    -- variable temp pour les emprunts de la liste
    V_emprunts_en_cours C_emprunts_en_cours%Rowtype;
BEGIN
    FOR V_membre_expi IN C_membre_expi LOOP
        OPEN C_emprunts_en_cours(V_membre_expi.Id_membre);
        FETCH C_emprunts_en_cours INTO V_emprunts_en_cours;
        IF V_emprunts_en_cours.coun = 0 THEN
            UPDATE Emprunts SET Id_membre = NULL
            WHERE Emprunts.ID_membre = V_membre_expi.ID_membre;
            DELETE FROM Membre WHERE CURRENT OF C_membre_expi;
        END IF;
        CLOSE C_emprunts_en_cours;
    END LOOP;
    COMMIT;
END;

END Maintenance;
/
