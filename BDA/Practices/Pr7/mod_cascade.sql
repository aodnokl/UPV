SET CONSTRAINTS ALL DEFERRED;

-- 1. Tabla principal EQUIPO
UPDATE EQUIPO
SET codeq = 'SPA'
WHERE codeq = 'ESP';

-- 2. Tablas hijas que referencian a EQUIPO(codeq)
UPDATE STAFF
SET codeq = 'SPA'
WHERE codeq = 'ESP';

UPDATE JUGADOR
SET codeq = 'SPA'
WHERE codeq = 'ESP';

UPDATE CUADRO
SET local = 'SPA'
WHERE local = 'ESP';

-- Por completitud, por si en algún caso apareciera como visitante:
UPDATE CUADRO
SET visitante = 'SPA'
WHERE visitante = 'ESP';

COMMIT;