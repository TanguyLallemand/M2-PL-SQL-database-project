-- IV - 1 QUESTION : deja fait avant non?
-- IV - 2 THIS PIECE OF SHIT WORKS!!!!
DECLARE
    -- curseur avec la liste des membres expirés
    CURSOR c_membre_expi
        IS SELECT *
        FROM MEMBRE
        WHERE ADD_MONTHS(Date_adhesion, Duree) < sysdate FOR UPDATE;
    -- variable temp pour les membres de la liste
    v_membre_expi c_membre_expi%ROWTYPE;

    -- curseur pour les emprunts des membres expirés
    CURSOR c_emprunts_membre(v_ID_membre EMPRUNTS.ID_membre%TYPE := NULL)
        IS SELECT ID_emprunt, ID_membre
        FROM emprunts
        WHERE ID_membre = v_ID_membre FOR UPDATE of ID_membre;
    -- variable temp pour les emprunts de la liste
    v_emprunts_membre c_emprunts_membre%ROWTYPE;

    -- curseur pour les details d'un emprunt
    CURSOR c_detail_emprunt(v_ID_emprunt EMPRUNTS.ID_emprunt%TYPE)
        IS SELECT count(*) as coun
        FROM details
        WHERE Etat_Emprunt = 'EC' and ID_emprunt = v_ID_emprunt;

    -- variable temp pour les details des emprunts de la liste
    v_detail_emprunt c_detail_emprunt%ROWTYPE;

    -- boolean to know if we delete or not
    EC_present Boolean;
BEGIN
    BEGIN
        FOR v_membre_expi IN c_membre_expi
        LOOP
            EC_present := FALSE;
            dbms_output.put_line(v_membre_expi.nom);
            FOR v_emprunts_membre IN c_emprunts_membre(v_membre_expi.ID_membre)
            LOOP
                dbms_output.put_line(v_emprunts_membre.ID_emprunt);
                OPEN c_detail_emprunt(v_emprunts_membre.ID_emprunt);
                FETCH c_detail_emprunt INTO v_detail_emprunt;
                dbms_output.put_line(v_detail_emprunt.coun || 'cout');
                IF v_detail_emprunt.coun = 0 THEN
                    EC_present := TRUE;
                END IF;
                CLOSE c_detail_emprunt;
            END LOOP;
            IF EC_present = FALSE THEN
                FOR v_emprunts_membre IN c_emprunts_membre(v_membre_expi.ID_membre)
                LOOP
                    UPDATE EMPRUNTS SET ID_membre = NULL
                    WHERE CURRENT OF c_emprunts_membre;
                END LOOP;
                delete from membre where current of c_membre_expi;
            END IF;
        END LOOP;
    END;
    COMMIT;
END;
/
