-- ============================================================
-- 20 CONSULTAS SQL - SISTEMA DE ALOJAMIENTOS
-- PostgreSQL
-- ============================================================

-- ============================================================
-- 01. INSERT - Insertar propietario
-- ============================================================

INSERT INTO propietarios (
    nombre,
    apellido,
    email,
    telefono
)
VALUES (
    'Roberto',
    'Hernández',
    'roberto.h2026@email.com',
    '+503-7890-5555'
)
RETURNING id_propietario;


-- ============================================================
-- 02. INSERT - Insertar alojamiento vinculado al propietario
-- ============================================================

-- Se utiliza el propietario con ID 6 que ya existe.
-- NO se coloca id_alojamiento porque PostgreSQL lo genera.

INSERT INTO alojamientos (
    id_propietario,
    nombre,
    descripcion,
    tipo,
    direccion,
    ciudad,
    pais,
    precio_noche,
    capacidad_personas,
    num_habitaciones,
    num_banos
)
VALUES (
    6,
    'Apartamento Vista Hermosa',
    'Apartamento elegante y amplio',
    'apartamento',
    'Av. Magnolias #456',
    'San Salvador',
    'El Salvador',
    85.00,
    4,
    2,
    2
)
RETURNING id_alojamiento;


-- ============================================================
-- 03. INSERT - Insertar huésped
-- ============================================================

INSERT INTO huespedes (
    nombre,
    apellido,
    email,
    nacionalidad
)
VALUES (
    'Carlos',
    'Gutiérrez',
    'carlos.g2026@email.com',
    'Costa Rica'
)
RETURNING id_huesped;


-- ============================================================
-- 04. INSERT - Crear reserva y pago
-- ============================================================

-- Se utilizan IDs que ya existen:
-- alojamiento = 11
-- huésped = 11
--
-- NO se coloca id_reserva.
-- PostgreSQL lo genera automáticamente.

WITH nueva_reserva AS (

    INSERT INTO reservas (
        id_alojamiento,
        id_huesped,
        fecha_entrada,
        fecha_salida,
        num_personas,
        precio_total,
        estado
    )
    VALUES (
        11,
        11,
        '2026-08-10',
        '2026-08-15',
        2,
        425.00,
        'confirmada'
    )
    RETURNING id_reserva

)

INSERT INTO pagos (
    id_reserva,
    monto,
    metodo_pago
)
SELECT
    id_reserva,
    425.00,
    'tarjeta'
FROM nueva_reserva;


-- ============================================================
-- 05. SELECT - Alojamientos activos
-- ============================================================

SELECT
    nombre,
    tipo,
    ciudad,
    precio_noche
FROM alojamientos
WHERE activo = TRUE;


-- ============================================================
-- 06. SELECT - Huéspedes por país
-- ============================================================

SELECT
    nombre,
    apellido,
    email,
    nacionalidad
FROM huespedes
WHERE nacionalidad = 'Estados Unidos';


-- ============================================================
-- 07. SELECT - Reservas por fechas
-- ============================================================

SELECT
    id_reserva,
    fecha_entrada,
    fecha_salida,
    precio_total
FROM reservas
WHERE fecha_entrada BETWEEN '2025-07-01' AND '2025-08-31';


-- ============================================================
-- 08. UPDATE - Actualizar propietario
-- ============================================================

UPDATE propietarios
SET email = 'roberto.actualizado@email.com'
WHERE id_propietario = 6;


-- ============================================================
-- 08. UPDATE - Actualizar precio del alojamiento
-- ============================================================

UPDATE alojamientos
SET precio_noche = 50.00
WHERE id_alojamiento = 1;


-- ============================================================
-- 09. UPDATE - Actualizar estado de reserva
-- ============================================================

UPDATE reservas
SET estado = 'completada'
WHERE id_reserva = 5;


-- ============================================================
-- 10. DELETE - Eliminar reseña
-- ============================================================

DELETE FROM resenas
WHERE id_resena = 3;


-- ============================================================
-- 11. JOIN - Reservas + huéspedes
-- ============================================================

