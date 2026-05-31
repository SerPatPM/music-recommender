package com.musicrecommender.repository;

import com.musicrecommender.model.Playlist;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface PlaylistRepository extends JpaRepository<Playlist, Long> {
    List<Playlist> findByUsuario_IdUsuario(Long idUsuario);
    List<Playlist> findByTipoPlaylist(String tipoPlaylist);
}
