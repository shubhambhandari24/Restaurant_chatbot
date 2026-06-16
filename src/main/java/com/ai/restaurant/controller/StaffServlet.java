package com.ai.restaurant.controller;

import com.ai.restaurant.service.OrderService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;

public class StaffServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private OrderService orderService = new OrderService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String status = request.getParameter("status");

        orderService.updateOrderStatus(orderId, status);

        response.sendRedirect("staff/dashboard.jsp");
    }
}