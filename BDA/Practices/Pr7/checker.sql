-- Comprobar todo


-- RG1. Equipos sin ningún miembro del staff en la posición Entrenador/a
SELECT e.codeq
FROM EQUIPO e
WHERE NOT EXISTS (SELECT *
FROM STAFF s
WHERE s.codeq = e.codeq AND s.codpos = 'ENT');


-- RG2. Equipos con menos de 9 jugadores
SELECT e.codeq, COUNT(j.id) AS num_jugadores
FROM EQUIPO e LEFT JOIN JUGADOR j ON j.codeq = e.codeq
GROUP BY e.codeq
HAVING COUNT(j.id) < 9;


-- RG3. Participantes que son staff y jugador de equipos distintos
SELECT s.id, s.codeq AS equipo_staff, j.codeq AS equipo_jugador
FROM STAFF s JOIN JUGADOR j ON j.id = s.id
WHERE s.codeq <> j.codeq;


-- RG4. Jugadores que no son de sexo masculino o cuyo país de
-- nacimiento no coincide con el país de su equipo
SELECT j.id, p.sexo, p.pais_nac, e.codpais
FROM JUGADOR j
JOIN PARTICIPANTE p ON p.id = j.id
JOIN EQUIPO e ON e.codeq = j.codeq
WHERE p.sexo <> 'masculino'
OR p.pais_nac IS NULL
OR p.pais_nac <> e.codpais;