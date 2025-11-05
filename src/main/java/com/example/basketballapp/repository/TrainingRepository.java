package com.example.basketballapp.repository;

import com.example.basketballapp.model.Training;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.OffsetDateTime;
import java.util.List;

public interface TrainingRepository extends JpaRepository<Training, Long> {
    List<Training> findByStartsAtBetweenOrderByStartsAtAsc(OffsetDateTime from, OffsetDateTime to);
    long countByIdAndCanceledFalse(Long id);
}
