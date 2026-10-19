/* Ejercicio 32 */
/* Para todo actor de pais -> actor ha nacido en el siglo XX */

SELECT P.cod_pais, P.nombre
FROM PAIS P
WHERE NOT EXISTS (
    SELECT *
    FROM ACTOR A
    WHERE A.cod_pais = P.cod_pais
      AND EXTRACT(YEAR FROM A.fecha_nac)
          NOT BETWEEN 1900 AND 1999)

AND EXISTS (
    SELECT *
    FROM ACTOR A
    WHERE A.cod_pais = P.cod_pais
)
ORDER BY P.nombre;





/* EJERCICIO 33*/

/* 
Para actua de este actor -> EXISTE peopel es secundario
No existe(actua de ese actor AND no existe paple = secundario)
y existe actua de este actor
*/


SELECT A.cod_act, A.nombre
FROM ACTOR A
WHERE NOT EXISTS (
    SELECT *
    FROM ACTUA AC
    WHERE AC.cod_act = A.cod_act
    AND AC.papel <> 'Secundario'
) 
AND EXISTS (
    SELECT *
    FROM ACTUA AC 
    WHERE AC.cod_act = A.cod_act

)
ORDER BY A.nombre;




/* Ejercicio 34 */

/* Actores que han aparecido en todas las películas
   de Guy Ritchie, si ha dirigido al menos una */


SELECT A.cod_act, A.nombre
FROM ACTOR A
WHERE NOT EXISTS (
    SELECT *
    FROM PELICULA P
    WHERE P.director = 'Guy Ritchie'
    AND NOT EXISTS (
        SELECT *
        FROM ACTUA AC
        WHERE AC.cod_peli = P.cod_peli
        AND AC.cod_act = A.cod_act))

    AND EXISTS (
        SELECT *
        FROM PELICULA P
        WHERE P.director = 'Guy Ritchie')
    
ORDER BY A.nombre;


-- 35. Resolver la consulta anterior pero para el director de nombre ‘John Steel’. no se ha seleccionado ninguna fila 

SELECT A.cod_act, A.nombre
FROM ACTOR A
WHERE NOT EXISTS (
    SELECT *
    FROM PELICULA P
    WHERE P.director = 'John Steel'
    AND NOT EXISTS (
        SELECT *
        FROM ACTUA AC
        WHERE AC.cod_peli = P.cod_peli
        AND AC.cod_act = A.cod_act))

    AND EXISTS (
        SELECT *
        FROM PELICULA P
        WHERE P.director = 'John Steel')
    
ORDER BY A.nombre;





/* Ejercicio 36 */
/* Películas de menos de 100 minutos
   cuyos actores son todos del mismo país */

SELECT P.cod_peli, P.titulo
FROM PELICULA P
WHERE P.duracion < 100
  AND EXISTS (
      SELECT *
      FROM ACTUA AC
      WHERE AC.cod_peli = P.cod_peli
  )
  AND NOT EXISTS (
      SELECT *
      FROM ACTUA AC1, ACTOR A1,
           ACTUA AC2, ACTOR A2
      WHERE AC1.cod_peli = P.cod_peli
        AND AC2.cod_peli = P.cod_peli
        AND AC1.cod_act = A1.cod_act
        AND AC2.cod_act = A2.cod_act
        AND A1.cod_pais <> A2.cod_pais
  )
ORDER BY P.cod_peli;





/* Ejercicio 37 */

--  Obtener el código, el título y el año de las películas en las que haya actuado 
-- algún actor si se cumple que todos los actores que han actuado en ella 
-- han nacido antes del año 1943 (hasta el 31/12/1942). 


SELECT P.cod_peli, P.titulo, P.anyo
FROM PELICULA P
WHERE NOT EXISTS (
    SELECT *
    FROM ACTUA AC, ACTOR A
    WHERE AC.cod_peli = P.cod_peli
    AND AC.cod_act = A.cod_act
    AND A.fecha_nac >= DATE '1943-01-01')

AND EXISTS (
    SELECT *
    FROM ACTUA AC
    WHERE AC.cod_peli = P.cod_peli
)

ORDER BY P.cod_peli;




/* Ejercicio 38 */
--  Obtener el código y el nombre de cada país si 
-- se cumple que todos sus actores han actuado en al menos una película 
-- de más de 120 minutos. (Ordenados por nombre). 

SELECT P.cod_pais, P.nombre
FROM PAIS P
WHERE NOT EXISTS (
    SELECT *
    FROM ACTOR A
    WHERE A.cod_pais = P.cod_pais
    AND NOT EXISTS (
        SELECT *
        FROM ACTUA AC, PELICULA PE
        WHERE AC.cod_act = A.cod_act
        AND AC.cod_peli = PE.cod_peli
        AND PE.duracion > 120
    )
)
ORDER BY P.nombre;



-- PROBLEMA EXAMEN


SELECT p.cod_peli, p.titulo
FROM pelicula p
WHERE NOT EXISTS (
    SELECT *
    FROM actua ac
    WHERE ac.cod_peli = p.cod_peli
    AND ac.papel = 'Principal'
    AND NOT EXISTS (
                SELECT *
                FROM actor a, pais pa
                WHERE a.cod_act = ac.cod_act
                AND a.cod_pais = pa.cod_pais
                AND pa.nombre = 'España'
    )
)
AND EXISTS (
    SELECT *
    FROM actua ac
    WHERE ac.cod_peli = p.cod_peli
    AND ac.papel = 'Principal'
)
ORDER BY p.titulo;