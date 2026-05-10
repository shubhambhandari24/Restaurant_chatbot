package com.ai.restaurant.service;

import com.ai.restaurant.dao.UserDAO;
import com.ai.restaurant.dao.UserDAOImpl;
import com.ai.restaurant.model.User;

public class AuthService {

    private UserDAO userDAO = new UserDAOImpl();

    // =========================
    // REGISTER
    // =========================
    public String register(User user) {

        // Basic validation
        if (user.getName() == null || user.getEmail() == null || user.getPassword() == null) {
            return "All fields are required";
        }

        // Check email exists
        if (userDAO.isEmailExists(user.getEmail())) {
            return "Email already registered";
        }

        // Default role
        user.setRole("customer");

        boolean success = userDAO.registerUser(user);

        if (success) {
            return "SUCCESS";
        } else {
            return "Registration failed";
        }
    }

    // =========================
    // LOGIN
    // =========================
    public User login(String email, String password) {

        if (email == null || password == null) {
            return null;
        }

        return userDAO.loginUser(email, password);
    }

    // =========================
    // GET USER
    // =========================
    public User getUserById(int id) {
        return userDAO.getUserById(id);
    }
}