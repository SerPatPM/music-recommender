package com.musicrecommender.repository;

import com.musicrecommender.model.ResultadoQuiz;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ResultadoQuizRepository extends JpaRepository<ResultadoQuiz, Long> {
    List<ResultadoQuiz> findByUsuario_IdUsuario(Long idUsuario);
}
