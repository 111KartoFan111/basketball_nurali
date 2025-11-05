package com.example.basketballapp.repository;

import com.example.basketballapp.model.Training;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.OffsetDateTime;
import java.util.List;

public interface TrainingRepository extends JpaRepository<Training, Long> {
    
    // ИСПРАВЛЕНО: Добавлен JOIN FETCH для загрузки coach вместе с training
    @Query("SELECT t FROM Training t JOIN FETCH t.coach WHERE t.startsAt BETWEEN :from AND :to ORDER BY t.startsAt ASC")
    List<Training> findByStartsAtBetweenOrderByStartsAtAsc(
        @Param("from") OffsetDateTime from, 
        @Param("to") OffsetDateTime to
    );
    
    long countByIdAndCanceledFalse(Long id);
}