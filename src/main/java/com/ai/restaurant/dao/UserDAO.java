package com.ai.restaurant.dao;

import com.ai.restaurant.model.User;
import java.util.List;

public interface UserDAO {

    // Create
    boolean registerUser(User user);

    // Read
    User getUserById(int id);
    User getUserByEmail(String email);
    List<User> getAllUsers();

    // Update
    boolean updateUser(User user);

    // Delete
    boolean deleteUser(int id);

    // Authentication
    User loginUser(String email, String password);

    // Utility
    boolean isEmailExists(String email);
}