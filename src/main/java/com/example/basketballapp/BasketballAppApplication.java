package com.example.basketballapp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling  // Включаем планировщик для очистки кодов
public class BasketballAppApplication {
    public static void main(String[] args) {
        SpringApplication.run(BasketballAppApplication.class, args);
    }
}