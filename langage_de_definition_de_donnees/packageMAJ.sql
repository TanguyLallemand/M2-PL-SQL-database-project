-- Add functions and procedure signatures
CREATE PACKAGE Maintenance AS
    PROCEDURE MAJ_etat_emprunt;

    FUNCTION Finvalidite (Num_adhe IN number)
        RETURN DATE;

END Maintenance;
/

CREATE OR REPLACE PACKAGE BODY Maintenance AS

PROCEDURE MAJ_etat_emprunt AS
BEGIN
    UPDATE Emprunts
    SET Etat_emprunt = 'RE'
    WHERE Id_emprunt NOT IN (SELECT Id_emprunt
    FROM Details
    WHERE Date_retour IS NULL);
    COMMIT;
END;
