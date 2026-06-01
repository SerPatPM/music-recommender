-- ============================================================
-- Script SQL: Music Recommender
-- Base de datos: PostgreSQL (Supabase)
-- Proyecto: Music Recommender API
-- Escuela Superior de Cómputo - IPN
-- ============================================================

-- ============================================================
-- LIMPIEZA PREVIA (en orden inverso por dependencias)
-- ============================================================
DROP TABLE IF EXISTS public.respuesta_quiz CASCADE;
DROP TABLE IF EXISTS public.resultado_quiz CASCADE;
DROP TABLE IF EXISTS public.opcion_rasgo CASCADE;
DROP TABLE IF EXISTS public.opcion_quiz CASCADE;
DROP TABLE IF EXISTS public.pregunta_quiz CASCADE;
DROP TABLE IF EXISTS public.perfil_rasgo CASCADE;
DROP TABLE IF EXISTS public.perfil_playlist CASCADE;
DROP TABLE IF EXISTS public.rasgo_personalidad CASCADE;
DROP TABLE IF EXISTS public.cancion_actividad CASCADE;
DROP TABLE IF EXISTS public.playlist_actividad CASCADE;
DROP TABLE IF EXISTS public.cancion_estado_animo CASCADE;
DROP TABLE IF EXISTS public.playlist_estado_animo CASCADE;
DROP TABLE IF EXISTS public.cancion_genero CASCADE;
DROP TABLE IF EXISTS public.artista_genero CASCADE;
DROP TABLE IF EXISTS public.playlist_genero CASCADE;
DROP TABLE IF EXISTS public.cancion_pais_popularidad CASCADE;
DROP TABLE IF EXISTS public.artista_pais_popularidad CASCADE;
DROP TABLE IF EXISTS public.genero_pais_popularidad CASCADE;
DROP TABLE IF EXISTS public.playlist_cancion CASCADE;
DROP TABLE IF EXISTS public.cancion_artista CASCADE;
DROP TABLE IF EXISTS public.playlist_pais CASCADE;
DROP TABLE IF EXISTS public.playlist_estado_animo CASCADE;
DROP TABLE IF EXISTS public.actividad CASCADE;
DROP TABLE IF EXISTS public.estado_animo CASCADE;
DROP TABLE IF EXISTS public.playlist CASCADE;
DROP TABLE IF EXISTS public.perfil_musical CASCADE;
DROP TABLE IF EXISTS public.cancion CASCADE;
DROP TABLE IF EXISTS public.artista CASCADE;
DROP TABLE IF EXISTS public.genero CASCADE;
DROP TABLE IF EXISTS public.pais CASCADE;
DROP TABLE IF EXISTS public.usuario CASCADE;

-- ============================================================
-- SECUENCIAS
-- ============================================================
CREATE SEQUENCE IF NOT EXISTS actividad_id_actividad_seq;
CREATE SEQUENCE IF NOT EXISTS artista_id_artista_seq;
CREATE SEQUENCE IF NOT EXISTS cancion_id_cancion_seq;
CREATE SEQUENCE IF NOT EXISTS estado_animo_id_estado_animo_seq;
CREATE SEQUENCE IF NOT EXISTS genero_id_genero_seq;
CREATE SEQUENCE IF NOT EXISTS opcion_quiz_id_opcion_seq;
CREATE SEQUENCE IF NOT EXISTS pais_id_pais_seq;
CREATE SEQUENCE IF NOT EXISTS perfil_musical_id_perfil_seq;
CREATE SEQUENCE IF NOT EXISTS playlist_id_playlist_seq;
CREATE SEQUENCE IF NOT EXISTS pregunta_quiz_id_pregunta_seq;
CREATE SEQUENCE IF NOT EXISTS rasgo_personalidad_id_rasgo_seq;
CREATE SEQUENCE IF NOT EXISTS resultado_quiz_id_resultado_seq;
CREATE SEQUENCE IF NOT EXISTS usuario_id_usuario_seq;

-- ============================================================
-- TABLAS INDEPENDIENTES (sin llaves foráneas)
-- ============================================================

CREATE TABLE public.pais (
    id_pais     INTEGER      NOT NULL DEFAULT nextval('pais_id_pais_seq'),
    nombre_pais VARCHAR(100) NOT NULL UNIQUE,
    codigo_iso  CHAR(2)           UNIQUE,
    CONSTRAINT pais_pkey PRIMARY KEY (id_pais)
);

CREATE TABLE public.genero (
    id_genero     INTEGER      NOT NULL DEFAULT nextval('genero_id_genero_seq'),
    nombre_genero VARCHAR(100) NOT NULL UNIQUE,
    CONSTRAINT genero_pkey PRIMARY KEY (id_genero)
);

