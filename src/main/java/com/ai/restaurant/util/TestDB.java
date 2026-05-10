package com.ai.restaurant.util;

import java.sql.Connection;

public class TestDB {

    public static void main(String[] args) {
        try {
            Connection conn = DBConnection.getConnection();
            
            if (conn != null) {
                System.out.println("✅ Database Connected Successfully!");
            } else {
                System.out.println("❌ Connection Failed!");
            }

        } catch (Exception e) {
            System.out.println("❌ Error connecting to DB");
            e.printStackTrace();
        }
    }
}