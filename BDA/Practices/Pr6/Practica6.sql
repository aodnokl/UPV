
-- Práctica Parte 2
-- Estructura: 0) DROP  1) CREATE TABLE  2) ALTER TABLE 



-- 0. BORRAR LAS TABLAS (para poder relanzar el script sin errores)
--    La primera vez darán error ORA-00942 (la tabla no existe)

DROP TABLE CUADRO       CASCADE CONSTRAINTS;
DROP TABLE JUGADOR      CASCADE CONSTRAINTS;
DROP TABLE STAFF        CASCADE CONSTRAINTS;
DROP TABLE PARTICIPANTE CASCADE CONSTRAINTS;
DROP TABLE EQUIPO       CASCADE CONSTRAINTS;
DROP TABLE POSICION     CASCADE CONSTRAINTS;
DROP TABLE SEDE         CASCADE CONSTRAINTS;
DROP TABLE FASE         CASCADE CONSTRAINTS;
DROP TABLE PAIS         CASCADE CONSTRAINTS;



-- 1. CREACIÓN DE TABLAS (PK, UNIQUE, NOT NULL, CHECK; todavía sin FKs)

CREATE TABLE PAIS (
  codpais CHAR(3)      CONSTRAINT pk_pais PRIMARY KEY,
  nombre  VARCHAR2(30) CONSTRAINT nn_pais_nombre NOT NULL
                       CONSTRAINT uq_pais_nombre UNIQUE
);

CREATE TABLE EQUIPO (
  codeq   CHAR(3) CONSTRAINT pk_equipo PRIMARY KEY,
  codpais CHAR(3) CONSTRAINT nn_equipo_codpais NOT NULL
                  CONSTRAINT uq_equipo_codpais UNIQUE,
  ranking INTEGER CONSTRAINT uq_equipo_ranking UNIQUE
                  CONSTRAINT ck_equipo_ranking CHECK (ranking < 200),
  grupo   CHAR(1)
);

CREATE TABLE PARTICIPANTE (
  id        VARCHAR2(9)  CONSTRAINT pk_participante PRIMARY KEY,
  nombre    VARCHAR2(30),
  fecha_nac DATE,
  pais_nac  CHAR(3),
  sexo      CHAR(9)      CONSTRAINT ck_participante_sexo
                         CHECK (sexo IN ('masculino', 'femenino'))
);


CREATE TABLE POSICION (
  codpos CHAR(3)   CONSTRAINT pk_posicion PRIMARY KEY,
  descr  CHAR(100) CONSTRAINT nn_posicion_descr NOT NULL
);

CREATE TABLE STAFF (
  id     VARCHAR2(9) CONSTRAINT pk_staff PRIMARY KEY,
  codeq  CHAR(3),
  codpos CHAR(3)
);

CREATE TABLE JUGADOR (
  id     VARCHAR2(9) CONSTRAINT pk_jugador PRIMARY KEY,
  dorsal INTEGER     CONSTRAINT nn_jugador_dorsal NOT NULL
                     CONSTRAINT ck_jugador_dorsal CHECK (dorsal < 100),
  codeq  CHAR(3)     CONSTRAINT nn_jugador_codeq NOT NULL,
  altura NUMBER(3,2) CONSTRAINT ck_jugador_altura CHECK (altura > 0 AND altura < 3),
  codpos CHAR(3)     CONSTRAINT nn_jugador_codpos NOT NULL,
  CONSTRAINT uq_jugador_codeq_dorsal UNIQUE (codeq, dorsal)
);

CREATE TABLE SEDE (
  codse     CHAR(3) CONSTRAINT pk_sede PRIMARY KEY,
  nombre    CHAR(30),
  ciudad    CHAR(30),
  capacidad INTEGER
);

CREATE TABLE FASE (
  codfase     INTEGER       CONSTRAINT pk_fase PRIMARY KEY,
  descripcion VARCHAR2(150) CONSTRAINT nn_fase_descripcion NOT NULL
);

