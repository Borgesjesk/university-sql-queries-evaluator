/*
 * PROYECTO: IT Academy - Java Backend Sprint 2
 * TAREA: S2.02 - Consultas SQL Universidad
 * DESCRIPCIÓN: Implementación optimizada para validador automático.
 */

-- 1. Listado de alumnos ordenado alfabéticamente
SELECT apellido1, apellido2, nombre
FROM persona
WHERE tipo = 'alumno'
ORDER BY apellido1, apellido2, nombre ASC;

-- 2. Alumnos sin teléfono registrado
SELECT nombre, apellido1, apellido2
FROM persona
WHERE tipo = 'alumno'
  AND telefono IS NULL;

-- 3. Alumnos nacidos en 1999
SELECT nombre, apellido1, apellido2
FROM persona
WHERE tipo = 'alumno'
  AND YEAR(fecha_nacimiento) = 1999;

-- 4. Profesores sin teléfono y NIF terminado en K
SELECT nombre, apellido1, apellido2, nif
FROM persona
WHERE tipo = 'profesor'
  AND telefono IS NULL
  AND NIF LIKE '%K';

-- 5. Asignaturas del 1er cuatrimestre, 3er curso, grado 7
SELECT id, nombre, cuatrimestre, curso, id_grado
FROM asignatura
WHERE cuatrimestre = 1
  AND curso = 3
  AND id_grado = 7;

-- 6. Profesores y sus departamentos
SELECT p.apellido1, p.apellido2, p.nombre, d.nombre AS departamento
FROM persona p
JOIN profesor prof ON p.id = prof.id_profesor
JOIN departamento d ON prof.id_departamento = d.id
ORDER BY p.apellido1, p.apellido2, p.nombre, d.nombre ASC;

-- 7. Asignaturas y curso del alumno con NIF 26902806M
SELECT a.nombre, ce.anyo_inicio, ce.anyo_fin
FROM asignatura a
JOIN alumno_se_matricula_asignatura ma ON a.id = ma.id_asignatura
JOIN curso_escolar ce ON ce.id = ma.id_curso_escolar
JOIN persona p ON ma.id_alumno = p.id
WHERE p.nif = '26902806M';

-- 8. Departamentos con profesores en Ingeniería Informática (Plan 2015)
SELECT DISTINCT d.nombre
FROM asignatura a
JOIN profesor p ON a.id_profesor = p.id_profesor
JOIN departamento d ON d.id = p.id_departamento
JOIN grado g ON g.id = a.id_grado
WHERE g.nombre = 'Grado en Ingeniería Informática (Plan 2015)';

-- 9. Alumnos matriculados en 2018/2019
SELECT DISTINCT p.nombre, p.apellido1, p.apellido2
FROM persona p
JOIN alumno_se_matricula_asignatura ma ON p.id = ma.id_alumno
JOIN asignatura a ON a.id = id_asignatura
JOIN curso_escolar ce ON ce.id = ma.id_curso_escolar
WHERE ce.anyo_inicio = 2018
  AND ce.anyo_fin = 2019;

-- 10. Profesores y departamentos (incluyendo los que no tienen)
SELECT d.nombre AS departamento, p.apellido1, p.apellido2, p.nombre
FROM persona p
RIGHT JOIN profesor prof ON p.id = prof.id_profesor
LEFT JOIN departamento d ON prof.id_departamento = d.id
ORDER BY d.nombre, p.apellido1, p.apellido2, p.nombre ASC;

-- 11. Profesores sin departamento asociado
SELECT p.apellido1, p.apellido2, p.nombre
FROM persona p
LEFT JOIN profesor prof ON p.id = prof.id_profesor
WHERE p.tipo = 'Profesor'
  AND id_departamento IS NULL;

-- 12. Departamentos sin profesores
SELECT d.nombre
FROM departamento d
LEFT JOIN profesor prof ON d.id = prof.id_departamento
WHERE prof.id_departamento IS NULL;

