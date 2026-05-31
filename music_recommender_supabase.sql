CREATE TABLE usuario (
    id_usuario BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido_p VARCHAR(100),
    apellido_m VARCHAR(100),
    nombre_usuario VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(150) UNIQUE,
    password_hash VARCHAR(255),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pais (
    id_pais SERIAL PRIMARY KEY,
    nombre_pais VARCHAR(100) NOT NULL UNIQUE,
    codigo_iso CHAR(2) UNIQUE
);

CREATE TABLE perfil_musical (
    id_perfil SERIAL PRIMARY KEY,
    nombre_perfil VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT
);

CREATE TABLE genero (
    id_genero SERIAL PRIMARY KEY,
    nombre_genero VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE estado_animo (
    id_estado_animo SERIAL PRIMARY KEY,
    nombre_estado_animo VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE actividad (
    id_actividad SERIAL PRIMARY KEY,
    nombre_actividad VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE artista (
    id_artista BIGSERIAL PRIMARY KEY,
    nombre_artista VARCHAR(150) NOT NULL,
    id_pais_origen INT NULL,
    spotify_id VARCHAR(60) UNIQUE,
    youtube_channel_id VARCHAR(100) UNIQUE,
    FOREIGN KEY (id_pais_origen) REFERENCES pais(id_pais)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE cancion (
    id_cancion BIGSERIAL PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    duracion_segundos INT NOT NULL,
    letra TEXT,
    fecha_lanzamiento DATE,
    spotify_id VARCHAR(60) UNIQUE,
    youtube_video_id VARCHAR(100) UNIQUE,
    CHECK (duracion_segundos > 0)
);

CREATE TABLE playlist (
    id_playlist BIGSERIAL PRIMARY KEY,
    nombre_playlist VARCHAR(150) NOT NULL,
    descripcion TEXT,
    id_usuario BIGINT NULL,
    tipo_playlist VARCHAR(20) NOT NULL CHECK (tipo_playlist IN ('usuario','estado_animo','actividad','personalidad','pais','mixta')),
    plataforma_origen VARCHAR(10) NOT NULL DEFAULT 'interna' CHECK (plataforma_origen IN ('interna','spotify','youtube')),
    spotify_playlist_id VARCHAR(60) UNIQUE,
    youtube_playlist_id VARCHAR(100) UNIQUE,
    creada_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE cancion_artista (
    id_cancion BIGINT NOT NULL,
    id_artista BIGINT NOT NULL,
    rol VARCHAR(10) DEFAULT 'principal' CHECK (rol IN ('principal','feat','productor')),
    PRIMARY KEY (id_cancion, id_artista),
    FOREIGN KEY (id_cancion) REFERENCES cancion(id_cancion)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_artista) REFERENCES artista(id_artista)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE cancion_genero (
    id_cancion BIGINT NOT NULL,
    id_genero INT NOT NULL,
    PRIMARY KEY (id_cancion, id_genero),
    FOREIGN KEY (id_cancion) REFERENCES cancion(id_cancion)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_genero) REFERENCES genero(id_genero)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE artista_genero (
    id_artista BIGINT NOT NULL,
    id_genero INT NOT NULL,
    PRIMARY KEY (id_artista, id_genero),
    FOREIGN KEY (id_artista) REFERENCES artista(id_artista)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_genero) REFERENCES genero(id_genero)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE playlist_cancion (
    id_playlist BIGINT NOT NULL,
    id_cancion BIGINT NOT NULL,
    posicion INT,
    PRIMARY KEY (id_playlist, id_cancion),
    UNIQUE (id_playlist, posicion),
    FOREIGN KEY (id_playlist) REFERENCES playlist(id_playlist)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_cancion) REFERENCES cancion(id_cancion)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE cancion_estado_animo (
    id_cancion BIGINT NOT NULL,
    id_estado_animo INT NOT NULL,
    afinidad SMALLINT DEFAULT 50,
    PRIMARY KEY (id_cancion, id_estado_animo),
    FOREIGN KEY (id_cancion) REFERENCES cancion(id_cancion)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_estado_animo) REFERENCES estado_animo(id_estado_animo)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CHECK (afinidad BETWEEN 0 AND 100)
);

CREATE TABLE cancion_actividad (
    id_cancion BIGINT NOT NULL,
    id_actividad INT NOT NULL,
    afinidad SMALLINT DEFAULT 50,
    PRIMARY KEY (id_cancion, id_actividad),
    FOREIGN KEY (id_cancion) REFERENCES cancion(id_cancion)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_actividad) REFERENCES actividad(id_actividad)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CHECK (afinidad BETWEEN 0 AND 100)
);

CREATE TABLE perfil_playlist (
    id_perfil INT NOT NULL,
    id_playlist BIGINT NOT NULL,
    PRIMARY KEY (id_perfil, id_playlist),
    FOREIGN KEY (id_perfil) REFERENCES perfil_musical(id_perfil)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_playlist) REFERENCES playlist(id_playlist)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE playlist_estado_animo (
    id_playlist BIGINT NOT NULL,
    id_estado_animo INT NOT NULL,
    PRIMARY KEY (id_playlist, id_estado_animo),
    FOREIGN KEY (id_playlist) REFERENCES playlist(id_playlist)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_estado_animo) REFERENCES estado_animo(id_estado_animo)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE playlist_actividad (
    id_playlist BIGINT NOT NULL,
    id_actividad INT NOT NULL,
    PRIMARY KEY (id_playlist, id_actividad),
    FOREIGN KEY (id_playlist) REFERENCES playlist(id_playlist)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_actividad) REFERENCES actividad(id_actividad)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE playlist_genero (
    id_playlist BIGINT NOT NULL,
    id_genero INT NOT NULL,
    PRIMARY KEY (id_playlist, id_genero),
    FOREIGN KEY (id_playlist) REFERENCES playlist(id_playlist)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_genero) REFERENCES genero(id_genero)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE playlist_pais (
    id_playlist BIGINT NOT NULL,
    id_pais INT NOT NULL,
    PRIMARY KEY (id_playlist, id_pais),
    FOREIGN KEY (id_playlist) REFERENCES playlist(id_playlist)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_pais) REFERENCES pais(id_pais)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE genero_pais_popularidad (
    id_genero INT NOT NULL,
    id_pais INT NOT NULL,
    fecha_referencia DATE NOT NULL,
    nivel_popularidad DECIMAL(5,2) NOT NULL,
    PRIMARY KEY (id_genero, id_pais, fecha_referencia),
    FOREIGN KEY (id_genero) REFERENCES genero(id_genero)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_pais) REFERENCES pais(id_pais)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CHECK (nivel_popularidad BETWEEN 0 AND 100)
);

CREATE TABLE cancion_pais_popularidad (
    id_cancion BIGINT NOT NULL,
    id_pais INT NOT NULL,
    fecha_referencia DATE NOT NULL,
    nivel_popularidad DECIMAL(5,2) NOT NULL,
    PRIMARY KEY (id_cancion, id_pais, fecha_referencia),
    FOREIGN KEY (id_cancion) REFERENCES cancion(id_cancion)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_pais) REFERENCES pais(id_pais)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CHECK (nivel_popularidad BETWEEN 0 AND 100)
);

CREATE TABLE artista_pais_popularidad (
    id_artista BIGINT NOT NULL,
    id_pais INT NOT NULL,
    fecha_referencia DATE NOT NULL,
    nivel_popularidad DECIMAL(5,2) NOT NULL,
    PRIMARY KEY (id_artista, id_pais, fecha_referencia),
    FOREIGN KEY (id_artista) REFERENCES artista(id_artista)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_pais) REFERENCES pais(id_pais)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CHECK (nivel_popularidad BETWEEN 0 AND 100)
);

CREATE TABLE rasgo_personalidad (
    id_rasgo SERIAL PRIMARY KEY,
    nombre_rasgo VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT
);

CREATE TABLE pregunta_quiz (
    id_pregunta SERIAL PRIMARY KEY,
    texto_pregunta VARCHAR(255) NOT NULL,
    orden_pregunta INT NOT NULL UNIQUE
);

CREATE TABLE opcion_quiz (
    id_opcion SERIAL PRIMARY KEY,
    id_pregunta INT NOT NULL,
    texto_opcion VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_pregunta) REFERENCES pregunta_quiz(id_pregunta)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE opcion_rasgo (
    id_opcion INT NOT NULL,
    id_rasgo INT NOT NULL,
    puntaje INT NOT NULL DEFAULT 0,
    PRIMARY KEY (id_opcion, id_rasgo),
    FOREIGN KEY (id_opcion) REFERENCES opcion_quiz(id_opcion)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_rasgo) REFERENCES rasgo_personalidad(id_rasgo)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE perfil_rasgo (
    id_perfil INT NOT NULL,
    id_rasgo INT NOT NULL,
    peso DECIMAL(5,2) NOT NULL DEFAULT 1.00,
    PRIMARY KEY (id_perfil, id_rasgo),
    FOREIGN KEY (id_perfil) REFERENCES perfil_musical(id_perfil)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_rasgo) REFERENCES rasgo_personalidad(id_rasgo)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE resultado_quiz (
    id_resultado BIGSERIAL PRIMARY KEY,
    id_usuario BIGINT NOT NULL,
    id_perfil INT NOT NULL,
    fecha_resultado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_perfil) REFERENCES perfil_musical(id_perfil)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE respuesta_quiz (
    id_resultado BIGINT NOT NULL,
    id_pregunta INT NOT NULL,
    id_opcion INT NOT NULL,
    PRIMARY KEY (id_resultado, id_pregunta),
    FOREIGN KEY (id_resultado) REFERENCES resultado_quiz(id_resultado)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_pregunta) REFERENCES pregunta_quiz(id_pregunta)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_opcion) REFERENCES opcion_quiz(id_opcion)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE INDEX idx_cancion_titulo ON cancion(titulo);