CREATE TABLE CUADRO (
  fase       INTEGER,
  local      CHAR(3),
  visitante  CHAR(3),
  puntvis    INTEGER,
  puntloc    INTEGER,
  codse      CHAR(3),
  fecha_hora DATE,
  CONSTRAINT pk_cuadro            PRIMARY KEY (fase, local, visitante),
  CONSTRAINT uq_cuadro_sede_fecha UNIQUE (codse, fecha_hora),
  CONSTRAINT ck_cuadro_equipos    CHECK (local <> visitante)
);


-- 2. CLAVES AJENAS (al final, cuando ya existen todas las tablas)
--    Borrado RESTRICTIVO -> no se pone nada (es lo que hace Oracle por defecto)
--    Borrado CASCADA     -> ON DELETE CASCADE
--    Borrado a NULOS     -> ON DELETE SET NULL
--    Actualización CASCADA -> Oracle NO tiene ON UPDATE CASCADE: no se puede
--                             expresar con DDL (haría falta un trigger).

ALTER TABLE EQUIPO
  ADD CONSTRAINT fk_equipo_pais FOREIGN KEY (codpais)
  REFERENCES PAIS(codpais);

ALTER TABLE PARTICIPANTE
  ADD CONSTRAINT fk_participante_pais FOREIGN KEY (pais_nac)
  REFERENCES PAIS(codpais);

ALTER TABLE STAFF
  ADD CONSTRAINT fk_staff_participante FOREIGN KEY (id)
  REFERENCES PARTICIPANTE(id) ON DELETE CASCADE;

ALTER TABLE STAFF
  ADD CONSTRAINT fk_staff_equipo FOREIGN KEY (codeq)
  REFERENCES EQUIPO(codeq) ON DELETE SET NULL;

ALTER TABLE STAFF
  ADD CONSTRAINT fk_staff_posicion FOREIGN KEY (codpos)
  REFERENCES POSICION(codpos) ON DELETE SET NULL;

ALTER TABLE JUGADOR
  ADD CONSTRAINT fk_jugador_participante FOREIGN KEY (id)
  REFERENCES PARTICIPANTE(id) ON DELETE CASCADE;

ALTER TABLE JUGADOR
  ADD CONSTRAINT fk_jugador_equipo FOREIGN KEY (codeq)
  REFERENCES EQUIPO(codeq);

ALTER TABLE JUGADOR
  ADD CONSTRAINT fk_jugador_posicion FOREIGN KEY (codpos)
  REFERENCES POSICION(codpos);

ALTER TABLE CUADRO
  ADD CONSTRAINT fk_cuadro_fase FOREIGN KEY (fase)
  REFERENCES FASE(codfase) ON DELETE CASCADE;

ALTER TABLE CUADRO
  ADD CONSTRAINT fk_cuadro_sede FOREIGN KEY (codse)
  REFERENCES SEDE(codse) ON DELETE SET NULL;

ALTER TABLE CUADRO
  ADD CONSTRAINT fk_cuadro_local FOREIGN KEY (local)
  REFERENCES EQUIPO(codeq);

ALTER TABLE CUADRO
  ADD CONSTRAINT fk_cuadro_visitante FOREIGN KEY (visitante)
  REFERENCES EQUIPO(codeq);



-- 3. RESTRICCIONES QUE NO SE PUEDEN IMPLEMENTAR CON DDL
--    (un CHECK solo ve la fila actual de su propia tabla; estas implican
--     varias tablas o contar filas -> harían falta triggers)
--  - Todo equipo debe tener al menos un miembro del staff con posición
--    "Entrenador/a".
--  - Todo equipo debe tener al menos 9 jugadores.
--  - Un participante puede ser staff y jugador solo si es del mismo equipo.
--  - Todo jugador debe ser participante masculino nacido en el país de su
--    equipo.
--  - Todas las "Actualización CASCADA" (Oracle no soporta ON UPDATE).



-- 4. COMPROBACIÓN
SELECT table_name FROM user_tables ORDER BY table_name;

SELECT table_name, constraint_name, constraint_type, delete_rule
FROM   user_constraints
WHERE  table_name IN ('PAIS','EQUIPO','PARTICIPANTE','STAFF','JUGADOR',
                      'POSICION','SEDE','FASE','CUADRO')
ORDER  BY table_name, constraint_type;




