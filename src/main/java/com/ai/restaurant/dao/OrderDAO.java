package com.ai.restaurant.dao;

import com.ai.restaurant.model.Order;
import java.util.List;

public interface OrderDAO {

    int createOrder(Order order);

    Order getOrderById(int id);

    List<Order> getOrdersByUserId(int userId);

    boolean updateOrderStatus(int orderId, String status);

    List<Order> getActiveOrders();

    Order getPendingOrderByUserId(int userId);

    boolean updateOrderAmount(int orderId, double totalPrice, double gstAmount);
}