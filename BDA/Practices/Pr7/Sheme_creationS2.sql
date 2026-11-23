-- =====================================================================
--  Bases de Datos - Grado en Inteligencia Artificial
--  Práctica 2. Sesión 1: Creación de tablas
--  Esquema: campeonato de baloncesto masculino
--
--  Estructura del script (apartado 2.1 del enunciado):
--    1. CREATE TABLE de todas las tablas, solo con clave primaria y
--       restricciones de columna (NOT NULL, UNIQUE, CHECK), sin
--       ninguna clave ajena.
--    2. ALTER TABLE ... ADD CONSTRAINT ... FOREIGN KEY para todas las
--       claves ajenas, una vez creadas todas las tablas. Todas se
--       declaran DEFERRABLE INITIALLY IMMEDIATE: se comprueban al final
--       de cada sentencia, pero dentro de una transacción pueden
--       diferirse hasta el COMMIT con
--         SET CONSTRAINT <nombre> DEFERRED;   o
--         SET CONSTRAINTS ALL DEFERRED;
--    3. GRANT de consulta y manipulación al compañero/a de prácticas.
--
--  Notas sobre Oracle (UD3.3.2):
--    - Oracle solo admite ON DELETE CASCADE y ON DELETE SET NULL. El
--      borrado RESTRICTIVO es el comportamiento por defecto (no se
--      escribe cláusula ON DELETE).
--    - Oracle NO admite la cláusula ON UPDATE. Las directrices
--      "Actualización CASCADA" del esquema no pueden declararse; se
--      indican como comentario en cada clave ajena. Para conseguirlas
--      habría que recurrir a disparadores (UD3.3.3).
-- =====================================================================


-- ---------------------------------------------------------------------
--  0. (Opcional) Borrado previo de las tablas para poder relanzar el
--     script. CASCADE CONSTRAINTS elimina también las claves ajenas
--     que las referencian. Descomentar si se necesita.
-- ---------------------------------------------------------------------
-- DROP TABLE cuadro       CASCADE CONSTRAINTS;
-- DROP TABLE fase         CASCADE CONSTRAINTS;
-- DROP TABLE sede         CASCADE CONSTRAINTS;
-- DROP TABLE jugador      CASCADE CONSTRAINTS;
-- DROP TABLE staff        CASCADE CONSTRAINTS;
-- DROP TABLE posicion     CASCADE CONSTRAINTS;
-- DROP TABLE participante CASCADE CONSTRAINTS;
-- DROP TABLE equipo       CASCADE CONSTRAINTS;
-- DROP TABLE pais         CASCADE CONSTRAINTS;



-- =====================================================================
--  1. CREACIÓN DE TABLAS (sin claves ajenas)
-- =====================================================================

-- PAIS (codpais, nombre)
--   CP: {codpais}   VNN: {nombre}   UNI: {nombre}
CREATE TABLE PAIS (
   codpais   CHAR(3)      CONSTRAINT PK_pais PRIMARY KEY,
   nombre    VARCHAR2(30) CONSTRAINT NN_pais_nombre NOT NULL
                          CONSTRAINT UN_pais_nombre UNIQUE
);

-- EQUIPO (codeq, codpais, ranking, grupo)
--   CP: {codeq}   VNN: {codpais}   UNI: {codpais}   UNI: {ranking}
--   COM: ranking < 200
CREATE TABLE EQUIPO (
   codeq     CHAR(3)      CONSTRAINT PK_equipo PRIMARY KEY,
   codpais   CHAR(3)      CONSTRAINT NN_equipo_codpais NOT NULL
                          CONSTRAINT UN_equipo_codpais UNIQUE,
   ranking   INTEGER      CONSTRAINT UN_equipo_ranking UNIQUE
                          CONSTRAINT CK_equipo_ranking CHECK (ranking < 200),
   grupo     CHAR(1)
);

-- PARTICIPANTE (id, nombre, fecha_nac, pais_nac, sexo)
--   CP: {id}   COM: sexo IN {masculino, femenino}
--   (Tabla dada como ejemplo en el enunciado.)
CREATE TABLE PARTICIPANTE (
   id        VARCHAR2(9)  CONSTRAINT PK_participante PRIMARY KEY,
   nombre    VARCHAR2(30),
   fecha_nac DATE,
   pais_nac  CHAR(3),
   sexo      CHAR(9)      CONSTRAINT CK_participante_sexo
                          CHECK (sexo IN ('masculino','femenino'))
);

