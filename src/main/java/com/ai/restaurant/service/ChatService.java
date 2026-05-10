package com.ai.restaurant.service;

import com.ai.restaurant.dao.ChatDAO;
import com.ai.restaurant.dao.ChatDAOImpl;
import com.ai.restaurant.model.ChatMessage;
import com.ai.restaurant.model.MenuItem;
import com.ai.restaurant.model.Order;

import java.util.List;

public class ChatService {

    private ChatDAO chatDAO       = new ChatDAOImpl();
    private MenuService menuService   = new MenuService();
    private OrderService orderService = new OrderService();
    private GeminiService geminiService = new GeminiService(); // 🤖 AI-powered replies

    public String processMessage(int userId, String message) {

        ChatMessage userMsg = new ChatMessage();
        userMsg.setUserId(userId);
        userMsg.setMessageType("user");
        userMsg.setContent(message);
        userMsg.setSentiment("neutral");
        chatDAO.saveMessage(userMsg);

        String response;
        message = message.toLowerCase().trim();

        if (message.contains("add")) {
            response = handleAdd(userId, message);

        } else if (message.contains("status")) {
            response = checkOrderStatus(userId);

        } else if (message.contains("veg")) {
            List<MenuItem> items = menuService.filterMenu(true, null, null, null, null, null, null);
            response = formatMenu(items);

        } else if (message.contains("spicy")) {
            List<MenuItem> items = menuService.filterMenu(null, null, null, 3, null, null, null);
            response = formatMenu(items);

        } else if (message.contains("under")) {
            double price = extractPrice(message);
            List<MenuItem> items = menuService.filterMenu(null, null, null, null, null, price, null);
            response = formatMenu(items);

        } else if (message.contains("menu")) {
            List<MenuItem> items = menuService.getAvailableMenu();
            response = formatMenu(items);

        } else {
            // 🤖 Unknown intent — ask Gemini AI for a smart reply
            List<MenuItem> allItems = menuService.getAvailableMenu();
            String aiReply = geminiService.getAIResponse(message, allItems);
            if (aiReply != null && !aiReply.isEmpty()) {
                response = aiReply;
            } else {
                // Fallback if Gemini is unavailable
                response = "I can help with: menu, veg items, spicy dishes, price filters (e.g. under 200), adding items (add 2 paneer tikka), or checking your order status.";
            }
        }

        ChatMessage botMsg = new ChatMessage();
        botMsg.setUserId(userId);
        botMsg.setMessageType("assistant");
        botMsg.setContent(response);
        botMsg.setSentiment("neutral");
        chatDAO.saveMessage(botMsg);

        return response;
    }

    private String handleAdd(int userId, String message) {
        try {
            String[] parts = message.split("\\s+");

            int quantity = 1;

            for (String part : parts) {
                try {
                    quantity = Integer.parseInt(part);
                    break;
                } catch (Exception ignored) {
                }
            }

            String itemName = message.replaceAll(".*add\\s+\\d*\\s*", "").trim();

            if (itemName.isEmpty()) {
                return "Use format: add 2 paneer tikka";
            }

            return orderService.addItemToOrder(userId, itemName, quantity);

        } catch (Exception e) {
            return "Use format: add 2 paneer tikka";
        }
    }

    private String checkOrderStatus(int userId) {

        List<Order> orders = orderService.getUserOrders(userId);

        if (orders == null || orders.isEmpty()) {
            return "No orders found.";
        }

        // ✅ FIXED: take latest order
        Order latestOrder = orders.get(0);

        return "Your latest order ID " + latestOrder.getId()
                + " is currently: " + latestOrder.getStatus();
    }
    private String formatMenu(List<MenuItem> items) {

        if (items == null || items.isEmpty()) {
            return "No items found matching your request.";
        }

        StringBuilder sb = new StringBuilder();

        for (MenuItem item : items) {
            sb.append(item.getName())
              .append(" - ₹")
              .append(item.getPrice())
              .append("\n");
        }

        return sb.toString();
    }

    private double extractPrice(String message) {
        String[] words = message.split("\\s+");

        for (String word : words) {
            try {
                return Double.parseDouble(word);
            } catch (Exception ignored) {
            }
        }

        return 0;
    }

    public List<ChatMessage> getChatHistory(int userId) {
        return chatDAO.getMessagesByUserId(userId);
    }
}