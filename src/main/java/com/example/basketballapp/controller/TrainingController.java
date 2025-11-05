package com.example.basketballapp.controller;

import com.example.basketballapp.dto.TrainingDto;
import com.example.basketballapp.dto.TrainingResponseDto;
import com.example.basketballapp.model.Training;
import com.example.basketballapp.service.TrainingService;
import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.OffsetDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/trainings")
public class TrainingController {

    private static final Logger log = LoggerFactory.getLogger(TrainingController.class);
    private final TrainingService trainingService;

    public TrainingController(TrainingService trainingService) {
        this.trainingService = trainingService;
    }

    @GetMapping
    public ResponseEntity<List<TrainingResponseDto>> schedule(
            @RequestParam(name = "from", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) OffsetDateTime from,
            @RequestParam(name = "to", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) OffsetDateTime to
    ) {
        log.info("📋 Fetching trainings schedule (from: {}, to: {})", from, to);
        List<Training> trainings = trainingService.getSchedule(from, to);
        log.info("✅ Found {} trainings", trainings.size());
        List<TrainingResponseDto> dtos = trainings.stream()
                .map(TrainingResponseDto::fromEntity)
                .toList();
        return ResponseEntity.ok(dtos);
    }

    @PreAuthorize("hasRole('COACH')")
    @PostMapping
    public ResponseEntity<Training> create(@RequestBody @Valid TrainingDto dto) {
        log.info("➕ Creating new training: {}", dto.getTitle());
        Training training = trainingService.create(dto);
        log.info("✅ Training created with ID: {}", training.getId());
        return ResponseEntity.ok(training);
    }

    @PreAuthorize("hasRole('COACH')")
    @PutMapping("/{id}")
    public ResponseEntity<Training> update(@PathVariable Long id, @RequestBody @Valid TrainingDto dto) {
        log.info("✏️ Updating training ID: {}", id);
        Training training = trainingService.update(id, dto);
        log.info("✅ Training updated: {}", id);
        return ResponseEntity.ok(training);
    }

    @PreAuthorize("hasRole('COACH')")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> cancel(@PathVariable Long id) {
        log.info("❌ Canceling training ID: {}", id);
        trainingService.cancel(id);
        log.info("✅ Training canceled: {}", id);
        return ResponseEntity.noContent().build();
    }
}