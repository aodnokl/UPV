/* Ejercicio 15 */
SELECT cod_peli, titulo 
FROM Pelicula p
WHERE p.director IN (SELECT a.nombre FROM actor a
                        JOIN actua at ON a.cod_act = at.cod_act
                        WHERE at.cod_peli = p.cod_peli);


/* Ejercicio 16 */
SELECT cod_act, nombre 
FROM Actor a
WHERE cod_act IN (SELECT at.cod_act
                FROM actua at
                WHERE at.papel = 'Principal') 
                AND EXTRACT (year FROM a.fecha_nac) < 1950
                ORDER BY a.nombre;



/* Ejercicio 18 */
/* Hay que tener cuidado con los valores nulos usando NOT IN */

SELECT cod_lib, titulo, autor
FROM LIBRO_PELI lb
WHERE lb.cod_lib NOT IN (SELECT p.cod_lib
                        FROM PELICULA P
                        WHERE cod_lib IS NOT NULL);

/*  Solucion 2 pero sin acordarse de los valores nulos */
SELECT lb.cod_lib, lb.titulo, lb.autor
FROM LIBRO_PELI lb
WHERE  NOT EXISTS (SELECT *
                        FROM PELICULA P
                        WHERE P.cod_lib = lb.cod_lib);


/* Ejercicio 19 */
SELECT g.nombre
FROM GENERO g
WHERE EXISTS (SELECT *
                FROM clasificacion c
                WHERE g.cod_gen = c.cod_gen 
                AND NOT EXISTS (SELECT * 
                                FROM actua a 
                                WHERE c.cod_peli = a.cod_peli))

ORDER BY g.nombre;


/* Ejercicio 20 */


SELECT DISTINCT L.titulo
FROM LIBRO_PELI L, PELICULA P
WHERE L.cod_lib = P.cod_lib
                    AND P.cod_peli NOT IN 
                    (
                    SELECT A.cod_peli
                    FROM ACTUA A, ACTOR AC, PAIS PA
                    WHERE A.cod_act = AC.cod_act
                        AND AC.cod_pais = PA.cod_pais
                        AND PA.nombre = 'USA'
                    )
ORDER BY L.titulo;


/* Ejercicio 21 ???? */


/* Ejercicio 23 */

SELECT A.cod_act, A.nombre 
FROM ACTOR A
WHERE A.fecha_nac IN (
    SELECT MIN(ac.fecha_nac)
    FROM ACTOR ac
);

/* Ejercicio 24 */

SELECT A.cod_act, A.nombre, A.fecha_nac
FROM ACTOR A
WHERE A.fecha_nac IN (
    SELECT MAX(ac.fecha_nac)
    FROM ACTOR ac 
    WHERE EXTRACT (year FROM a.fecha_nac) = 1940
);



-- EXAMEN 2
-- Corrige la siguiente consulta para obtener el nombre de los países de los que no hay ningún 
-- actor o actriz nacido antes de 1920 (ordenados por nombre). La consulta correcta obtiene los 
-- siguientes resultados:

-- nombre
-- 1. Alemania
-- 2. Australia
-- 3. Bélgica
-- 4. Canadá
-- 5. Cuba
-- 6. España
-- 7. Francia
-- 8. Italia
-- 9. USA

SELECT pa.nombre
FROM pais pa
WHERE NOT EXISTS (SELECT *
FROM actor a
WHERE a.cod_pais = pa.cod_pais AND EXTRACT(YEAR FROM a.fecha_nac) < 1920)
ORDER BY pa.nombre;