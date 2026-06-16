package com.ai.restaurant.controller;

import com.ai.restaurant.model.User;
import com.ai.restaurant.service.AuthService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;

public class AuthServlet extends HttpServlet {

    private AuthService authService = new AuthService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("login".equals(action)) {
            login(request, response);
        } else if ("register".equals(action)) {
            register(request, response);
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = authService.login(email, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("role", user.getRole());

            if ("staff".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("staff/dashboard.jsp");
            } else {
                response.sendRedirect("customer/chat.jsp");
            }

        } else {
            response.sendRedirect("login.jsp?error=1");
        }
    }

    private void register(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");

        User user = new User(name, email, password, phone, "customer");

        String result = authService.register(user);

        if ("SUCCESS".equals(result)) {
            response.sendRedirect("login.jsp");
        } else {
            response.sendRedirect("register.jsp?msg=" + result.replace(" ", "%20"));
        }
    }
}