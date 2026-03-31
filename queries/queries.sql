-- 1. Llistat d'alumnes ordenat alfabèticament
SELECT apellido1, apellido2, nombre
FROM persona
WHERE tipo = 'alumno'
ORDER BY apellido1, apellido2, nombre ASC;

-- 2. Alumnes sense telèfon
SELECT nombre, apellido1, apellido2
FROM persona
WHERE tipo = 'alumno' AND telefono IS NULL;

-- 3. Alumnes nascuts en 1999
SELECT id, nombre, apellido1, apellido2, fecha_nacimiento
FROM persona
WHERE tipo = 'alumno' AND YEAR(fecha_nacimiento) = 1999;

-- 4. Professors sense telèfon i NIF acabat en K
SELECT nombre, apellido1, apellido2, nif
FROM persona
WHERE tipo = 'profesor' AND telefono IS NULL AND nif LIKE '%K';

-- 5. Assignatures 1er quadrimestre, 3er curs, grau 7
SELECT id, nombre, cuatrimestre, curso, id_grado
FROM asignatura
WHERE cuatrimestre = 1 AND curso = 3 AND id_grado = 7;

-- 6. Professors i el seu departament
SELECT p.apellido1, p.apellido2, p.nombre, d.nombre AS departamento
FROM persona p
         JOIN profesor prof ON p.id = prof.id_profesor
         JOIN departamento d ON prof.id_departamento = d.id
ORDER BY p.apellido1, p.apellido2, p.nombre ASC;

-- 7. Assignatures de l'alumne amb NIF 26902806M
SELECT a.nombre, ce.anyo_inicio, ce.anyo_fin
FROM asignatura a
         JOIN alumno_se_matricula_asignatura ma ON a.id = ma.id_asignatura
         JOIN curso_escolar ce ON ce.id = ma.id_curso_escolar
         JOIN persona p ON ma.id_alumno = p.id
WHERE p.nif = '26902806M';

-- 8. Departaments amb professors en Enginyeria Informàtica (Pla 2015)
SELECT DISTINCT d.nombre
FROM asignatura a
         JOIN profesor prof ON a.id_profesor = prof.id_profesor
         JOIN departamento d ON d.id = prof.id_departamento
         JOIN grado g ON g.id = a.id_grado
WHERE g.nombre = 'Grado en Ingeniería Informática (Plan 2015)';

-- 9. Alumnes matriculats en 2018/2019
SELECT DISTINCT p.nombre, p.apellido1, p.apellido2
FROM persona p
         JOIN alumno_se_matricula_asignatura ma ON p.id = ma.id_alumno
         JOIN curso_escolar ce ON ce.id = ma.id_curso_escolar
WHERE ce.anyo_inicio = 2018 AND ce.anyo_fin = 2019;

-- 10. Professors i departaments (incloent-hi els no associats)
SELECT d.nombre AS departamento, p.apellido1, p.apellido2, p.nombre
FROM persona p
         JOIN profesor prof ON p.id = prof.id_profesor
         LEFT JOIN departamento d ON prof.id_departamento = d.id
ORDER BY d.nombre, p.apellido1, p.apellido2, p.nombre ASC;

-- 11. Professors sense departament
SELECT p.apellido1, p.apellido2, p.nombre
FROM persona p
         JOIN profesor prof ON p.id = prof.id_profesor
WHERE p.tipo = 'profesor' AND prof.id_departamento IS NULL;

-- 12. Departaments sense professors
SELECT d.nombre
FROM departamento d
         LEFT JOIN profesor prof ON d.id = prof.id_departamento
WHERE prof.id_profesor IS NULL;

-- 13. Professors que no imparteixen cap assignatura
SELECT p.apellido1, p.apellido2, p.nombre
FROM persona p
         JOIN profesor prof ON p.id = prof.id_profesor
         LEFT JOIN asignatura a ON a.id_profesor = prof.id_profesor
WHERE a.id IS NULL;

-- 14. Assignatures sense professor
SELECT a.id, a.nombre
FROM asignatura a
         LEFT JOIN profesor prof ON a.id_profesor = prof.id_profesor
WHERE prof.id_profesor IS NULL;

-- 15. Departaments sense assignatures impartides
SELECT DISTINCT d.nombre
FROM departamento d
         LEFT JOIN profesor prof ON d.id = prof.id_departamento
         LEFT JOIN asignatura a ON prof.id_profesor = a.id_profesor
WHERE a.id IS NULL;

-- 16. Total alumnes
SELECT COUNT(id) AS total FROM persona WHERE tipo = 'alumno';

-- 17. Alumnes nascuts en 1999 (conteo)
SELECT COUNT(id) AS total FROM persona WHERE tipo = 'alumno' AND YEAR(fecha_nacimiento) = 1999;

-- 18. Professors per departament (ordenat per total)
SELECT d.nombre AS departamento, COUNT(prof.id_profesor) AS total
FROM departamento d
         JOIN profesor prof ON d.id = prof.id_departamento
GROUP BY d.nombre
ORDER BY total DESC;

-- 19. Tots els departaments i nombre de professors
SELECT d.nombre AS departamento, COUNT(prof.id_profesor) AS total
FROM departamento d
         LEFT JOIN profesor prof ON d.id = prof.id_departamento
GROUP BY d.nombre;

-- 20. Graus i nombre d'assignatures
SELECT g.nombre AS grau, COUNT(a.id) AS total
FROM grado g
         LEFT JOIN asignatura a ON g.id = a.id_grado
GROUP BY g.nombre
ORDER BY total DESC;

-- 21. Graus amb més de 40 assignatures
SELECT g.nombre AS grau, COUNT(a.id) AS total
FROM grado g
         LEFT JOIN asignatura a ON g.id = a.id_grado
GROUP BY g.nombre
HAVING total > 40;

-- 22. Crèdits per tipus i grau
SELECT g.nombre AS grau, a.tipo, SUM(a.creditos) AS total_creditos
FROM grado g
         JOIN asignatura a ON g.id = a.id_grado
GROUP BY g.nombre, a.tipo;

-- 23. Alumnes matriculats per curs escolar
SELECT ce.anyo_inicio, COUNT(DISTINCT ma.id_alumno) AS total
FROM curso_escolar ce
         JOIN alumno_se_matricula_asignatura ma ON ce.id = ma.id_curso_escolar
GROUP BY ce.anyo_inicio;

-- 24. Nombre d'assignatures per professor
SELECT p.id, p.nombre, p.apellido1, p.apellido2, COUNT(a.id) AS total
FROM persona p
         JOIN profesor prof ON p.id = prof.id_profesor
         LEFT JOIN asignatura a ON prof.id_profesor = a.id_profesor
GROUP BY p.id, p.nombre, p.apellido1, p.apellido2
ORDER BY total DESC;

-- 25. Alumne/a més jove
SELECT * FROM persona
WHERE tipo = 'alumno'
ORDER BY fecha_nacimiento DESC
LIMIT 1;

-- 26. Professors amb departament però sense assignatura
SELECT p.apellido1, p.apellido2, p.nombre
FROM persona p
         JOIN profesor prof ON p.id = prof.id_profesor
         JOIN departamento d ON prof.id_departamento = d.id
         LEFT JOIN asignatura a ON prof.id_profesor = a.id_profesor
WHERE a.id IS NULL;