CREATE INDEX idx_artista_nombre ON artista(nombre_artista);
CREATE INDEX idx_playlist_nombre ON playlist(nombre_playlist);
CREATE INDEX idx_usuario_nombre_usuario ON usuario(nombre_usuario);
CREATE INDEX idx_resultado_quiz_usuario ON resultado_quiz(id_usuario);


-- DML

INSERT INTO pais (nombre_pais, codigo_iso) VALUES
('México', 'MX'),
('Estados Unidos', 'US'),
('Colombia', 'CO'),
('Argentina', 'AR'),
('España', 'ES'),
('Brasil', 'BR'),
('Reino Unido', 'GB'),
('Canadá', 'CA'),
('Puerto Rico', 'PR'),
('Chile', 'CL'),
('Jamaica', 'JM'),
('Suecia', 'SE'),
('Francia', 'FR'),
('Alemania', 'DE'),
('Australia', 'AU');

INSERT INTO genero (nombre_genero) VALUES
('Pop'),
('Rock'),
('Hip-Hop'),
('Reggaeton'),
('Electrónica'),
('Jazz'),
('Clásica'),
('R&B'),
('Latin Pop'),
('Trap'),
('Cumbia'),
('Salsa'),
('Metal'),
('Indie'),
('Country');

INSERT INTO estado_animo (nombre_estado_animo) VALUES
('Feliz'),
('Triste'),
('Enérgico'),
('Relajado'),
('Romántico'),
('Nostálgico'),
('Motivado'),
('Ansioso'),
('Melancólico'),
('Eufórico'),
('Tranquilo'),
('Enojado'),
('Esperanzador'),
('Concentrado'),
('Festivo');

