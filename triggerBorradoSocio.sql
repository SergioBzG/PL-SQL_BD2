CREATE OR REPLACE TRIGGER borrado_socio
BEFORE DELETE ON socio
FOR EACH ROW
DECLARE
    socio_borrado socio.idsocio%TYPE;
BEGIN
    socio_borrado:= :OLD.idsocio;
    DELETE FROM coopexsocio WHERE socio = socio_borrado;
END;
/
COMMIT;