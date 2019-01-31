-- PARTIE 2:

-- QUESTION 1:

INSERT INTO GENRE VALUES ('REC', 'Récit');
INSERT INTO GENRE VALUES ('POL', 'Policier');
INSERT INTO GENRE VALUES ('BD', 'Bande Dessinée');
INSERT INTO GENRE VALUES ('INF', 'Informatique');
INSERT INTO GENRE VALUES ('THE', 'Théatre');
INSERT INTO GENRE VALUES ('ROM', 'Roman');

-- ISBN Titre Auteur Genre Editeur pk_Ouvrage
INSERT INTO OUVRAGE VALUES ('2203314168', 'LEFRANC-Lultimatum','Martin, Carin','BD','Casterman');
INSERT INTO OUVRAGE VALUES ('2746021285','HTML – entraînez-vous pour
maîtriser le code source','Luc Van Lancker','INF','ENI');
INSERT INTO OUVRAGE VALUES ('2746026090','Oracle 10g SQL, PL/SQL,
SQL*Plus','J. Gabillaud','INF','ENI');
INSERT INTO OUVRAGE VALUES ('2266085816','Pantagruel','F. Robert','ROM','Pocket');
INSERT INTO OUVRAGE VALUES ('2266091611','Voyage au centre de la terre','Jules VERNE','ROM','Pocket');
INSERT INTO OUVRAGE VALUES ('2253010219','Le crime de l’Orient Express','Agatha Christie','POL','Livre de Poche');
INSERT INTO OUVRAGE VALUES ('2070400816','Le Bourgois gentilhomme','Molière','THE','Gallimard');
INSERT INTO OUVRAGE VALUES ('2070397177','Le curé de Tours','Honoré de Balzac','ROM','Gallimard');
INSERT INTO OUVRAGE VALUES ('2080720872','Boule de suif','G. de Maupassant','REC','Flammarion');
INSERT INTO OUVRAGE VALUES ('2877065073','La gloire de mon père','Marcel Pagnol','ROM','Fallois');
INSERT INTO OUVRAGE VALUES ('2020549522','L’aventure des manuscrits de la mer morte', default,'REC','Seuil');
INSERT INTO OUVRAGE VALUES ('2253006327','Vingt mille lieues sous les mers','Jules Verne','ROM','LGF');
INSERT INTO OUVRAGE VALUES ('2038704015','De la terre à la lune','Jules Verne','ROM','Larousse');

-- ISBN Numero etat
INSERT INTO EXEMPLAIRE VALUES ('2203314168','1','Moyen');
INSERT INTO EXEMPLAIRE VALUES ('2203314168','2','Bon');
INSERT INTO EXEMPLAIRE VALUES ('2203314168','3','Neuf');
INSERT INTO EXEMPLAIRE VALUES ('2746021285','1','Bon');
INSERT INTO EXEMPLAIRE VALUES ('2746026090','1','Bon');
INSERT INTO EXEMPLAIRE VALUES ('2746026090','2','Moyen');
INSERT INTO EXEMPLAIRE VALUES ('2266085816','1','Bon');
INSERT INTO EXEMPLAIRE VALUES ('2266085816','2','Moyen');
INSERT INTO EXEMPLAIRE VALUES ('2266091611','1','Bon');
INSERT INTO EXEMPLAIRE VALUES ('2266091611','2','Moyen');
INSERT INTO EXEMPLAIRE VALUES ('2253010219','1','Bon');
INSERT INTO EXEMPLAIRE VALUES ('2253010219','2','Moyen');
INSERT INTO EXEMPLAIRE VALUES ('2070400816','1','Bon');
INSERT INTO EXEMPLAIRE VALUES ('2070400816','2','Moyen');
INSERT INTO EXEMPLAIRE VALUES ('2070397177','1','Bon');
INSERT INTO EXEMPLAIRE VALUES ('2070397177','2','Moyen');
INSERT INTO EXEMPLAIRE VALUES ('2080720872','1','Bon');
INSERT INTO EXEMPLAIRE VALUES ('2080720872','2','Moyen');
INSERT INTO EXEMPLAIRE VALUES ('2877065073','1','Bon');
INSERT INTO EXEMPLAIRE VALUES ('2877065073','2','Moyen');
INSERT INTO EXEMPLAIRE VALUES ('2020549522','1','Bon');
INSERT INTO EXEMPLAIRE VALUES ('2020549522','2','Moyen');
INSERT INTO EXEMPLAIRE VALUES ('2253006327','1','Bon');
INSERT INTO EXEMPLAIRE VALUES ('2253006327','2','Moyen');
INSERT INTO EXEMPLAIRE VALUES ('2038704015','1','Bon');
INSERT INTO EXEMPLAIRE VALUES ('2038704015','2','Moyen');

-- QUESTION 2:
INSERT INTO MEMBRE VALUES (uniq_id_membre.nextval,'Albert','Anne','13 rue des alpes','0601020304',Sysdate-60,1);
INSERT INTO MEMBRE VALUES (uniq_id_membre.nextval,'Bernaud','Barnabé','6 rue des bécasses','0602030105',Sysdate-10,3);
INSERT INTO MEMBRE VALUES (uniq_id_membre.nextval,'Cuvard','Camille','53 rue des cerisiers','0602010509',Sysdate-100,6);
INSERT INTO MEMBRE VALUES (uniq_id_membre.nextval,'Dupond','Daniel','11 rue des daims','0610236515',Sysdate-250,12);
INSERT INTO MEMBRE VALUES (uniq_id_membre.nextval,'Evroux','Eglantine','34 rue des elfes','0658963125',Sysdate-150,6);
INSERT INTO MEMBRE VALUES (uniq_id_membre.nextval,'Fregeon','Fernand','11 rue des Francs','0602036987',Sysdate-400,6);
INSERT INTO MEMBRE VALUES (uniq_id_membre.nextval,'Gorit','Gaston','96 rue de la glacerie','0684235781',Sysdate-150,1);
INSERT INTO MEMBRE VALUES (uniq_id_membre.nextval,'Hevard','Hector','12 rue haute','0608546578',Sysdate-250,12);
INSERT INTO MEMBRE VALUES (uniq_id_membre.nextval,'Ingrand','Irène','54 rue de iris','0605020409',Sysdate-50,12);
INSERT INTO MEMBRE VALUES (uniq_id_membre.nextval,'Juste','Julien','5 place des Jacobins','0603069876',Sysdate-100,6);

-- QUESTION 3:
INSERT INTO EMPRUNTS VALUES (uniq_id_emprunt.nextval,1,Sysdate-200);
INSERT INTO EMPRUNTS VALUES (uniq_id_emprunt.nextval,3,Sysdate-190);
INSERT INTO EMPRUNTS VALUES (uniq_id_emprunt.nextval,4,Sysdate-180);
INSERT INTO EMPRUNTS VALUES (uniq_id_emprunt.nextval,1,Sysdate-170);
INSERT INTO EMPRUNTS VALUES (uniq_id_emprunt.nextval,5,Sysdate-160);
INSERT INTO EMPRUNTS VALUES (uniq_id_emprunt.nextval,2,Sysdate-150);
INSERT INTO EMPRUNTS VALUES (uniq_id_emprunt.nextval,4,Sysdate-140);
INSERT INTO EMPRUNTS VALUES (uniq_id_emprunt.nextval,1,Sysdate-130);
INSERT INTO EMPRUNTS VALUES (uniq_id_emprunt.nextval,9,Sysdate-120);
INSERT INTO EMPRUNTS VALUES (uniq_id_emprunt.nextval,6,Sysdate-110);
INSERT INTO EMPRUNTS VALUES (uniq_id_emprunt.nextval,1,Sysdate-100);
INSERT INTO EMPRUNTS VALUES (uniq_id_emprunt.nextval,6,Sysdate-90);
INSERT INTO EMPRUNTS VALUES (uniq_id_emprunt.nextval,2,Sysdate-80);
INSERT INTO EMPRUNTS VALUES (uniq_id_emprunt.nextval,4,Sysdate-70);
INSERT INTO EMPRUNTS VALUES (uniq_id_emprunt.nextval,1,Sysdate-60);
INSERT INTO EMPRUNTS VALUES (uniq_id_emprunt.nextval,3,Sysdate-50);
INSERT INTO EMPRUNTS VALUES (uniq_id_emprunt.nextval,1,Sysdate-40);
INSERT INTO EMPRUNTS VALUES (uniq_id_emprunt.nextval,5,Sysdate-30);
INSERT INTO EMPRUNTS VALUES (uniq_id_emprunt.nextval,4,Sysdate-20);
INSERT INTO EMPRUNTS VALUES (uniq_id_emprunt.nextval,1,Sysdate-10);

INSERT INTO DETAILS VALUES (1,1,'2038704015',1,Sysdate-195,default);
INSERT INTO DETAILS VALUES (1,2,'2070367177',2,Sysdate-190,default);
INSERT INTO DETAILS VALUES (2,1,'2080720872',1,Sysdate-180,default);
INSERT INTO DETAILS VALUES (2,2,'2203314168',1,Sysdate-179,default);
INSERT INTO DETAILS VALUES (3,1,'2038704015',1,Sysdate-170,default);
INSERT INTO DETAILS VALUES (4,1,'2203314168',2,Sysdate-155,default);
INSERT INTO DETAILS VALUES (4,2,'2080720872',1,Sysdate-155,default);
INSERT INTO DETAILS VALUES (4,3,'2266085816',1,Sysdate-159,default);
INSERT INTO DETAILS VALUES (5,1,'2038704015',2,Sysdate-140,default);
INSERT INTO DETAILS VALUES (6,1,'2266085816',2,Sysdate-141,default);
INSERT INTO DETAILS VALUES (6,2,'2080720872',2,Sysdate-130,default);
INSERT INTO DETAILS VALUES (6,3,'2746021285',2,Sysdate-133,default);
INSERT INTO DETAILS VALUES (7,1,'2070367177',2,Sysdate-100,default);
INSERT INTO DETAILS VALUES (8,1,'2080720872',1,Sysdate-116,default);
INSERT INTO DETAILS VALUES (9,1,'2038704015',1,Sysdate-100,default);
INSERT INTO DETAILS VALUES (10,1,'2080720872',2,Sysdate-107,default);
INSERT INTO DETAILS VALUES (10,2,'2746026090',1,Sysdate-78,default);
INSERT INTO DETAILS VALUES (11,1,'2746021285',1,Sysdate-81,default);
INSERT INTO DETAILS VALUES (12,1,'2203314168',1,Sysdate-86,default);
INSERT INTO DETAILS VALUES (12,2,'2038704015',1,Sysdate-60,default);
INSERT INTO DETAILS VALUES (13,1,'2070367177',1,Sysdate-65,default);
INSERT INTO DETAILS VALUES (14,1,'2266091611',1,Sysdate-66,default);
INSERT INTO DETAILS VALUES (15,1,'2266085816',1,Sysdate-50,default);
INSERT INTO DETAILS VALUES (16,1,'2253010219',2,Sysdate-41,default);
INSERT INTO DETAILS VALUES (16,2,'2070367177',2,Sysdate-41,default);
INSERT INTO DETAILS VALUES (17,1,'2877065073',2,Sysdate-36,default);
INSERT INTO DETAILS VALUES (18,1,'2070367177',1,Sysdate-14,default);
INSERT INTO DETAILS VALUES (19,1,'2746026090',1,Sysdate-12,default);
INSERT INTO DETAILS VALUES (20,1,'2266091611',1,default,default);
INSERT INTO DETAILS VALUES (20,2,'2253010219',1,default,default);