-- POSICION (codpos, desc)
--   CP: {codpos}   VNN: {desc}
--   OJO: DESC es palabra reservada en Oracle (ORDER BY ... DESC), por
--   lo que no puede usarse sin comillas como nombre de columna. Se ha
--   renombrado a "descripcion".
CREATE TABLE POSICION (
   codpos      CHAR(3)    CONSTRAINT PK_posicion PRIMARY KEY,
   descripcion CHAR(100)  CONSTRAINT NN_posicion_desc NOT NULL
);

-- STAFF (id, codeq, codpos)
--   CP: {id}
CREATE TABLE STAFF (
   id        VARCHAR2(9)  CONSTRAINT PK_staff PRIMARY KEY,
   codeq     CHAR(3),
   codpos    CHAR(3)
);

-- JUGADOR (id, dorsal, codeq, altura, codpos)
--   CP: {id}   UNI: {codeq, dorsal}   VNN: {codeq, dorsal, codpos}
--   COM: dorsal < 100   COM: 0 < altura < 3
--   La unicidad se aplica a la combinación (id, codeq, dorsal), por lo
--   que se declara como restricción de tabla.
CREATE TABLE JUGADOR (
   id        VARCHAR2(9)  CONSTRAINT PK_jugador PRIMARY KEY,
   dorsal    INTEGER      CONSTRAINT NN_jugador_dorsal NOT NULL
                          CONSTRAINT CK_jugador_dorsal CHECK (dorsal < 100),
   codeq     CHAR(3)      CONSTRAINT NN_jugador_codeq NOT NULL,
   altura    NUMBER(3,2)  CONSTRAINT CK_jugador_altura
                          CHECK (altura > 0 AND altura < 3),
   codpos    CHAR(3)      CONSTRAINT NN_jugador_codpos NOT NULL,
   CONSTRAINT UN_jugador_id_eq_dorsal UNIQUE (codeq, dorsal)
);

-- SEDE (codse, nombre, ciudad, capacidad)
--   CP: {codse}
CREATE TABLE SEDE (
   codse     CHAR(3)      CONSTRAINT PK_sede PRIMARY KEY,
   nombre    CHAR(30),
   ciudad    CHAR(30),
   capacidad INTEGER
);

-- FASE (codfase, descripcion)
--   CP: {codfase}   VNN: {descripcion}
CREATE TABLE FASE (
   codfase     INTEGER       CONSTRAINT PK_fase PRIMARY KEY,
   descripcion VARCHAR2(150) CONSTRAINT NN_fase_desc NOT NULL
);

-- CUADRO (fase, local, visitante, puntvis, puntloc, codse, fecha_hora)
--   CP: {fase, local, visitante}
--   UNI: {codse, fecha_hora}       COM: local <> visitante
--   La CP, la unicidad y el CHECK afectan a varias columnas, así que
--   se declaran como restricciones de tabla.
CREATE TABLE CUADRO (
   fase       INTEGER,
   local      CHAR(3),
   visitante  CHAR(3),
   puntvis    INTEGER,
   puntloc    INTEGER,
   codse      CHAR(3),
   fecha_hora DATE,
   CONSTRAINT PK_cuadro PRIMARY KEY (fase, local, visitante),
   CONSTRAINT UN_cuadro_sede_fecha UNIQUE (codse, fecha_hora),
   CONSTRAINT CK_cuadro_loc_vis CHECK (local <> visitante)
);


-- =====================================================================
--  2. CLAVES AJENAS (ALTER TABLE, una vez creadas todas las tablas)
-- =====================================================================

-- EQUIPO.codpais -> PAIS     Borrado RESTRICTIVO (por defecto): no se
--   permite borrar un país si tiene equipos clasificados.
ALTER TABLE EQUIPO
   ADD CONSTRAINT FK_equipo_pais FOREIGN KEY (codpais) REFERENCES PAIS(codpais)
   DEFERRABLE INITIALLY IMMEDIATE;

-- PARTICIPANTE.pais_nac -> PAIS  (sentencia dada en el enunciado)
ALTER TABLE PARTICIPANTE
   ADD CONSTRAINT FK_participante_pais FOREIGN KEY (pais_nac) REFERENCES PAIS(codpais)
   DEFERRABLE INITIALLY IMMEDIATE;