CREATE TABLE public.estado_animo (
    id_estado_animo     INTEGER      NOT NULL DEFAULT nextval('estado_animo_id_estado_animo_seq'),
    nombre_estado_animo VARCHAR(100) NOT NULL UNIQUE,
    CONSTRAINT estado_animo_pkey PRIMARY KEY (id_estado_animo)
);

CREATE TABLE public.actividad (
    id_actividad     INTEGER      NOT NULL DEFAULT nextval('actividad_id_actividad_seq'),
    nombre_actividad VARCHAR(100) NOT NULL UNIQUE,
    CONSTRAINT actividad_pkey PRIMARY KEY (id_actividad)
);

CREATE TABLE public.rasgo_personalidad (
    id_rasgo    INTEGER NOT NULL DEFAULT nextval('rasgo_personalidad_id_rasgo_seq'),
    nombre_rasgo VARCHAR(100) NOT NULL UNIQUE,
    descripcion  TEXT,
    CONSTRAINT rasgo_personalidad_pkey PRIMARY KEY (id_rasgo)
);

CREATE TABLE public.perfil_musical (
    id_perfil    INTEGER NOT NULL DEFAULT nextval('perfil_musical_id_perfil_seq'),
    nombre_perfil VARCHAR(100) NOT NULL UNIQUE,
    descripcion   TEXT,
    CONSTRAINT perfil_musical_pkey PRIMARY KEY (id_perfil)
);

CREATE TABLE public.usuario (
    id_usuario     BIGINT       NOT NULL DEFAULT nextval('usuario_id_usuario_seq'),
    nombre         VARCHAR(100) NOT NULL,
    apellido_p     VARCHAR(100),
    apellido_m     VARCHAR(100),
    nombre_usuario VARCHAR(50)  NOT NULL UNIQUE,
    email          VARCHAR(150)      UNIQUE,
    password_hash  VARCHAR(255),
    fecha_registro TIMESTAMP         DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT usuario_pkey PRIMARY KEY (id_usuario)
);

CREATE TABLE public.artista (
    id_artista         BIGINT       NOT NULL DEFAULT nextval('artista_id_artista_seq'),
    nombre_artista     VARCHAR(150) NOT NULL,
    id_pais_origen     INTEGER,
    spotify_id         VARCHAR(60)  UNIQUE,
    youtube_channel_id VARCHAR(100) UNIQUE,
    CONSTRAINT artista_pkey PRIMARY KEY (id_artista),
    CONSTRAINT artista_id_pais_origen_fkey FOREIGN KEY (id_pais_origen) REFERENCES public.pais(id_pais)
);

CREATE TABLE public.cancion (
    id_cancion        BIGINT       NOT NULL DEFAULT nextval('cancion_id_cancion_seq'),
    titulo            VARCHAR(200) NOT NULL,
    duracion_segundos INTEGER      NOT NULL CHECK (duracion_segundos > 0),
    letra             TEXT,
    fecha_lanzamiento DATE,
    spotify_id        VARCHAR(60)  UNIQUE,
    youtube_video_id  VARCHAR(100) UNIQUE,
    CONSTRAINT cancion_pkey PRIMARY KEY (id_cancion)
);

CREATE TABLE public.playlist (
    id_playlist        BIGINT       NOT NULL DEFAULT nextval('playlist_id_playlist_seq'),
    nombre_playlist    VARCHAR(150) NOT NULL,
    descripcion        TEXT,
    id_usuario         BIGINT,
    tipo_playlist      VARCHAR(20)  NOT NULL
        CHECK (tipo_playlist IN ('usuario','estado_animo','actividad','personalidad','pais','mixta')),
    plataforma_origen  VARCHAR(10)  NOT NULL DEFAULT 'interna'
        CHECK (plataforma_origen IN ('interna','spotify','youtube')),
    spotify_playlist_id  VARCHAR(60)  UNIQUE,
    youtube_playlist_id  VARCHAR(100) UNIQUE,
    creada_en          TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT playlist_pkey PRIMARY KEY (id_playlist),
    CONSTRAINT playlist_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario)
);

CREATE TABLE public.pregunta_quiz (
    id_pregunta    INTEGER      NOT NULL DEFAULT nextval('pregunta_quiz_id_pregunta_seq'),
    texto_pregunta VARCHAR(300) NOT NULL,
    orden_pregunta INTEGER      NOT NULL UNIQUE,
    CONSTRAINT pregunta_quiz_pkey PRIMARY KEY (id_pregunta)
);

