-- 1. Retorna un llistat amb el primer cognom, segon cognom i el nom de tots els/les alumnes. El llistat haurà d'estar ordenat alfabèticament de menor a major pel primer cognom, segon cognom i nom.
SELECT apellido1, apellido2, nombre
FROM persona-- 1. Retorna un llistat amb el primer cognom, segon cognom i el nom de tots els/les alumnes.
SELECT apellido1, apellido2, nombre
FROM persona
WHERE tipo = 'alumno'
ORDER BY apellido1, apellido2, nombre ASC;

-- 2. Esbrina el nom i els dos cognoms dels alumnes que no han donat d'alta el seu telèfon.
SELECT nombre, apellido1, apellido2
FROM persona
WHERE tipo = 'alumno'
  AND telefono IS NULL;

-- 3. Retorna el llistat dels alumnes que van néixer en 1999 (només nombre, apellido1, apellido2 segons el teu diff).
SELECT nombre, apellido1, apellido2
FROM persona
WHERE tipo = 'alumno'
  AND YEAR(fecha_nacimiento) = 1999;

-- 4. Professors sense telèfon i NIF acabat en K.
SELECT nombre, apellido1, apellido2, nif
FROM persona
WHERE tipo = 'profesor'
  AND telefono IS NULL
  AND nif LIKE '%K';

-- 5. Assignatures 1er quadrimestre, 3er curs, grau 7.
SELECT id, nombre, cuatrimestre, curso, id_grado
FROM asignatura
WHERE cuatrimestre = 1
  AND curso = 3
  AND id_grado = 7;

-- 6. Retorna un llistat dels professors/es juntament amb el nom del departament al qual estan vinculats. El llistat ha de retornar quatre columnes, primer cognom, segon cognom, nom i nom del departament. El resultat estarà ordenat alfabèticament de menor a major pels cognoms i el nom.
SELECT p.apellido1, p.apellido2, p.nombre, d.nombre AS departamento
FROM persona p
         JOIN profesor prof ON p.id = prof.id_profesor
         JOIN departamento d ON prof.id_departamento = d.id
ORDER BY p.apellido1, p.apellido2, p.nombre, d.nombre ASC;

-- 7. Retorna un llistat amb el nom de les assignatures, any d'inici i any de fi del curs escolar de l'alumne/a amb NIF 26902806M.
SELECT a.nombre, ce.anyo_inicio, ce.anyo_fin
FROM asignatura a
         JOIN alumno_se_matricula_asignatura ma ON a.id = ma.id_asignatura
         JOIN curso_escolar ce ON ce.id = ma.id_curso_escolar
         JOIN persona p ON ma.id_alumno = p.id
WHERE p.nif = '26902806M';

-- 8. Retorna un llistat amb el nom de tots els departaments que tenen professors/es que imparteixen alguna assignatura en el Grau en Enginyeria Informàtica (Pla 2015).
SELECT DISTINCT d.nombre
FROM asignatura a
         JOIN profesor p ON a.id_profesor = p.id_profesor
         JOIN departamento d ON d.id = p.id_departamento
         JOIN grado g ON g.id = a.id_grado
WHERE g.nombre = 'Grado en Ingeniería Informática (Plan 2015)';

-- 9. Retorna un llistat amb tots els alumnes que s'han matriculat en alguna assignatura durant el curs escolar 2018/2019.
SELECT DISTINCT p.nombre, p.apellido1, p.apellido2
FROM persona p
         JOIN alumno_se_matricula_asignatura ma ON p.id = ma.id_alumno
         JOIN asignatura a ON a.id = id_asignatura
         JOIN curso_escolar ce ON ce.id = ma.id_curso_escolar
WHERE ce.anyo_inicio = 2018
  AND ce.anyo_fin = 2019;

-- 10. Retorna un llistat amb els noms de tots els professors/es i els departaments que tenen vinculats. El llistat també ha de mostrar aquells professors/es que no tenen cap departament associat. El resultat estarà ordenat alfabèticament pel nom del departament, cognoms i el nom.
SELECT d.nombre AS departamento, p.apellido1, p.apellido2, p.nombre
FROM persona p
         RIGHT JOIN profesor prof ON p.id = prof.id_profesor
         LEFT JOIN departamento d ON prof.id_departamento = d.id
ORDER BY d.nombre, p.apellido1, p.apellido2, p.nombre ASC;

-- 11. Retorna un llistat amb els professors/es que no estan associats a un departament.
SELECT p.apellido1, p.apellido2, p.nombre
FROM persona p
         LEFT JOIN profesor prof ON p.id = prof.id_profesor
WHERE p.tipo = 'Profesor'
  AND prof.id_departamento IS NULL;

-- 12. Retorna un llistat amb els departaments que no tenen professors/es associats.
SELECT d.nombre
FROM departamento d
         LEFT JOIN profesor prof ON d.id = prof.id_departamento
WHERE prof.id_departamento IS NULL;

