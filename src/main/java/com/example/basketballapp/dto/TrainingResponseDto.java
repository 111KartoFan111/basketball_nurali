package com.example.basketballapp.dto;

import com.example.basketballapp.model.Training;
import java.time.OffsetDateTime;

public class TrainingResponseDto {
    private Long id;
    private String title;
    private String description;
    private OffsetDateTime startsAt;
    private OffsetDateTime endsAt;
    private Integer capacity;
    private boolean canceled;
    private UserDto coach;

    public TrainingResponseDto() {}

    public static TrainingResponseDto fromEntity(Training training) {
        TrainingResponseDto dto = new TrainingResponseDto();
        dto.setId(training.getId());
        dto.setTitle(training.getTitle());
        dto.setDescription(training.getDescription());
        dto.setStartsAt(training.getStartsAt());
        dto.setEndsAt(training.getEndsAt());
        dto.setCapacity(training.getCapacity());
        dto.setCanceled(training.isCanceled());
        if (training.getCoach() != null) {
            dto.setCoach(UserDto.fromEntity(training.getCoach()));
        }
        return dto;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public OffsetDateTime getStartsAt() { return startsAt; }
    public void setStartsAt(OffsetDateTime startsAt) { this.startsAt = startsAt; }

    public OffsetDateTime getEndsAt() { return endsAt; }
    public void setEndsAt(OffsetDateTime endsAt) { this.endsAt = endsAt; }

    public Integer getCapacity() { return capacity; }
    public void setCapacity(Integer capacity) { this.capacity = capacity; }

    public boolean isCanceled() { return canceled; }
    public void setCanceled(boolean canceled) { this.canceled = canceled; }

    public UserDto getCoach() { return coach; }
    public void setCoach(UserDto coach) { this.coach = coach; }
}