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
INSERT INTO MEMBRE VALUES (default,'Albert','Anne','13 rue des alpes','0601020304',Sysdate-60,1);
INSERT INTO MEMBRE VALUES (default,'Bernaud','Barnabé','6 rue des bécasses','0602030105',Sysdate-10,3);
INSERT INTO MEMBRE VALUES (default,'Cuvard','Camille','53 rue des cerisiers','0602010509',Sysdate-100,6);
INSERT INTO MEMBRE VALUES (default,'Dupond','Daniel','11 rue des daims','0610236515',Sysdate-250,12);
INSERT INTO MEMBRE VALUES (default,'Evroux','Eglantine','34 rue des elfes','0658963125',Sysdate-150,6);
INSERT INTO MEMBRE VALUES (default,'Fregeon','Fernand','11 rue des Francs','0602036987',Sysdate-400,6);
INSERT INTO MEMBRE VALUES (default,'Gorit','Gaston','96 rue de la glacerie','0684235781',Sysdate-150,1);
INSERT INTO MEMBRE VALUES (default,'Hevard','Hector','12 rue haute','0608546578',Sysdate-250,12);
INSERT INTO MEMBRE VALUES (default,'Ingrand','Irène','54 rue de iris','0605020409',Sysdate-50,12);
INSERT INTO MEMBRE VALUES (default,'Juste','Julien','5 place des Jacobins','0603069876',Sysdate-100,6);

-- QUESTION 3:
INSERT INTO EMPRUNTS VALUES (default ,1,Sysdate-200, default);
INSERT INTO EMPRUNTS VALUES (default ,3,Sysdate-190, default);
INSERT INTO EMPRUNTS VALUES (default ,4,Sysdate-180, default);
INSERT INTO EMPRUNTS VALUES (default ,1,Sysdate-170, default);
INSERT INTO EMPRUNTS VALUES (default ,5,Sysdate-160, default);
INSERT INTO EMPRUNTS VALUES (default ,2,Sysdate-150, default);
INSERT INTO EMPRUNTS VALUES (default ,4,Sysdate-140, default);
INSERT INTO EMPRUNTS VALUES (default ,1,Sysdate-130, default);
INSERT INTO EMPRUNTS VALUES (default ,9,Sysdate-120, default);
INSERT INTO EMPRUNTS VALUES (default ,6,Sysdate-110, default);
INSERT INTO EMPRUNTS VALUES (default ,1,Sysdate-100, default);
INSERT INTO EMPRUNTS VALUES (default ,6,Sysdate-90, default);
INSERT INTO EMPRUNTS VALUES (default ,2,Sysdate-80, default);
INSERT INTO EMPRUNTS VALUES (default ,4,Sysdate-70, default);
INSERT INTO EMPRUNTS VALUES (default ,1,Sysdate-60, default);
INSERT INTO EMPRUNTS VALUES (default ,3,Sysdate-50, default);
INSERT INTO EMPRUNTS VALUES (default ,1,Sysdate-40, default);
INSERT INTO EMPRUNTS VALUES (default ,5,Sysdate-30, default);
INSERT INTO EMPRUNTS VALUES (default ,4,Sysdate-20, default);
INSERT INTO EMPRUNTS VALUES (default ,1,Sysdate-10, default);

INSERT INTO DETAILS VALUES (1,1,'2038704015',1,Sysdate-195);
INSERT INTO DETAILS VALUES (1,2,'2070367177',2,Sysdate-190);
INSERT INTO DETAILS VALUES (2,1,'2080720872',1,Sysdate-180);
INSERT INTO DETAILS VALUES (2,2,'2203314168',1,Sysdate-179);
INSERT INTO DETAILS VALUES (3,1,'2038704015',1,Sysdate-170);
INSERT INTO DETAILS VALUES (4,1,'2203314168',2,Sysdate-155);
INSERT INTO DETAILS VALUES (4,2,'2080720872',1,Sysdate-155);
INSERT INTO DETAILS VALUES (4,3,'2266085816',1,Sysdate-159);
INSERT INTO DETAILS VALUES (5,1,'2038704015',2,Sysdate-140);
INSERT INTO DETAILS VALUES (6,1,'2266085816',2,Sysdate-141);
INSERT INTO DETAILS VALUES (6,2,'2080720872',2,Sysdate-130);
INSERT INTO DETAILS VALUES (6,3,'2746021285',2,Sysdate-133);
INSERT INTO DETAILS VALUES (7,1,'2070367177',2,Sysdate-100);
INSERT INTO DETAILS VALUES (8,1,'2080720872',1,Sysdate-116);
INSERT INTO DETAILS VALUES (9,1,'2038704015',1,Sysdate-100);
INSERT INTO DETAILS VALUES (10,1,'2080720872',2,Sysdate-107);
INSERT INTO DETAILS VALUES (10,2,'2746026090',1,Sysdate-78);
INSERT INTO DETAILS VALUES (11,1,'2746021285',1,Sysdate-81);
INSERT INTO DETAILS VALUES (12,1,'2203314168',1,Sysdate-86);
INSERT INTO DETAILS VALUES (12,2,'2038704015',1,Sysdate-60);
INSERT INTO DETAILS VALUES (13,1,'2070367177',1,Sysdate-65);
INSERT INTO DETAILS VALUES (14,1,'2266091611',1,Sysdate-66);
INSERT INTO DETAILS VALUES (15,1,'2266085816',1,Sysdate-50);
INSERT INTO DETAILS VALUES (16,1,'2253010219',2,Sysdate-41);
INSERT INTO DETAILS VALUES (16,2,'2070367177',2,Sysdate-41);
INSERT INTO DETAILS VALUES (17,1,'2877065073',2,Sysdate-36);
INSERT INTO DETAILS VALUES (18,1,'2070367177',1,Sysdate-14);
INSERT INTO DETAILS VALUES (19,1,'2746026090',1,Sysdate-12);
INSERT INTO DETAILS VALUES (20,1,'2266091611',1,default);
INSERT INTO DETAILS VALUES (20,2,'2253010219',1,default);
