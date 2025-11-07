package com.example.basketballapp.dto;

import java.time.OffsetDateTime;

public class UserAnalyticsDto {
    private Long userId;
    private String username;
    private int totalTrainings;
    private int totalBookings;
    private int canceledBookings;
    private OffsetDateTime lastTrainingDate;
    private double attendanceRate; // процент посещаемости

    // Getters and Setters
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public int getTotalTrainings() { return totalTrainings; }
    public void setTotalTrainings(int totalTrainings) { this.totalTrainings = totalTrainings; }

    public int getTotalBookings() { return totalBookings; }
    public void setTotalBookings(int totalBookings) { this.totalBookings = totalBookings; }

    public int getCanceledBookings() { return canceledBookings; }
    public void setCanceledBookings(int canceledBookings) { this.canceledBookings = canceledBookings; }

    public OffsetDateTime getLastTrainingDate() { return lastTrainingDate; }
    public void setLastTrainingDate(OffsetDateTime lastTrainingDate) { this.lastTrainingDate = lastTrainingDate; }

    public double getAttendanceRate() { return attendanceRate; }
    public void setAttendanceRate(double attendanceRate) { this.attendanceRate = attendanceRate; }
}