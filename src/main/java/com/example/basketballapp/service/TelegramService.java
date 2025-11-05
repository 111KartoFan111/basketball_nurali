package com.example.basketballapp.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

@Service
public class TelegramService {
    
    private static final Logger log = LoggerFactory.getLogger(TelegramService.class);
    
    @Value("${telegram.bot.token:}")
    private String botToken;
    
    private final RestTemplate restTemplate = new RestTemplate();
    
    /**
     * Отправить код сброса пароля пользователю через Telegram
     */
    public boolean sendPasswordResetCode(Long telegramId, String username, String code) {
        
        if (botToken == null || botToken.isEmpty()) {
            log.warn("Telegram bot token is not configured. Cannot send reset code.");
            return false;
        }
        
        try {
            String message = String.format(
                "🔐 *Код для сброса пароля*%n%n" +
                "Username: `%s`%n" +
                "Код подтверждения: `%s`%n%n" +
                "⏰ Код действителен 15 минут%n" +
                "⚠️ Не сообщайте код никому!",
                username,
                code
            );
            
            String url = String.format("https://api.telegram.org/bot%s/sendMessage", botToken);
            
            Map<String, Object> request = new HashMap<>();
            request.put("chat_id", telegramId);
            request.put("text", message);
            request.put("parse_mode", "Markdown");
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            
            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(request, headers);
            
            ResponseEntity<String> response = restTemplate.exchange(
                url,
                HttpMethod.POST,
                entity,
                String.class
            );
            
            if (response.getStatusCode() == HttpStatus.OK) {
                log.info("✅ Password reset code sent to Telegram ID: {}", telegramId);
                return true;
            } else {
                log.error("❌ Failed to send Telegram message. Status: {}", response.getStatusCode());
                return false;
            }
            
        } catch (Exception e) {
            log.error("❌ Error sending Telegram message to {}: {}", telegramId, e.getMessage());
            return false;
        }
    }
    
    /**
     * Отправить уведомление о новой тренировке
     */
    public void sendTrainingNotification(Long telegramId, String trainingTitle, String dateTime) {
        if (botToken == null || botToken.isEmpty()) {
            return;
        }
        
        try {
            String message = String.format(
                "🏀 *Новая тренировка!*%n%n" +
                "📝 %s%n" +
                "📅 %s%n%n" +
                "Откройте приложение для записи!",
                trainingTitle,
                dateTime
            );
            
            String url = String.format("https://api.telegram.org/bot%s/sendMessage", botToken);
            
            Map<String, Object> request = new HashMap<>();
            request.put("chat_id", telegramId);
            request.put("text", message);
            request.put("parse_mode", "Markdown");
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            
            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(request, headers);
            
            restTemplate.exchange(url, HttpMethod.POST, entity, String.class);
            
            log.info("Training notification sent to Telegram ID: {}", telegramId);
            
        } catch (Exception e) {
            log.error("Error sending training notification: {}", e.getMessage());
        }
    }
}