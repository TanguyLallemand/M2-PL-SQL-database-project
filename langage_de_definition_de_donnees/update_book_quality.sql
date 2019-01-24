--update book's quality

--NEUF < 11
--11<BON<25
--25<MOYEN<60
-->60 MAUVAIS delete


/* WORK IN PROGRESS, NEED TO CREATE A PACKAGE APPARENTLY)*/

CREATE FUNCTION number_uses_book(
  book_ISBN IN NUMBER
  number_uses OUT NUMBER
)
  RETURN  NUMBER IS
BEGIN
  number_uses = SELECT * FROM  DETAILS WHERE ISBN = book_ISBN;
  RETURN to_number(number_uses);
END;

--TRIGGER
DECLARE
  number_uses = number_uses_book()
CREATE TRIGGER update_quality
AFTER UPDATE ON EXEMPLAIRE OF Etat
FOR EACH ROW

BEGIN
  IF
END;
/
