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
-- IV - 3

SET Serveroutput ON
DECLARE
    CURSOR C_order_croissant IS
        SELECT Emprunts.Id_membre, Count(*)
        FROM Emprunts, Details
        WHERE Emprunts.Id_emprunt=Details.Id_emprunt AND Months_between(Sysdate, Emprunts.Cree_le) <=10
        GROUP BY Emprunts.Id_membre
        ORDER BY 1 ASC;

    CURSOR C_order_decroissant IS
        SELECT Emprunts.Id_membre, Count(*)
        FROM Emprunts, Details
        WHERE Emprunts.Id_emprunt=Details.Id_emprunt AND Months_between(Sysdate, Emprunts.Cree_le) <=10
        GROUP BY Emprunts.Id_membre
        ORDER BY 1 DESC;

    V_reception C_order_croissant%Rowtype;
    Iterator number;
    V_membre Membre%Rowtype;
BEGIN
    Dbms_output.Put_line('Membres empruntant le moins:');
    OPEN C_order_croissant;
    FOR Iterator IN 1..3 LOOP
        FETCH C_order_croissant INTO V_reception;
        IF C_order_croissant%NOTFOUND
        THEN Exit;
        END IF;
        SELECT * INTO V_membre
        FROM Membre
        WHERE Id_membre=V_reception.Id_membre;
        Dbms_output.Put_line(Iterator||': Nombre d emprunts: ' ||V_membre.Id_membre||' Nom:   '||V_membre.Nom);
    END LOOP;
    CLOSE C_order_croissant;


    Dbms_output.Put_line('Membres empruntant le plus:');
    OPEN C_order_decroissant;
    FOR Iterator IN 1..3 LOOP
        FETCH C_order_decroissant INTO V_reception;
        IF C_order_decroissant%NOTFOUND
        THEN Exit;
        END IF;
        SELECT * INTO V_membre
        FROM Membre
        WHERE Id_membre=V_reception.Id_membre;
        Dbms_output.Put_line(Iterator||': Nombre d emprunts: ' ||V_membre.Id_membre||' Nom:   '||V_membre.Nom);
    END LOOP;
    CLOSE C_order_decroissant;
END;
/

-- IV - 4 --
DECLARE
    CURSOR C_ouvrages IS
    SELECT Isbn, Count(*) AS Numbre_emprunts
    FROM Details
    GROUP BY Isbn
    ORDER BY 2 DESC;

    V_ouvrage C_ouvrages%Rowtype;
    Iterator number;
BEGIN
    OPEN C_ouvrages;
    FOR Iterator IN 1..5 LOOP
        FETCH C_ouvrages INTO V_ouvrage;
        Dbms_output.Put_line('Numero: ' ||Iterator||' Isbn: '||V_ouvrage.Isbn);
    END LOOP;
    CLOSE C_ouvrages;
END;
/

-- IV - 5 -- J ai refait la requete, plus otpimisé qu un bloc pl/sql a voir...
SELECT Numero, Nom
FROM Membre
WHERE Add_months(Date_adhesion, Duree) < (Sysdate+30);

-- IV - 6 --

-- alteration de la table pour supporter la nouvelle approche
ALTER TABLE Exemplaire Add(Nombre_emprunts Number(3) DEFAULT 0, Datecalculemprunt date DEFAULT Sysdate);
-- Mise a jour de la TABLE
UPDATE Exemplaire SET Datecalculemprunt=(
    SELECT Min(Cree_le)
    FROM Emprunts, Details
    WHERE Emprunts.Id_emprunt=Details.Id_emprunt
    AND Details.Isbn=Exemplaire.Numero_exemplaire
    );
    UPDATE Exemplaire SET Datecalculemprunt = Sysdate
    WHERE Datecalculemprunt IS NULL;
    COMMIT;
-- Mise a jour des informations du nombre d'emprunts et de l'etat des ouvrages
DECLARE
    CURSOR C_exemplaire IS
        SELECT * FROM Exemplaire
        FOR UPDATE OF Nombre_emprunts, Datecalculemprunt;
    V_nombre_emprunts Exemplaire.Nombre_emprunts%TYPE;
BEGIN
    FOR V_exemplaire IN C_exemplaire LOOP
        SELECT Count(*) INTO V_nombre_emprunts
        FROM Details, Emprunts
        WHERE Details.Id_emprunt=Emprunts.Id_emprunt
            AND Isbn=V_exemplaire.Numero_exemplaire
            AND Cree_le>=V_exemplaire.Datecalculemprunt;
        UPDATE Exemplaire SET Nombre_emprunts=Nombre_emprunts+V_nombre_emprunts, Datecalculemprunt = Sysdate
        WHERE CURRENT OF C_exemplaire;
        UPDATE Exemplaire SET Etat='Neuf'
        WHERE Nombre_emprunts<=10;
        UPDATE Exemplaire SET Etat='Bon'
        WHERE Nombre_emprunts BETWEEN 11 AND 25;
        UPDATE Exemplaire SET Etat='Moyen'
        WHERE Nombre_emprunts BETWEEN 26 AND 40;
        UPDATE Exemplaire SET Etat='Mauvais'
        WHERE Nombre_emprunts >=41;
        END LOOP
        COMMIT;
    end;
/
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
