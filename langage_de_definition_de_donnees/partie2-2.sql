-- IV - 1 QUESTION : deja fait avant non?
-- IV - 2
DECLARE
    -- curseur avec la liste des membres expirés
    CURSOR c_membre_expi
        IS SELECT *
        FROM MEMBRE
        WHERE ADD_MONTHS(Date_adhesion, Duree) < sysdate;
    -- variable temp pour les membres de la liste
    v_membre_expi c_membre_expi%ROWTYPE;

    -- curseur pour les emprunts des membres expirés
    CURSOR c_emprunts_membre(v_ID_membre EMPRUNTS.ID_membre%TYPE := NULL)
        IS SELECT ID_emprunt, ID_membre
        FROM emprunts
        WHERE ID_membre = v_ID_membre;
    -- variable temp pour les emprunts de la liste
    v_emprunts_membre c_emprunts_membre%ROWTYPE;

    -- curseur pour les details d'un emprunt
    CURSOR c_detail_emprunt(v_ID_emprunt EMPRUNTS.ID_emprunt%TYPE := NULL)
        IS SELECT I
    -- variable temp pour les details des emprunts de la liste
    v_detail_emprunt c_detail_emprunt%ROWTYPE;

BEGIN
    OPEN c_membre_expi;
    IF c_membre_expi%ISOPEN THEN
        BEGIN
            FOR v_membre_expi IN c_membre_expi
            LOOP
                OPEN c_emprunts_membre(v_membre_expi.ID_membre);
                FOR v_emprunts_membre IN c_emprunts_membre;
                LOOP
                    IF

                    IF END;
                END LOOP;
            END LOOP;
        END;
    ENDIF;
    CLOSE c_membre_expi;
END;
