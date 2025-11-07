package com.example.basketballapp.controller;

import com.example.basketballapp.dto.UserAnalyticsDto;
import com.example.basketballapp.service.AnalyticsService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/analytics")
public class AnalyticsController {

    private final AnalyticsService analyticsService;

    public AnalyticsController(AnalyticsService analyticsService) {
        this.analyticsService = analyticsService;
    }

    @GetMapping("/users")
    public ResponseEntity<List<UserAnalyticsDto>> getUsersAnalytics() {
        return ResponseEntity.ok(analyticsService.getUsersAnalytics());
    }
}