-- 13. Retorna un llistat amb els professors/es que no imparteixen cap assignatura.
SELECT p.apellido1, p.apellido2, p.nombre
FROM persona p
         RIGHT JOIN profesor prof ON p.id = prof.id_profesor
         LEFT JOIN asignatura a ON a.id_profesor = prof.id_profesor
WHERE a.id IS NULL;

-- 14. Retorna un llistat amb les assignatures que no tenen un professor/a assignat.
SELECT a.id, a.nombre
FROM asignatura a
         LEFT JOIN profesor prof ON a.id_profesor = prof.id_profesor
WHERE prof.id_profesor IS NULL;

-- 15. Retorna un llistat amb tots els departaments que no han impartit assignatures en cap curs escolar.
SELECT DISTINCT d.nombre
FROM departamento d
         LEFT JOIN profesor prof ON d.id = prof.id_departamento
         LEFT JOIN asignatura a ON prof.id_profesor = a.id_profesor
         LEFT JOIN alumno_se_matricula_asignatura m ON a.id = m.id_asignatura
WHERE m.id_asignatura IS NULL;

-- 16. Retorna el nombre total d'alumnes que hi ha.
SELECT COUNT(id) AS total
FROM persona
WHERE tipo = 'alumno';

-- 17. Calcula quants alumnes van néixer en 1999.
SELECT COUNT(id) AS total
FROM persona
WHERE tipo = 'alumno'
  AND YEAR(fecha_nacimiento) = 1999;

-- 18. Calcula quants professors/es hi ha en cada departament. El llistat només ha d'incloure els departaments que tenen professors/es associats i haurà d'estar ordenat de major a menor pel nombre de professors/es.
SELECT d.nombre AS departamento, COUNT(p.id) AS total
FROM persona p
         JOIN profesor prof ON p.id = prof.id_profesor
         JOIN departamento d ON prof.id_departamento = d.id
GROUP BY d.nombre
ORDER BY total DESC;

-- 19. Retorna un llistat amb tots els departaments i el nombre de professors/es que hi ha en cadascun d'ells. Tingui en compte que poden existir departaments que no tenen professors/es associats.
SELECT d.nombre AS departamento, COUNT(p.id) AS total
FROM persona p
         JOIN profesor prof ON p.id = prof.id_profesor
         RIGHT JOIN departamento d ON prof.id_departamento = d.id
GROUP BY d.nombre;

-- 20. Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun. El resultat haurà d'estar ordenat de major a menor pel nombre d'assignatures.
SELECT g.nombre AS grau, COUNT(a.id) AS total
FROM grado g
         LEFT JOIN asignatura a ON g.id = a.id_grado
GROUP BY g.nombre
ORDER BY total DESC;

-- 21. Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun, dels graus que tinguin més de 40 assignatures associades.
SELECT g.nombre AS grau, COUNT(a.id) AS total
FROM grado g
         LEFT JOIN asignatura a ON g.id = a.id_grado
GROUP BY g.nombre
HAVING COUNT(a.id) > 40;

-- 22. Crèdits per tipus i grau (Compte amb l'àlies 'tipus')
SELECT g.nombre AS grau, a.tipo AS tipus, SUM(a.creditos) AS total_creditos
FROM grado g
         JOIN asignatura a ON g.id = a.id_grado
GROUP BY g.nombre, a.tipo;

-- 23. Retorna un llistat que mostri quants alumnes s'han matriculat d'alguna assignatura en cadascun dels cursos escolars.
SELECT ce.anyo_inicio, COUNT(DISTINCT p.id) AS total
FROM persona p
         JOIN alumno_se_matricula_asignatura ma ON p.id = ma.id_alumno
         JOIN curso_escolar ce ON ma.id_curso_escolar = ce.id
GROUP BY ce.anyo_inicio;

-- 24. Retorna un llistat amb el nombre d'assignatures que imparteix cada professor/a. El resultat estarà ordenat de major a menor pel nombre d'assignatures.
SELECT p.id, p.nombre, p.apellido1, p.apellido2, COUNT(a.id) AS total
FROM persona p
         JOIN profesor prof ON p.id = prof.id_profesor
         LEFT JOIN asignatura a ON prof.id_profesor = a.id_profesor
GROUP BY p.id, p.nombre, p.apellido1, p.apellido2
ORDER BY total DESC;

-- 25. Retorna totes les dades de l'alumne/a més jove.
SELECT *
FROM persona
WHERE tipo = 'alumno'
  AND fecha_nacimiento = (SELECT MAX(fecha_nacimiento)
                          FROM persona
                          WHERE tipo = 'alumno');

-- 26. Retorna un llistat amb els professors/es que tenen un departament associat i que no imparteixen cap assignatura.
SELECT p.apellido1, p.apellido2, p.nombre
FROM persona p
         JOIN profesor prof ON p.id = prof.id_profesor
         JOIN departamento d ON prof.id_departamento = d.id
         LEFT JOIN asignatura a ON prof.id_profesor = a.id_profesor
WHERE a.id IS NULL;