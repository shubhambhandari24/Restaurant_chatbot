package com.ai.restaurant.dao;

import com.ai.restaurant.model.OrderItem;
import java.util.List;

public interface OrderItemDAO {

    // Create
    boolean addOrderItem(OrderItem item);
    boolean addMultipleItems(List<OrderItem> items);

    // Read
    List<OrderItem> getItemsByOrderId(int orderId);

    // Update
    boolean updateOrderItem(OrderItem item);

    // Delete
    boolean deleteOrderItem(int id);
    boolean deleteItemsByOrderId(int orderId);

    // Utility
    double calculateTotalByOrderId(int orderId);
}