-- Projet de gestion de base de données
-- Fresnais Louison, Courtin François, Lallemand Tanguy, Cruard Jonathan

--------------------------------------------------------------------------------
-- Add functions and procedure signatures
--------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE Maintenance AS
    PROCEDURE Maj_etat_emprunt;
    PROCEDURE Purgemembres;
    PROCEDURE number_uses_book;

END Maintenance;
/

CREATE OR REPLACE PACKAGE BODY Maintenance AS

--------------------------------------------------------------------------------
-- passe l'etat de l'emprunt à RE si tout les livres correspondants sont rendus
--------------------------------------------------------------------------------

PROCEDURE Maj_etat_emprunt AS
BEGIN
    UPDATE Emprunts
    SET Etat_emprunt = 'RE'
    WHERE Id_emprunt NOT IN (SELECT Id_emprunt
    FROM Details
    WHERE Date_retour IS NULL);
    COMMIT;
END;

-------------------------------------------------------------------------------
-- Purgemembres, permet de supprimer tous les membres dont
-- l’adhésion n’a pas été renouvelée depuis trois ans.
-- TODO ça doit pas marcher ton truc normalement car il y a la contrainte de forein key dans les autres tables (cf part IV Q2)
-------------------------------------------------------------------------------

PROCEDURE Purgemembres AS
CURSOR C_membre_expi
    IS SELECT *
    FROM Membre
    WHERE Add_months(Date_adhesion, Duree) < Add_months(Sysdate, (-3*12)) FOR UPDATE;
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


PROCEDURE number_uses_book AS

CURSOR nombre_details IS
    select d.isbn, d.numero_exemplaire, count(*) as nombre
    from Details d, Exemplaire e
    where d.date_retour > e.DATECALCULEMPRUNT and d.isbn = e.isbn and d.NUMERO_EXEMPLAIRE = e.NUMERO_EXEMPLAIRE
    group by d.isbn, d.numero_exemplaire;
    -- Mise a jour des informations concernant le nombre d'emprunts
V_exemplaire nombre_details%Rowtype;

BEGIN
  FOR V_exemplaire IN nombre_details
  LOOP
  UPDATE Exemplaire SET Nombre_emprunts = Nombre_emprunts+V_exemplaire.nombre, DATECALCULEMPRUNT = Sysdate
  WHERE numero_exemplaire = V_exemplaire.numero_exemplaire
  AND Isbn=V_exemplaire.Isbn;
  END LOOP;
END;


END Maintenance;
/

--@langage_de_definition_de_donnees/package_maintenance
