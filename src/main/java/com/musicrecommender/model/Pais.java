package com.musicrecommender.model;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "pais")
public class Pais {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_pais")
    private Integer idPais;

    @Column(name = "nombre_pais", nullable = false, unique = true, length = 100)
    private String nombrePais;

    @Column(name = "codigo_iso", unique = true, length = 2)
    private String codigoIso;
}