SELECT
    r.id_reserva,
    r.fecha_entrada,
    r.fecha_salida,
    r.precio_total,
    h.nombre,
    h.apellido,
    h.nacionalidad
FROM reservas r
INNER JOIN huespedes h
    ON r.id_huesped = h.id_huesped;


-- ============================================================
-- 12. JOIN - Alojamiento + propietario + reserva
-- ============================================================

SELECT
    a.nombre AS alojamiento,
    a.ciudad,
    p.nombre AS propietario,
    p.apellido AS apellido_propietario,
    r.fecha_entrada
FROM alojamientos a
INNER JOIN propietarios p
    ON a.id_propietario = p.id_propietario
INNER JOIN reservas r
    ON a.id_alojamiento = r.id_alojamiento;


-- ============================================================
-- 13. JOIN - Pagos + reservas + huéspedes
-- ============================================================

SELECT
    pag.monto,
    pag.metodo_pago,
    r.fecha_entrada,
    r.fecha_salida,
    h.nombre AS huesped,
    h.apellido
FROM pagos pag
INNER JOIN reservas r
    ON pag.id_reserva = r.id_reserva
INNER JOIN huespedes h
    ON r.id_huesped = h.id_huesped;


-- ============================================================
-- 14. LEFT JOIN - Alojamientos sin reseñas
-- ============================================================

SELECT
    a.nombre AS alojamiento,
    COUNT(res.id_resena) AS total_resenas
FROM alojamientos a
LEFT JOIN resenas res
    ON a.id_alojamiento = res.id_alojamiento
GROUP BY
    a.id_alojamiento,
    a.nombre
HAVING COUNT(res.id_resena) = 0;


-- ============================================================
-- 15. LEFT JOIN - Alojamientos sin reservas
-- ============================================================

SELECT
    a.nombre AS alojamiento,
    a.ciudad
FROM alojamientos a
LEFT JOIN reservas r
    ON a.id_alojamiento = r.id_alojamiento
WHERE r.id_reserva IS NULL;


-- ============================================================
-- 16. AGG - Total de ingresos por alojamiento
-- ============================================================

SELECT
    a.nombre AS alojamiento,
    SUM(r.precio_total) AS ingresos_totales
FROM alojamientos a
INNER JOIN reservas r
    ON a.id_alojamiento = r.id_alojamiento
GROUP BY
    a.id_alojamiento,
    a.nombre;


-- ============================================================
-- 17. AGG - Promedio de calificación
-- ============================================================

SELECT
    a.nombre AS alojamiento,
    AVG(res.calificacion) AS promedio_calificacion
FROM alojamientos a
INNER JOIN resenas res
    ON a.id_alojamiento = res.id_alojamiento
GROUP BY
    a.id_alojamiento,
    a.nombre;


-- ============================================================
-- 18. AGG - Top 5 alojamientos con más reservas
-- ============================================================

SELECT
    a.nombre AS alojamiento,
    COUNT(r.id_reserva) AS total_reservas
FROM alojamientos a
INNER JOIN reservas r
    ON a.id_alojamiento = r.id_alojamiento
GROUP BY
    a.id_alojamiento,
    a.nombre
ORDER BY
    total_reservas DESC
LIMIT 5;


-- ============================================================
-- 19. HAVING - Alojamientos con más de 3 reservas
-- ============================================================

SELECT
    a.nombre AS alojamiento,
    COUNT(r.id_reserva) AS total_reservas
FROM alojamientos a
INNER JOIN reservas r
    ON a.id_alojamiento = r.id_alojamiento
GROUP BY
    a.id_alojamiento,
    a.nombre
HAVING COUNT(r.id_reserva) > 3;


-- ============================================================
-- 20. SUBCONSULTA - Alojamiento más caro
-- ============================================================

SELECT
    nombre,
    precio_noche
FROM alojamientos
WHERE precio_noche = (
    SELECT MAX(precio_noche)
    FROM alojamientos
);


-- ============================================================
-- FIN DEL SCRIPT
-- ============================================================
