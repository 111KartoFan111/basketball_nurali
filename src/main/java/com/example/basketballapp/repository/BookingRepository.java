package com.example.basketballapp.repository;

import com.example.basketballapp.model.Booking;
import com.example.basketballapp.model.Training;
import com.example.basketballapp.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface BookingRepository extends JpaRepository<Booking, Long> {
    long countByTraining(Training training);
    boolean existsByUserAndTraining(User user, Training training);
    List<Booking> findByUser(User user);
    Optional<Booking> findByIdAndUser(Long id, User user);
}
