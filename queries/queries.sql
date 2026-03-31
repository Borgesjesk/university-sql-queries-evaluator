-- 1. Retorna un llistat amb el primer cognom, segon cognom i el nom de tots els/les alumnes.
SELECT apellido1, apellido2, nombre
FROM persona
WHERE tipo = 'alumno'
ORDER BY apellido1, apellido2, nombre;

-- 2. Esbrina el nom i els dos cognoms dels alumnes que no han donat d'alta el seu número de telèfon.
SELECT nombre, apellido1, apellido2
FROM persona
WHERE tipo = 'alumno' AND telefono IS NULL;

-- 3. Retorna el llistat dels alumnes que van néixer en 1999. (nombre, apellido1, apellido2)
SELECT nombre, apellido1, apellido2
FROM persona
WHERE tipo = 'alumno' AND YEAR(fecha_nacimiento) = 1999;

-- 4. Professors/es sense telèfon i NIF que acaba en K.
SELECT nombre, apellido1, apellido2, nif
FROM persona
WHERE tipo = 'profesor' AND telefono IS NULL AND nif LIKE '%K';

-- 5. Assignatures del primer quadrimestre, tercer curs, grau 7.
SELECT id, nombre, cuatrimestre, curso, id_grado
FROM asignatura
WHERE cuatrimestre = 1 AND curso = 3 AND id_grado = 7;

-- 6. Professors juntament amb el nom del departament.
SELECT p.apellido1, p.apellido2, p.nombre, d.nombre AS departamento
FROM persona p
         JOIN profesor prof ON p.id = prof.id_profesor
         JOIN departamento d ON prof.id_departamento = d.id
ORDER BY p.apellido1, p.apellido2, p.nombre;

-- 7. Assignatures i curs de l'alumne amb NIF 26902806M.
SELECT asig.nombre, ce.anyo_inicio, ce.anyo_fin
FROM persona p
         JOIN alumno_se_matricula_asignatura ama ON p.id = ama.id_alumno
         JOIN asignatura asig ON ama.id_asignatura = asig.id
         JOIN curso_escolar ce ON ama.id_curso_escolar = ce.id
WHERE p.nif = '26902806M';

-- 8. Departaments amb professors en Enginyeria Informàtica (Pla 2015).
SELECT DISTINCT d.nombre
FROM departamento d
         JOIN profesor prof ON d.id = prof.id_departamento
         JOIN asignatura asig ON prof.id_profesor = asig.id_profesor
         JOIN grado g ON asig.id_grado = g.id
WHERE g.nombre = 'Grado en Ingeniería Informática (Plan 2015)';

-- 9. Alumnes matriculats en el curs escolar 2018/2019.
SELECT DISTINCT p.nombre, p.apellido1, p.apellido2
FROM persona p
         JOIN alumno_se_matricula_asignatura ama ON p.id = ama.id_alumno
         JOIN curso_escolar ce ON ama.id_curso_escolar = ce.id
WHERE ce.anyo_inicio = 2018 AND ce.anyo_fin = 2019;

-- 10. Professors i els seus departaments (inclou els que no en tenen).
SELECT d.nombre AS departamento, p.apellido1, p.apellido2, p.nombre
FROM persona p
         LEFT JOIN profesor prof ON p.id = prof.id_profesor
         LEFT JOIN departamento d ON prof.id_departamento = d.id
WHERE p.tipo = 'profesor'
ORDER BY d.nombre, p.apellido1, p.apellido2, p.nombre;

-- 11. Professors sense departament.
SELECT p.apellido1, p.apellido2, p.nombre
FROM persona p
         JOIN profesor prof ON p.id = prof.id_profesor
         LEFT JOIN departamento d ON prof.id_departamento = d.id
WHERE d.id IS NULL;

-- 12. Departaments sense professors.
SELECT d.nombre
FROM departamento d
         LEFT JOIN profesor prof ON d.id = prof.id_departamento
