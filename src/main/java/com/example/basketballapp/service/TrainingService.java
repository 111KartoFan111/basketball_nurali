package com.example.basketballapp.service;

import com.example.basketballapp.dto.TrainingDto;
import com.example.basketballapp.model.Training;
import com.example.basketballapp.model.User;
import com.example.basketballapp.repository.TrainingRepository;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.OffsetDateTime;
import java.util.List;

@Service
public class TrainingService {

    private final TrainingRepository trainingRepository;
    private final UserService userService;

    public TrainingService(TrainingRepository trainingRepository, UserService userService) {
        this.trainingRepository = trainingRepository;
        this.userService = userService;
    }

    public List<Training> getSchedule(OffsetDateTime from, OffsetDateTime to) {
        if (from == null) from = OffsetDateTime.now().minusDays(1);
        if (to == null) to = OffsetDateTime.now().plusDays(30);
        return trainingRepository.findByStartsAtBetweenOrderByStartsAtAsc(from, to);
    }

    @Transactional
    public Training create(TrainingDto dto) {
        User coach = userService.getCurrentUser();
        Training t = new Training();
        t.setTitle(dto.getTitle());
        t.setDescription(dto.getDescription());
        t.setStartsAt(dto.getStartsAt());
        t.setEndsAt(dto.getEndsAt());
        t.setCapacity(dto.getCapacity());
        t.setCoach(coach);
        return trainingRepository.save(t);
    }

    @Transactional
    public Training update(Long id, TrainingDto dto) {
        User coach = userService.getCurrentUser();
        Training t = trainingRepository.findById(id).orElseThrow();
        if (!t.getCoach().getId().equals(coach.getId())) {
            throw new AccessDeniedException("Not your training");
        }
        if (t.isCanceled()) {
            throw new IllegalStateException("Training is canceled");
        }
        t.setTitle(dto.getTitle());
        t.setDescription(dto.getDescription());
        t.setStartsAt(dto.getStartsAt());
        t.setEndsAt(dto.getEndsAt());
        t.setCapacity(dto.getCapacity());
        return trainingRepository.save(t);
    }

    @Transactional
    public void cancel(Long id) {
        User coach = userService.getCurrentUser();
        Training t = trainingRepository.findById(id).orElseThrow();
        if (!t.getCoach().getId().equals(coach.getId())) {
            throw new AccessDeniedException("Not your training");
        }
        t.setCanceled(true);
        trainingRepository.save(t);
    }
}
