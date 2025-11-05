package com.example.basketballapp.dto;

import jakarta.validation.constraints.NotBlank;

public class RegisterRequest {
    @NotBlank
    private String username;
    @NotBlank
    private String password;
    private boolean coach; // if true -> COACH role

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public boolean isCoach() { return coach; }
    public void setCoach(boolean coach) { this.coach = coach; }
}
