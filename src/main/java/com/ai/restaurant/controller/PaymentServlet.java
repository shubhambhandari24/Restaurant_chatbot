package com.ai.restaurant.controller;

import com.ai.restaurant.service.OrderService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/pay")
public class PaymentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private OrderService orderService = new OrderService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String orderIdParam = request.getParameter("orderId");

        // Guard: ignore empty/missing orderId (e.g. preflight or duplicate fetch calls)
        if (orderIdParam == null || orderIdParam.trim().isEmpty() || "0".equals(orderIdParam)) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Missing orderId\"}");
            return;
        }

        int orderId = Integer.parseInt(orderIdParam.trim());
        orderService.updateOrderStatus(orderId, "served");

        // After payment, redirect to chatbot for a fresh start
        response.sendRedirect("customer/chat.jsp?msg=Payment+successful!+Thank+you+for+dining+with+PlateUp.");
    }
}