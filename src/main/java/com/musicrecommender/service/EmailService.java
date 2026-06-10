package com.musicrecommender.service;

import com.resend.Resend;
import com.resend.services.emails.model.CreateEmailOptions;
import com.resend.core.exception.ResendException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Value("${RESEND_API_KEY}")
    private String resendApiKey;

    public void enviarBienvenida(String destinatario, String nombre) {
        try {
            Resend resend = new Resend(resendApiKey);
            CreateEmailOptions request = CreateEmailOptions.builder()
                .from("onboarding@resend.dev")
                .to(destinatario)
                .subject("Bienvenido a Music Recommender")
                .text("Hola " + nombre + ",\n\nTu cuenta ha sido creada exitosamente en Music Recommender.\n\n¡Disfruta la música!")
                .build();
            resend.emails().send(request);
        } catch (ResendException e) {
            throw new RuntimeException("Error al enviar correo: " + e.getMessage(), e);
        }
    }

    public void enviarNotificacion(String destinatario, String asunto, String cuerpo) {
        try {
            Resend resend = new Resend(resendApiKey);
            CreateEmailOptions request = CreateEmailOptions.builder()
                .from("onboarding@resend.dev")
                .to(destinatario)
                .subject(asunto)
                .text(cuerpo)
                .build();
            resend.emails().send(request);
        } catch (ResendException e) {
            throw new RuntimeException("Error al enviar correo: " + e.getMessage(), e);
        }
    }
}