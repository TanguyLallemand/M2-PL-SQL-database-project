
-- Add functions and procedure signatures
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
    FUNCTION Dureemoyenne (v_Num_isbn IN VARCHAR2, v_Num_exemplaire IN NUMBER default null)
    RETURN number;
    PROCEDURE Majeetatexemplaire;
    FUNCTION Ajoutemembre (V_nom IN Varchar2,
                        V_prenom IN Varchar2,
                        V_adresse IN Varchar2,
                        V_telephone IN Varchar2,
                        V_date_adhesion IN date,
                        V_duree IN number)
        RETURN number;
    PROCEDURE Empruntexpress (V_membre number, V_num_isbn number, V_num_exemplaire number);
    PROCEDURE Supprimeexemplaire (V_num_isbn number, V_num_exemplaire number);

END Livre;
/



-- Add functions code
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

PROCEDURE Retourexemplaire (Num_isbn IN VARCHAR2, Num_exemplaire IN NUMBER)
AS
BEGIN
   UPDATE Details SET Date_retour=Sysdate
   WHERE Date_retour IS NULL AND Isbn=Num_isbn AND Numero_exemplaire = Num_exemplaire;
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

-------------------------------------------------------------------------------
-- Dureemoyenne, accepte en paramètre un numéro d’ISBN et
-- éventuellement un numéro d’exemplaire et qui retourne, soit la durée moyenne
-- d’emprunt de l’ouvrage (seul le numéro ISBN est connu), soit la durée
-- moyenne d’emprunt de l’exemplairedans le cas où l’on connaît le numéro d’ISBN et
-- le numéro de l’exemplaire
-------------------------------------------------------------------------------

FUNCTION Dureemoyenne (v_Num_isbn IN VARCHAR2, v_Num_exemplaire IN NUMBER default null)
RETURN number AS
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


-------------------------------------------------------------------------------
-- Supprimeexemplaire, qui accepte en paramètre l’identification
-- complète d’un exemplaire (ISBN et numéro d’exemplaire) et supprime
-- celui-ci s’il n’est pas emprunté.
-------------------------------------------------------------------------------
PROCEDURE Supprimeexemplaire (V_num_isbn number, V_num_exemplaire number)
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


-------------------------------------------------------------------------------
-- Empruntexpress, qui accepte en paramètre le numéro du membre et l’identification
-- exacte de l’exemplaire emprunté (ISBN et numéro). La procédure ajoute
-- automatiquement une ligne dans la table des emprunts et une
-- ligne dans la table des détails.
-------------------------------------------------------------------------------
PROCEDURE Empruntexpress (V_membre number, V_num_isbn number, V_num_exemplaire number)
AS
V_emprunt Emprunts.Id_emprunt%TYPE;
BEGIN
    INSERT INTO Emprunts (Id_emprunt, Id_membre, Cree_le, Etat_emprunt) VALUES (Uniq_id_emprunt.Nextval, V_membre, Sysdate, DEFAULT)
    RETURNING Id_emprunt INTO V_emprunt;
    INSERT INTO Details(Id_emprunt,	Numero_livre_emprunt, Isbn, Numero_exemplaire) VALUES(V_emprunt, 1, V_num_isbn, V_num_exemplaire);
END;

END Livre;
/

FUNCTION AnalyseActivite_emprunt (
  v_util IN VARCHAR2 DEFAULT NULL, v_date IN DATE DEFAULT NULL)
  RETURN NUMBER
  IS
  v_nb_emprunts NUMBER := 0;

  BEGIN

    IF (v_util IS NOT NULL AND v_date IS NULL) THEN
      SELECT count(*) INTO v_nb_emprunts
      FROM Emprunts
      WHERE Cree_par = v_util;

      RETURN v_nb_emprunts;
    END IF;

    IF (v_util IS NULL AND v_date IS NOT NULL) THEN
      SELECT count(*) INTO v_nb_emprunts
      FROM Emprunts
      WHERE to_date(Cree_le, 'DD-MON-YY') = to_date(v_date, 'DD-MON-YY');
      dbms_output.put_line(v_date);
      RETURN v_nb_emprunts;
    END IF;

    IF (v_util IS NOT NULL AND v_date IS NOT NULL) THEN
      SELECT count(*) INTO v_nb_emprunts
      FROM Emprunts
      WHERE Cree_par = v_util
      AND to_date(Cree_le, 'DD-MON-YY') = to_date(v_date, 'DD-MON-YY');

      RETURN v_nb_emprunts;
    END IF;
  END;
/

FUNCTION AnalyseActivite_detail (
  v_util IN VARCHAR2 DEFAULT NULL, v_date IN DATE DEFAULT NULL)
  RETURN NUMBER
  IS
  v_nb_retour NUMBER := 0;

  BEGIN
    IF (v_util IS NULL AND v_date IS NOT NULL) THEN

      SELECT count(*) INTO v_nb_retour
      FROM Details
      WHERE to_date(Date_retour, 'DD-MON-YY') = to_date(v_date, 'DD-MON-YY');

      RETURN v_nb_retour;
    END IF;

    IF (v_util IS NOT NULL AND v_date IS NULL) THEN

      SELECT count(*) INTO v_nb_retour
      FROM Details
      WHERE Termine_par = v_util;

      RETURN v_nb_retour;
    END IF;

    IF (v_util IS NOT NULL AND v_date IS NOT NULL) THEN

      SELECT count(*) INTO v_nb_retour
      FROM Details
      WHERE Termine_par = v_util
      AND to_date(Date_retour, 'DD-MON-YY') = to_date(v_date, 'DD-MON-YY');

      RETURN v_nb_retour;
    END IF;
  END;
/

FUNCTION AnalyseActivite (
  v_util IN VARCHAR2 DEFAULT NULL, v_date IN DATE DEFAULT NULL)
  RETURN NUMBER
  IS
    v_nb_emprunts NUMBER := 0;
    v_nb_retour NUMBER := 0;
  BEGIN
    IF (v_util IS NOT NULL AND v_date IS NOT NULL) THEN
      v_nb_emprunts := AnalyseActivite_emprunt(v_util, v_date);
      v_nb_retour := AnalyseActivite_detail(v_util, v_date);

      RETURN v_nb_emprunts + v_nb_retour;
    END IF;

    IF (v_util IS NOT NULL AND v_date IS NULL) THEN
      v_nb_emprunts := AnalyseActivite_emprunt(v_util);
      v_nb_retour := AnalyseActivite_detail(v_util);

      RETURN v_nb_emprunts + v_nb_retour;
    END IF;

    IF (v_util IS NULL AND v_date IS NOT NULL) THEN
      v_nb_emprunts := AnalyseActivite_emprunt(v_date);
      v_nb_retour := AnalyseActivite_detail(v_date);

      RETURN v_nb_emprunts + v_nb_retour;
    END IF;
  END;
/