-- STAFF.id -> PARTICIPANTE   Borrado CASCADA, Actualización CASCADA (*)
ALTER TABLE STAFF
   ADD CONSTRAINT FK_staff_participante FOREIGN KEY (id) REFERENCES PARTICIPANTE(id)
   ON DELETE CASCADE
   DEFERRABLE INITIALLY IMMEDIATE;

-- STAFF.codeq -> EQUIPO      Borrado A NULOS, Actualización CASCADA (*)
ALTER TABLE STAFF
   ADD CONSTRAINT FK_staff_equipo FOREIGN KEY (codeq) REFERENCES EQUIPO(codeq)
   ON DELETE SET NULL
   DEFERRABLE INITIALLY IMMEDIATE;

-- STAFF.codpos -> POSICION   Borrado A NULOS, Actualización CASCADA (*)
ALTER TABLE STAFF
   ADD CONSTRAINT FK_staff_posicion FOREIGN KEY (codpos) REFERENCES POSICION(codpos)
   ON DELETE SET NULL
   DEFERRABLE INITIALLY IMMEDIATE;

-- JUGADOR.id -> PARTICIPANTE Borrado CASCADA, Actualización CASCADA (*)
ALTER TABLE JUGADOR
   ADD CONSTRAINT FK_jugador_participante FOREIGN KEY (id) REFERENCES PARTICIPANTE(id)
   ON DELETE CASCADE
   DEFERRABLE INITIALLY IMMEDIATE;

-- JUGADOR.codeq -> EQUIPO    Borrado RESTRICTIVO, Actualización CASCADA (*)
ALTER TABLE JUGADOR
   ADD CONSTRAINT FK_jugador_equipo FOREIGN KEY (codeq) REFERENCES EQUIPO(codeq)
   DEFERRABLE INITIALLY IMMEDIATE;

-- JUGADOR.codpos -> POSICION Borrado RESTRICTIVO, Actualización CASCADA (*)
ALTER TABLE JUGADOR
   ADD CONSTRAINT FK_jugador_posicion FOREIGN KEY (codpos) REFERENCES POSICION(codpos)
   DEFERRABLE INITIALLY IMMEDIATE;

-- CUADRO.fase -> FASE        Borrado CASCADA, Actualización CASCADA (*)
ALTER TABLE CUADRO
   ADD CONSTRAINT FK_cuadro_fase FOREIGN KEY (fase) REFERENCES FASE(codfase)
   ON DELETE CASCADE
   DEFERRABLE INITIALLY IMMEDIATE;

-- CUADRO.codse -> SEDE       Borrado A NULOS, Actualización CASCADA (*)
ALTER TABLE CUADRO
   ADD CONSTRAINT FK_cuadro_sede FOREIGN KEY (codse) REFERENCES SEDE(codse)
   ON DELETE SET NULL
   DEFERRABLE INITIALLY IMMEDIATE;

-- CUADRO.local -> EQUIPO     Borrado RESTRICTIVO, Actualización CASCADA (*)
ALTER TABLE CUADRO
   ADD CONSTRAINT FK_cuadro_local FOREIGN KEY (local) REFERENCES EQUIPO(codeq)
   DEFERRABLE INITIALLY IMMEDIATE;

-- CUADRO.visitante -> EQUIPO Borrado RESTRICTIVO, Actualización CASCADA (*)
ALTER TABLE CUADRO
   ADD CONSTRAINT FK_cuadro_visitante FOREIGN KEY (visitante) REFERENCES EQUIPO(codeq)
   DEFERRABLE INITIALLY IMMEDIATE;

-- (*) Oracle no admite ON UPDATE: la actualización en cascada no se
--     puede declarar en la clave ajena.


-- =====================================================================
--  Restricciones generales NO incluidas
--  No pueden expresarse con CREATE/ALTER TABLE porque afectan a varias
--  filas o tablas; requieren disparadores (UD3.3.3):
--    - Todo equipo tiene al menos un miembro del staff en la posición
--      "Entrenador/a".
--    - Todo equipo tiene al menos 9 jugadores registrados.
--    - Un participante puede ser staff y jugador solo si es del mismo
--      equipo.
--    - Todo jugador es un participante de sexo masculino cuyo país de
--      nacimiento coincide con el país de su equipo.
-- =====================================================================


