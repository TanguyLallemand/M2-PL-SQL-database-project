-- V - 1
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
-- V - 2
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

-- V - 3
CREATE OR REPLACE PROCEDURE Retourexemplaire (Num_isbn IN VARCHAR2, Num_exemplaire IN NUMBER)
AS
BEGIN
    UPDATE Details SET Date_retour=Sysdate
    WHERE Date_retour IS NULL AND Isbn=Num_isbn AND Numero_exemplaire = Num_exemplaire;
END;
/

-- V - 4
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

-- V - 5
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

-- V - 6
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

-- V - 7
CREATE OR REPLACE FUNCTION Dureemoyenne (V_num_isbn IN VARCHAR2, V_num_exemplaire IN NUMBER DEFAULT NULL) AS
    V_duree NUMBER;
BEGIN
    IF (V_num_exemplaire IS NULL) THEN
        SELECT Avg(Trunc(Date_retour,'DD')-Trunc(Cree_le,'DD')+1) INTO V_duree
        FROM Emprunts,Details
        WHERE Emprunts.Id_emprunt=Details.Id_emprunt AND Details.Isbn=V_num_isbn AND Date_retour IS NOT NULL;
    ELSE
        SELECT Avg(Trunc(Date_retour,'DD')-Trunc(Cree_le,'DD')+1) INTO V_duree
        FROM Emprunts,Details
        WHERE Emprunts.Id_emprunt=Details.Id_emprunt AND Details.Isbn=V_num_isbn AND Details.Numero_exemplaire=V_num_exemplaire AND Date_retour IS NOT NULL;
    END IF;
    RETURN V_duree;
END;
/

-- V - 8
-- TODO faire un job avec dbms scheduler, pas les droits.
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
    THEN V_etat_emprunt:='Neuf';
        ELSE IF (V_quantite<=25)
        THEN V_etat_emprunt :='Bon';
            ELSE IF (V_quantite<=40)
            THEN V_etat_emprunt :='Moyen';
            ELSE V_etat_emprunt :='Mauvais';
            END IF;
        END IF;
    END IF;
    UPDATE Exemplaire SET Etat=V_etat_emprunt
    WHERE CURRENT OF C_exemplaire;
    END LOOP;
END;
/


-- V - 9
CREATE OR REPLACE FUNCTION Ajoutemembre (V_nom IN VARCHAR2, V_prenom IN VARCHAR2, V_adresse IN Varchar2, V_telephone IN VARCHAR2, V_date_adhesion IN date, V_duree IN number)
RETURN number AS
    V_id number;
BEGIN
    INSERT INTO Membre (Id_membre, Nom, Prenom, Adresse, Telephone, Date_adhesion, Duree) VALUES (Uniq_id_membre.Nextval, V_nom, V_prenom, V_adresse, V_telephone, V_date_adhesion, V_duree) RETURNING Id_membre INTO V_id;
    RETURN V_id;
END;
/

-- V - 10
CREATE OR REPLACE PROCEDURE Supprimeexemplaire (V_num_isbn number, V_num_exemplaire number)
AS
V_nombre_livre_empruntes Number(3);
BEGIN
SELECT COUNT (*) INTO V_nombre_livre_empruntes
FROM Details
WHERE Details.Isbn = V_num_isbn;
    IF (V_nombre_livre_empruntes=0) THEN
        DELETE FROM Exemplaire WHERE Isbn=V_num_isbn AND Numero_exemplaire=V_num_exemplaire;
        ELSE
         Raise_application_error(-20343, 'exemplaire emprunté');
    END IF;
END;
/

-- V - 11
CREATE OR REPLACE PROCEDURE Empruntexpress (V_membre number, V_num_isbn number, V_num_exemplaire number)
AS
V_emprunt Emprunts.Id_emprunt%TYPE;
BEGIN
    INSERT INTO Emprunts (Id_emprunt, Id_membre, Cree_le, Etat_emprunt) VALUES (Uniq_id_emprunt.Nextval, V_membre, Sysdate, DEFAULT)
    RETURNING Id_emprunt INTO V_emprunt;
    INSERT INTO Details(Id_emprunt,	Numero_livre_emprunt, Isbn, Numero_exemplaire) VALUES(V_emprunt, 1, V_num_isbn, V_num_exemplaire);
END;
/

-- V - 12
--CF fichier package_livre.sql
