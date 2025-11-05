package com.example.basketballapp.service;

import com.example.basketballapp.dto.AuthRequest;
import com.example.basketballapp.dto.AuthResponse;
import com.example.basketballapp.dto.RegisterRequest;
import com.example.basketballapp.model.Role;
import com.example.basketballapp.model.User;
import com.example.basketballapp.repository.UserRepository;
import com.example.basketballapp.security.JwtTokenProvider;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AuthService {

    private final AuthenticationManager authenticationManager;
    private final JwtTokenProvider tokenProvider;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public AuthService(AuthenticationManager authenticationManager, JwtTokenProvider tokenProvider, UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.authenticationManager = authenticationManager;
        this.tokenProvider = tokenProvider;
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional
    public void register(RegisterRequest request) {
        if (userRepository.existsByUsername(request.getUsername())) {
            throw new IllegalArgumentException("Username already exists");
        }
        Role role = request.isCoach() ? Role.COACH : Role.USER;
        User user = new User(request.getUsername(), passwordEncoder.encode(request.getPassword()), role);
        userRepository.save(user);
    }

    public AuthResponse login(AuthRequest request) {
        Authentication auth = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getUsername(), request.getPassword())
        );
        String role = auth.getAuthorities().stream().findFirst().orElseThrow().getAuthority().replace("ROLE_", "");
        String token = tokenProvider.generateToken(request.getUsername(), role);
        return new AuthResponse(token);
    }
}
