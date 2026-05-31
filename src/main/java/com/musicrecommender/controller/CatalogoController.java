package com.musicrecommender.controller;

import com.musicrecommender.model.Genero;
import com.musicrecommender.model.Pais;
import com.musicrecommender.repository.GeneroRepository;
import com.musicrecommender.repository.PaisRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api")
@Tag(name = "Catálogos", description = "Países y géneros musicales")
public class CatalogoController {

    @Autowired
    private PaisRepository paisRepository;

    @Autowired
    private GeneroRepository generoRepository;

    @GetMapping("/paises")
    @Operation(summary = "Obtener todos los países")
    public List<Pais> findAllPaises() {
        return paisRepository.findAll();
    }

    @GetMapping("/paises/{id}")
    @Operation(summary = "Obtener país por ID")
    public ResponseEntity<Pais> findPaisById(@PathVariable Integer id) {
        return paisRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping("/paises")
    @Operation(summary = "Crear nuevo país")
    public ResponseEntity<Pais> savePais(@RequestBody Pais pais) {
        return ResponseEntity.ok(paisRepository.save(pais));
    }

    @DeleteMapping("/paises/{id}")
    @Operation(summary = "Eliminar país")
    public ResponseEntity<Void> deletePais(@PathVariable Integer id) {
        if (paisRepository.existsById(id)) {
            paisRepository.deleteById(id);
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/generos")
    @Operation(summary = "Obtener todos los géneros musicales")
    public List<Genero> findAllGeneros() {
        return generoRepository.findAll();
    }

    @GetMapping("/generos/{id}")
    @Operation(summary = "Obtener género por ID")
    public ResponseEntity<Genero> findGeneroById(@PathVariable Integer id) {
        return generoRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping("/generos")
    @Operation(summary = "Crear nuevo género")
    public ResponseEntity<Genero> saveGenero(@RequestBody Genero genero) {
        return ResponseEntity.ok(generoRepository.save(genero));
    }

    @DeleteMapping("/generos/{id}")
    @Operation(summary = "Eliminar género")
    public ResponseEntity<Void> deleteGenero(@PathVariable Integer id) {
        if (generoRepository.existsById(id)) {
            generoRepository.deleteById(id);
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }
}
