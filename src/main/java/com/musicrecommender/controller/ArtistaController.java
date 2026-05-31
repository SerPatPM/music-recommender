package com.musicrecommender.controller;

import com.musicrecommender.model.Artista;
import com.musicrecommender.service.ArtistaService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/artistas")
@Tag(name = "Artistas", description = "Gestión de artistas musicales")
public class ArtistaController {

    @Autowired
    private ArtistaService artistaService;

    @GetMapping
    @Operation(summary = "Obtener todos los artistas")
    public List<Artista> findAll() {
        return artistaService.findAll();
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener artista por ID")
    public ResponseEntity<Artista> findById(@PathVariable Long id) {
        return artistaService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/buscar")
    @Operation(summary = "Buscar artistas por nombre")
    public List<Artista> findByNombre(@RequestParam String nombre) {
        return artistaService.findByNombre(nombre);
    }

    @PostMapping
    @Operation(summary = "Crear nuevo artista")
    public ResponseEntity<Artista> save(@RequestBody Artista artista) {
        return ResponseEntity.ok(artistaService.save(artista));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar artista")
    public ResponseEntity<Artista> update(@PathVariable Long id, @RequestBody Artista artista) {
        return artistaService.update(id, artista)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar artista")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        return artistaService.delete(id)
                ? ResponseEntity.noContent().build()
                : ResponseEntity.notFound().build();
    }
}