CREATE TABLE public.opcion_quiz (
    id_opcion    INTEGER      NOT NULL DEFAULT nextval('opcion_quiz_id_opcion_seq'),
    id_pregunta  INTEGER      NOT NULL,
    texto_opcion VARCHAR(300) NOT NULL,
    CONSTRAINT opcion_quiz_pkey PRIMARY KEY (id_opcion),
    CONSTRAINT opcion_quiz_id_pregunta_fkey FOREIGN KEY (id_pregunta) REFERENCES public.pregunta_quiz(id_pregunta)
);

CREATE TABLE public.resultado_quiz (
    id_resultado   BIGINT  NOT NULL DEFAULT nextval('resultado_quiz_id_resultado_seq'),
    id_usuario     BIGINT  NOT NULL,
    id_perfil      INTEGER NOT NULL,
    fecha_resultado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT resultado_quiz_pkey PRIMARY KEY (id_resultado),
    CONSTRAINT resultado_quiz_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario),
    CONSTRAINT resultado_quiz_id_perfil_fkey  FOREIGN KEY (id_perfil)  REFERENCES public.perfil_musical(id_perfil)
);

-- ============================================================
-- TABLAS DE RELACIÓN N:M
-- ============================================================

CREATE TABLE public.respuesta_quiz (
    id_resultado BIGINT  NOT NULL,
    id_pregunta  INTEGER NOT NULL,
    id_opcion    INTEGER NOT NULL,
    CONSTRAINT respuesta_quiz_pkey PRIMARY KEY (id_resultado, id_pregunta),
    CONSTRAINT respuesta_quiz_id_resultado_fkey FOREIGN KEY (id_resultado) REFERENCES public.resultado_quiz(id_resultado),
    CONSTRAINT respuesta_quiz_id_pregunta_fkey  FOREIGN KEY (id_pregunta)  REFERENCES public.pregunta_quiz(id_pregunta),
    CONSTRAINT respuesta_quiz_id_opcion_fkey    FOREIGN KEY (id_opcion)    REFERENCES public.opcion_quiz(id_opcion)
);

CREATE TABLE public.opcion_rasgo (
    id_opcion INTEGER NOT NULL,
    id_rasgo  INTEGER NOT NULL,
    puntaje   INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT opcion_rasgo_pkey PRIMARY KEY (id_opcion, id_rasgo),
    CONSTRAINT opcion_rasgo_id_opcion_fkey FOREIGN KEY (id_opcion) REFERENCES public.opcion_quiz(id_opcion),
    CONSTRAINT opcion_rasgo_id_rasgo_fkey  FOREIGN KEY (id_rasgo)  REFERENCES public.rasgo_personalidad(id_rasgo)
);

CREATE TABLE public.perfil_rasgo (
    id_perfil INTEGER NOT NULL,
    id_rasgo  INTEGER NOT NULL,
    peso      NUMERIC NOT NULL DEFAULT 1.00,
    CONSTRAINT perfil_rasgo_pkey PRIMARY KEY (id_perfil, id_rasgo),
    CONSTRAINT perfil_rasgo_id_perfil_fkey FOREIGN KEY (id_perfil) REFERENCES public.perfil_musical(id_perfil),
    CONSTRAINT perfil_rasgo_id_rasgo_fkey  FOREIGN KEY (id_rasgo)  REFERENCES public.rasgo_personalidad(id_rasgo)
);

CREATE TABLE public.perfil_playlist (
    id_perfil  INTEGER NOT NULL,
    id_playlist BIGINT NOT NULL,
    CONSTRAINT perfil_playlist_pkey PRIMARY KEY (id_perfil, id_playlist),
    CONSTRAINT perfil_playlist_id_perfil_fkey  FOREIGN KEY (id_perfil)   REFERENCES public.perfil_musical(id_perfil),
    CONSTRAINT perfil_playlist_id_playlist_fkey FOREIGN KEY (id_playlist) REFERENCES public.playlist(id_playlist)
);

CREATE TABLE public.artista_genero (
    id_artista BIGINT  NOT NULL,
    id_genero  INTEGER NOT NULL,
    CONSTRAINT artista_genero_pkey PRIMARY KEY (id_artista, id_genero),
    CONSTRAINT artista_genero_id_artista_fkey FOREIGN KEY (id_artista) REFERENCES public.artista(id_artista),
    CONSTRAINT artista_genero_id_genero_fkey  FOREIGN KEY (id_genero)  REFERENCES public.genero(id_genero)
);

CREATE TABLE public.artista_pais_popularidad (
    id_artista        BIGINT  NOT NULL,
    id_pais           INTEGER NOT NULL,
    fecha_referencia  DATE    NOT NULL,
    nivel_popularidad NUMERIC NOT NULL CHECK (nivel_popularidad >= 0 AND nivel_popularidad <= 100),
    CONSTRAINT artista_pais_popularidad_pkey PRIMARY KEY (id_artista, id_pais, fecha_referencia),
    CONSTRAINT artista_pais_popularidad_id_artista_fkey FOREIGN KEY (id_artista) REFERENCES public.artista(id_artista),
    CONSTRAINT artista_pais_popularidad_id_pais_fkey    FOREIGN KEY (id_pais)    REFERENCES public.pais(id_pais)
);