-- 13. Profesores que no imparten asignaturas
SELECT p.apellido1, p.apellido2, p.nombre
FROM persona p
RIGHT JOIN profesor prof ON p.id = prof.id_profesor
LEFT JOIN asignatura a ON a.id_profesor = prof.id_profesor
WHERE a.id IS NULL;

-- 14. Asignaturas sin profesor asignado
SELECT a.id, a.nombre
FROM asignatura a
LEFT JOIN profesor prof ON a.id_profesor = prof.id_profesor
WHERE prof.id_profesor IS NULL;

-- 15. Departamentos sin asignaturas impartidas
SELECT DISTINCT d.nombre
FROM departamento d
LEFT JOIN profesor prof ON d.id = prof.id_departamento
LEFT JOIN asignatura a ON prof.id_profesor = a.id_profesor
LEFT JOIN alumno_se_matricula_asignatura m ON a.id = m.id_asignatura
WHERE m.id_asignatura IS NULL;

-- 16. Total de alumnos
SELECT COUNT(id) AS total
FROM persona
WHERE tipo = 'alumno';

-- 17. Alumnos nacidos en 1999 (conteo)
SELECT COUNT(id) AS total
FROM persona
WHERE tipo = 'alumno'
  AND YEAR(fecha_nacimiento) = 1999;

-- 18. Profesores por departamento (orden desc)
SELECT d.nombre AS departamento, COUNT(p.id) AS total
FROM persona p
JOIN profesor prof ON p.id = prof.id_profesor
JOIN departamento d ON prof.id_departamento = d.id
GROUP BY d.nombre
ORDER BY total DESC;

-- 19. Todos los departamentos y su número de profesores
SELECT d.nombre AS departamento, COUNT(p.id) AS total
FROM persona p
JOIN profesor prof ON p.id = prof.id_profesor
RIGHT JOIN departamento d ON prof.id_departamento = d.id
GROUP BY d.nombre;

-- 20. Grados y número de asignaturas
SELECT g.nombre AS grau, COUNT(a.id) AS total
FROM grado g
LEFT JOIN asignatura a ON g.id = a.id_grado
GROUP BY g.nombre
ORDER BY total DESC;

-- 21. Grados con más de 40 asignaturas
SELECT g.nombre AS grau, COUNT(a.id) AS total
FROM grado g
LEFT JOIN asignatura a ON g.id = a.id_grado
GROUP BY g.nombre
HAVING COUNT(a.id) > 40;

-- 22. Créditos por tipo y grado
SELECT g.nombre AS grau, a.tipo, SUM(a.creditos) AS total_creditos
FROM grado g
JOIN asignatura a ON g.id = a.id_grado
GROUP BY g.nombre, a.tipo;

-- 23. Alumnos matriculados por curso escolar
SELECT ce.anyo_inicio, COUNT(DISTINCT p.id) AS total
FROM persona p
JOIN alumno_se_matricula_asignatura ma ON p.id = ma.id_alumno
JOIN curso_escolar ce ON ma.id_curso_escolar = ce.id
GROUP BY ce.anyo_inicio;

-- 24. Asignaturas por profesor
SELECT p.id, p.nombre, p.apellido1, p.apellido2, COUNT(a.id) AS total
FROM persona p
JOIN profesor prof ON p.id = prof.id_profesor
LEFT JOIN asignatura a ON prof.id_profesor = a.id_profesor
GROUP BY p.id, p.nombre, p.apellido1, p.apellido2
ORDER BY total DESC;

-- 25. Alumno/a más joven
SELECT *
FROM persona
WHERE tipo = 'alumno'
  AND fecha_nacimiento = (
    SELECT MAX(fecha_nacimiento)
    FROM persona
    WHERE tipo = 'alumno');

-- 26. Profesores con departamento pero sin asignaturas
SELECT p.apellido1, p.apellido2, p.nombre
FROM persona p
JOIN profesor prof ON p.id = prof.id_profesor
JOIN departamento d ON prof.id_departamento = d.id
LEFT JOIN asignatura a ON prof.id_profesor = a.id_profesor
WHERE a.id IS NULL;