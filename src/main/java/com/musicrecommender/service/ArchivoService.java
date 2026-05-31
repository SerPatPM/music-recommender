package com.musicrecommender.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.nio.file.*;
import java.util.UUID;

@Service
public class ArchivoService {

    @Value("${app.upload.dir}")
    private String uploadDir;

    public String guardarArchivo(MultipartFile archivo) throws IOException {
        Path dirPath = Paths.get(uploadDir);
        if (!Files.exists(dirPath)) {
            Files.createDirectories(dirPath);
        }
        String nombreArchivo = UUID.randomUUID() + "_" + archivo.getOriginalFilename();
        Path rutaArchivo = dirPath.resolve(nombreArchivo);
        Files.copy(archivo.getInputStream(), rutaArchivo, StandardCopyOption.REPLACE_EXISTING);
        return nombreArchivo;
    }

    public byte[] obtenerArchivo(String nombreArchivo) throws IOException {
        Path rutaArchivo = Paths.get(uploadDir).resolve(nombreArchivo);
        return Files.readAllBytes(rutaArchivo);
    }

    public boolean eliminarArchivo(String nombreArchivo) {
        try {
            Path rutaArchivo = Paths.get(uploadDir).resolve(nombreArchivo);
            return Files.deleteIfExists(rutaArchivo);
        } catch (IOException e) {
            return false;
        }
    }
}
