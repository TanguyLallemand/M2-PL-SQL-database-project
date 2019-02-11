-- efface automatiquement les exemplaire en mauvais état
CREATE OR REPLACE TRIGGER supprimer_exemplaire_en_mauvais_etat AFTER UPDATE ON EXEMPLAIRE
FOR EACH ROW
WHEN (new.Etat = 'Mauvais')

BEGIN
  DELETE FROM Exemplaire WHERE isbn = :new.isbn and Numero_exemplaire = :new.Numero_exemplaire;
END;
/
