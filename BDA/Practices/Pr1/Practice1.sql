SELECT DISTINCT COD_PAIS
FROM ACTOR;



SELECT COD_PELI, TITULO
FROM PELICULA
WHERE ANYO<1970 AND COD_LIB IS NULL
ORDER BY TITULO;



SELECT COD_ACT, NOMBRE
FROM ACTOR
WHERE NOMBRE LIKE '%John%';



SELECT COD_peli, titulo
FROM pelicula
WHERE duracion > 120 AND anyo BETWEEN 1980 AND 1989;




SELECT COUNT(DISTINCT COD_PELI)
FROM clasificacion
WHERE COD_GEN IN ('BB5', 'GG4', 'JH6');


SELECT COUNT(DISTINCT COD_PELI)
FROM clasificacion
WHERE COD_GEN IN ('BB5', 'GG4', 'JH6');




SELECT min(anyo)
FROM libro_peli;

SELECT min(anyo) as mas_antiguo
FROM libro_peli;




SELECT p.cod_peli, p.titulo
FROM pelicula p
JOIN actu ac ON p.codPpeli= ac.cod_peli
JOIN actor a ON ac.cod_act= a.COD_ACT
WHERE a.nombre = p.director
ORDER BY titulo;




SELECT DISTINCT P.titulo
FROM ACTOR A
JOIN ACTUA AC ON A.cod_act = AC.cod_act
JOIN PELICULA P ON AC.cod_peli = P.cod_peli
WHERE A.nombre = 'Jude Law' AND P.anyo >= 2005;



SELECT DISTINCT A.nombre, L.titulo
FROM Actor A
JOIN Actua AC ON A.cod_act = AC.cod_act
JOIN Pelicula P ON AC.cod_peli = P.cod_peli
JOIN Libro_Peli L ON P.cod_lib = L.cod_lib
WHERE AC.papel = 'Secundario'
ORDER BY A.nombre;