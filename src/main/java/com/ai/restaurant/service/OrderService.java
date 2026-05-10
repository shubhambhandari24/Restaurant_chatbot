package com.ai.restaurant.service;

import com.ai.restaurant.dao.MenuDAO;
import com.ai.restaurant.dao.MenuDAOImpl;
import com.ai.restaurant.dao.OrderDAO;
import com.ai.restaurant.dao.OrderDAOImpl;
import com.ai.restaurant.dao.OrderItemDAO;
import com.ai.restaurant.dao.OrderItemDAOImpl;
import com.ai.restaurant.model.MenuItem;
import com.ai.restaurant.model.Order;
import com.ai.restaurant.model.OrderItem;

import java.util.List;

public class OrderService {

    private OrderDAO orderDAO = new OrderDAOImpl();
    private OrderItemDAO orderItemDAO = new OrderItemDAOImpl();

    public int placeOrder(Order order, List<OrderItem> items) {

        double subtotal = 0.0;

        for (OrderItem item : items) {
            subtotal += item.getQuantity() * item.getPriceAtOrder();
        }

        double gst = subtotal * 0.18;

        order.setTotalPrice(subtotal + gst);
        order.setGstAmount(gst);
        order.setStatus("pending");

        int orderId = orderDAO.createOrder(order);

        if (orderId == -1) {
            return -1;
        }

        for (OrderItem item : items) {
            item.setOrderId(orderId);
        }

        boolean itemsInserted = orderItemDAO.addMultipleItems(items);

        if (!itemsInserted) {
            return -1;
        }

        return orderId;
    }

    public String addItemToOrder(int userId, String itemName, int quantity) {

        MenuDAO menuDAO = new MenuDAOImpl();
        List<MenuItem> menuItems = menuDAO.getAllMenuItems();

        MenuItem found = null;

        for (MenuItem m : menuItems) {
            String dbName = m.getName().toLowerCase();
            String userItem = itemName.toLowerCase();

            if (dbName.contains(userItem) || userItem.contains(dbName)) {
                found = m;
                break;
            }
        }

        if (found == null) {
            return "Item not found: " + itemName;
        }

        Order order = orderDAO.getPendingOrderByUserId(userId);
        int orderId;

        if (order == null) {
            order = new Order();
            order.setUserId(userId);
            order.setTableNumber(1);
            order.setStatus("pending");
            order.setTotalPrice(0);
            order.setGstAmount(0);
            order.setSpecialNotes("Placed via chatbot");

            orderId = orderDAO.createOrder(order);

            if (orderId == -1) {
                return "Failed to create order.";
            }
        } else {
            orderId = order.getId();
        }

        OrderItem orderItem = new OrderItem();
        orderItem.setOrderId(orderId);
        orderItem.setMenuItemId(found.getId());
        orderItem.setQuantity(quantity);
        orderItem.setPriceAtOrder(found.getPrice());

        boolean added = orderItemDAO.addOrderItem(orderItem);

        if (!added) {
            return "Failed to add item.";
        }

        double subtotal = orderItemDAO.calculateTotalByOrderId(orderId);
        double gst = subtotal * 0.18;
        double finalTotal = subtotal + gst;

        orderDAO.updateOrderAmount(orderId, finalTotal, gst);

        return quantity + " x " + found.getName()
                + " added to your order. Order ID: " + orderId;
    }

    public Order getOrder(int orderId) {
        return orderDAO.getOrderById(orderId);
    }

    public List<OrderItem> getOrderItems(int orderId) {
        return orderItemDAO.getItemsByOrderId(orderId);
    }

    public List<Order> getUserOrders(int userId) {
        return orderDAO.getOrdersByUserId(userId);
    }

    
    
    
    
    
    
    
    
    
    public boolean updateOrderStatus(int orderId, String status) {

        if (!(status.equals("pending") || status.equals("preparing")
                || status.equals("ready") || status.equals("served"))) {
            return false;
        }

        return orderDAO.updateOrderStatus(orderId, status);
    }

    public List<Order> getActiveOrders() {
        return orderDAO.getActiveOrders();
    }

    public double calculateTotal(int orderId) {
        return orderItemDAO.calculateTotalByOrderId(orderId);
    }
}