package com.musicrecommender.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "genero")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Genero {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_genero")
    private Integer idGenero;

    @Column(name = "nombre_genero", nullable = false, unique = true, length = 100)
    private String nombreGenero;
}
