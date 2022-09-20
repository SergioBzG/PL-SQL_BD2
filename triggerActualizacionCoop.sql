CREATE OR REPLACE TRIGGER actualizarCoop
BEFORE UPDATE OF c_acumulado ON cooperativa
FOR EACH ROW
DECLARE
    incremento cooperativa.c_acumulado%TYPE;
    cantSocios NUMBER(8);
    CURSOR sociosCoop IS
    SELECT *
    FROM socio, coopexsocio
    WHERE idsocio = socio AND coope = :OLD.codigo;
    incrementoNegativo EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO cantSocios
    FROM coopexsocio
    WHERE coope = :OLD.codigo;
    --Se obtiene la cantidad de socios presentes en la cooperativa
    incremento := :NEW.c_acumulado - :OLD.c_acumulado;
    iF incremento < :OLD.c_acumulado THEN
        RAISE incrementoNegativo;
    END IF;
    FOR i IN sociosCoop LOOP
        UPDATE coopexsocio
        SET sc_acumulado = sc_acumulado + incremento/cantSocios
        WHERE socio = i.socio AND coope = i.coope;
        --Se actualiza el valor en coopexsocio
        UPDATE socio
        SET s_acumulado = s_acumulado + incremento/cantSocios
        WHERE idsocio = i.idsocio;
        --Se actualiza el valor en socio
    END LOOP;
    EXCEPTION
        WHEN incrementoNegativo THEN
            DBMS_OUTPUT.PUT_LINE('Solo se permiten incrementos positivos');
        WHEN ZERO_DIVIDE THEN
            DBMS_OUTPUT.PUT_LINE('Esta cooperativa no tiene socios vinculados');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('EL error es ' || SQLERRM || ' y su código es: ' || sqlcode);
END;
/
COMMIT;