CREATE TABLE public.cancion_artista (
    id_cancion BIGINT      NOT NULL,
    id_artista BIGINT      NOT NULL,
    rol        VARCHAR(20) DEFAULT 'principal'
        CHECK (rol IN ('principal','feat','productor')),
    CONSTRAINT cancion_artista_pkey PRIMARY KEY (id_cancion, id_artista),
    CONSTRAINT cancion_artista_id_cancion_fkey FOREIGN KEY (id_cancion) REFERENCES public.cancion(id_cancion),
    CONSTRAINT cancion_artista_id_artista_fkey FOREIGN KEY (id_artista) REFERENCES public.artista(id_artista)
);

CREATE TABLE public.cancion_genero (
    id_cancion BIGINT  NOT NULL,
    id_genero  INTEGER NOT NULL,
    CONSTRAINT cancion_genero_pkey PRIMARY KEY (id_cancion, id_genero),
    CONSTRAINT cancion_genero_id_cancion_fkey FOREIGN KEY (id_cancion) REFERENCES public.cancion(id_cancion),
    CONSTRAINT cancion_genero_id_genero_fkey  FOREIGN KEY (id_genero)  REFERENCES public.genero(id_genero)
);

CREATE TABLE public.cancion_pais_popularidad (
    id_cancion        BIGINT  NOT NULL,
    id_pais           INTEGER NOT NULL,
    fecha_referencia  DATE    NOT NULL,
    nivel_popularidad NUMERIC NOT NULL CHECK (nivel_popularidad >= 0 AND nivel_popularidad <= 100),
    CONSTRAINT cancion_pais_popularidad_pkey PRIMARY KEY (id_cancion, id_pais, fecha_referencia),
    CONSTRAINT cancion_pais_popularidad_id_cancion_fkey FOREIGN KEY (id_cancion) REFERENCES public.cancion(id_cancion),
    CONSTRAINT cancion_pais_popularidad_id_pais_fkey    FOREIGN KEY (id_pais)    REFERENCES public.pais(id_pais)
);

CREATE TABLE public.cancion_estado_animo (
    id_cancion      BIGINT   NOT NULL,
    id_estado_animo INTEGER  NOT NULL,
    afinidad        SMALLINT DEFAULT 50 CHECK (afinidad >= 0 AND afinidad <= 100),
    CONSTRAINT cancion_estado_animo_pkey PRIMARY KEY (id_cancion, id_estado_animo),
    CONSTRAINT cancion_estado_animo_id_cancion_fkey      FOREIGN KEY (id_cancion)      REFERENCES public.cancion(id_cancion),
    CONSTRAINT cancion_estado_animo_id_estado_animo_fkey FOREIGN KEY (id_estado_animo) REFERENCES public.estado_animo(id_estado_animo)
);

CREATE TABLE public.cancion_actividad (
    id_cancion   BIGINT   NOT NULL,
    id_actividad INTEGER  NOT NULL,
    afinidad     SMALLINT DEFAULT 50 CHECK (afinidad >= 0 AND afinidad <= 100),
    CONSTRAINT cancion_actividad_pkey PRIMARY KEY (id_cancion, id_actividad),
    CONSTRAINT cancion_actividad_id_cancion_fkey   FOREIGN KEY (id_cancion)   REFERENCES public.cancion(id_cancion),
    CONSTRAINT cancion_actividad_id_actividad_fkey FOREIGN KEY (id_actividad) REFERENCES public.actividad(id_actividad)
);

CREATE TABLE public.playlist_cancion (
    id_playlist BIGINT  NOT NULL,
    id_cancion  BIGINT  NOT NULL,
    posicion    INTEGER,
    CONSTRAINT playlist_cancion_pkey PRIMARY KEY (id_playlist, id_cancion),
    CONSTRAINT playlist_cancion_id_playlist_fkey FOREIGN KEY (id_playlist) REFERENCES public.playlist(id_playlist),
    CONSTRAINT playlist_cancion_id_cancion_fkey  FOREIGN KEY (id_cancion)  REFERENCES public.cancion(id_cancion)
);

CREATE TABLE public.playlist_genero (
    id_playlist BIGINT  NOT NULL,
    id_genero   INTEGER NOT NULL,
    CONSTRAINT playlist_genero_pkey PRIMARY KEY (id_playlist, id_genero),
    CONSTRAINT playlist_genero_id_playlist_fkey FOREIGN KEY (id_playlist) REFERENCES public.playlist(id_playlist),
    CONSTRAINT playlist_genero_id_genero_fkey   FOREIGN KEY (id_genero)   REFERENCES public.genero(id_genero)
);

