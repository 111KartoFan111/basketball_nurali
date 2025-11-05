package com.example.basketballapp.controller;

import com.example.basketballapp.dto.RequestPasswordResetDto;
import com.example.basketballapp.dto.ResetPasswordDto;
import com.example.basketballapp.service.PasswordResetService;
import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/password-reset")
public class PasswordResetController {
    
    private static final Logger log = LoggerFactory.getLogger(PasswordResetController.class);
    private final PasswordResetService passwordResetService;
    
    public PasswordResetController(PasswordResetService passwordResetService) {
        this.passwordResetService = passwordResetService;
    }
    
    /**
     * Шаг 1: Запросить код сброса пароля
     * POST /api/password-reset/request
     * Body: { "username": "player1", "telegramId": 123456789 }
     */
    @PostMapping("/request")
    public ResponseEntity<Map<String, String>> requestReset(
        @RequestBody @Valid RequestPasswordResetDto request
    ) {
        log.info("📨 Password reset request from username: {}", request.getUsername());
        
        try {
            passwordResetService.requestPasswordReset(request);
            
            return ResponseEntity.ok(Map.of(
                "message", "Reset code sent to your Telegram",
                "status", "success"
            ));
            
        } catch (IllegalArgumentException e) {
            log.warn("⚠️ Invalid reset request: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of(
                "message", e.getMessage(),
                "status", "error"
            ));
            
        } catch (Exception e) {
            log.error("❌ Error processing reset request: {}", e.getMessage());
            return ResponseEntity.internalServerError().body(Map.of(
                "message", "Failed to send reset code. Please try again.",
                "status", "error"
            ));
        }
    }
    
    /**
     * Шаг 2: Сбросить пароль с кодом
     * POST /api/password-reset/reset
     * Body: { "code": "123456", "newPassword": "newpass123" }
     */
    @PostMapping("/reset")
    public ResponseEntity<Map<String, String>> resetPassword(
        @RequestBody @Valid ResetPasswordDto request
    ) {
        log.info("🔐 Password reset attempt with code");
        
        try {
            passwordResetService.resetPassword(request);
            
            return ResponseEntity.ok(Map.of(
                "message", "Password successfully reset",
                "status", "success"
            ));
            
        } catch (IllegalArgumentException e) {
            log.warn("⚠️ Invalid reset code: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of(
                "message", e.getMessage(),
                "status", "error"
            ));
            
        } catch (Exception e) {
            log.error("❌ Error resetting password: {}", e.getMessage());
            return ResponseEntity.internalServerError().body(Map.of(
                "message", "Failed to reset password. Please try again.",
                "status", "error"
            ));
        }
    }
    
    /**
     * Проверка валидности кода (опционально, для UI)
     * GET /api/password-reset/validate?code=123456
     */
    @GetMapping("/validate")
    public ResponseEntity<Map<String, Boolean>> validateCode(
        @RequestParam String code
    ) {
        boolean valid = passwordResetService.isCodeValid(code);
        return ResponseEntity.ok(Map.of("valid", valid));
    }
}