package com.musicrecommender.service;

import com.musicrecommender.model.Cancion;
import com.musicrecommender.repository.CancionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class CancionService {

    @Autowired
    private CancionRepository cancionRepository;

    public List<Cancion> findAll() {
        return cancionRepository.findAll();
    }

    public Optional<Cancion> findById(Long id) {
        return cancionRepository.findById(id);
    }

    public List<Cancion> findByTitulo(String titulo) {
        return cancionRepository.findByTituloContainingIgnoreCase(titulo);
    }

    public Cancion save(Cancion cancion) {
        return cancionRepository.save(cancion);
    }

    public Optional<Cancion> update(Long id, Cancion datos) {
        return cancionRepository.findById(id).map(c -> {
            c.setTitulo(datos.getTitulo());
            c.setDuracionSegundos(datos.getDuracionSegundos());
            c.setLetra(datos.getLetra());
            c.setFechaLanzamiento(datos.getFechaLanzamiento());
            c.setSpotifyId(datos.getSpotifyId());
            c.setYoutubeVideoId(datos.getYoutubeVideoId());
            return cancionRepository.save(c);
        });
    }

    public boolean delete(Long id) {
        if (cancionRepository.existsById(id)) {
            cancionRepository.deleteById(id);
            return true;
        }
        return false;
    }
}
