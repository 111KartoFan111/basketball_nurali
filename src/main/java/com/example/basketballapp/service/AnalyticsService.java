package com.example.basketballapp.service;

import com.example.basketballapp.dto.UserAnalyticsDto;
import com.example.basketballapp.model.Booking;
import com.example.basketballapp.model.User;
import com.example.basketballapp.repository.BookingRepository;
import com.example.basketballapp.repository.UserRepository;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class AnalyticsService {

    private final UserRepository userRepository;
    private final BookingRepository bookingRepository;
    private final UserService userService;

    public AnalyticsService(UserRepository userRepository, BookingRepository bookingRepository, UserService userService) {
        this.userRepository = userRepository;
        this.bookingRepository = bookingRepository;
        this.userService = userService;
    }

    @Transactional(readOnly = true)
    public List<UserAnalyticsDto> getUsersAnalytics() {
        // Проверяем, что текущий пользователь - тренер
        User currentUser = userService.getCurrentUser();
        if (!currentUser.getRole().name().equals("COACH")) {
            throw new AccessDeniedException("Only coaches can access analytics");
        }

        // Получаем всех пользователей (не тренеров)
        List<User> users = userRepository.findAll().stream()
                .filter(user -> !user.getRole().name().equals("COACH"))
                .collect(Collectors.toList());

        // Формируем аналитику для каждого пользователя
        return users.stream().map(user -> {
            List<Booking> userBookings = bookingRepository.findByUser(user);
            
            UserAnalyticsDto dto = new UserAnalyticsDto();
            dto.setUserId(user.getId());
            dto.setUsername(user.getUsername());
            dto.setTotalBookings(userBookings.size());
            dto.setCanceledBookings((int) userBookings.stream()
                    .filter(Booking::getCanceled)
                    .count());
            
            // Рассчитываем посещаемость
            if (!userBookings.isEmpty()) {
                double attendanceRate = (double) (userBookings.size() - dto.getCanceledBookings()) 
                        / userBookings.size() * 100.0;
                dto.setAttendanceRate(Math.round(attendanceRate * 100.0) / 100.0); // Округляем до 2 знаков
                
                // Последняя тренировка
                userBookings.stream()
                        .filter(b -> !b.getCanceled())
                        .map(b -> b.getTraining().getStartsAt())
                        .max(OffsetDateTime::compareTo)
                        .ifPresent(dto::setLastTrainingDate);
            } else {
                dto.setAttendanceRate(0.0);
            }
            
            return dto;
        }).collect(Collectors.toList());
    }
}