INSERT INTO actividad (nombre_actividad) VALUES
('Ejercicio'),
('Estudio'),
('Trabajo'),
('Meditación'),
('Fiesta'),
('Conducir'),
('Dormir'),
('Cocinar'),
('Correr'),
('Yoga'),
('Lectura'),
('Videojuegos'),
('Viaje'),
('Descanso'),
('Socializar');

INSERT INTO perfil_musical (nombre_perfil, descripcion) VALUES
('Explorador Urbano', 'Le gusta el hip-hop, trap y música urbana en general'),
('Romántico Clásico', 'Prefiere baladas, pop suave y música romántica'),
('Energético', 'Busca música con alto ritmo para ejercicio y actividades físicas'),
('Melómano Ecléctico', 'Disfruta de todos los géneros sin preferencia definida'),
('Relajado Bohemio', 'Prefiere jazz, indie y música tranquila'),
('Fiestero Latino', 'Amante de la cumbia, salsa y reggaeton'),
('Rockero', 'Fanático del rock y metal en todas sus formas'),
('Electrónico Digital', 'Vive para la música electrónica y el dance'),
('Pop Moderno', 'Sigue las tendencias del pop actual'),
('Clásico Culto', 'Aprecia la música clásica y el jazz'),
('Trapero', 'Fan del trap y el rap en español'),
('Indie Alternativo', 'Busca música independiente y alternativa'),
('Reggaetonero', 'Devoto del reggaeton y la música urbana latina'),
('Country Roots', 'Ama el country y la música folk'),
('Soulero', 'Vive por el R&B y el soul');

