package com.example.basketballapp.service;

import com.example.basketballapp.dto.AuthRequest;
import com.example.basketballapp.dto.AuthResponse;
import com.example.basketballapp.dto.RegisterRequest;
import com.example.basketballapp.model.Role;
import com.example.basketballapp.model.User;
import com.example.basketballapp.repository.UserRepository;
import com.example.basketballapp.security.JwtTokenProvider;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AuthService {

    private static final Logger log = LoggerFactory.getLogger(AuthService.class);
    private final AuthenticationManager authenticationManager;
    private final JwtTokenProvider tokenProvider;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public AuthService(AuthenticationManager authenticationManager, JwtTokenProvider tokenProvider, 
                      UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.authenticationManager = authenticationManager;
        this.tokenProvider = tokenProvider;
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional
    public void register(RegisterRequest request) {
        log.debug("Attempting to register user: {}", request.getUsername());
        
        if (userRepository.existsByUsername(request.getUsername())) {
            log.warn("Username already exists: {}", request.getUsername());
            throw new IllegalArgumentException("Username already exists");
        }
        
        Role role = request.isCoach() ? Role.COACH : Role.USER;
        String encodedPassword = passwordEncoder.encode(request.getPassword());
        
        User user = new User(request.getUsername(), encodedPassword, role);
        userRepository.save(user);
        
        log.info("User registered successfully: {} with role: {}", request.getUsername(), role);
    }

    public AuthResponse login(AuthRequest request) {
        log.debug("Attempting login for user: {}", request.getUsername());
        
        try {
            Authentication auth = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(request.getUsername(), request.getPassword())
            );
            
            String role = auth.getAuthorities().stream()
                    .findFirst()
                    .orElseThrow(() -> new IllegalStateException("No authorities found"))
                    .getAuthority()
                    .replace("ROLE_", "");
            
            String token = tokenProvider.generateToken(request.getUsername(), role);
            
            log.info("Login successful for user: {} with role: {}", request.getUsername(), role);
            return new AuthResponse(token);
            
        } catch (BadCredentialsException e) {
            log.warn("Bad credentials for user: {}", request.getUsername());
            throw new BadCredentialsException("Invalid username or password");
        } catch (AuthenticationException e) {
            log.error("Authentication failed for user: {}", request.getUsername(), e);
            throw new BadCredentialsException("Authentication failed: " + e.getMessage());
        }
    }
}