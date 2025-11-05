package com.example.basketballapp.service;

import com.example.basketballapp.model.Booking;
import com.example.basketballapp.model.Training;
import com.example.basketballapp.model.User;
import com.example.basketballapp.repository.BookingRepository;
import com.example.basketballapp.repository.TrainingRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class BookingService {

    private final BookingRepository bookingRepository;
    private final TrainingRepository trainingRepository;
    private final UserService userService;

    public BookingService(BookingRepository bookingRepository, TrainingRepository trainingRepository, UserService userService) {
        this.bookingRepository = bookingRepository;
        this.trainingRepository = trainingRepository;
        this.userService = userService;
    }

    @Transactional
    public Booking book(Long trainingId) {
        User user = userService.getCurrentUser();
        Training training = trainingRepository.findById(trainingId).orElseThrow();
        if (training.isCanceled()) {
            throw new IllegalStateException("Training canceled");
        }
        if (bookingRepository.existsByUserAndTraining(user, training)) {
            throw new IllegalStateException("Already booked");
        }
        long booked = bookingRepository.countByTraining(training);
        if (booked >= training.getCapacity()) {
            throw new IllegalStateException("No spots left");
        }
        Booking b = new Booking(user, training);
        return bookingRepository.save(b);
    }

    public List<Booking> myBookings() {
        User user = userService.getCurrentUser();
        return bookingRepository.findByUser(user);
    }

    @Transactional
    public void cancelMyBooking(Long bookingId) {
        User user = userService.getCurrentUser();
        Booking booking = bookingRepository.findByIdAndUser(bookingId, user).orElseThrow();
        bookingRepository.delete(booking);
    }
}
