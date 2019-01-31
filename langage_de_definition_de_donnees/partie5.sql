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
CREATE OR REPLACE PROCEDURE Retourexemplaire (Num_isbn IN VARCHAR2, Num_exemplaire NUMBER)
AS
BEGIN
    UPDATE Details SET Date_retour=Sysdate
    WHERE Date_retour IS NULL AND Isbn=Num_isbn AND Numero_exemplaire = Num_exemplaire;
END;
/

-- PARTIE V Q4
CREATE OR REPLACE PROCEDURE Purgemembres AS
BEGIN

END;
/

-- PARTIE V Q5
CREATE OR REPLACE FUNCTION Mesureactivite (V_periode IN number)
RETURN number IS
    CURSOR C_activite(V_mois IN number) IS
        SELECT Id_membre, Count(*)
        FROM Emprunts, Details
        WHERE Details.Id_emprunt=Emprunts.Numero_exemplaire AND months_between(Sysdate, Cree_le) < V_mois
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