INSERT INTO rasgo_personalidad (nombre_rasgo, descripcion) VALUES
('Extrovertido', 'Disfruta de la interacción social y los ambientes ruidosos'),
('Introvertido', 'Prefiere ambientes tranquilos y la introspección'),
('Aventurero', 'Busca experiencias nuevas y emocionantes'),
('Tranquilo', 'Valora la paz y la calma en su entorno'),
('Creativo', 'Tiene una mente artística y original'),
('Analítico', 'Piensa de forma lógica y detallada'),
('Empático', 'Conecta fácilmente con las emociones de otros'),
('Ambicioso', 'Orientado al logro y la superación personal'),
('Nostálgico', 'Se conecta fuertemente con el pasado'),
('Optimista', 'Ve el lado positivo de las situaciones');

INSERT INTO usuario (nombre, apellido_p, apellido_m, nombre_usuario, email, password_hash) VALUES
('Carlos', 'Ramírez', 'López', 'carlosrl', 'carlos.ramirez@email.com', '$2a$10$abc123'),
('Sofía', 'Martínez', 'García', 'sofiamg', 'sofia.martinez@email.com', '$2a$10$def456'),
('Diego', 'Hernández', 'Torres', 'diegoh', 'diego.hernandez@email.com', '$2a$10$ghi789'),
('Valentina', 'López', 'Sánchez', 'valels', 'vale.lopez@email.com', '$2a$10$jkl012'),
('Andrés', 'González', 'Ruiz', 'andresgr', 'andres.gonzalez@email.com', '$2a$10$mno345'),
('Camila', 'Pérez', 'Díaz', 'camilapd', 'camila.perez@email.com', '$2a$10$pqr678'),
('Rodrigo', 'Flores', 'Moreno', 'rodrigofm', 'rodrigo.flores@email.com', '$2a$10$stu901'),
('Isabella', 'Castro', 'Jiménez', 'isabellacj', 'isabella.castro@email.com', '$2a$10$vwx234'),
('Mateo', 'Vargas', 'Mendoza', 'mateovm', 'mateo.vargas@email.com', '$2a$10$yza567'),
('Lucía', 'Reyes', 'Ortega', 'luciarod', 'lucia.reyes@email.com', '$2a$10$bcd890'),
('Fernando', 'Morales', 'Silva', 'fernandoms', 'fernando.morales@email.com', '$2a$10$efg123'),
('Natalia', 'Jiménez', 'Romero', 'nataliajr', 'natalia.jimenez@email.com', '$2a$10$hij456'),
('Pablo', 'Rojas', 'Navarro', 'pablorn', 'pablo.rojas@email.com', '$2a$10$klm789'),
('Daniela', 'Torres', 'Vega', 'danielatv', 'daniela.torres@email.com', '$2a$10$nop012'),
('Miguel', 'Sánchez', 'Cruz', 'miguelsc', 'miguel.sanchez@email.com', '$2a$10$qrs345'),
('Valeria', 'Díaz', 'Herrera', 'valeriadh', 'valeria.diaz@email.com', '$2a$10$tuv678'),
('Alejandro', 'Medina', 'Ríos', 'alejandroc', 'alejandro.medina@email.com', '$2a$10$wxy901'),
('Ana', 'Ruiz', 'Guerrero', 'anarg', 'ana.ruiz@email.com', '$2a$10$zab234'),
('Sebastián', 'Ortega', 'Mendez', 'sebastianom', 'sebastian.ortega@email.com', '$2a$10$cde567'),
('Gabriela', 'Silva', 'Paredes', 'gabrielasp', 'gabriela.silva@email.com', '$2a$10$fgh890');

