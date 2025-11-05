package com.example.basketballapp.controller;

import com.example.basketballapp.dto.TrainingDto;
import com.example.basketballapp.dto.TrainingResponseDto;
import com.example.basketballapp.model.Training;
import com.example.basketballapp.service.TrainingService;
import jakarta.validation.Valid;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.OffsetDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/trainings")
public class TrainingController {

    private final TrainingService trainingService;

    public TrainingController(TrainingService trainingService) {
        this.trainingService = trainingService;
    }

    @GetMapping
    public ResponseEntity<List<TrainingResponseDto>> schedule(
            @RequestParam(name = "from", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) OffsetDateTime from,
            @RequestParam(name = "to", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) OffsetDateTime to
    ) {
        List<Training> trainings = trainingService.getSchedule(from, to);
        List<TrainingResponseDto> dtos = trainings.stream()
                .map(TrainingResponseDto::fromEntity)
                .toList();
        return ResponseEntity.ok(dtos);
    }

    @PreAuthorize("hasRole('COACH')")
    @PostMapping
    public ResponseEntity<Training> create(@RequestBody @Valid TrainingDto dto) {
        return ResponseEntity.ok(trainingService.create(dto));
    }

    @PreAuthorize("hasRole('COACH')")
    @PutMapping("/{id}")
    public ResponseEntity<Training> update(@PathVariable Long id, @RequestBody @Valid TrainingDto dto) {
        return ResponseEntity.ok(trainingService.update(id, dto));
    }

    @PreAuthorize("hasRole('COACH')")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> cancel(@PathVariable Long id) {
        trainingService.cancel(id);
        return ResponseEntity.noContent().build();
    }
}