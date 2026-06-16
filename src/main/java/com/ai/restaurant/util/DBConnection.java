package com.ai.restaurant.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // ─── Read from environment variables (set on Render/cloud) ───────────────
    // Falls back to localhost values so local Eclipse development still works.
    private static final String URL;
    private static final String USER;
    private static final String PASSWORD;

    static {
        String envUrl  = System.getenv("DB_URL");
        String envUser = System.getenv("DB_USER");
        String envPass = System.getenv("DB_PASSWORD");

        URL      = (envUrl  != null && !envUrl.isBlank())
                   ? envUrl
                   : "jdbc:mysql://localhost:3306/ai_restaurant_chatbot?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
        USER     = (envUser != null && !envUser.isBlank()) ? envUser : "root";
        PASSWORD = (envPass != null && !envPass.isBlank()) ? envPass : "Shubham@127";
    }

    private DBConnection() {}

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found", e);
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}