-- =====================================================================
--  3. CONCESIÓN DE PERMISOS AL COMPAÑERO/A DE PRÁCTICAS
--  Sustituir usuario_companero por el usuario Oracle del compañero/a.
-- =====================================================================
-- GRANT SELECT, INSERT, DELETE, UPDATE ON PAIS         TO usuario_companero;
-- GRANT SELECT, INSERT, DELETE, UPDATE ON EQUIPO       TO usuario_companero;
-- GRANT SELECT, INSERT, DELETE, UPDATE ON PARTICIPANTE TO usuario_companero;
-- GRANT SELECT, INSERT, DELETE, UPDATE ON POSICION     TO usuario_companero;
-- GRANT SELECT, INSERT, DELETE, UPDATE ON STAFF        TO usuario_companero;
-- GRANT SELECT, INSERT, DELETE, UPDATE ON JUGADOR      TO usuario_companero;
-- GRANT SELECT, INSERT, DELETE, UPDATE ON SEDE         TO usuario_companero;
-- GRANT SELECT, INSERT, DELETE, UPDATE ON FASE         TO usuario_companero;
-- GRANT SELECT, INSERT, DELETE, UPDATE ON CUADRO       TO usuario_companero;

COMMIT;





SET CONSTRAINT ALL DEFERRED;

-- Meter en las tablas los datos dados respetando todas las
-- restricciones de las tablas

-- PAIS 
INSERT INTO PAIS (codpais, nombre) VALUES ('ESP', 'España');
INSERT INTO PAIS (codpais, nombre) VALUES ('USA', 'Estados Unidos');

-- EQUIPO
INSERT INTO EQUIPO (codeq, codpais, ranking, grupo) VALUES ('ESP', 'ESP', 4, 'A');
INSERT INTO EQUIPO (codeq, codpais, ranking, grupo) VALUES ('USA', 'USA', 2, 'A');

-- POSICION
INSERT INTO POSICION (codpos, descripcion) VALUES ('ENT', 'Entrenador/a');
INSERT INTO POSICION (codpos, descripcion) VALUES ('AEN', 'Segundo entrenador/a (ayudante)');
INSERT INTO POSICION (codpos, descripcion) VALUES ('FIS', 'Fisioterapeuta');
INSERT INTO POSICION (codpos, descripcion) VALUES ('BAS', 'Base');
INSERT INTO POSICION (codpos, descripcion) VALUES ('ESC', 'Escolta');
INSERT INTO POSICION (codpos, descripcion) VALUES ('ALE', 'Alero');
INSERT INTO POSICION (codpos, descripcion) VALUES ('APV', 'Ala-pívot');
INSERT INTO POSICION (codpos, descripcion) VALUES ('PIV', 'Pívot');

-- SEDE
INSERT INTO SEDE (codse, nombre, ciudad, capacidad)
VALUES ('PAB', 'Pabellón Fuente de San Luis', 'Valencia', 9500);

-- FASE
INSERT INTO FASE (codfase, descripcion) VALUES (1, 'Fase de grupos');

