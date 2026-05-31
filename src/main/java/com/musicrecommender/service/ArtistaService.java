package com.musicrecommender.service;

import com.musicrecommender.model.Artista;
import com.musicrecommender.repository.ArtistaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class ArtistaService {

    @Autowired
    private ArtistaRepository artistaRepository;

    public List<Artista> findAll() {
        return artistaRepository.findAll();
    }

    public Optional<Artista> findById(Long id) {
        return artistaRepository.findById(id);
    }

    public List<Artista> findByNombre(String nombre) {
        return artistaRepository.findByNombreArtistaContainingIgnoreCase(nombre);
    }

    public Artista save(Artista artista) {
        return artistaRepository.save(artista);
    }

    public Optional<Artista> update(Long id, Artista datos) {
        return artistaRepository.findById(id).map(a -> {
            a.setNombreArtista(datos.getNombreArtista());
            a.setPaisOrigen(datos.getPaisOrigen());
            a.setSpotifyId(datos.getSpotifyId());
            a.setYoutubeChannelId(datos.getYoutubeChannelId());
            return artistaRepository.save(a);
        });
    }

    public boolean delete(Long id) {
        if (artistaRepository.existsById(id)) {
            artistaRepository.deleteById(id);
            return true;
        }
        return false;
    }
}
