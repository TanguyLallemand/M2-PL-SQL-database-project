-- IV - 1 -- non fonctionnel
DECLARE
CURSOR C_exemplaire IS
SELECT * FROM Exemplaire FOR UPDATE OF Etat;
V_etat Exemplaire.Etat%TYPE;
V_nombre Number(3);
BEGIN
    FOR V_exemplaire IN C_exemplaire
    LOOP
        SELECT Count(*) INTO V_nombre
        FROM Details
        WHERE Details.Isbn=V_exemplaire.Isbn
        AND Details.Numero_exemplaire=V_exemplaire.Numero_exemplaire;
        IF (V_nombre<=10)
        THEN
            V_etat :='NE';
        ELSE IF (V_nombre<=25)
        THEN
            V_etat :='BO';
        ELSE IF (V_nombre<=40)
            THEN
                V_etat :='MO';
            ELSE
                V_etat :='MA';
            END IF;
        END IF;
    END IF;
    UPDATE Exemplaire SET Etat=V_etat WHERE CURRENT OF C_exemplaire;
END LOOP;
END;
/

-- IV - 2
DECLARE
    -- curseur avec la liste des membres expirés
    CURSOR C_membre_expi
        IS SELECT *
        FROM Membre
        WHERE Add_months(Date_adhesion, Duree) < Sysdate FOR UPDATE;
    -- variable temp pour les membres de la liste
    V_membre_expi C_membre_expi%Rowtype;

    -- curseur pour les emprunts des membres expirés
    CURSOR C_emprunts_membre(V_id_membre Emprunts.Id_membre%TYPE := NULL)
        IS SELECT Id_emprunt, Id_membre
        FROM Emprunts
        WHERE Id_membre = V_id_membre FOR UPDATE OF Id_membre;
    -- variable temp pour les emprunts de la liste
    V_emprunts_membre C_emprunts_membre%Rowtype;

    -- curseur pour les details d'un emprunt
    CURSOR C_detail_emprunt(V_id_emprunt Emprunts.Id_emprunt%TYPE)
        IS SELECT Count(*) AS Coun
        FROM Details
        WHERE Etat_emprunt = 'EC' AND Id_emprunt = V_id_emprunt;

    -- variable temp pour les details des emprunts de la liste
    V_detail_emprunt C_detail_emprunt%Rowtype;

    -- boolean to know if we delete or not
    Ec_present Boolean;
BEGIN
    BEGIN
        FOR V_membre_expi IN C_membre_expi
        LOOP
            Ec_present := FALSE;
            Dbms_output.Put_line(V_membre_expi.Nom);
            FOR V_emprunts_membre IN C_emprunts_membre(V_membre_expi.Id_membre)
            LOOP
                Dbms_output.Put_line(V_emprunts_membre.Id_emprunt);
                OPEN C_detail_emprunt(V_emprunts_membre.Id_emprunt);
                FETCH C_detail_emprunt INTO V_detail_emprunt;
                Dbms_output.Put_line(V_detail_emprunt.Coun || 'cout');
                IF V_detail_emprunt.Coun = 0 THEN
                    Ec_present := TRUE;
                END IF;
                CLOSE C_detail_emprunt;
            END LOOP;
            IF Ec_present = FALSE THEN
                FOR V_emprunts_membre IN C_emprunts_membre(V_membre_expi.Id_membre)
                LOOP
                    UPDATE Emprunts SET Id_membre := NULL
                    WHERE CURRENT OF C_emprunts_membre;
                END LOOP;
                DELETE FROM Membre WHERE CURRENT OF C_membre_expi;
            END IF;
        END LOOP;
    END;
    COMMIT;
END;
/
-- IV - 3 -- TODO repasser en plsql
-- selectionne les ID de 3 membres qui ont le plus emprunté ça me casse les couille je laisse en plan pour le moment
SELECT Id_membre
FROM (SELECT Id_membre, Sum(Cou)
        FROM Emprunts JOIN (SELECT Id_emprunt, Count(*) AS Cou
                        FROM Details
                        GROUP BY Id_emprunt
                        ORDER BY Id_emprunt) Tttt
                    ON Emprunts.Id_emprunt = Tttt.Id_emprunt
        WHERE Add_months(Sysdate, -10) < Cree_le
        GROUP BY Id_membre
        ORDER BY Sum(Cou))
WHERE rownum <= 3

-- IV - 4 -- TODO repasser en plsql
SELECT *
FROM Ouvrage
WHERE Isbn IN (
  SELECT Isbn
  FROM Details
  GROUP BY Isbn
  ORDER BY Count(*) DESC
  FETCH FIRST 5 ROWS ONLY);
-- IV - 5 -- TODO repasser en plsql
SELECT *
FROM Membre
WHERE Add_months(Date_adhesion, Duree) < (Sysdate+30)
-- IV - 8 -- supprime les membres qui n'ont pas emprunté depuis 3 ans ou bien jamais emprunté
DECLARE
CURSOR C_membre_sans_emprunt IS
SELECT Id_membre
FROM Membre
WHERE Id_membre NOT IN
(SELECT Unique(Id_membre) AS Idtest
FROM
    (SELECT Id_membre, Max(Cree_le) AS Dernier_emprunt
    FROM Emprunts
    GROUP BY Id_membre)
WHERE Dernier_emprunt > Add_months(Sysdate, 12*-3));

    V_membre_sans_emprunt C_membre_sans_emprunt%Rowtype;

BEGIN
    FOR V_membre_sans_emprunt IN C_membre_sans_emprunt LOOP
        UPDATE Emprunts SET Id_membre = NULL
        WHERE Id_membre = V_membre_sans_emprunt.Id_membre;
        DELETE FROM Membre WHERE Id_membre = V_membre_sans_emprunt.Id_membre;
    END LOOP;
    COMMIT;
END;
/