INSERT INTO artista (nombre_artista, id_pais_origen, spotify_id, youtube_channel_id) VALUES
('Bad Bunny', 9, 'artist_bb001', 'UC_badbunny'),
('Taylor Swift', 2, 'artist_ts002', 'UC_taylorswift'),
('J Balvin', 3, 'artist_jb003', 'UC_jbalvin'),
('Rosalía', 5, 'artist_ros004', 'UC_rosalia'),
('Drake', 8, 'artist_drk005', 'UC_drake'),
('Shakira', 3, 'artist_shk006', 'UC_shakira'),
('The Weeknd', 8, 'artist_twknd007', 'UC_weeknd'),
('Karol G', 3, 'artist_kg008', 'UC_karolg'),
('Ed Sheeran', 7, 'artist_eds009', 'UC_edsheeran'),
('Peso Pluma', 1, 'artist_pp010', 'UC_pesopluma'),
('Dua Lipa', 7, 'artist_dl011', 'UC_dualipa'),
('Rauw Alejandro', 9, 'artist_ra012', 'UC_rauwalejandro'),
('Billie Eilish', 2, 'artist_be013', 'UC_billieeilish'),
('Maluma', 3, 'artist_mal014', 'UC_maluma'),
('Ariana Grande', 2, 'artist_ag015', 'UC_arianagrande'),
('Daddy Yankee', 9, 'artist_dy016', 'UC_daddyyankee'),
('Post Malone', 2, 'artist_pm017', 'UC_postmalone'),
('Anitta', 6, 'artist_ani018', 'UC_anitta'),
('Harry Styles', 7, 'artist_hs019', 'UC_harrystyles'),
('Feid', 3, 'artist_feid020', 'UC_feid');

INSERT INTO cancion (titulo, duracion_segundos, fecha_lanzamiento, spotify_id, youtube_video_id) VALUES
('Tití Me Preguntó', 198, '2022-05-06', 'track_001', 'yt_001'),
('Anti-Hero', 200, '2022-10-21', 'track_002', 'yt_002'),
('Con Calma', 187, '2019-01-17', 'track_003', 'yt_003'),
('Malamente', 225, '2018-06-01', 'track_004', 'yt_004'),
('God Plan', 198, '2018-01-19', 'track_005', 'yt_005'),
('Hips Don''t Lie', 218, '2006-02-14', 'track_006', 'yt_006'),
('Blinding Lights', 200, '2019-11-29', 'track_007', 'yt_007'),
('Mañana Será Bonito', 174, '2023-02-24', 'track_008', 'yt_008'),
('Shape of You', 234, '2017-01-06', 'track_009', 'yt_009'),
('Ella Baila Sola', 183, '2023-03-17', 'track_010', 'yt_010'),
('Levitating', 203, '2020-10-01', 'track_011', 'yt_011'),
('Mojabi Ghost', 217, '2023-04-07', 'track_012', 'yt_012'),
('Bad Guy', 194, '2019-03-29', 'track_013', 'yt_013'),
('Hawái', 198, '2020-07-09', 'track_014', 'yt_014'),
('7 Rings', 178, '2019-01-18', 'track_015', 'yt_015'),
('Gasolina', 207, '2004-01-01', 'track_016', 'yt_016'),
('Sunflower', 158, '2018-10-18', 'track_017', 'yt_017'),
('Envolver', 185, '2021-09-20', 'track_018', 'yt_018'),
('Watermelon Sugar', 174, '2020-05-15', 'track_019', 'yt_019'),
('Felices los 4', 211, '2017-05-19', 'track_020', 'yt_020');

INSERT INTO cancion_artista (id_cancion, id_artista, rol) VALUES
(1, 1, 'principal'),
(2, 2, 'principal'),
(3, 16, 'principal'),
(4, 4, 'principal'),
(5, 5, 'principal'),
(6, 6, 'principal'),
(7, 7, 'principal'),
(8, 8, 'principal'),
(9, 9, 'principal'),
(10, 10, 'principal'),
(11, 11, 'principal'),
(12, 12, 'principal'),
(13, 13, 'principal'),
(14, 14, 'principal'),
(15, 15, 'principal'),
(16, 16, 'principal'),
(17, 17, 'principal'),
(18, 18, 'principal'),
(19, 19, 'principal'),
(20, 14, 'principal');

