package com.ai.restaurant.controller;

import com.ai.restaurant.model.User;
import com.ai.restaurant.service.ChatService;
import com.ai.restaurant.service.N8nNotificationService;
import com.ai.restaurant.service.OrderService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;

public class ChatServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ChatService chatService             = new ChatService();
    private N8nNotificationService n8nService   = new N8nNotificationService();
    private OrderService orderService            = new OrderService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.getWriter().write("Session expired. Please login again.");
            return;
        }

        User user = (User) session.getAttribute("user");
        String message = request.getParameter("message");

        if (message == null || message.trim().isEmpty()) {
            response.getWriter().write("Please type something.");
            return;
        }

        String reply = chatService.processMessage(user.getId(), message);

        // 🔔 If an item was added to an order, fire n8n notification
        if (reply != null && reply.contains("added to your order") && reply.contains("Order ID:")) {
            try {
                int orderId = extractOrderId(reply);
                // Fetch the REAL total from DB (not hardcoded 0)
                double realTotal = orderService.calculateTotal(orderId) * 1.18; // include GST
                // Build a clean items string from the reply
                String itemsDesc = reply.split("added to your order")[0].trim();
                n8nService.sendOrderNotification(
                    orderId,
                    user.getName(),
                    user.getEmail(),
                    itemsDesc,
                    realTotal
                );
            } catch (Exception ignored) {
                // Notification failure should never affect the chat response
            }
        }

        response.getWriter().write(reply);
    }

    /** Extracts the Order ID from a reply like "2 x Paneer Tikka added to your order. Order ID: 42" */
    private int extractOrderId(String reply) {
        try {
            String[] parts = reply.split("Order ID:");
            return Integer.parseInt(parts[1].trim());
        } catch (Exception e) {
            return -1;
        }
    }
}