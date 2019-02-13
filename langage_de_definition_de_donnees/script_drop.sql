--------------------------------------------------------------------------------
-- Delete tables
--------------------------------------------------------------------------------
DROP TABLE Ouvrage CASCADE CONSTRAINTS;
DROP TABLE Exemplaire CASCADE CONSTRAINTS;
DROP TABLE Membre CASCADE CONSTRAINTS;
DROP TABLE Emprunts CASCADE CONSTRAINTS;
DROP TABLE Genre CASCADE CONSTRAINTS;
DROP TABLE Details CASCADE CONSTRAINTS;
--------------------------------------------------------------------------------
-- Delete datas from recycle bin
--------------------------------------------------------------------------------
Purge TABLE Ouvrage;
Purge TABLE Exemplaire;
Purge TABLE Membre;
Purge TABLE Emprunts;
Purge TABLE Genre;
Purge TABLE Details;
--------------------------------------------------------------------------------
-- Delete views
--------------------------------------------------------------------------------
DROP VIEW Ouvrage_emprunte_depuis_2_sem;
DROP VIEW Nbr_ouvrage;
DROP VIEW Nbr_ouvrage_par_genre;
DROP VIEW Nbr_emprunt;
DROP VIEW Membre_ordre_alpha;
DROP VIEW Ouvrages_par_genre;
DROP VIEW Temps_moyen_emprunt_membre;
DROP VIEW Temps_moyen_emprunt_genre;
DROP VIEW Liste_des_ouvrages;
DROP VIEW Ouvrage_plus_populaire_12mois;
DROP VIEW Ouvrage_moins_populaire_3mois;
DROP VIEW Ouvrage_sans_neuf;
DROP VIEW Ouvrage_avec_public;
DROP VIEW Abondance_ouvrages;
--------------------------------------------------------------------------------
-- Delete few things to completly purge project
--------------------------------------------------------------------------------
DROP SYNONYM Abonnes;
DROP SEQUENCE Uniq_id_membre;
DROP SEQUENCE Uniq_id_emprunt;

--------------------------------------------------------------------------------
-- Delete packages
--------------------------------------------------------------------------------
DROP PACKAGE LIVRE;
DROP PACKAGE MAINTENANCE;
DROP PACKAGE INFOS;