INSERT INTO cancion_genero (id_cancion, id_genero) VALUES
(1, 4), (1, 10),
(2, 1),
(3, 4),
(4, 9),
(5, 3),
(6, 9),
(7, 1),
(8, 4),
(9, 1),
(10, 10),
(11, 1),
(12, 4),
(13, 1),
(14, 4),
(15, 1),
(16, 4),
(17, 1),
(18, 4),
(19, 1),
(20, 4);

INSERT INTO artista_genero (id_artista, id_genero) VALUES
(1, 4), (1, 10),
(2, 1),
(3, 4), (3, 9),
(4, 9), (4, 1),
(5, 3), (5, 8),
(6, 9), (6, 1),
(7, 1), (7, 8),
(8, 4), (8, 9),
(9, 1),
(10, 10), (10, 4),
(11, 1), (11, 5),
(12, 4), (12, 10),
(13, 1),
(14, 4), (14, 9),
(15, 1), (15, 8),
(16, 4),
(17, 3), (17, 1),
(18, 4), (18, 1),
(19, 1),
(20, 4), (20, 9);

INSERT INTO playlist (nombre_playlist, descripcion, id_usuario, tipo_playlist, plataforma_origen) VALUES
('Urbano Total', 'Lo mejor del reggaeton y trap', 1, 'usuario', 'interna'),
('Relax Vibes', 'Para relajarte después de un día largo', 2, 'estado_animo', 'interna'),
('Gym Mode', 'Alta energía para el gimnasio', 3, 'actividad', 'interna'),
('Pop Hits 2024', 'Los éxitos pop del momento', 4, 'usuario', 'interna'),
('Latin Fever', 'Lo mejor de la música latina', 5, 'pais', 'interna'),
('Estudio Focus', 'Música para concentrarse', 6, 'actividad', 'interna'),
('Rock Classics', 'Clásicos del rock', 7, 'usuario', 'interna'),
('Fiesta Latina', 'Para bailar toda la noche', 8, 'actividad', 'interna'),
('Sad Hours', 'Para los momentos difíciles', 9, 'estado_animo', 'interna'),
('Morning Energy', 'Empieza el día con energía', 10, 'actividad', 'interna'),
('Chill Sunday', 'Domingos tranquilos', 11, 'estado_animo', 'interna'),
('Top Global', 'Lo más escuchado en el mundo', 12, 'mixta', 'interna'),
('Trap Nación', 'Todo el trap en un lugar', 13, 'usuario', 'interna'),
('Indie Vibes', 'Música independiente seleccionada', 14, 'usuario', 'interna'),
('Romantic Night', 'Para una noche especial', 15, 'estado_animo', 'interna');

INSERT INTO playlist_cancion (id_playlist, id_cancion, posicion) VALUES
(1, 1, 1), (1, 3, 2), (1, 8, 3), (1, 10, 4), (1, 12, 5),
(2, 4, 1), (2, 11, 2), (2, 19, 3),
(3, 7, 1), (3, 9, 2), (3, 15, 3), (3, 17, 4),
(4, 2, 1), (4, 11, 2), (4, 13, 3), (4, 15, 4),
(5, 6, 1), (5, 8, 2), (5, 14, 3), (5, 20, 4),
(6, 4, 1), (6, 9, 2), (6, 17, 3),
(8, 3, 1), (8, 6, 2), (8, 16, 3), (8, 20, 4),
(9, 4, 1), (9, 13, 2),
(10, 7, 1), (10, 9, 2), (10, 11, 3),
(12, 2, 1), (12, 7, 2), (12, 9, 3), (12, 10, 4),
(13, 1, 1), (13, 10, 2), (13, 12, 3),
(15, 4, 1), (15, 14, 2), (15, 19, 3);