-- PARTICIPANTE
INSERT INTO PARTICIPANTE (id, nombre, fecha_nac, pais_nac, sexo) VALUES ('ESP00001', 'Chus Mateo', TO_DATE('23/01/1969', 'DD/MM/YYYY'), 'ESP', 'masculino');
INSERT INTO PARTICIPANTE (id, nombre, fecha_nac, pais_nac, sexo) VALUES ('ESP00002', 'Guillermo Frutos', TO_DATE('02/05/1991', 'DD/MM/YYYY'), 'ESP', 'femenino');
INSERT INTO PARTICIPANTE (id, nombre, fecha_nac, pais_nac, sexo) VALUES ('ESP00003', 'Laura Prieto', TO_DATE('03/09/1985', 'DD/MM/YYYY'), 'ESP', 'femenino');
INSERT INTO PARTICIPANTE (id, nombre, fecha_nac, pais_nac, sexo) VALUES ('ESP00004', 'Ferrán Bassas', TO_DATE('12/02/1992', 'DD/MM/YYYY'), 'ESP', 'masculino');
INSERT INTO PARTICIPANTE (id, nombre, fecha_nac, pais_nac, sexo) VALUES ('ESP00005', 'Álvaro Cárdenas', TO_DATE('15/03/2003', 'DD/MM/YYYY'), 'ESP', 'masculino');
INSERT INTO PARTICIPANTE (id, nombre, fecha_nac, pais_nac, sexo) VALUES ('ESP00006', 'Mario Saint-Supéry', TO_DATE('08/01/2000', 'DD/MM/YYYY'), 'ESP', 'masculino');
INSERT INTO PARTICIPANTE (id, nombre, fecha_nac, pais_nac, sexo) VALUES ('ESP00007', 'Darío Brizuela', TO_DATE('06/06/1997', 'DD/MM/YYYY'), 'ESP', 'masculino');
INSERT INTO PARTICIPANTE (id, nombre, fecha_nac, pais_nac, sexo) VALUES ('ESP00008', 'Jaime Fernández', TO_DATE('20/01/1990', 'DD/MM/YYYY'), 'ESP', 'masculino');
INSERT INTO PARTICIPANTE (id, nombre, fecha_nac, pais_nac, sexo) VALUES ('ESP00009', 'Francis Alonso', TO_DATE('18/05/1992', 'DD/MM/YYYY'), 'ESP', 'masculino');
INSERT INTO PARTICIPANTE (id, nombre, fecha_nac, pais_nac, sexo) VALUES ('ESP00010', 'Santi Yusta', TO_DATE('09/11/1998', 'DD/MM/YYYY'), 'ESP', 'masculino');
INSERT INTO PARTICIPANTE (id, nombre, fecha_nac, pais_nac, sexo) VALUES ('ESP00011', 'Joel Parra', TO_DATE('03/04/2001', 'DD/MM/YYYY'), 'ESP', 'masculino');
INSERT INTO PARTICIPANTE (id, nombre, fecha_nac, pais_nac, sexo) VALUES ('ESP00012', 'Willy Hernangómez', TO_DATE('27/12/1994', 'DD/MM/YYYY'), 'ESP', 'masculino');
INSERT INTO PARTICIPANTE (id, nombre, fecha_nac, pais_nac, sexo) VALUES ('USA00001', 'Mark Daigneault', TO_DATE('14/03/1972', 'DD/MM/YYYY'), 'USA', 'masculino');
INSERT INTO PARTICIPANTE (id, nombre, fecha_nac, pais_nac, sexo) VALUES ('USA00002', 'Jennifer Lee', TO_DATE('02/11/1978', 'DD/MM/YYYY'), 'USA', 'femenino');
INSERT INTO PARTICIPANTE (id, nombre, fecha_nac, pais_nac, sexo) VALUES ('USA00003', 'Robert Johnson', TO_DATE('19/06/1982', 'DD/MM/YYYY'), 'USA', 'masculino');
INSERT INTO PARTICIPANTE (id, nombre, fecha_nac, pais_nac, sexo) VALUES ('USA00004', 'Tim Frazier', TO_DATE('29/03/1991', 'DD/MM/YYYY'), 'USA', 'masculino');
INSERT INTO PARTICIPANTE (id, nombre, fecha_nac, pais_nac, sexo) VALUES ('USA00005', 'Jalen Crutcher', TO_DATE('14/05/2000', 'DD/MM/YYYY'), 'USA', 'masculino');
INSERT INTO PARTICIPANTE (id, nombre, fecha_nac, pais_nac, sexo) VALUES ('USA00006', 'Mark Armstrong', TO_DATE('02/09/2004', 'DD/MM/YYYY'), 'USA', 'masculino');
INSERT INTO PARTICIPANTE (id, nombre, fecha_nac, pais_nac, sexo) VALUES ('USA00007', 'Buddy Boeheim', TO_DATE('28/09/1999', 'DD/MM/YYYY'), 'USA', 'masculino');
INSERT INTO PARTICIPANTE (id, nombre, fecha_nac, pais_nac, sexo) VALUES ('USA00008', 'Eli Pemberton', TO_DATE('10/11/1997', 'DD/MM/YYYY'), 'USA', 'masculino');
INSERT INTO PARTICIPANTE (id, nombre, fecha_nac, pais_nac, sexo) VALUES ('USA00009', 'Haywood Highsmith', TO_DATE('09/11/1997', 'DD/MM/YYYY'), 'USA', 'masculino');
INSERT INTO PARTICIPANTE (id, nombre, fecha_nac, pais_nac, sexo) VALUES ('USA00010', 'Pedro Bradshaw', TO_DATE('15/06/1996', 'DD/MM/YYYY'), 'USA', 'masculino');
INSERT INTO PARTICIPANTE (id, nombre, fecha_nac, pais_nac, sexo) VALUES ('USA00011', 'Dillon Jones', TO_DATE('03/02/2001', 'DD/MM/YYYY'), 'USA', 'masculino');
INSERT INTO PARTICIPANTE (id, nombre, fecha_nac, pais_nac, sexo) VALUES ('USA00012', 'Hunter Dickinson', TO_DATE('25/11/2001', 'DD/MM/YYYY'), 'USA', 'masculino');

