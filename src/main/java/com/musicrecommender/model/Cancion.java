package com.musicrecommender.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDate;

@Data
@Entity
@Table(name = "cancion")
public class Cancion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_cancion")
    private Long idCancion;

    @Column(name = "titulo", nullable = false, length = 200)
    private String titulo;

    @Column(name = "duracion_segundos", nullable = false)
    private Integer duracionSegundos;

    @Column(name = "letra", columnDefinition = "TEXT")
    private String letra;

    @Column(name = "fecha_lanzamiento")
    private LocalDate fechaLanzamiento;

    @Column(name = "spotify_id", unique = true, length = 60)
    private String spotifyId;

    @Column(name = "youtube_video_id", unique = true, length = 100)
    private String youtubeVideoId;
}
