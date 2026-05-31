package com.musicrecommender.service;

import com.musicrecommender.model.Usuario;
import com.musicrecommender.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class UsuarioService {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private EmailService emailService;

    public List<Usuario> findAll() {
        return usuarioRepository.findAll();
    }

    public Optional<Usuario> findById(Long id) {
        return usuarioRepository.findById(id);
    }

    public Usuario save(Usuario usuario) {
        Usuario guardado = usuarioRepository.save(usuario);
        emailService.enviarBienvenida(guardado.getEmail(), guardado.getNombre());
        return guardado;
    }

    public Optional<Usuario> update(Long id, Usuario datos) {
        return usuarioRepository.findById(id).map(u -> {
            u.setNombre(datos.getNombre());
            u.setApellidoP(datos.getApellidoP());
            u.setApellidoM(datos.getApellidoM());
            u.setEmail(datos.getEmail());
            return usuarioRepository.save(u);
        });
    }

    public boolean delete(Long id) {
        if (usuarioRepository.existsById(id)) {
            usuarioRepository.deleteById(id);
            return true;
        }
        return false;
    }
}
