CREATE OR REPLACE TRIGGER cooperativa_reinicio_acumulado
BEFORE INSERT ON cooperativa
FOR EACH ROW
DECLARE
BEGIN
    UPDATE cooperativa SET cooperativa.c_acumulado = 0;
    :NEW.c_acumulado := 0;
END;
/

CREATE OR REPLACE TRIGGER socio_reinicio_acumulado
BEFORE INSERT ON socio
FOR EACH ROW
DECLARE
BEGIN
    UPDATE socio SET socio.s_acumulado = 0;
    :NEW.s_acumulado := 0;
END;
/

CREATE OR REPLACE TRIGGER coopexsocio_reinicio_acumulado
BEFORE INSERT ON coopexsocio
FOR EACH ROW
DECLARE
BEGIN
    UPDATE coopexsocio SET coopexsocio.sc_acumulado = 0;
    :NEW.sc_acumulado := 0;
END;
/