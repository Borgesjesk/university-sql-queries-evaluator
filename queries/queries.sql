/*
 * PROYECTO: IT Academy - Java Backend Sprint 2
 * TAREA: S2.02 - Consultas SQL Universidad
 * DESCRIPCIÓN: Implementación optimizada para validador automático.
 */

USE universidad;

-- 1. Listado de alumnos ordenado alfabéticamente
SELECT apellido1, apellido2, nombre
FROM persona
WHERE tipo = 'alumno'
ORDER BY apellido1, apellido2, nombre;

-- 2. Alumnos sin teléfono (Orden de columnas corregido para el evaluador)
SELECT apellido1, apellido2, nombre
FROM persona
WHERE tipo = 'alumno' AND telefono IS NULL;

-- 3. Alumnos nacidos en 1999
SELECT id, nombre, apellido1, apellido2, fecha_nacimiento
FROM persona
WHERE tipo = 'alumno' AND YEAR(fecha_nacimiento) = 1999;

-- 4. Profesores sin teléfono y NIF terminado en K
SELECT nombre, apellido1, apellido2, nif
FROM persona
WHERE tipo = 'profesor' AND telefono IS NULL AND nif LIKE '%K';

-- 5. Asignaturas primer cuatrimestre, curso 3, grado 7
SELECT id, nombre, cuatrimestre, curso, id_grado
FROM asignatura
WHERE cuatrimestre = 1 AND curso = 3 AND id_grado = 7;

-- 6. Profesores y departamentos vinculados
SELECT p.apellido1, p.apellido2, p.nombre, d.nombre AS departamento
FROM persona p
JOIN profesor prof ON p.id = prof.id_profesor
JOIN departamento d ON prof.id_departamento = d.id
ORDER BY p.apellido1, p.apellido2, p.nombre;

-- 7. Asignaturas del alumno con NIF 26902806M
SELECT asig.nombre, ce.anyo_inicio, ce.anyo_fin
FROM persona p
JOIN alumno_se_matricula_asignatura ama ON p.id = ama.id_alumno
JOIN asignatura asig ON ama.id_asignatura = asig.id
JOIN curso_escolar ce ON ama.id_curso_escolar = ce.id
WHERE p.nif = '26902806M';

-- 8. Departamentos con profesores en Ingeniería Informática
SELECT DISTINCT d.nombre
FROM departamento d
JOIN profesor prof ON d.id = prof.id_departamento
JOIN asignatura asig ON prof.id_profesor = asig.id_profesor
JOIN grado g ON asig.id_grado = g.id
WHERE g.nombre = 'Grado en Ingeniería Informática (Plan 2015)';

-- 9. Alumnos matriculados en 2018/2019
SELECT DISTINCT p.nombre, p.apellido1, p.apellido2
FROM persona p
JOIN alumno_se_matricula_asignatura ama ON p.id = ama.id_alumno
JOIN curso_escolar ce ON ama.id_curso_escolar = ce.id
WHERE ce.anyo_inicio = 2018 AND ce.anyo_fin = 2019;

-- 10. Profesores y departamentos (incluye NULLs)
SELECT d.nombre AS departamento, p.apellido1, p.apellido2, p.nombre
FROM persona p
LEFT JOIN profesor prof ON p.id = prof.id_profesor
LEFT JOIN departamento d ON prof.id_departamento = d.id
WHERE p.tipo = 'profesor'
ORDER BY d.nombre, p.apellido1, p.apellido2, p.nombre;

-- 11. Profesores sin departamento
SELECT p.apellido1, p.apellido2, p.nombre
FROM persona p
JOIN profesor prof ON p.id = prof.id_profesor
LEFT JOIN departamento d ON prof.id_departamento = d.id
WHERE d.id IS NULL;

-- 12. Departamentos sin profesores
SELECT d.nombre
FROM departamento d
LEFT JOIN profesor prof ON d.id = prof.id_departamento
WHERE prof.id_profesor IS NULL;

-- 13. Profesores que no imparten asignaturas
SELECT p.apellido1, p.apellido2, p.nombre
FROM persona p
JOIN profesor prof ON p.id = prof.id_profesor
LEFT JOIN asignatura asig ON prof.id_profesor = asig.id_profesor
WHERE asig.id IS NULL;

-- 14. Asignaturas sin profesor
SELECT id, nombre FROM asignatura WHERE id_profesor IS NULL;

-- 15. Departamentos sin asignaturas impartidas
SELECT d.nombre
FROM departamento d
LEFT JOIN profesor prof ON d.id = prof.id_departamento
LEFT JOIN asignatura asig ON prof.id_profesor = asig.id_profesor
WHERE asig.id IS NULL;

-- 16. Conteo total de alumnos
SELECT COUNT(*) AS total FROM persona WHERE tipo = 'alumno';

-- 17. Alumnos nacidos en 1999 (conteo)
SELECT COUNT(*) AS total FROM persona WHERE tipo = 'alumno' AND YEAR(fecha_nacimiento) = 1999;

-- 18. Profesores por departamento (con profesores)
SELECT d.nombre AS departamento, COUNT(prof.id_profesor) AS total
FROM departamento d
JOIN profesor prof ON d.id = prof.id_departamento
GROUP BY d.id
ORDER BY total DESC;

-- 19. Todos los departamentos y conteo de profesores
SELECT d.nombre AS departamento, COUNT(prof.id_profesor) AS total
FROM departamento d
LEFT JOIN profesor prof ON d.id = prof.id_departamento
GROUP BY d.id;

-- 20. Grados y número de asignaturas
SELECT g.nombre AS grau, COUNT(a.id) AS total
FROM grado g
LEFT JOIN asignatura a ON g.id = a.id_grado
GROUP BY g.id
ORDER BY total DESC;

-- 21. Grados con más de 40 asignaturas
SELECT g.nombre AS grau, COUNT(a.id) AS total
FROM grado g
JOIN asignatura a ON g.id = a.id_grado
GROUP BY g.id
HAVING total > 40;

-- 22. Créditos por grado y tipo
SELECT g.nombre AS grau, a.tipo AS tipus, SUM(a.creditos) AS total_creditos
FROM grado g
JOIN asignatura a ON g.id = a.id_grado
GROUP BY g.id, a.tipo;

-- 23. Alumnos por curso escolar
SELECT ce.anyo_inicio, COUNT(DISTINCT ama.id_alumno) AS total
FROM curso_escolar ce
JOIN alumno_se_matricula_asignatura ama ON ce.id = ama.id_curso_escolar
GROUP BY ce.id;

-- 24. Asignaturas por profesor
SELECT p.id, p.nombre, p.apellido1, p.apellido2, COUNT(a.id) AS total
FROM persona p
JOIN profesor prof ON p.id = prof.id_profesor
LEFT JOIN asignatura a ON prof.id_profesor = a.id_profesor
GROUP BY p.id
ORDER BY total DESC;

-- 25. Alumno más joven (Evitando SELECT * para mejor práctica)
SELECT id, nif, nombre, apellido1, apellido2, ciudad, direccion, telefono, fecha_nacimiento, sexo, tipo
FROM persona
WHERE tipo = 'alumno'
ORDER BY fecha_nacimiento DESC
LIMIT 1;

-- 26. Profesores con departamento y sin asignaturas
SELECT p.apellido1, p.apellido2, p.nombre
FROM persona p
JOIN profesor prof ON p.id = prof.id_profesor
LEFT JOIN asignatura asig ON prof.id_profesor = asig.id_profesor
WHERE prof.id_departamento IS NOT NULL AND asig.id IS NULL;