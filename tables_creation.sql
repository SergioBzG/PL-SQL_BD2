CREATE TABLE cooperativa(
    codigo NUMBER(8) PRIMARY KEY,
    nombre VARCHAR2(30) NOT NULL UNIQUE,
    c_acumulado NUMBER(8)
);