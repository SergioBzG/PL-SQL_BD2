CREATE OR REPLACE TRIGGER borrado_cooperativa
BEFORE DELETE ON cooperativa
FOR EACH ROW
DECLARE
    CURSOR c_coopxsocio(cooperativa_borrada NUMBER) IS
    SELECT socio, sc_acumulado
    FROM coopexsocio
    WHERE coope = cooperativa_borrada;
    cooperativa_borrada cooperativa.codigo%TYPE;
BEGIN
    cooperativa_borrada:= :OLD.codigo;
    FOR i IN c_coopxsocio(cooperativa_borrada) LOOP
        UPDATE socio SET s_acumulado = s_acumulado - i.sc_acumulado WHERE idsocio = i.socio;
    END LOOP;
    DELETE FROM coopexsocio WHERE coope = cooperativa_borrada;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('EL error es ' || SQLERRM || ' y su código es: ' || sqlcode);
END;
/
COMMIT;

