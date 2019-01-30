CREATE PACKAGE utils AS
    CREATE FUNCTION number_uses_book(
      book_ISBN IN NUMBER
      number_exemp IN NUMBER
      number_uses OUT NUMBER
    )
      RETURN  NUMBER IS
    BEGIN
      number_uses = SELECT COUNT(*) FROM  DETAILS WHERE ISBN = book_ISBN, Numero_exemplaire = number_exemp;
      RETURN to_number(number_uses);
    END;
END utils;
/