CREATE TABLE public.playlist_estado_animo (
    id_playlist     BIGINT  NOT NULL,
    id_estado_animo INTEGER NOT NULL,
    CONSTRAINT playlist_estado_animo_pkey PRIMARY KEY (id_playlist, id_estado_animo),
    CONSTRAINT playlist_estado_animo_id_playlist_fkey     FOREIGN KEY (id_playlist)     REFERENCES public.playlist(id_playlist),
    CONSTRAINT playlist_estado_animo_id_estado_animo_fkey FOREIGN KEY (id_estado_animo) REFERENCES public.estado_animo(id_estado_animo)
);

CREATE TABLE public.playlist_actividad (
    id_playlist  BIGINT  NOT NULL,
    id_actividad INTEGER NOT NULL,
    CONSTRAINT playlist_actividad_pkey PRIMARY KEY (id_playlist, id_actividad),
    CONSTRAINT playlist_actividad_id_playlist_fkey  FOREIGN KEY (id_playlist)  REFERENCES public.playlist(id_playlist),
    CONSTRAINT playlist_actividad_id_actividad_fkey FOREIGN KEY (id_actividad) REFERENCES public.actividad(id_actividad)
);

CREATE TABLE public.playlist_pais (
    id_playlist BIGINT  NOT NULL,
    id_pais     INTEGER NOT NULL,
    CONSTRAINT playlist_pais_pkey PRIMARY KEY (id_playlist, id_pais),
    CONSTRAINT playlist_pais_id_playlist_fkey FOREIGN KEY (id_playlist) REFERENCES public.playlist(id_playlist),
    CONSTRAINT playlist_pais_id_pais_fkey     FOREIGN KEY (id_pais)     REFERENCES public.pais(id_pais)
);

CREATE TABLE public.genero_pais_popularidad (
    id_genero         INTEGER NOT NULL,
    id_pais           INTEGER NOT NULL,
    fecha_referencia  DATE    NOT NULL,
    nivel_popularidad NUMERIC NOT NULL CHECK (nivel_popularidad >= 0 AND nivel_popularidad <= 100),
    CONSTRAINT genero_pais_popularidad_pkey PRIMARY KEY (id_genero, id_pais, fecha_referencia),
    CONSTRAINT genero_pais_popularidad_id_genero_fkey FOREIGN KEY (id_genero) REFERENCES public.genero(id_genero),
    CONSTRAINT genero_pais_popularidad_id_pais_fkey   FOREIGN KEY (id_pais)   REFERENCES public.pais(id_pais)
);

-- ============================================================
-- DATOS DE PRUEBA
-- ============================================================

INSERT INTO public.pais (nombre_pais, codigo_iso) VALUES
    ('México',          'MX'),
    ('Estados Unidos',  'US'),
    ('Colombia',        'CO'),
    ('Argentina',       'AR'),
    ('España',          'ES'),
    ('Brasil',          'BR'),
    ('Reino Unido',     'GB'),
    ('Japón',           'JP'),
    ('Francia',         'FR'),
    ('Alemania',        'DE'),
    ('Puerto Rico',     'PR'),
    ('Chile',           'CL'),
    ('Perú',            'PE'),
    ('Venezuela',       'VE'),
    ('Italia',          'IT'),
    ('Canadá',          'CA');

INSERT INTO public.genero (nombre_genero) VALUES
    ('Pop'),('Rock'),('Hip-Hop'),('Reggaeton'),('Salsa'),
    ('Bachata'),('Cumbia'),('R&B'),('Jazz'),('Clásica'),
    ('Electrónica'),('Indie'),('Metal'),('Country'),('K-Pop');

INSERT INTO public.estado_animo (nombre_estado_animo) VALUES
    ('Feliz'),('Triste'),('Energético'),('Relajado'),('Romántico'),
    ('Nostálgico'),('Motivado'),('Ansioso'),('Melancólico'),('Eufórico');

INSERT INTO public.actividad (nombre_actividad) VALUES
    ('Ejercicio'),('Estudio'),('Trabajo'),('Meditación'),('Fiesta'),
    ('Conducir'),('Dormir'),('Cocinar'),('Lectura'),('Yoga');

