package com.ai.restaurant.util;

import com.ai.restaurant.dao.*;
import com.ai.restaurant.model.*;

import java.util.List;

public class a {

    public static void main(String[] args) {

        // =========================
        // TEST USER DAO
        // =========================
        UserDAO userDAO = new UserDAOImpl();

        System.out.println("=== USERS ===");
        List<User> users = userDAO.getAllUsers();
        for (User u : users) {
            System.out.println(u.getId() + " " + u.getName() + " " + u.getEmail());
        }

        // =========================
        // TEST MENU DAO
        // =========================
        MenuDAO menuDAO = new MenuDAOImpl();

        System.out.println("\n=== MENU ITEMS ===");
        List<MenuItem> items = menuDAO.getAllMenuItems();
        for (MenuItem m : items) {
            System.out.println(m.getId() + " " + m.getName() + " ₹" + m.getPrice());
        }

        // =========================
        // TEST FILTER
        // =========================
        System.out.println("\n=== VEG ITEMS UNDER 200 ===");
        List<MenuItem> vegItems = menuDAO.getVegetarianItems();
        for (MenuItem m : vegItems) {
            if (m.getPrice() <= 200) {
                System.out.println(m.getName() + " ₹" + m.getPrice());
            }
        }

        // =========================
        // TEST ORDER DAO
        // =========================
        OrderDAO orderDAO = new OrderDAOImpl();

        System.out.println("\n=== ORDERS ===");
        List<Order> orders = orderDAO.getActiveOrders();
        for (Order o : orders) {
            System.out.println("Order ID: " + o.getId() +
                    " | Table: " + o.getTableNumber() +
                    " | Status: " + o.getStatus());
        }

        // =========================
        // TEST ORDER ITEMS
        // =========================
        OrderItemDAO orderItemDAO = new OrderItemDAOImpl();

        System.out.println("\n=== ORDER ITEMS (Order ID = 1) ===");
        List<OrderItem> orderItems = orderItemDAO.getItemsByOrderId(1);
        for (OrderItem oi : orderItems) {
            System.out.println("Item ID: " + oi.getMenuItemId() +
                    " Qty: " + oi.getQuantity() +
                    " Price: " + oi.getPriceAtOrder());
        }

        // =========================
        // TEST TOTAL CALCULATION
        // =========================
        double total = orderItemDAO.calculateTotalByOrderId(1);
        System.out.println("\nTotal for Order 1: ₹" + total);

        // =========================
        // TEST CHAT DAO
        // =========================
        ChatDAO chatDAO = new ChatDAOImpl();

        System.out.println("\n=== CHAT HISTORY (User ID = 1) ===");
        List<ChatMessage> chats = chatDAO.getMessagesByUserId(1);
        for (ChatMessage c : chats) {
            System.out.println(c.getMessageType() + ": " + c.getContent());
        }

        System.out.println("\n=== TEST COMPLETED ===");
    }
}