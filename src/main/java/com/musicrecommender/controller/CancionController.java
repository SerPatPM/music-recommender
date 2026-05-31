package com.musicrecommender.controller;

import com.musicrecommender.model.Cancion;
import com.musicrecommender.service.CancionService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/canciones")
@Tag(name = "Canciones", description = "Gestión del catálogo de canciones")
public class CancionController {

    @Autowired
    private CancionService cancionService;

    @GetMapping
    @Operation(summary = "Obtener todas las canciones")
    public List<Cancion> findAll() {
        return cancionService.findAll();
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener canción por ID")
    public ResponseEntity<Cancion> findById(@PathVariable Long id) {
        return cancionService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/buscar")
    @Operation(summary = "Buscar canciones por título")
    public List<Cancion> findByTitulo(@RequestParam String titulo) {
        return cancionService.findByTitulo(titulo);
    }

    @PostMapping
    @Operation(summary = "Crear nueva canción")
    public ResponseEntity<Cancion> save(@RequestBody Cancion cancion) {
        return ResponseEntity.ok(cancionService.save(cancion));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar canción")
    public ResponseEntity<Cancion> update(@PathVariable Long id, @RequestBody Cancion cancion) {
        return cancionService.update(id, cancion)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar canción")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        return cancionService.delete(id)
                ? ResponseEntity.noContent().build()
                : ResponseEntity.notFound().build();
    }
}
