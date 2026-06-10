package com.musicrecommender.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "artista")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Artista {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_artista")
    private Long idArtista;

    @Column(name = "nombre_artista", nullable = false, length = 150)
    private String nombreArtista;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_pais_origen")
    private Pais paisOrigen;

    @Column(name = "spotify_id", unique = true, length = 60)
    private String spotifyId;

    @Column(name = "youtube_channel_id", unique = true, length = 100)
    private String youtubeChannelId;
}
