package com.example.basketballapp;

import com.example.basketballapp.model.Role;
import com.example.basketballapp.model.User;
import com.example.basketballapp.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
public class DataInitializer {
    private static final Logger log = LoggerFactory.getLogger(DataInitializer.class);

    @Bean
    CommandLineRunner initUsers(UserRepository userRepository, PasswordEncoder encoder) {
        return args -> {
            if (!userRepository.existsByUsername("coach")) {
                User coach = new User("coach", encoder.encode("coach123"), Role.COACH);
                userRepository.save(coach);
                log.info("Created default coach user: username=coach password=coach123");
            }
        };
    }
}
