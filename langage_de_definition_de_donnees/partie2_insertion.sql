-- Projet de gestion de base de données
-- Fresnais Louison, Courtin François, Lallemand Tanguy, Cruard Jonathan
-- PARTIE 2:

-- QUESTION 1:

INSERT INTO Genre VALUES ('REC', 'Récit');
INSERT INTO Genre VALUES ('POL', 'Policier');
INSERT INTO Genre VALUES ('BD', 'Bande Dessinée');
INSERT INTO Genre VALUES ('INF', 'Informatique');
INSERT INTO Genre VALUES ('THE', 'Théatre');
INSERT INTO Genre VALUES ('ROM', 'Roman');

-- ISBN Titre Auteur Genre Editeur pk_Ouvrage
INSERT INTO Ouvrage VALUES ('2203314168', 'LEFRANC-Lultimatum','Martin, Carin','BD','Casterman');
INSERT INTO Ouvrage VALUES ('2746021285','HTML – entraînez-vous pour
maîtriser le code source','Luc Van Lancker','INF','ENI');
INSERT INTO Ouvrage VALUES ('2746026090','Oracle 10g SQL, PL/SQL,
SQL*Plus','J. Gabillaud','INF','ENI');
INSERT INTO Ouvrage VALUES ('2266085816','Pantagruel','F. Robert','ROM','Pocket');
INSERT INTO Ouvrage VALUES ('2266091611','Voyage au centre de la terre','Jules VERNE','ROM','Pocket');
INSERT INTO Ouvrage VALUES ('2253010219','Le crime de l’Orient Express','Agatha Christie','POL','Livre de Poche');
INSERT INTO Ouvrage VALUES ('2070400816','Le Bourgois gentilhomme','Molière','THE','Gallimard');
INSERT INTO Ouvrage VALUES ('2070397177','Le curé de Tours','Honoré de Balzac','ROM','Gallimard');
INSERT INTO Ouvrage VALUES ('2080720872','Boule de suif','G. de Maupassant','REC','Flammarion');
INSERT INTO Ouvrage VALUES ('2877065073','La gloire de mon père','Marcel Pagnol','ROM','Fallois');
INSERT INTO Ouvrage VALUES ('2020549522','L’aventure des manuscrits de la mer morte', DEFAULT,'REC','Seuil');
INSERT INTO Ouvrage VALUES ('2253006327','Vingt mille lieues sous les mers','Jules Verne','ROM','LGF');
INSERT INTO Ouvrage VALUES ('2038704015','De la terre à la lune','Jules Verne','ROM','Larousse');

-- ISBN Numero etat
INSERT INTO Exemplaire VALUES ('2203314168','1','MO',DEFAULT,DEFAULT);
INSERT INTO Exemplaire VALUES ('2203314168','2','BO',DEFAULT,DEFAULT);
INSERT INTO Exemplaire VALUES ('2203314168','3','NE',DEFAULT,DEFAULT);
INSERT INTO Exemplaire VALUES ('2746021285','1','BO',DEFAULT,DEFAULT);
INSERT INTO Exemplaire VALUES ('2746026090','1','BO',DEFAULT,DEFAULT);
INSERT INTO Exemplaire VALUES ('2746026090','2','MO',DEFAULT,DEFAULT);
INSERT INTO Exemplaire VALUES ('2266085816','1','BO',DEFAULT,DEFAULT);
INSERT INTO Exemplaire VALUES ('2266085816','2','MO',DEFAULT,DEFAULT);
INSERT INTO Exemplaire VALUES ('2266091611','1','BO',DEFAULT,DEFAULT);
INSERT INTO Exemplaire VALUES ('2266091611','2','MO',DEFAULT,DEFAULT);
INSERT INTO Exemplaire VALUES ('2253010219','1','BO',DEFAULT,DEFAULT);
INSERT INTO Exemplaire VALUES ('2253010219','2','MO',DEFAULT,DEFAULT);
INSERT INTO Exemplaire VALUES ('2070400816','1','BO',DEFAULT,DEFAULT);
INSERT INTO Exemplaire VALUES ('2070400816','2','MO',DEFAULT,DEFAULT);
INSERT INTO Exemplaire VALUES ('2070397177','1','BO',DEFAULT,DEFAULT);
INSERT INTO Exemplaire VALUES ('2070397177','2','MO',DEFAULT,DEFAULT);
INSERT INTO Exemplaire VALUES ('2080720872','1','BO',DEFAULT,DEFAULT);
INSERT INTO Exemplaire VALUES ('2080720872','2','MO',DEFAULT,DEFAULT);
INSERT INTO Exemplaire VALUES ('2877065073','1','BO',DEFAULT,DEFAULT);
INSERT INTO Exemplaire VALUES ('2877065073','2','MO',DEFAULT,DEFAULT);
INSERT INTO Exemplaire VALUES ('2020549522','1','BO',DEFAULT,DEFAULT);
INSERT INTO Exemplaire VALUES ('2020549522','2','MO',DEFAULT,DEFAULT);
INSERT INTO Exemplaire VALUES ('2253006327','1','BO',DEFAULT,DEFAULT);
INSERT INTO Exemplaire VALUES ('2253006327','2','MO',DEFAULT,DEFAULT);
INSERT INTO Exemplaire VALUES ('2038704015','1','BO',DEFAULT,DEFAULT);
INSERT INTO Exemplaire VALUES ('2038704015','2','MO',DEFAULT,DEFAULT);

-- QUESTION 2:
INSERT INTO Membre VALUES (Uniq_id_membre.Nextval,'Albert','Anne','13 rue des alpes','0601020304',Sysdate-60,1);
INSERT INTO Membre VALUES (Uniq_id_membre.Nextval,'Bernaud','Barnabé','6 rue des bécasses','0602030105',Sysdate-10,3);
INSERT INTO Membre VALUES (Uniq_id_membre.Nextval,'Cuvard','Camille','53 rue des cerisiers','0602010509',Sysdate-100,6);
INSERT INTO Membre VALUES (Uniq_id_membre.Nextval,'Dupond','Daniel','11 rue des daims','0610236515',Sysdate-250,12);
INSERT INTO Membre VALUES (Uniq_id_membre.Nextval,'Evroux','Eglantine','34 rue des elfes','0658963125',Sysdate-150,6);
INSERT INTO Membre VALUES (Uniq_id_membre.Nextval,'Fregeon','Fernand','11 rue des Francs','0602036987',Sysdate-400,6);
INSERT INTO Membre VALUES (Uniq_id_membre.Nextval,'Gorit','Gaston','96 rue de la glacerie','0684235781',Sysdate-150,1);
INSERT INTO Membre VALUES (Uniq_id_membre.Nextval,'Hevard','Hector','12 rue haute','0608546578',Sysdate-250,12);
INSERT INTO Membre VALUES (Uniq_id_membre.Nextval,'Ingrand','Irène','54 rue de iris','0605020409',Sysdate-50,12);
INSERT INTO Membre VALUES (Uniq_id_membre.Nextval,'Juste','Julien','5 place des Jacobins','0603069876',Sysdate-100,6);

-- QUESTION 3:
INSERT INTO Emprunts VALUES (Uniq_id_emprunt.Nextval,1,Sysdate-200,DEFAULT);
INSERT INTO Emprunts VALUES (Uniq_id_emprunt.Nextval,3,Sysdate-190,DEFAULT);
INSERT INTO Emprunts VALUES (Uniq_id_emprunt.Nextval,4,Sysdate-180,DEFAULT);
INSERT INTO Emprunts VALUES (Uniq_id_emprunt.Nextval,1,Sysdate-170,DEFAULT);
INSERT INTO Emprunts VALUES (Uniq_id_emprunt.Nextval,5,Sysdate-160,DEFAULT);
INSERT INTO Emprunts VALUES (Uniq_id_emprunt.Nextval,2,Sysdate-150,DEFAULT);
INSERT INTO Emprunts VALUES (Uniq_id_emprunt.Nextval,4,Sysdate-140,DEFAULT);
INSERT INTO Emprunts VALUES (Uniq_id_emprunt.Nextval,1,Sysdate-130,DEFAULT);
INSERT INTO Emprunts VALUES (Uniq_id_emprunt.Nextval,9,Sysdate-120,DEFAULT);
INSERT INTO Emprunts VALUES (Uniq_id_emprunt.Nextval,6,Sysdate-110,DEFAULT);
INSERT INTO Emprunts VALUES (Uniq_id_emprunt.Nextval,1,Sysdate-100,DEFAULT);
INSERT INTO Emprunts VALUES (Uniq_id_emprunt.Nextval,6,Sysdate-90,DEFAULT);
INSERT INTO Emprunts VALUES (Uniq_id_emprunt.Nextval,2,Sysdate-80,DEFAULT);
INSERT INTO Emprunts VALUES (Uniq_id_emprunt.Nextval,4,Sysdate-70,DEFAULT);
INSERT INTO Emprunts VALUES (Uniq_id_emprunt.Nextval,1,Sysdate-60,DEFAULT);
INSERT INTO Emprunts VALUES (Uniq_id_emprunt.Nextval,3,Sysdate-50,DEFAULT);
INSERT INTO Emprunts VALUES (Uniq_id_emprunt.Nextval,1,Sysdate-40,DEFAULT);
INSERT INTO Emprunts VALUES (Uniq_id_emprunt.Nextval,5,Sysdate-30,DEFAULT);
INSERT INTO Emprunts VALUES (Uniq_id_emprunt.Nextval,4,Sysdate-20,DEFAULT);
INSERT INTO Emprunts VALUES (Uniq_id_emprunt.Nextval,1,Sysdate-10,DEFAULT);

INSERT INTO Details VALUES (1,1,'2038704015',1,Sysdate-190);
INSERT INTO Details VALUES (1,2,'2070367177',2,Sysdate-190);
INSERT INTO Details VALUES (2,1,'2080720872',1,Sysdate-180);
INSERT INTO Details VALUES (2,2,'2203314168',1,Sysdate-179);
INSERT INTO Details VALUES (3,1,'2038704015',1,Sysdate-170);
INSERT INTO Details VALUES (4,1,'2203314168',2,Sysdate-155);
INSERT INTO Details VALUES (4,2,'2080720872',1,Sysdate-155);
INSERT INTO Details VALUES (4,3,'2266085816',1,Sysdate-159);
INSERT INTO Details VALUES (5,1,'2038704015',2,Sysdate-140);
INSERT INTO Details VALUES (6,1,'2266085816',2,Sysdate-141);
INSERT INTO Details VALUES (6,2,'2080720872',2,Sysdate-130);
INSERT INTO Details VALUES (6,3,'2746021285',2,Sysdate-133);
INSERT INTO Details VALUES (7,1,'2070367177',2,Sysdate-100);
INSERT INTO Details VALUES (8,1,'2080720872',1,Sysdate-116);
INSERT INTO Details VALUES (9,1,'2038704015',1,Sysdate-100);
INSERT INTO Details VALUES (10,1,'2080720872',2,Sysdate-107);
INSERT INTO Details VALUES (10,2,'2746026090',1,Sysdate-78);
INSERT INTO Details VALUES (11,1,'2746021285',1,Sysdate-81);
INSERT INTO Details VALUES (12,1,'2203314168',1,Sysdate-86);
INSERT INTO Details VALUES (12,2,'2038704015',1,Sysdate-60);
INSERT INTO Details VALUES (13,1,'2070367177',1,Sysdate-65);
INSERT INTO Details VALUES (14,1,'2266091611',1,Sysdate-66);
INSERT INTO Details VALUES (15,1,'2266085816',1,Sysdate-50);
INSERT INTO Details VALUES (16,1,'2253010219',2,Sysdate-41);
INSERT INTO Details VALUES (16,2,'2070367177',2,Sysdate-41);
INSERT INTO Details VALUES (17,1,'2877065073',2,Sysdate-36);
INSERT INTO Details VALUES (18,1,'2070367177',1,Sysdate-14);
INSERT INTO Details VALUES (19,1,'2746026090',1,Sysdate-12);
INSERT INTO Details VALUES (20,1,'2266091611',1,DEFAULT);
INSERT INTO Details VALUES (20,2,'2253010219',1,DEFAULT);

--------------------------------------------------------------------------------
-- Altération des tables
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Altération des tables nécessaire au bon fonctionnement des triggers.
--------------------------------------------------------------------------------

ALTER TABLE Emprunts
ADD (Cree_par VARCHAR2(20) DEFAULT user);

ALTER TABLE Details
ADD (Termine_par VARCHAR2(20) DEFAULT user);
