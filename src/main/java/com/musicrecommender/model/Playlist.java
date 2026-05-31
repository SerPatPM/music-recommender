package com.musicrecommender.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "playlist")
public class Playlist {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_playlist")
    private Long idPlaylist;

    @Column(name = "nombre_playlist", nullable = false, length = 150)
    private String nombrePlaylist;

    @Column(name = "descripcion", columnDefinition = "TEXT")
    private String descripcion;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_usuario")
    private Usuario usuario;

    @Column(name = "tipo_playlist", nullable = false, length = 20)
    private String tipoPlaylist;

    @Column(name = "plataforma_origen", nullable = false, length = 10)
    private String plataformaOrigen;

    @Column(name = "spotify_playlist_id", unique = true, length = 60)
    private String spotifyPlaylistId;

    @Column(name = "youtube_playlist_id", unique = true, length = 100)
    private String youtubePlaylistId;

    @Column(name = "creada_en")
    private LocalDateTime creadaEn;
}
