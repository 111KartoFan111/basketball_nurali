package com.example.basketballapp.service;

import com.example.basketballapp.dto.RequestPasswordResetDto;
import com.example.basketballapp.dto.ResetPasswordDto;
import com.example.basketballapp.model.PasswordResetCode;
import com.example.basketballapp.model.User;
import com.example.basketballapp.repository.PasswordResetCodeRepository;
import com.example.basketballapp.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.OffsetDateTime;

@Service
public class PasswordResetService {
    
    private static final Logger log = LoggerFactory.getLogger(PasswordResetService.class);
    private static final int CODE_LENGTH = 6;
    private static final int CODE_EXPIRY_MINUTES = 15;
    private static final SecureRandom random = new SecureRandom();
    
    private final UserRepository userRepository;
    private final PasswordResetCodeRepository codeRepository;
    private final TelegramService telegramService;
    private final PasswordEncoder passwordEncoder;
    
    public PasswordResetService(
        UserRepository userRepository,
        PasswordResetCodeRepository codeRepository,
        TelegramService telegramService,
        PasswordEncoder passwordEncoder
    ) {
        this.userRepository = userRepository;
        this.codeRepository = codeRepository;
        this.telegramService = telegramService;
        this.passwordEncoder = passwordEncoder;
    }
    
    /**
     * Запросить сброс пароля - отправить код в Telegram
     */
    @Transactional
    public void requestPasswordReset(RequestPasswordResetDto request) {
        log.info("📨 Password reset requested for username: {}", request.getUsername());
        
        // Найти пользователя по username
        User user = userRepository.findByUsername(request.getUsername())
            .orElseThrow(() -> new IllegalArgumentException("User not found"));
        
        // Проверить, что Telegram ID совпадает или еще не установлен
        if (user.getTelegramId() != null && !user.getTelegramId().equals(request.getTelegramId())) {
            log.warn("⚠️ Telegram ID mismatch for user: {}", request.getUsername());
            throw new IllegalArgumentException("Telegram ID does not match");
        }
        
        // Если Telegram ID еще не установлен, установить его
        if (user.getTelegramId() == null) {
            user.setTelegramId(request.getTelegramId());
            userRepository.save(user);
            log.info("✅ Telegram ID set for user: {}", request.getUsername());
        }
        
        // Сгенерировать код
        String code = generateCode();
        OffsetDateTime expiresAt = OffsetDateTime.now().plusMinutes(CODE_EXPIRY_MINUTES);
        
        // Сохранить код в базу
        PasswordResetCode resetCode = new PasswordResetCode(user, code, expiresAt);
        codeRepository.save(resetCode);
        
        log.info("🔑 Reset code generated for user: {} (expires in {} min)", 
                 request.getUsername(), CODE_EXPIRY_MINUTES);
        
        // Отправить код в Telegram
        boolean sent = telegramService.sendPasswordResetCode(
            request.getTelegramId(),
            request.getUsername(),
            code
        );
        
        if (!sent) {
            log.error("❌ Failed to send reset code to Telegram for user: {}", request.getUsername());
            throw new RuntimeException("Failed to send reset code. Please check your Telegram ID and try again.");
        }
        
        log.info("✅ Password reset code sent successfully to user: {}", request.getUsername());
    }
    
    /**
     * Сбросить пароль с использованием кода
     */
    @Transactional
    public void resetPassword(ResetPasswordDto request) {
        log.info("🔐 Password reset attempt with code: {}", request.getCode());
        
        // Найти действующий код
        PasswordResetCode resetCode = codeRepository
            .findByCodeAndUsedFalseAndExpiresAtAfter(request.getCode(), OffsetDateTime.now())
            .orElseThrow(() -> {
                log.warn("⚠️ Invalid or expired reset code: {}", request.getCode());
                return new IllegalArgumentException("Invalid or expired reset code");
            });
        
        // Пометить код как использованный
        resetCode.setUsed(true);
        codeRepository.save(resetCode);
        
        // Обновить пароль пользователя
        User user = resetCode.getUser();
        user.setPasswordHash(passwordEncoder.encode(request.getNewPassword()));
        userRepository.save(user);
        
        log.info("✅ Password successfully reset for user: {}", user.getUsername());
    }
    
    /**
     * Проверить валидность кода (для UI обратной связи)
     */
    @Transactional(readOnly = true)
    public boolean isCodeValid(String code) {
        return codeRepository
            .findByCodeAndUsedFalseAndExpiresAtAfter(code, OffsetDateTime.now())
            .isPresent();
    }
    
    /**
     * Генерировать случайный 6-значный код
     */
    private String generateCode() {
        StringBuilder code = new StringBuilder();
        for (int i = 0; i < CODE_LENGTH; i++) {
            code.append(random.nextInt(10));
        }
        return code.toString();
    }
    
    /**
     * Очистка истекших кодов (раз в час)
     */
    @Scheduled(fixedRate = 3600000) // 1 час
    @Transactional
    public void cleanupExpiredCodes() {
        OffsetDateTime now = OffsetDateTime.now();
        codeRepository.deleteByExpiresAtBefore(now);
        log.debug("🧹 Expired password reset codes cleaned up");
    }
}