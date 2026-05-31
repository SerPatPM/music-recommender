package com.musicrecommender.controller;

import com.musicrecommender.model.Playlist;
import com.musicrecommender.service.PlaylistService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/playlists")
@Tag(name = "Playlists", description = "Gestión de playlists musicales")
public class PlaylistController {

    @Autowired
    private PlaylistService playlistService;

    @GetMapping
    @Operation(summary = "Obtener todas las playlists")
    public List<Playlist> findAll() {
        return playlistService.findAll();
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener playlist por ID")
    public ResponseEntity<Playlist> findById(@PathVariable Long id) {
        return playlistService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/usuario/{idUsuario}")
    @Operation(summary = "Obtener playlists de un usuario")
    public List<Playlist> findByUsuario(@PathVariable Long idUsuario) {
        return playlistService.findByUsuario(idUsuario);
    }

    @PostMapping
    @Operation(summary = "Crear nueva playlist")
    public ResponseEntity<Playlist> save(@RequestBody Playlist playlist) {
        return ResponseEntity.ok(playlistService.save(playlist));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar playlist")
    public ResponseEntity<Playlist> update(@PathVariable Long id, @RequestBody Playlist playlist) {
        return playlistService.update(id, playlist)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar playlist")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        return playlistService.delete(id)
                ? ResponseEntity.noContent().build()
                : ResponseEntity.notFound().build();
    }
}
