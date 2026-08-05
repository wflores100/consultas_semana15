# consultas_semana15
# 🏨 Sistema de Gestión de Alojamientos

Sistema de gestión de alojamientos turísticos desarrollado con **PostgreSQL**.  
El proyecto permite administrar propietarios, alojamientos, huéspedes, reservas, pagos y reseñas.

---

## 📋 Descripción

La base de datos está diseñada para gestionar información relacionada con alojamientos turísticos, permitiendo:

- Registrar propietarios.
- Registrar alojamientos.
- Registrar huéspedes.
- Gestionar reservas.
- Registrar pagos.
- Gestionar reseñas y calificaciones.
- Consultar alojamientos disponibles.
- Consultar reservas y huéspedes.
- Obtener estadísticas mediante funciones de agregación.
- Realizar consultas utilizando `JOIN`, `LEFT JOIN`, `GROUP BY`, `HAVING` y subconsultas.

---

## 🗄️ Esquema de la Base de Datos

El siguiente diagrama representa la estructura y relaciones principales de la base de datos:

##mermaid
erDiagram

    PROPIETARIOS {
        INT id_propietario PK
        VARCHAR nombre
        VARCHAR apellido
        VARCHAR email UK
        VARCHAR telefono
    }

    ALOJAMIENTOS {
        INT id_alojamiento PK
        INT id_propietario FK
        VARCHAR nombre
        TEXT descripcion
        VARCHAR tipo
        VARCHAR direccion
        VARCHAR ciudad
        VARCHAR pais
        DECIMAL precio_noche
        INT capacidad_personas
        INT num_habitaciones
        INT num_banos
        BOOLEAN activo
    }

    HUESPEDES {
        INT id_huesped PK
        VARCHAR nombre
        VARCHAR apellido
        VARCHAR email
        VARCHAR nacionalidad
    }

    RESERVAS {
        INT id_reserva PK
        INT id_alojamiento FK
        INT id_huesped FK
        DATE fecha_entrada
        DATE fecha_salida
        INT num_personas
        DECIMAL precio_total
        VARCHAR estado
    }

    PAGOS {
        INT id_pago PK
        INT id_reserva FK
        DECIMAL monto
        VARCHAR metodo_pago
    }

    RESENAS {
        INT id_resena PK
        INT id_alojamiento FK
        INT calificacion
    }

    PROPIETARIOS ||--o{ ALOJAMIENTOS : "posee"

    ALOJAMIENTOS ||--o{ RESERVAS : "recibe"

    HUESPEDES ||--o{ RESERVAS : "realiza"

    RESERVAS ||--o{ PAGOS : "genera"

    ALOJAMIENTOS ||--o{ RESENAS : "recibe"
```

---

## 🔗 Relaciones

| Relación | Descripción |
|---|---|
| `propietarios → alojamientos` | Un propietario puede tener uno o varios alojamientos. |
| `alojamientos → reservas` | Un alojamiento puede tener múltiples reservas. |
| `huespedes → reservas` | Un huésped puede realizar múltiples reservas. |
| `reservas → pagos` | Una reserva puede generar uno o varios pagos. |
| `alojamientos → resenas` | Un alojamiento puede recibir múltiples reseñas. |

### Cardinalidades

##text
PROPIETARIOS
     │
     │ 1:N
     ▼
ALOJAMIENTOS
     │
     ├───────────────┐
     │               │
     │ 1:N           │ 1:N
     ▼               ▼
RESERVAS          RESENAS
     │
     │ N:1
     ▼
HUESPEDES

RESERVAS
     │
     │ 1:N
     ▼
PAGOS
```

---

## 📊 Tablas principales

### 👤 Propietarios

Almacena la información de las personas propietarias de los alojamientos.

**Campos principales:**

- `id_propietario` — Clave primaria.
- `nombre`
- `apellido`
- `email`
- `telefono`

---

### 🏠 Alojamientos

Contiene la información de los alojamientos turísticos.

**Campos principales:**

- `id_alojamiento` — Clave primaria.
- `id_propietario` — Clave foránea.
- `nombre`
- `descripcion`
- `tipo`
- `direccion`
- `ciudad`
- `pais`
- `precio_noche`
- `capacidad_personas`
- `num_habitaciones`
- `num_banos`
- `activo`

---

### 🧳 Huéspedes

Almacena la información de los clientes que realizan reservas.

**Campos principales:**

- `id_huesped` — Clave primaria.
- `nombre`
- `apellido`
- `email`
- `nacionalidad`

---

### 📅 Reservas

Registra las reservas realizadas por los huéspedes.

**Campos principales:**

- `id_reserva` — Clave primaria.
- `id_alojamiento` — Clave foránea.
- `id_huesped` — Clave foránea.
- `fecha_entrada`
- `fecha_salida`
- `num_personas`
- `precio_total`
- `estado`

---

### 💳 Pagos

Registra los pagos asociados a las reservas.

**Campos principales:**

- `id_pago` — Clave primaria.
- `id_reserva` — Clave foránea.
- `monto`
- `metodo_pago`

---

### ⭐ Reseñas

Almacena las reseñas y calificaciones realizadas sobre los alojamientos.

**Campos principales:**

- `id_resena` — Clave primaria.
- `id_alojamiento` — Clave foránea.
- `calificacion`

---

## 🔍 Consultas SQL incluidas

El proyecto contiene **20 consultas SQL** utilizando diferentes operaciones de PostgreSQL:

| Nº | Tipo | Operación |
|---:|---|---|
| 01 | INSERT | Insertar propietario |
| 02 | INSERT | Insertar alojamiento |
| 03 | INSERT | Insertar huésped |
| 04 | INSERT | Crear reserva y pago |
| 05 | SELECT | Alojamientos activos |
| 06 | SELECT | Huéspedes por país |
| 07 | SELECT | Reservas por fechas |
| 08 | UPDATE | Actualizar propietario |
| 09 | UPDATE | Actualizar precio |
| 10 | UPDATE | Actualizar estado de reserva |
| 11 | DELETE | Eliminar reseña |
| 12 | JOIN | Reservas + huéspedes |
| 13 | JOIN | Alojamiento + propietario + reserva |
| 14 | JOIN | Pagos + reservas + huéspedes |
| 15 | LEFT JOIN | Alojamientos sin reseñas |
| 16 | LEFT JOIN | Alojamientos sin reservas |
| 17 | AGG | Total de ingresos |
| 18 | AGG | Promedio de calificación |
| 19 | AGG | Top 5 alojamientos |
| 20 | HAVING / SUBCONSULTA | Consultas avanzadas |

---

## 🧠 Conceptos SQL utilizados

El proyecto permite practicar los siguientes conceptos:

##text
INSERT
SELECT
UPDATE
DELETE
INNER JOIN
LEFT JOIN
GROUP BY
HAVING
ORDER BY
LIMIT
COUNT()
SUM()
AVG()
MAX()
WITH
CTE
SUBCONSULTAS
RETURNING
CLAVES PRIMARIAS
CLAVES FORÁNEAS
```

---

## 🛠️ Tecnologías utilizadas

- 🐘 PostgreSQL
- 🗃️ SQL
- 🐙 Git
- 🐙 GitHub
- 📊 Mermaid ER Diagram

---

## 📁 Estructura sugerida del repositorio

```text
sistema-alojamientos/
│
├── README.md
│
├── sql/
│   ├── 01_creacion_tablas.sql
│   ├── 02_datos.sql
│   └── 03_consultas.sql
│
└── docs/
    └── esquema-base-datos.md
```


## 👨‍💻 Proyecto

**Sistema de Gestión de Alojamientos Turísticos**

Base de datos desarrollada utilizando PostgreSQL para practicar operaciones CRUD, relaciones entre tablas, consultas avanzadas y funciones de agregación.
