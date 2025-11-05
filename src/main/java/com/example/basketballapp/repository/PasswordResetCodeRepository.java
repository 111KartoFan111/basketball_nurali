package com.example.basketballapp.repository;

import com.example.basketballapp.model.PasswordResetCode;
import com.example.basketballapp.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.OffsetDateTime;
import java.util.Optional;

public interface PasswordResetCodeRepository extends JpaRepository<PasswordResetCode, Long> {
    
    Optional<PasswordResetCode> findByCodeAndUsedFalseAndExpiresAtAfter(
        String code, 
        OffsetDateTime now
    );
    
    Optional<PasswordResetCode> findTopByUserOrderByCreatedAtDesc(User user);
    
    void deleteByExpiresAtBefore(OffsetDateTime now);
}