package com.example.basketballapp.controller;

import com.example.basketballapp.dto.AuthRequest;
import com.example.basketballapp.dto.AuthResponse;
import com.example.basketballapp.dto.RegisterRequest;
import com.example.basketballapp.service.AuthService;
import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private static final Logger log = LoggerFactory.getLogger(AuthController.class);
    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/register")
    public ResponseEntity<Void> register(@RequestBody @Valid RegisterRequest request) {
        log.info("📝 Registration request for username: {}", request.getUsername());
        try {
            authService.register(request);
            log.info("✅ User registered successfully: {}", request.getUsername());
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            log.error("❌ Registration failed for {}: {}", request.getUsername(), e.getMessage());
            throw e;
        }
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody @Valid AuthRequest request) {
        log.info("🔐 Login attempt for username: {}", request.getUsername());
        try {
            AuthResponse response = authService.login(request);
            log.info("✅ Login successful for: {}", request.getUsername());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("❌ Login failed for {}: {}", request.getUsername(), e.getMessage());
            throw e;
        }
    }
}