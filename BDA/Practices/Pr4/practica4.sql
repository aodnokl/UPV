-- Ejercicio 40
-- Idea clave: usar la agrupacion GROUP BY con el Having
-- Nota: ROUND(campo_numerico) -> devuelve el entero mas cercano

--  Obtener para cada género en el que se han clasificado más de 5 películas, 
-- el código y el nombre del género indicando la cantidad de películas del mismo 
-- y duración media de sus películas. (Ordenados por nombre). 
-- (La función ROUND redondea al entero más cercano). 

-- Usar HAVING solo se puede con el GROUP BY


SELECT G.cod_gen, G.NOMBRE, COUNT(C.cod_peli), ROUND(AVG(P.duracion))
FROM GENERO G
JOIN CLASIFICACION C ON G.cod_gen = C.cod_gen
JOIN PELICULA P ON P.cod_peli = C.cod_peli
GROUP BY G.cod_gen, G.nombre
HAVING COUNT(C.cod_peli) > 0
ORDER BY G.nombre;





-- Ejercicio 41

-- Obtener el código y el título de las películas de año posterior al 2000 
-- junto con el número de géneros en que están clasificadas, si es que están 
-- en alguno. (Ordenadas por título). 


SELECT P.cod_peli, P.titulo, COUNT(C.cod_gen)
FROM PELICULA P
JOIN CLASIFICACION C ON P.cod_peli = C.cod_peli
WHERE P.ANYO > 2000
GROUP BY P.cod_peli, P.titulo
ORDER BY P.titulo;


-- Ejercicio 42

-- Obtener los directores que tienen la cadena ‘George’ en 
-- su nombre y que han dirigido exactamente dos películas. 

SELECT Director
FROM PELICULA
WHERE Director LIKE '%George%'
GROUP BY DIRECTOR
HAVING COUNT(COD_PELI) = 2;



-- Ejercicio 43
-- Obtener para cada película clasificada exactamente en un género y en la que 
-- haya actuado algún actor, el código, el título y la cantidad de actores que actúan en el


SELECT P.COD_PELI, P.TITULO, COUNT(distinct act.cod_act) as cuantos
FROM (Pelicula P JOIN ACTUA ACT ON ACT.COD_PELI = P.COD_PELI)
JOIN CLASIFICACION C ON P.COD_PELI = C.COD_PELI
GROUP BY P.COD_PELI, P.TITULO
HAVING count(distinct c.cod_gen) = 1
ORDER BY P.TITULO;



-- Ejercicio 44

-- Obtener el código y el nombre de todos los países con actores indicando 
-- cuántos actores de cada país han actuado en al menos una película de la década de los 60. 

-- SELECT P.COD_PAIS, P.NOMBRE, COUNT(ACTORE)
-- FROM PAIS P


-- EXAMEN

SELECT p.cod_peli, p.titulo, COUNT(distinct act.cod_act) AS num_actores
FROM pelicula p
JOIN actua act ON p.cod_peli = act.cod_peli
JOIN clasificacion c ON p.cod_peli = c.cod_peli
GROUP BY p.cod_peli, p.titulo
HAVING COUNT(distinct c.cod_gen) > 2
AND COUNT(distinct act.cod_act) > 2
ORDER BY p.titulo;