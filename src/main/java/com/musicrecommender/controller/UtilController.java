package com.musicrecommender.controller;

import com.musicrecommender.service.ArchivoService;
import com.musicrecommender.service.EmailService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.util.Map;

@RestController
@RequestMapping("/api")
@Tag(name = "Utilidades", description = "Subida de archivos y envío de correos")
public class UtilController {

    @Autowired
    private ArchivoService archivoService;

    @Autowired
    private EmailService emailService;

    @PostMapping("/archivos/subir")
    @Operation(summary = "Subir un archivo al servidor")
    public ResponseEntity<Map<String, String>> subirArchivo(@RequestParam("archivo") MultipartFile archivo) {
        try {
            String nombre = archivoService.guardarArchivo(archivo);
            return ResponseEntity.ok(Map.of("nombreArchivo", nombre, "mensaje", "Archivo subido correctamente"));
        } catch (IOException e) {
            return ResponseEntity.internalServerError().body(Map.of("error", "Error al subir el archivo"));
        }
    }

    @GetMapping("/archivos/{nombreArchivo}")
    @Operation(summary = "Descargar un archivo del servidor")
    public ResponseEntity<byte[]> descargarArchivo(@PathVariable String nombreArchivo) {
        try {
            byte[] contenido = archivoService.obtenerArchivo(nombreArchivo);
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + nombreArchivo + "\"")
                    .contentType(MediaType.APPLICATION_OCTET_STREAM)
                    .body(contenido);
        } catch (IOException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @DeleteMapping("/archivos/{nombreArchivo}")
    @Operation(summary = "Eliminar un archivo del servidor")
    public ResponseEntity<Map<String, String>> eliminarArchivo(@PathVariable String nombreArchivo) {
        boolean eliminado = archivoService.eliminarArchivo(nombreArchivo);
        return eliminado
                ? ResponseEntity.ok(Map.of("mensaje", "Archivo eliminado"))
                : ResponseEntity.notFound().build();
    }

    @PostMapping("/email/enviar")
    @Operation(summary = "Enviar correo electrónico de notificación")
    public ResponseEntity<Map<String, String>> enviarEmail(
            @RequestParam String destinatario,
            @RequestParam String asunto,
            @RequestParam String cuerpo) {
        try {
            emailService.enviarNotificacion(destinatario, asunto, cuerpo);
            return ResponseEntity.ok(Map.of("mensaje", "Correo enviado correctamente"));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body(Map.of("error", "Error al enviar el correo"));
        }
    }
}
