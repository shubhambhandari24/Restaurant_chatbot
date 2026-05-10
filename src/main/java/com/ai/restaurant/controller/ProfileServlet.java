package com.ai.restaurant.controller;

import com.ai.restaurant.dao.UserDAO;
import com.ai.restaurant.dao.UserDAOImpl;
import com.ai.restaurant.model.User;
import com.ai.restaurant.service.OrderService;
import com.ai.restaurant.model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private UserDAO userDAO = new UserDAOImpl();
    private OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Load order history
        List<Order> orders = orderService.getUserOrders(user.getId());
        request.setAttribute("orders", orders);

        String error = request.getParameter("error");
        String success = request.getParameter("success");
        if (error != null)   request.setAttribute("error", error);
        if (success != null) request.setAttribute("success", success);

        request.getRequestDispatcher("/customer/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("updateProfile".equals(action)) {
            String name  = request.getParameter("name");
            String phone = request.getParameter("phone");

            if (name != null && !name.trim().isEmpty()) user.setName(name.trim());
            if (phone != null) user.setPhone(phone.trim());

            boolean updated = userDAO.updateUser(user);
            if (updated) {
                session.setAttribute("user", user);
                response.sendRedirect("profile?success=Profile+updated+successfully!");
            } else {
                response.sendRedirect("profile?error=Failed+to+update+profile.");
            }

        } else if ("changePassword".equals(action)) {
            String currentPwd = request.getParameter("currentPassword");
            String newPwd     = request.getParameter("newPassword");
            String confirmPwd = request.getParameter("confirmPassword");

            if (!user.getPassword().equals(currentPwd)) {
                response.sendRedirect("profile?error=Current+password+is+incorrect.");
                return;
            }
            if (newPwd == null || newPwd.length() < 6) {
                response.sendRedirect("profile?error=New+password+must+be+at+least+6+characters.");
                return;
            }
            if (!newPwd.equals(confirmPwd)) {
                response.sendRedirect("profile?error=Passwords+do+not+match.");
                return;
            }

            user.setPassword(newPwd);
            boolean updated = userDAO.updateUser(user);
            if (updated) {
                session.setAttribute("user", user);
                response.sendRedirect("profile?success=Password+changed+successfully!");
            } else {
                response.sendRedirect("profile?error=Failed+to+change+password.");
            }
        }
    }
}
