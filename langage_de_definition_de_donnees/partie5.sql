-- PARTIE V Q1
CREATE OR REPLACE FUNCTION Finvalidite (Num_adhe IN NUMBER)
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
CREATE OR REPLACE FUNCTION Adhesionajour (Num_adhe IN NUMBER)
  RETURN BOOLEAN
AS
BEGIN
    IF (Finvalidite(Num_adhe) >= Sysdate()) THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
END;
/
--CODE POUR TESTER LA FONCTION
-- DECLARE
--   d BOOLEAN;
-- BEGIN
--   d := AdhesionAjour(3);
--   dbms_output.put_line(d);
-- END;
-- /

-- PARTIE V Q3
CREATE OR REPLACE PROCEDURE Retourexemplaire (Num_isbn IN VARCHAR2, Num_exemplaire IN NUMBER)
AS
BEGIN
    UPDATE Details SET Date_retour=Sysdate
    WHERE Date_retour IS NULL AND Isbn=Num_isbn AND Numero_exemplaire = Num_exemplaire;
END;
/

-- PARTIE V Q4
CREATE OR REPLACE PROCEDURE Purgemembres AS
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
/

-- PARTIE V Q5
CREATE OR REPLACE FUNCTION Mesureactivite (V_periode IN number)
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
/

-- PARTIE V Q6
CREATE OR REPLACE FUNCTION Empruntmoyen (V_idmembre IN number)
RETURN number IS
    V_emprunt_moyen number;
BEGIN
    SELECT Avg(Date_retour-Cree_le + 1) INTO V_emprunt_moyen
    FROM Emprunts, Details
    WHERE Emprunts.Id_membre=V_idmembre AND Details.Id_emprunt=Emprunts.Id_emprunt AND Details.Date_retour IS NOT NULL;
    RETURN V_emprunt_moyen;
END;
/

-- PARTIE V Q7 --
CREATE OR REPLACE FUNCTION Dureemoyenne (v_Num_isbn IN VARCHAR2, v_Num_exemplaire IN NUMBER default null) AS
    v_duree NUMBER;
BEGIN
    IF (v_Num_exemplaire IS null) THEN
        SELECT AVG(TRUNC(Date_retour,'DD')-TRUNC(Cree_le,'DD')+1) INTO v_duree
        FROM Emprunts,Details
        WHERE emprunts.Id_emprunt=details.Id_emprunt AND details.ISBN=v_Num_isbn and Date_retour is not null;
    ELSE
        SELECT AVG(TRUNC(Date_retour,'DD')-TRUNC(Cree_le,'DD')+1) INTO v_duree
        FROM Emprunts,Details
        WHERE emprunts.Id_emprunt=details.Id_emprunt AND details.ISBN=v_Num_isbn AND Details.Numero_exemplaire=v_Num_exemplaire and Date_retour is not null;
    END IF;
    RETURN v_duree;
END;
/

-- PARTIE V Q8 -- TODO a faire tt les 15 jours... don t know...
CREATE OR REPLACE PROCEDURE Majeetatexemplaire AS
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
/


-- PARTIE V Q9
CREATE OR REPLACE FUNCTION Ajoutemembre (V_nom IN VARCHAR2, V_prenom IN VARCHAR2, V_adresse IN Varchar2, V_telephone IN VARCHAR2, V_date_adhesion IN date, V_duree IN number)
RETURN number AS
    V_id number;
BEGIN
    INSERT INTO Membre (Id_membre, Nom, Prenom, Adresse, Telephone, Date_adhesion, Duree) VALUES (Uniq_id_membre.Nextval, V_nom, V_prenom, V_adresse, V_telephone, V_date_adhesion, V_duree) RETURNING Id_membre INTO V_id;
    RETURN V_id;
END;
/