INSERT INTO public.rasgo_personalidad (nombre_rasgo, descripcion) VALUES
    ('Extrovertido',   'Persona sociable y enérgica que disfruta interactuar con otros'),
    ('Introvertido',   'Persona reflexiva que prefiere ambientes tranquilos'),
    ('Aventurero',     'Persona que busca nuevas experiencias y emociones'),
    ('Tranquilo',      'Persona calmada que prefiere la paz y el equilibrio'),
    ('Creativo',       'Persona con alta imaginación e inclinación artística'),
    ('Analítico',      'Persona lógica y metódica en su forma de pensar'),
    ('Empático',       'Persona sensible a las emociones de los demás'),
    ('Apasionado',     'Persona intensa y entusiasta en sus actividades'),
    ('Nostálgico',     'Persona que valora los recuerdos y el pasado'),
    ('Optimista',      'Persona con visión positiva ante la vida');

INSERT INTO public.perfil_musical (nombre_perfil, descripcion) VALUES
    ('Explorador Urbano',     'Perfil orientado al rap, hip-hop y música urbana contemporánea'),
    ('Alma Romántica',        'Perfil para amantes de las baladas, el R&B suave y la música romántica'),
    ('Espíritu Libre',        'Perfil indie y alternativo para mentes creativas e independientes'),
    ('Energía Total',         'Perfil de alta energía con electrónica, reggaeton y pop bailable'),
    ('Raíces Latinas',        'Perfil con salsa, cumbia, bachata y folclor latinoamericano'),
    ('Clásico Atemporal',     'Perfil para amantes del rock clásico, jazz y música orquestal'),
    ('Zen y Consciencia',     'Perfil relajante con ambient, acústico y música meditativa'),
    ('Fiestero Internacional','Perfil multicultural con los mejores hits de fiesta globales'),
    ('Melómano Curioso',      'Perfil ecléctico para quienes disfrutan todo tipo de géneros'),
    ('Nostálgico Retro',      'Perfil dedicado a los clásicos de los 70s, 80s y 90s');

INSERT INTO public.pregunta_quiz (texto_pregunta, orden_pregunta) VALUES
    ('¿Cómo describirías tu energía en una reunión social?',             1),
    ('¿Qué tipo de ambiente prefieres para escuchar música?',            2),
    ('¿Qué actividad disfrutas más en tu tiempo libre?',                 3),
    ('¿Cómo reaccionas ante situaciones de estrés?',                     4),
    ('¿Qué valor es más importante para ti en la música?',               5),
    ('¿Con qué frecuencia descubres música nueva?',                      6),
    ('¿Cómo describirías tu relación con las emociones?',                7),
    ('¿Qué importancia tiene la letra en una canción para ti?',          8),
    ('¿Qué tipo de concierto preferirías asistir?',                      9),
    ('¿Cómo usas la música en tu día a día?',                           10);

INSERT INTO public.artista (nombre_artista, id_pais_origen, spotify_id) VALUES
    ('Bad Bunny',       11, '4q3ewBCX7sLwd24euuV69X'),
    ('Taylor Swift',     2, '06HL4z0CvFAxyc27GXpf02'),
    ('J Balvin',         3, '1vyhD5VmyZ7KMfW5gqLgo5'),
    ('Shakira',          3, '0EmeFodog0BfCgMzAIvKQp'),
    ('Daddy Yankee',    11, '1KCSPY1glIKqW2TotWuXOR'),
    ('The Weeknd',      16, '1Xyo4u8uXC1ZmMpatF05PJ'),
    ('Dua Lipa',         7, '6M2wZ9GZgrQXHCFfjv46we'),
    ('BTS',              8, '3Nrfpe0tUJi4K4DXYWgMUX'),
    ('Coldplay',         7, '4gzpq5DPGxSnKTe4SA8HAU'),
    ('Ozuna',           11, '1i8SpTcr7yvPOmcqrbnVXY'),
    ('Maluma',           3, '1r0DMo4BiHWN9UW7kQGOoV'),
    ('Rosalía',          5, '791skzt7tgHjTkMRpGJNwe'),
    ('Rauw Alejandro',  11, '1McMsnEElThX1knmq4tnds'),
    ('Feid',             3, '0ikz6tENMONtK6qGkOrU3c'),
    ('Karol G',          3, '790FomKkXshlbRYZFtlgla'),
    ('Harry Styles',     7, '6KImCVD70vtIoJWnq6nGn3');

