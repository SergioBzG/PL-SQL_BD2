CREATE OR REPLACE PROCEDURE mostrarSocio(id_socio IN socio.idsocio%TYPE)
IS
    nombre_socio socio.nombre%TYPE;
    nombre_cooperativa cooperativa.nombre%TYPE;
    acumulado socio.s_acumulado%TYPE;
    contador NUMBER(8);
    comparacion VARCHAR(10);

    TYPE socio_type IS TABLE OF coopexsocio%ROWTYPE;
    TYPE cooperativa_type IS TABLE OF cooperativa%ROWTYPE;
    arreglo_contiene socio_type;
    total_cooperativas cooperativa_type;
BEGIN
    SELECT nombre INTO nombre_socio FROM socio WHERE idsocio =  id_socio;
    SELECT s_acumulado INTO acumulado FROM socio WHERE idsocio =  id_socio;
    SELECT * BULK COLLECT INTO arreglo_contiene FROM coopexsocio WHERE socio = id_socio;
    SELECT * BULK COLLECT INTO total_cooperativas FROM cooperativa;

    DBMS_OUTPUT.PUT_LINE('Nombre del socio: ' || nombre_socio);
    DBMS_OUTPUT.PUT_LINE('Acumulado del socio: ' || acumulado);
    DBMS_OUTPUT.PUT_LINE('Número de cooperativas en las que participa: ' || arreglo_contiene.COUNT);
    DBMS_OUTPUT.PUT_LINE('Cooperativas del socio: ');
    DBMS_OUTPUT.PUT_LINE('{');

    -- MUESTRA LAS COOPERATIVAS A LAS QUE ESTÁ AFILIADO EL SOCIO
    contador := 1;
    IF arreglo_contiene.FIRST IS NOT NULL THEN
        FOR i IN arreglo_contiene.FIRST .. arreglo_contiene.LAST LOOP
            SELECT nombre INTO nombre_cooperativa FROM cooperativa WHERE codigo = arreglo_contiene(i).coope;
            DBMS_OUTPUT.PUT_LINE(contador || '. (Nombre: ' || nombre_cooperativa || ', Valorsc: ' || arreglo_contiene(i).sc_acumulado || ')');
            contador := contador + 1;
        END LOOP;
    END IF;
    DBMS_OUTPUT.PUT_LINE('}');

    -- MUESTRA LAS COOPERATIVAS A LAS QUE NO ESTÁ AFILIADO EL SOCIO
    DBMS_OUTPUT.PUT_LINE('Cooperativas en las que no está el socio: ');
    DBMS_OUTPUT.PUT_LINE('{');
    contador := 1;
    FOR i IN total_cooperativas.FIRST .. total_cooperativas.LAST LOOP
        comparacion := 'false';
        FOR J IN arreglo_contiene.FIRST .. arreglo_contiene.LAST LOOP
            IF (total_cooperativas(i).codigo = arreglo_contiene(j).coope) THEN
                comparacion := 'true';
                EXIT;
            END IF;
        END LOOP;
        IF (comparacion = 'false') THEN
            DBMS_OUTPUT.PUT_LINE(contador || '. ' || total_cooperativas(i).nombre);
            contador := contador + 1;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('}');
END;
/
COMMIT;