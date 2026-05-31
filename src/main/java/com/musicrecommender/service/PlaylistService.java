package com.musicrecommender.service;

import com.musicrecommender.model.Playlist;
import com.musicrecommender.repository.PlaylistRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class PlaylistService {

    @Autowired
    private PlaylistRepository playlistRepository;

    public List<Playlist> findAll() {
        return playlistRepository.findAll();
    }

    public Optional<Playlist> findById(Long id) {
        return playlistRepository.findById(id);
    }

    public List<Playlist> findByUsuario(Long idUsuario) {
        return playlistRepository.findByUsuario_IdUsuario(idUsuario);
    }

    public Playlist save(Playlist playlist) {
        return playlistRepository.save(playlist);
    }

    public Optional<Playlist> update(Long id, Playlist datos) {
        return playlistRepository.findById(id).map(p -> {
            p.setNombrePlaylist(datos.getNombrePlaylist());
            p.setDescripcion(datos.getDescripcion());
            p.setTipoPlaylist(datos.getTipoPlaylist());
            p.setPlataformaOrigen(datos.getPlataformaOrigen());
            return playlistRepository.save(p);
        });
    }

    public boolean delete(Long id) {
        if (playlistRepository.existsById(id)) {
            playlistRepository.deleteById(id);
            return true;
        }
        return false;
    }
}
