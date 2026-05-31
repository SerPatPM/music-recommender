package com.musicrecommender.repository;

import com.musicrecommender.model.Artista;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ArtistaRepository extends JpaRepository<Artista, Long> {
    List<Artista> findByNombreArtistaContainingIgnoreCase(String nombre);
    List<Artista> findByPaisOrigen_IdPais(Integer idPais);
}
