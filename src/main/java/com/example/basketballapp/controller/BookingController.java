package com.example.basketballapp.controller;

import com.example.basketballapp.model.Booking;
import com.example.basketballapp.service.BookingService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/bookings")
public class BookingController {

    private final BookingService bookingService;

    public BookingController(BookingService bookingService) {
        this.bookingService = bookingService;
    }

    @PostMapping("/{trainingId}")
    public ResponseEntity<Booking> book(@PathVariable Long trainingId) {
        return ResponseEntity.ok(bookingService.book(trainingId));
    }

    @GetMapping("/me")
    public ResponseEntity<List<Booking>> myBookings() {
        return ResponseEntity.ok(bookingService.myBookings());
    }

    @DeleteMapping("/{bookingId}")
    public ResponseEntity<Void> cancel(@PathVariable Long bookingId) {
        bookingService.cancelMyBooking(bookingId);
        return ResponseEntity.noContent().build();
    }
}
