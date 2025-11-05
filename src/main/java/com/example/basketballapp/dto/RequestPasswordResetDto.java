package com.example.basketballapp.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public class RequestPasswordResetDto {
    
    @NotBlank(message = "Username is required")
    private String username;
    
    @NotNull(message = "Telegram ID is required")
    private Long telegramId;
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public Long getTelegramId() { return telegramId; }
    public void setTelegramId(Long telegramId) { this.telegramId = telegramId; }
}