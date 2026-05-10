package com.ai.restaurant.dao;

import com.ai.restaurant.model.OrderItem;
import com.ai.restaurant.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderItemDAOImpl implements OrderItemDAO {

    // =========================
    // ADD SINGLE ITEM
    // =========================
    @Override
    public boolean addOrderItem(OrderItem item) {
        String query = "INSERT INTO order_items (order_id, menu_item_id, quantity, price_at_order) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, item.getOrderId());
            ps.setInt(2, item.getMenuItemId());
            ps.setInt(3, item.getQuantity());
            ps.setDouble(4, item.getPriceAtOrder());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // =========================
    // ADD MULTIPLE ITEMS
    // =========================
    @Override
    public boolean addMultipleItems(List<OrderItem> items) {
        String query = "INSERT INTO order_items (order_id, menu_item_id, quantity, price_at_order) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            for (OrderItem item : items) {
                ps.setInt(1, item.getOrderId());
                ps.setInt(2, item.getMenuItemId());
                ps.setInt(3, item.getQuantity());
                ps.setDouble(4, item.getPriceAtOrder());
                ps.addBatch();
            }

            int[] result = ps.executeBatch();

            for (int r : result) {
                if (r == Statement.EXECUTE_FAILED) {
                    return false;
                }
            }

            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // =========================
    // GET ITEMS BY ORDER ID
    // =========================
    @Override
    public List<OrderItem> getItemsByOrderId(int orderId) {
        List<OrderItem> list = new ArrayList<>();
        String query = "SELECT * FROM order_items WHERE order_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(extractOrderItem(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // =========================
    // UPDATE ITEM
    // =========================
    @Override
    public boolean updateOrderItem(OrderItem item) {
        String query = "UPDATE order_items SET quantity=? WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, item.getQuantity());
            ps.setInt(2, item.getId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // =========================
    // DELETE SINGLE ITEM
    // =========================
    @Override
    public boolean deleteOrderItem(int id) {
        String query = "DELETE FROM order_items WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // =========================
    // DELETE ALL ITEMS OF ORDER
    // =========================
    @Override
    public boolean deleteItemsByOrderId(int orderId) {
        String query = "DELETE FROM order_items WHERE order_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // =========================
    // CALCULATE TOTAL
    // =========================
    @Override
    public double calculateTotalByOrderId(int orderId) {
        String query = "SELECT SUM(quantity * price_at_order) AS total FROM order_items WHERE order_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getDouble("total");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    // =========================
    // RESULTSET MAPPER
    // =========================
    private OrderItem extractOrderItem(ResultSet rs) throws SQLException {
        OrderItem item = new OrderItem();

        item.setId(rs.getInt("id"));
        item.setOrderId(rs.getInt("order_id"));
        item.setMenuItemId(rs.getInt("menu_item_id"));
        item.setQuantity(rs.getInt("quantity"));
        item.setPriceAtOrder(rs.getDouble("price_at_order"));

        return item;
    }
}