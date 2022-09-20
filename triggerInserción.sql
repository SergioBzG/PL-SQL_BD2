CREATE OR REPLACE TRIGGER cooperativa_reinicio_acumulado
BEFORE INSERT ON cooperativa
FOR EACH ROW
DECLARE
BEGIN
    :NEW.c_acumulado := 0;
END;
/

CREATE OR REPLACE TRIGGER socio_reinicio_acumulado
BEFORE INSERT ON socio
FOR EACH ROW
DECLARE
BEGIN
    :NEW.s_acumulado := 0;
END;
/

CREATE OR REPLACE TRIGGER coopexsocio_reinicio_acumulado
BEFORE INSERT ON coopexsocio
FOR EACH ROW
DECLARE
BEGIN
    :NEW.sc_acumulado := 0;
END;
/
COMMIT;