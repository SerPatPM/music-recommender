package com.musicrecommender.model;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "perfil_musical")
public class PerfilMusical {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_perfil")
    private Integer idPerfil;

    @Column(name = "nombre_perfil", nullable = false, unique = true, length = 100)
    private String nombrePerfil;

    @Column(name = "descripcion", columnDefinition = "TEXT")
    private String descripcion;
}