-- STAFF
INSERT INTO STAFF (id, codeq, codpos) VALUES ('ESP00001', 'ESP', 'ENT');
INSERT INTO STAFF (id, codeq, codpos) VALUES ('ESP00002', 'ESP', 'AEN');
INSERT INTO STAFF (id, codeq, codpos) VALUES ('ESP00003', 'ESP', 'FIS');
INSERT INTO STAFF (id, codeq, codpos) VALUES ('USA00001', 'USA', 'ENT');
INSERT INTO STAFF (id, codeq, codpos) VALUES ('USA00002', 'USA', 'AEN');
INSERT INTO STAFF (id, codeq, codpos) VALUES ('USA00003', 'USA', 'FIS');


-- JUGADOR
INSERT INTO JUGADOR (id, dorsal, codeq, altura, codpos) VALUES ('ESP00004', 7,  'ESP', 1.90, 'BAS');
INSERT INTO JUGADOR (id, dorsal, codeq, altura, codpos) VALUES ('ESP00005', 23, 'ESP', 1.90, 'BAS');
INSERT INTO JUGADOR (id, dorsal, codeq, altura, codpos) VALUES ('ESP00006', 9,  'ESP', 1.93, 'BAS');
INSERT INTO JUGADOR (id, dorsal, codeq, altura, codpos) VALUES ('ESP00007', 32, 'ESP', 1.96, 'ESC');
INSERT INTO JUGADOR (id, dorsal, codeq, altura, codpos) VALUES ('ESP00008', 6,  'ESP', 1.96, 'ESC');
INSERT INTO JUGADOR (id, dorsal, codeq, altura, codpos) VALUES ('ESP00009', 22, 'ESP', 1.98, 'ESC');
INSERT INTO JUGADOR (id, dorsal, codeq, altura, codpos) VALUES ('ESP00010', 10, 'ESP', 2.01, 'ALE');
INSERT INTO JUGADOR (id, dorsal, codeq, altura, codpos) VALUES ('ESP00011', 17, 'ESP', 2.02, 'APV');
INSERT INTO JUGADOR (id, dorsal, codeq, altura, codpos) VALUES ('ESP00012', 14, 'ESP', 2.11, 'PIV');
INSERT INTO JUGADOR (id, dorsal, codeq, altura, codpos) VALUES ('USA00004', 1,  'USA', 1.83, 'BAS');
INSERT INTO JUGADOR (id, dorsal, codeq, altura, codpos) VALUES ('USA00005', 3,  'USA', 1.85, 'BAS');
INSERT INTO JUGADOR (id, dorsal, codeq, altura, codpos) VALUES ('USA00006', 2,  'USA', 1.85, 'BAS');
INSERT INTO JUGADOR (id, dorsal, codeq, altura, codpos) VALUES ('USA00007', 35, 'USA', 1.98, 'ESC');
INSERT INTO JUGADOR (id, dorsal, codeq, altura, codpos) VALUES ('USA00008', 24, 'USA', 1.93, 'ESC');
INSERT INTO JUGADOR (id, dorsal, codeq, altura, codpos) VALUES ('USA00009', 11, 'USA', 2.01, 'ALE');
INSERT INTO JUGADOR (id, dorsal, codeq, altura, codpos) VALUES ('USA00010', 21, 'USA', 2.03, 'ALE');
INSERT INTO JUGADOR (id, dorsal, codeq, altura, codpos) VALUES ('USA00011', 10, 'USA', 2.01, 'APV');
INSERT INTO JUGADOR (id, dorsal, codeq, altura, codpos) VALUES ('USA00012', 5,  'USA', 2.16, 'PIV');

-- CUADRO
INSERT INTO CUADRO (fase, local, visitante, puntvis, puntloc, codse, fecha_hora)
VALUES (1, 'ESP', 'USA', NULL, NULL, 'PAB', TO_DATE('05/12/2026 18:00', 'DD/MM/YYYY HH24:MI'));



COMMIT;