INSERT INTO cancion_estado_animo (id_cancion, id_estado_animo, afinidad) VALUES
(1, 1, 90), (1, 15, 85),
(2, 2, 80), (2, 6, 75),
(3, 1, 95), (3, 15, 90),
(4, 4, 85), (4, 6, 80),
(5, 7, 90),
(6, 1, 88), (6, 15, 92),
(7, 3, 95), (7, 7, 88),
(8, 1, 90), (8, 3, 85),
(9, 5, 88), (9, 1, 82),
(10, 1, 92), (10, 3, 88),
(11, 1, 85), (11, 3, 90),
(12, 3, 88), (12, 7, 85),
(13, 9, 90), (13, 2, 85),
(14, 5, 92), (14, 6, 88),
(15, 1, 85),
(16, 1, 90), (16, 15, 88),
(17, 4, 85), (17, 11, 90),
(18, 3, 88), (18, 1, 85),
(19, 4, 90), (19, 11, 85),
(20, 5, 88), (20, 15, 85);

INSERT INTO cancion_actividad (id_cancion, id_actividad, afinidad) VALUES
(1, 5, 92), (1, 6, 80),
(2, 2, 75), (2, 12, 70),
(3, 5, 95), (3, 6, 85),
(4, 4, 88), (4, 11, 82),
(5, 6, 85), (5, 1, 80),
(6, 5, 92), (6, 1, 88),
(7, 1, 95), (7, 9, 92),
(8, 5, 90), (8, 6, 85),
(9, 8, 85), (9, 6, 80),
(10, 1, 90), (10, 9, 88),
(11, 1, 88), (11, 5, 85),
(12, 1, 90), (12, 9, 88),
(13, 11, 85), (13, 7, 80),
(14, 13, 82), (14, 6, 78),
(15, 5, 88),
(16, 5, 95), (16, 1, 90),
(17, 6, 85), (17, 13, 82),
(18, 5, 90), (18, 1, 88),
(19, 8, 85), (19, 15, 80),
(20, 5, 90), (20, 15, 85);

INSERT INTO pregunta_quiz (texto_pregunta, orden_pregunta) VALUES
('¿Cómo prefieres pasar tu tiempo libre?', 1),
('¿Qué tipo de ambiente te hace sentir más cómodo?', 2),
('¿Cuál de estas actividades disfrutas más?', 3),
('¿Cómo describes tu energía en general?', 4),
('¿Qué te motiva más en la vida?', 5),
('¿Cómo reaccionas ante situaciones nuevas?', 6),
('¿Qué tipo de conversaciones prefieres?', 7),
('¿Cómo te sientes en grupos grandes?', 8),
('¿Qué valoras más en una canción?', 9),
('¿Cuál es tu momento favorito del día para escuchar música?', 10);

INSERT INTO opcion_quiz (id_pregunta, texto_opcion) VALUES
(1, 'Salir con amigos y conocer gente nueva'),
(1, 'Leer o ver series en casa'),
(1, 'Hacer deporte o actividades al aire libre'),
(1, 'Crear algo nuevo: arte, música o escritura'),
(2, 'Lugares llenos de gente y movimiento'),
(2, 'Lugares tranquilos y silenciosos'),
(2, 'Cualquier lugar donde pueda explorar'),
(2, 'Espacios creativos e inspiradores'),
(3, 'Bailar y escuchar música'),
(3, 'Meditar o practicar yoga'),
(3, 'Competir en deportes'),
(3, 'Tocar un instrumento o pintar'),
(4, 'Muy alta, siempre activo'),
(4, 'Moderada, equilibrada'),
(4, 'Tranquila, prefiero la calma'),
(4, 'Variable, depende del día'),
(5, 'El reconocimiento y el éxito'),
(5, 'La conexión con otros'),
(5, 'La aventura y lo desconocido'),
(5, 'La creatividad y la expresión'),
(6, 'Con emoción y entusiasmo'),
(6, 'Con cautela y análisis'),
(6, 'Con curiosidad y apertura'),
(6, 'Depende de la situación'),
(7, 'Animadas y divertidas'),
(7, 'Profundas y reflexivas'),
(7, 'Sobre viajes y aventuras'),
(7, 'Sobre arte y cultura'),
(8, 'Me encanta, me da energía'),
(8, 'Me agota, prefiero grupos pequeños'),
(8, 'Me es indiferente'),
(8, 'Depende de las personas'),
(9, 'El ritmo y el beat'),
(9, 'La letra y el mensaje'),
(9, 'La melodía y la armonía'),
(9, 'La historia que cuenta'),
(10, 'Por la mañana para comenzar el día'),
(10, 'Por la noche para relajarme'),
(10, 'Mientras hago ejercicio'),
(10, 'Todo el día, es mi compañía constante');