WHERE prof.id_profesor IS NULL;

-- 13. Professors que no imparteixen cap assignatura.
SELECT p.apellido1, p.apellido2, p.nombre
FROM persona p
         JOIN profesor prof ON p.id = prof.id_profesor
         LEFT JOIN asignatura asig ON prof.id_profesor = asig.id_profesor
WHERE asig.id IS NULL;

-- 14. Assignatures sense professor assignat.
SELECT id, nombre
FROM asignatura
WHERE id_profesor IS NULL;

-- 15. Retorna un llistat amb tots els departaments que no han impartit assignatures en cap curs escolar. (nombre)
SELECT DISTINCT d.nombre
FROM departamento d
         LEFT JOIN profesor prof ON d.id = prof.id_departamento
         LEFT JOIN asignatura asig ON prof.id_profesor = asig.id_profesor
WHERE asig.id IS NULL;

-- 16. Nombre total d'alumnes.
SELECT COUNT(*) AS total
FROM persona
WHERE tipo = 'alumno';

-- 17. Alumnes nascuts en 1999.
SELECT COUNT(*) AS total
FROM persona
WHERE tipo = 'alumno' AND YEAR(fecha_nacimiento) = 1999;

-- 18. Professors per departament (només amb associats).
SELECT d.nombre AS departamento, COUNT(prof.id_profesor) AS total
FROM departamento d
         JOIN profesor prof ON d.id = prof.id_departamento
GROUP BY d.id
ORDER BY total DESC;

-- 19. Tots els departaments i el seu nombre de professors.
SELECT d.nombre AS departamento, COUNT(prof.id_profesor) AS total
FROM departamento d
         LEFT JOIN profesor prof ON d.id = prof.id_departamento
GROUP BY d.id;

-- 20. Graus i el seu nombre d'assignatures.
SELECT g.nombre AS grau, COUNT(a.id) AS total
FROM grado g
         LEFT JOIN asignatura a ON g.id = a.id_grado
GROUP BY g.id
ORDER BY total DESC;

-- 21. Graus amb més de 40 assignatures.
SELECT g.nombre AS grau, COUNT(a.id) AS total
FROM grado g
         JOIN asignatura a ON g.id = a.id_grado
GROUP BY g.id
HAVING total > 40;

-- 22. Retorna un llistat que mostri el nom dels graus i la suma del nombre total de crèdits... (grau, tipus, total_creditos)
SELECT g.nombre AS grau, a.tipo AS tipus, SUM(a.creditos) AS total_creditos
FROM grado g
         JOIN asignatura a ON g.id = a.id_grado
GROUP BY g.id, a.tipo;

-- 23. Alumnes matriculats per curs escolar.
SELECT ce.anyo_inicio, COUNT(DISTINCT ama.id_alumno) AS total
FROM curso_escolar ce
         JOIN alumno_se_matricula_asignatura ama ON ce.id = ama.id_curso_escolar
GROUP BY ce.id;

-- 24. Assignatures per professor.
SELECT p.id, p.nombre, p.apellido1, p.apellido2, COUNT(a.id) AS total
FROM persona p
         JOIN profesor prof ON p.id = prof.id_profesor
         LEFT JOIN asignatura a ON prof.id_profesor = a.id_profesor
GROUP BY p.id
ORDER BY total DESC;

-- 25. Alumne/a més jove.
SELECT id, nif, nombre, apellido1, apellido2, ciudad, direccion, telefono, fecha_nacimiento, sexo, tipo
FROM persona
WHERE tipo = 'alumno'
ORDER BY fecha_nacimiento DESC
LIMIT 1;

-- 26. Professors amb departament però sense assignatura.
SELECT p.apellido1, p.apellido2, p.nombre
FROM persona p
         JOIN profesor prof ON p.id = prof.id_profesor
         LEFT JOIN asignatura asig ON prof.id_profesor = asig.id_profesor
WHERE prof.id_departamento IS NOT NULL AND asig.id IS NULL;