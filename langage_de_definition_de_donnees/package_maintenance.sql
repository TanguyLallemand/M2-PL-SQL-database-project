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

-- Mise a jour de la TABLE
-- PROCEDURE Update_calcul_emprunt AS
-- UPDATE Exemplaire SET Datecalculemprunt=(
--     SELECT Min(Cree_le)
--     FROM Emprunts Emp, Details Det
--     WHERE Emp.Id_emprunt=Det.Id_emprunt
--     AND Det.Isbn=Exemplaire.Isbn
--     AND Det.Numero_exemplaire=Exemplaire.Numero_exemplaire);
--     UPDATE Exemplaire SET Datecalculemprunt = Sysdate
--     WHERE Datecalculemprunt IS NULL;
--     COMMIT;
-- -- Mise a jour des informations du nombre d'emprunts et de l'etat des ouvrages
-- DECLARE
--     CURSOR C_exemplaire IS
--         SELECT * FROM Exemplaire
--         -- Mise a jour des informations concernant le nombre d'emprunts
--         FOR UPDATE OF Nombre_emprunts, Datecalculemprunt;
--     V_nombre_emprunts Exemplaire.Nombre_emprunts%TYPE;
-- BEGIN
--     FOR V_exemplaire IN C_exemplaire LOOP
--         SELECT Count(*) INTO V_nombre_emprunts
--         FROM Details, Emprunts
--         WHERE Details.Id_emprunt=Emprunts.Id_emprunt
--             AND Isbn=V_exemplaire.Isbn
--             AND Cree_le>=V_exemplaire.Datecalculemprunt;
--         -- Mise a jour de l'etat des livres en fonctions du nombre d'emprunts
--         UPDATE Exemplaire SET Nombre_emprunts=Nombre_emprunts+V_nombre_emprunts, Datecalculemprunt = Sysdate
--         WHERE CURRENT OF C_exemplaire;
--         CASE
--             WHEN V_exemplaire.Nombre_emprunts<=10 THEN UPDATE Exemplaire SET Exemplaire.Etat = 'Neuf';
--             WHEN V_exemplaire.Nombre_emprunts<=25 THEN UPDATE Exemplaire SET Exemplaire.Etat = 'Bon';
--             WHEN V_exemplaire.Nombre_emprunts<=40 THEN UPDATE Exemplaire SET Exemplaire.Etat = 'Moyen';
--             ELSE UPDATE Exemplaire SET Exemplaire.Etat ='Mauvais';
--         END CASE;
--     END LOOP
--     -- On repercute les changement dans la base de données
--     COMMIT;
-- END;


-- DECLARE
--     CURSOR C_exemplaire IS
--         SELECT * FROM Exemplaire
--         -- Mise a jour des informations concernant le nombre d'emprunts
--         FOR UPDATE OF Nombre_emprunts, Datecalculemprunt;
--     V_nombre_emprunts Exemplaire.Nombre_emprunts%TYPE;
-- BEGIN
--     FOR V_exemplaire IN C_exemplaire LOOP
--         SELECT Count(*) INTO V_nombre_emprunts
--         FROM Details, Emprunts
--         WHERE Details.Id_emprunt=Emprunts.Id_emprunt
--             AND Isbn=V_exemplaire.Isbn
--             AND Cree_le>=V_exemplaire.Datecalculemprunt;
PROCEDURE number_uses_book AS

CURSOR C_exemplaire IS
    select D.isbn, D.numero_exemplaire, count(*) nombre
    from details D, exemplaire E
    where date_retour > DATECALCULEMPRUNT and D.isbn = E.isbn and D.NUMERO_EXEMPLAIRE = E.NUMERO_EXEMPLAIRE
    group by D.isbn, D.numero_exemplaire;
    -- Mise a jour des informations concernant le nombre d'emprunts
    --FOR UPDATE OF Nombre_emprunts, Datecalculemprunt;
V_nombre_emprunts Exemplaire.Nombre_emprunts%TYPE;

BEGIN
  FOR V_exemplaire IN C_exemplaire
  LOOP
  SELECT e.Nombre_emprunts INTO V_nombre_emprunts
  FROM Details d, Exemplaire e
  WHERE d.numero_exemplaire = e.numero_exemplaire
      AND Isbn=V_exemplaire.Isbn;
  UPDATE Exemplaire SET Nombre_emprunts=Nombre_emprunts+V_nombre_emprunts, Datecalculemprunt = Sysdate;
  END LOOP;
END;


END Maintenance;
/

--@langage_de_definition_de_donnees/package_maintenance
