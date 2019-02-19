# Projet de base de données
## Fonctionnement des scripts

Dans le dossier script on retrouve l'ensemble des scripts utiles à l'intialisation de la base de données. Pour rendre la base de données utilisable veuillez executer la ligne suivante dans sqlplus:

    @script_global.sql

Ce script va tout d'abord nettoyé des possibles reliquats de la base de données, puis va l'initialisé. Il va alors appelé à la suite et dans le bon ordre l'ensemble des scripts du projets permettant ainsi de remplir les tables avec les données pui ajouté les packages, triggers et views. Pour supprimé la base de donnée il est possible de la supprimé via:

    @script_drop.sql

