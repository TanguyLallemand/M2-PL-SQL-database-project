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


CREATE OR REPLACE PACKAGE BODY 



END Livre;
/
