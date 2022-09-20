CREATE OR REPLACE PROCEDURE mostrarCoop(codigoCoop cooperativa.codigo%TYPE)
IS
    nombreCoop cooperativa.nombre%TYPE;
    acumCoop cooperativa.c_acumulado%TYPE;
    cantSocios NUMBER(8);
    totalAcum socio.s_acumulado%TYPE;
    cont NUMBER(8);
    --Se obtiene el nombre de los socios y sus respectivos acumulados en la cooperativa
    CURSOR curSocios IS
    SELECT *
    FROM socio, coopexsocio
    WHERE coopexsocio.coope = codigoCoop AND socio.idsocio = coopexsocio.socio;
BEGIN
    --Se obtiene el nombre y el acumulado de la cooperativa
    SELECT nombre, c_acumulado INTO nombreCoop, acumCoop
    FROM cooperativa
    WHERE codigo = codigoCoop;
    --Se obtiene la cantidad de socios presentes en la cooperativa
    SELECT COUNT(*) INTO cantSocios
    FROM coopexsocio
    WHERE coope = codigoCoop;
    --Se reliza la impresión
    DBMS_OUTPUT.PUT_LINE('Nombre de la cooperativa: ' || nombreCoop);
    DBMS_OUTPUT.PUT_LINE('Acumulado de la cooperativa: ' || acumCoop);
    DBMS_OUTPUT.PUT_LINE('Número de socios: ' || cantSocios);
    DBMS_OUTPUT.PUT_LINE('Socios de la cooperativa:');
    DBMS_OUTPUT.PUT_LINE('{');
    cont := 1;
    FOR socioAct IN curSocios LOOP
        DBMS_OUTPUT.PUT_LINE(cont || '. (Nombre: ' || socioAct.nombre || ', Valorsc: ' || socioAct.sc_acumulado || ')');
        cont := cont + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('}');
    --Se obtiene el acumulado total de los socios presentes en la cooperativa
    SELECT SUM(sc_acumulado) INTO totalAcum
    FROM coopexsocio
    WHERE coope = codigoCoop;
    IF totalAcum IS NULL THEN
        totalAcum := 0;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Total valores de los socios en la cooperativa: ' || totalAcum);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('La cooperativa ingresada no existe');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('EL error es ' || SQLERRM || ' y su código es: ' || sqlcode);
END;
/
COMMIT;