INSERT INTO public.cancion (titulo, duracion_segundos, fecha_lanzamiento, spotify_id) VALUES
    ('Tití Me Preguntó',         248, '2022-05-06', '1IHWl5LamUGEuP4uQW1hOE'),
    ('Anti-Hero',                200, '2022-10-21', '0V3wPSX9ygBnCm8psDIegu'),
    ('In Da Getto',              185, '2021-07-09', '5PjdY0CKGZdEuoNab3yDmX'),
    ('Waka Waka',                223, '2010-05-07', '2CEgGE6aESpnmtfiZwBSo9'),
    ('Gasolina',                 196, '2004-06-01', '21THa8j9TaSGuoiNiQIL6e'),
    ('Blinding Lights',          200, '2019-11-29', '0VjIjW4GlUZAMYd2vXMi3b'),
    ('Levitating',               203, '2020-10-01', '463CkQjx2Zk1yXoBuierM9'),
    ('Dynamite',                 199, '2020-08-21', '5QDLhrAOJJdNAmCTJ8xMyW'),
    ('Yellow',                   269, '2000-06-26', '3AJwUDP919kvQ9QcozQPxg'),
    ('La Corriente',             212, '2022-03-25', '5vNRhJKiMEdqtEGxhXMtxb'),
    ('Hawái',                    197, '2020-07-09', '1yoMvmasuxZvzmKNO3vKLI'),
    ('MALAMENTE',                197, '2018-06-01', '3ZE3wv8V3w2T2f7nOCjV0N'),
    ('Todo de Ti',               175, '2021-06-11', '3B4MLJMmRQfZFgEfHzWvaF'),
    ('Yandel 150',               185, '2022-10-27', '3QGsuHI8K3M2b4NMPX7YoD'),
    ('PROVENZA',                 196, '2022-03-25', '0ofbQMrtzNnNvPIBbsZRQd'),
    ('As It Was',                167, '2022-04-01', '4LRPiXqCikLlN15c3yImP7');


INSERT INTO public.artista_genero (id_artista, id_genero) VALUES
    (1,4),(1,3),(2,1),(2,2),(3,4),(3,1),(4,1),(4,5),
    (5,4),(6,8),(6,1),(7,1),(7,11),(8,1),(8,15),
    (9,2),(9,12),(10,4),(11,4),(12,1),(12,12),
    (13,4),(14,4),(15,4),(16,1),(16,12);

INSERT INTO public.cancion_artista (id_cancion, id_artista, rol) VALUES
    (1,1,'principal'),(2,2,'principal'),(3,3,'principal'),
    (4,4,'principal'),(5,5,'principal'),(6,6,'principal'),
    (7,7,'principal'),(8,8,'principal'),(9,9,'principal'),
    (10,10,'principal'),(10,13,'feat'),(11,11,'principal'),
    (12,12,'principal'),(13,13,'principal'),(14,14,'principal'),
    (15,15,'principal'),(16,16,'principal');

INSERT INTO public.cancion_genero (id_cancion, id_genero) VALUES
    (1,4),(1,3),(2,1),(3,4),(4,1),(5,4),(6,8),(6,1),
    (7,1),(7,11),(8,1),(8,15),(9,2),(10,4),(11,4),
    (12,1),(12,12),(13,4),(14,4),(15,4),(16,1),(16,12);

INSERT INTO public.cancion_estado_animo (id_cancion, id_estado_animo, afinidad) VALUES
    (1,1,90),(1,3,85),(2,2,80),(2,6,75),(3,3,95),(3,10,90),
    (4,3,90),(4,1,85),(5,5,95),(5,3,90),(6,2,70),(6,6,80),
    (7,1,90),(7,3,85),(8,1,95),(8,3,90),(9,5,85),(9,4,80),
    (10,5,90),(10,4,85),(11,5,90),(12,2,85),(12,6,80),
    (13,3,90),(14,3,95),(14,10,90),(15,5,90),(16,1,85),(16,4,80);

INSERT INTO public.cancion_actividad (id_cancion, id_actividad, afinidad) VALUES
    (1,5,95),(1,6,80),(2,2,70),(2,8,75),(3,1,90),(3,5,95),
    (4,1,85),(4,5,90),(5,1,95),(5,5,90),(6,1,85),(6,6,80),
    (7,5,90),(7,6,85),(8,5,95),(8,1,85),(9,2,80),(9,8,75),
    (10,8,85),(10,5,80),(11,8,80),(12,2,75),(13,1,90),
    (14,5,95),(15,5,90),(16,2,75),(16,8,80);

INSERT INTO public.usuario (nombre, apellido_p, apellido_m, nombre_usuario, email, password_hash) VALUES
    ('Sergio',   'Pérez',     'Montané',  'serpatpm',      'patriciopmontane05@gmail.com', '$2a$10$xamplehash1'),
    ('Ana',      'Luciano',   'Alvarado', 'analuci',       'ana.luciano@example.com',      '$2a$10$xamplehash2'),
    ('Samuel',   'Gutiérrez', 'López',    'samguti',       'samuel.gutierrez@example.com', '$2a$10$xamplehash3'),
    ('Yoshua',   'Cortés',    'Avilez',   'yoshuacortez',  'yoshua.cortes@example.com',    '$2a$10$xamplehash4'),
    ('Demo',     'Usuario',   NULL,       'demo_user',     'demo@musicrecommender.com',    '$2a$10$xamplehash5');

