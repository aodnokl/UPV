-- 3.6 Consultas con concatenación 


-- Ejercicio 50
-- 50. Obtener para todos los países que hay en la base de datos, el código, 
-- el nombre y la cantidad de actores que hay de ese país. 

SELECT p.cod_pais, p.nombre, count(a.cod_pais)
FROM pais p
LEFT JOIN actor a ON a.cod_pais = p.cod_pais
GROUP BY p.cod_pais, p.nombre
ORDER BY p.nombre;

-- A parte quiero que el nombre el actor sea George
-- Se pierden los paises por tener los nulos despues de left join
SELECT p.cod_pais, p.nombre, count(a.cod_pais)
FROM pais p
LEFT JOIN actor a ON a.cod_pais = p.cod_pais
WHERE a.nombre LIKE '%George%'
GROUP BY p.cod_pais, p.nombre
ORDER BY p.nombre;



--  La solucion es meter la condicion dentro del left join
SELECT p.cod_pais, p.nombre, count(a.cod_pais)
FROM pais p
LEFT JOIN actor a ON a.cod_pais = p.cod_pais AND a.nombre LIKE '%George%'
GROUP BY p.cod_pais, p.nombre
ORDER BY p.nombre;





-- Ejercicio 51
-- 51. Obtener el código y el título de todos los libros de la base de datos de 
-- año posterior a 1980 junto con la cantidad de películas a que han dado lugar. 

SELECT l.cod_lib, l.titulo, count(p.cod_peli)
FROM libro_peli l
LEFT JOIN pelicula p ON l.cod_lib = p.cod_lib
WHERE l.anyo > 1980
GROUP BY l.cod_lib, l.titulo;



-- Ejercicio 52
-- 52. Obtener para todos los países que hay en la base de datos, el código, el nombre y la cantidad de actores que hay de ese país que hayan 
-- tenido un papel como “Secundario” en alguna película. 

SELECT P.cod_pais AS COD_P, 
       P.nombre AS NOMBRE, 
       COUNT(A.cod_act)
FROM PAIS P
     LEFT JOIN (SELECT DISTINCT ACTOR.cod_act, ACTOR.cod_pais
                FROM ACTOR
                JOIN ACTUA ON ACTOR.cod_act = ACTUA.cod_act
                WHERE ACTUA.papel = 'Secundario') A ON P.cod_pais = A.cod_pais
GROUP BY P.cod_pais, P.nombre;




-- Ejercicio 53
-- 53. Obtener para cada película que hay en la base de datos que dure más de 140 minutos, el código, 
-- el título, la cantidad de géneros en los que está clasificado y la cantidad de 
-- actores que han actuado en ella. 

SELECT 
    p.cod_peli, 
    p.titulo,
    (
        SELECT COUNT(*) 
        FROM clasificacion c 
        WHERE c.cod_peli = p.cod_peli
    ) AS cantidad_generos,
    (
        SELECT COUNT(*) 
        FROM actua a 
        WHERE a.cod_peli = p.cod_peli
    ) AS cantidad_actores

FROM pelicula p
WHERE p.duracion > 140
ORDER BY p.titulo;




SELECT p.cod_peli, p.titulo, COUNT(DISTINCT c.cod_gen) AS cantidad_generos, COUNT(DISTINCT a.cod_act) AS cantidad_actores
FROM pelicula p
LEFT JOIN clasificacion c ON p.cod_peli = c.cod_peli
LEFT JOIN actua a ON p.cod_peli = a.cod_peli
WHERE p.duracion > 140
GROUP BY p.cod_peli, p.titulo;


-- Examen
SELECT p.cod_peli AS cod, p.titulo, 'SIN LIBRO' AS libro, COUNT(c.cod_gen) AS n_gen
FROM pelicula p
LEFT JOIN clasificacion c ON p.cod_peli = c.cod_peli
WHERE p.duracion > 145 
  AND p.anyo BETWEEN 1995 AND 2010
  AND p.cod_lib IS NULL
GROUP BY p.cod_peli, p.titulo

UNION

SELECT p.cod_peli AS cod, p.titulo, l.titulo AS libro, COUNT(c.cod_gen) AS n_gen
FROM pelicula p
JOIN libro_peli l ON p.cod_lib = l.cod_lib
LEFT JOIN clasificacion c ON p.cod_peli = c.cod_peli
WHERE p.duracion > 145 
  AND p.anyo BETWEEN 1995 AND 2010
GROUP BY p.cod_peli, p.titulo, l.titulo;