CREATE OR REPLACE TRIGGER actualizarCoop
BEFORE UPDATE OF c_acumulado ON cooperativa
FOR EACH ROW
WHEN (NEW.c_acumulado > 0) --Solo se permiten incrementos positivos
DECLARE
    valor cooperativa.c_acumulado%TYPE;
    cantSocios NUMBER(8);
    CURSOR sociosCoop IS
    SELECT *
    FROM socio, coopexsocio
    WHERE idsocio = socio AND coope = :OLD.codigo;
BEGIN
    SELECT COUNT(*) INTO cantSocios
    FROM coopexsocio
    WHERE coope = :OLD.codigo;
    --Se obtiene la cantidad de socios presentes en la cooperativa
    valor := :NEW.c_acumulado;
    FOR i IN sociosCoop LOOP
        UPDATE coopexsocio
        SET sc_acumulado = sc_acumulado + valor/cantSocios
        WHERE socio = i.socio AND coope = i.coope;
        --Se actualiza el valor en coopexsocio
        UPDATE socio
        SET s_acumulado = s_acumulado + valor/cantSocios
        WHERE idsocio = i.idsocio;
        --Se actualiza el valor en socio
    END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('EL error es ' || SQLERRM || ' y su código es: ' || sqlcode);
END;
/
COMMIT;