INSERT INTO public.resultado_quiz (id_usuario, id_perfil) VALUES
    (1, 1),(2, 2),(3, 3),(4, 4),(5, 5);

INSERT INTO public.playlist (nombre_playlist, descripcion, id_usuario, tipo_playlist, plataforma_origen) VALUES
    ('Hits Urbanos 2024',    'Lo mejor del reggaeton y trap latino',       1, 'estado_animo', 'interna'),
    ('Chill Vibes',          'Música relajante para estudiar o trabajar',  2, 'actividad',    'interna'),
    ('Fiesta Total',         'Los temazos para cualquier fiesta',          3, 'estado_animo', 'interna'),
    ('Romántica Playlist',   'Baladas y canciones de amor',                4, 'personalidad', 'interna'),
    ('Workout Mix',          'Energía máxima para el gimnasio',            5, 'actividad',    'interna');

INSERT INTO public.playlist_cancion (id_playlist, id_cancion, posicion) VALUES
    (1,1,1),(1,3,2),(1,5,3),(1,10,4),(1,13,5),
    (2,2,1),(2,9,2),(2,16,3),(2,12,4),
    (3,4,1),(3,7,2),(3,8,3),(3,14,4),(3,15,5),
    (4,6,1),(4,9,2),(4,11,3),(4,15,4),
    (5,3,1),(5,5,2),(5,8,3),(5,13,4),(5,14,5);

INSERT INTO public.playlist_estado_animo (id_playlist, id_estado_animo) VALUES
    (1,3),(1,10),(2,4),(2,7),(3,1),(3,3),(3,10),(4,5),(4,4),(5,3),(5,7);

INSERT INTO public.playlist_actividad (id_playlist, id_actividad) VALUES
    (1,5),(1,6),(2,2),(2,3),(3,5),(4,8),(5,1),(5,3);

INSERT INTO public.playlist_genero (id_playlist, id_genero) VALUES
    (1,4),(1,3),(2,1),(2,12),(3,1),(3,4),(3,11),(4,1),(4,8),(5,4),(5,1);

INSERT INTO public.pais (nombre_pais, codigo_iso) VALUES ('Global', 'GL') ON CONFLICT DO NOTHING;

INSERT INTO public.cancion_pais_popularidad (id_cancion, id_pais, fecha_referencia, nivel_popularidad) VALUES
    (1,1,'2024-01-01',94.00),(1,11,'2024-01-01',97.00),(1,2,'2024-01-01',88.00),
    (2,2,'2024-01-01',96.00),(2,7,'2024-01-01',92.00),(2,1,'2024-01-01',78.00),
    (5,11,'2024-01-01',98.00),(5,1,'2024-01-01',95.00),(5,3,'2024-01-01',90.00),
    (6,2,'2024-01-01',95.00),(6,7,'2024-01-01',93.00),(6,16,'2024-01-01',89.00),
    (8,8,'2024-01-01',99.00),(8,2,'2024-01-01',97.00),(8,15,'2024-01-01',91.00),
    (16,7,'2024-01-01',94.00),(16,2,'2024-01-01',91.00),(16,1,'2024-01-01',82.00);

INSERT INTO public.artista_pais_popularidad (id_artista, id_pais, fecha_referencia, nivel_popularidad) VALUES
    (1,1,'2024-01-01',95.00),(1,11,'2024-01-01',98.00),(1,2,'2024-01-01',90.00),
    (2,2,'2024-01-01',98.00),(2,7,'2024-01-01',95.00),(2,1,'2024-01-01',80.00),
    (5,11,'2024-01-01',97.00),(5,1,'2024-01-01',96.00),(6,2,'2024-01-01',95.00),
    (7,7,'2024-01-01',94.00),(7,2,'2024-01-01',92.00),(8,8,'2024-01-01',99.00),
    (9,7,'2024-01-01',93.00),(15,3,'2024-01-01',97.00),(15,1,'2024-01-01',88.00);

INSERT INTO public.genero_pais_popularidad (id_genero, id_pais, fecha_referencia, nivel_popularidad) VALUES
    (4,1,'2024-01-01',95.00),(4,11,'2024-01-01',98.00),(4,3,'2024-01-01',92.00),
    (1,2,'2024-01-01',90.00),(1,7,'2024-01-01',88.00),(1,1,'2024-01-01',85.00),
    (3,2,'2024-01-01',92.00),(3,1,'2024-01-01',78.00),(2,7,'2024-01-01',87.00),
    (15,8,'2024-01-01',99.00),(15,2,'2024-01-01',75.00),(8,2,'2024-01-01',85.00);

-- ============================================================
-- FIN DEL SCRIPT
-- ============================================================
