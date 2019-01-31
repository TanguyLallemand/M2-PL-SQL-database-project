CREATE PACKAGE Livre AS
    FUNCTION Finvalidite (Num_adhe IN number)
        RETURN DATE;
    FUNCTION Adhesionajour (Num_adhe IN number)
        RETURN BOOLEAN;
    PROCEDURE Retourexemplaire (Num_isbn IN Varchar2, Num_exemplaire number);
    FUNCTION Mesureactivite (V_periode IN number)
        RETURN number;
    FUNCTION Empruntmoyen (V_idmembre IN number)
        RETURN number;
    FUNCTION Ajoutemembre (V_nom IN Varchar2,
                        V_prenom IN Varchar2,
                        V_adresse IN Varchar2,
                        V_telephone IN Varchar2,
                        V_date_adhesion IN date,
                        V_duree IN number)
        RETURN number;


END Livre;
/


CREATE OR REPLACE PACKAGE BODY Livre AS

-------------------------------------------------------------------------------
-- Finvalidite, calcule la date de fin de validité de l’adhésion d’un
-- membre dont le numéro est passé en paramètre.
-------------------------------------------------------------------------------

FUNCTION Finvalidite (Num_adhe IN NUMBER)
    RETURN DATE
    IS
    V_datedeb Membre.Date_adhesion%TYPE;
    V_duree Membre.Duree%TYPE;
    V_finval DATE;
BEGIN
    SELECT Duree INTO V_duree
    FROM Membre
    WHERE Id_membre = Num_adhe;
    SELECT Date_adhesion INTO V_datedeb
    FROM Membre
    WHERE Id_membre = Num_adhe;
    V_finval := Add_months(V_datedeb, V_duree);
    Dbms_output.Put_line(V_finval);
    RETURN V_finval;
END;

-------------------------------------------------------------------------------
-- Adhesionajour, retourne une valeur booléenne afin de savoir si un
-- membre peut ou non effectuer des locations.
-------------------------------------------------------------------------------

FUNCTION Adhesionajour (Num_adhe IN NUMBER)
  RETURN BOOLEAN
AS
BEGIN
    IF (Finvalidite(Num_adhe) >= Sysdate()) THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
END;

-------------------------------------------------------------------------------
-- RetourExemplaire, accepte en paramètres un numéro d’ISBN et
-- un numéro d’exemplaire afin d’enregistrer la restitution de
-- l’exemplaire de l’ouvrage emprunté.
-------------------------------------------------------------------------------

PROCEDURE Retourexemplaire (Num_isbn IN VARCHAR2, Num_exemplaire NUMBER)
AS
BEGIN
   UPDATE Details SET Date_retour=Sysdate
   WHERE Date_retour IS NULL AND Isbn=Num_isbn AND Numero_exemplaire = Num_exemplaire;
END;

-------------------------------------------------------------------------------
-- Purgemembres, permet de supprimer tous les membres dont
-- l’adhésion n’a pas été renouvelée depuis trois ans.
-------------------------------------------------------------------------------

PROCEDURE Purgemembres AS
    CURSOR C_membre IS
    SELECT Id_membre
    FROM Membre
    WHERE (Trunc(Sysdate(), 'YYYY') - Trunc(Add_months(Date_adhesion, Duree), 'YYYY')) >3;
BEGIN
    FOR V_id IN C_membre LOOP
        DELETE FROM Membre WHERE Id_membre=V_id.Id_membre;
    END LOOP;
    COMMIT;
END;

-------------------------------------------------------------------------------
-- Mesureactivite, permet de connaître le numéro du membre qui a
-- emprunté le plus d’ouvrage pendant une période de temps passée
-- en paramètre de la fonction.
-------------------------------------------------------------------------------

FUNCTION Mesureactivite (V_periode IN number)
RETURN number IS
    CURSOR C_activite(V_periode IN number) IS
        SELECT Id_membre, Count(*)
        FROM Emprunts, Details
        WHERE Details.Id_emprunt=Emprunts.Id_emprunt AND Months_between(Sysdate, Cree_le) < V_periode
        GROUP BY Id_membre
        ORDER BY 2 DESC;
    V_membre C_activite%Rowtype;
BEGIN
    OPEN C_activite(V_periode);
    FETCH C_activite INTO V_membre;
    CLOSE C_activite;
    RETURN V_membre.Id_membre;
END;

-------------------------------------------------------------------------------
-- Empruntmoyen, ui accepte en paramètre d’entrée le numéro d’un membre
-- et qui retourne la durée moyenne (en nombre de jours) d’emprunt d’un ouvrage.
-------------------------------------------------------------------------------

FUNCTION Empruntmoyen (V_idmembre IN number)
RETURN number IS
   V_emprunt_moyen number;
BEGIN
   SELECT Avg(Date_retour-Cree_le + 1) INTO V_emprunt_moyen
   FROM Emprunts, Details
   WHERE Emprunts.Id_membre=V_idmembre AND Details.Id_emprunt=Emprunts.Id_emprunt AND Details.Date_retour IS NOT NULL;
   RETURN V_emprunt_moyen;
END;

-------------------------------------------------------------------------------
-- Majeetatexemplaire, pour mettre à jour l’état des exemplaires et
-- planifier l’exécution de cette procédure toutes les deux semaines.
-------------------------------------------------------------------------------

PROCEDURE Majeetatexemplaire AS
CURSOR C_exemplaire IS SELECT * FROM Exemplaire FOR UPDATE OF Etat;
V_etat_emprunt Exemplaire.Etat%TYPE;
V_quantite number (3);
BEGIN
    FOR V_exemplaire IN C_exemplaire LOOP
    SELECT COUNT (*) INTO V_quantite
    FROM Details
    WHERE Details.Isbn=V_exemplaire.Isbn AND Details.Numero_exemplaire=V_exemplaire.Numero_exemplaire;
    IF (V_quantite<=10)
        THEN V_etat_emprunt:='NE';
        ELSE IF (V_quantite<=25)
            THEN V_etat_emprunt :='BO';
            ELSE IF (V_quantite<=40)
                THEN V_etat_emprunt :='MO';
                ELSE V_etat_emprunt :='MA';
            END IF;
        END IF;
    END IF;
    UPDATE Exemplaire SET Etat=V_etat_emprunt
    WHERE CURRENT OF C_exemplaire;
    END LOOP;
END;

-------------------------------------------------------------------------------
-- Ajoute membre, qui accepte en paramètre les différentes valeurs de chacune
-- des colonnes et qui retourne le numéro de séquence attribué à la ligne
-- d’information nouvellement ajoutée dans la table.
-------------------------------------------------------------------------------

FUNCTION Ajoutemembre (V_nom IN VARCHAR2, V_prenom IN VARCHAR2, V_adresse IN Varchar2, V_telephone IN VARCHAR2, V_date_adhesion IN date, V_duree IN number)
RETURN number AS
    V_id number;
BEGIN
    INSERT INTO Membre (Id_membre, Nom, Prenom, Adresse, Telephone, Date_adhesion, Duree) VALUES (Uniq_id_membre.Nextval, V_nom, V_prenom, V_adresse, V_telephone, V_date_adhesion, V_duree) RETURNING Id_membre INTO V_id;
    RETURN V_id;
END;



END Livre;
/