INSERT INTO opcion_rasgo (id_opcion, id_rasgo, puntaje) VALUES
(1, 1, 3), (1, 3, 2),
(2, 2, 3), (2, 9, 2),
(3, 3, 3), (3, 8, 2),
(4, 5, 3), (4, 6, 2),
(5, 1, 3),
(6, 2, 3), (6, 4, 2),
(7, 3, 3),
(8, 5, 3),
(9, 1, 3), (9, 7, 2),
(10, 4, 3), (10, 2, 2),
(11, 8, 3), (11, 3, 2),
(12, 5, 3),
(13, 1, 3), (13, 8, 2),
(14, 10, 3),
(15, 4, 3), (15, 2, 2),
(16, 5, 2),
(17, 8, 3), (17, 1, 2),
(18, 7, 3), (18, 10, 2),
(19, 3, 3),
(20, 5, 3);

INSERT INTO perfil_rasgo (id_perfil, id_rasgo, peso) VALUES
(1, 1, 2.00), (1, 3, 1.50),
(2, 7, 2.00), (2, 9, 1.50),
(3, 8, 2.00), (3, 1, 1.50),
(4, 5, 2.00), (4, 6, 1.50),
(5, 2, 2.00), (5, 4, 1.50),
(6, 1, 2.00), (6, 10, 1.50),
(7, 3, 2.00), (7, 8, 1.50),
(8, 5, 2.00), (8, 1, 1.50),
(9, 10, 2.00), (9, 1, 1.50),
(10, 6, 2.00), (10, 2, 1.50);

INSERT INTO resultado_quiz (id_usuario, id_perfil) VALUES
(1, 1), (2, 2), (3, 3), (4, 9), (5, 6),
(6, 5), (7, 7), (8, 6), (9, 2), (10, 3),
(11, 8), (12, 4), (13, 1), (14, 5), (15, 9);

INSERT INTO genero_pais_popularidad (id_genero, id_pais, fecha_referencia, nivel_popularidad) VALUES
(4, 1, '2024-01-01', 92.50),
(4, 9, '2024-01-01', 95.00),
(4, 3, '2024-01-01', 88.00),
(1, 2, '2024-01-01', 90.00),
(1, 7, '2024-01-01', 85.50),
(3, 2, '2024-01-01', 88.00),
(2, 7, '2024-01-01', 82.00),
(9, 5, '2024-01-01', 87.50),
(5, 12, '2024-01-01', 91.00),
(6, 13, '2024-01-01', 78.50);

INSERT INTO artista_pais_popularidad (id_artista, id_pais, fecha_referencia, nivel_popularidad) VALUES
(1, 1, '2024-01-01', 95.00),
(1, 9, '2024-01-01', 98.00),
(2, 2, '2024-01-01', 97.00),
(3, 3, '2024-01-01', 93.00),
(6, 3, '2024-01-01', 89.00),
(7, 2, '2024-01-01', 91.00),
(9, 7, '2024-01-01', 88.00),
(10, 1, '2024-01-01', 94.00),
(11, 7, '2024-01-01', 86.00),
(16, 9, '2024-01-01', 90.00);

INSERT INTO cancion_pais_popularidad (id_cancion, id_pais, fecha_referencia, nivel_popularidad) VALUES
(1, 1, '2024-01-01', 94.00),
(1, 9, '2024-01-01', 97.00),
(2, 2, '2024-01-01', 96.00),
(3, 1, '2024-01-01', 88.00),
(7, 2, '2024-01-01', 92.00),
(8, 3, '2024-01-01', 95.00),
(9, 7, '2024-01-01', 89.00),
(10, 1, '2024-01-01', 93.00),
(16, 9, '2024-01-01', 91.00),
(6, 3, '2024-01-01', 85.00);
