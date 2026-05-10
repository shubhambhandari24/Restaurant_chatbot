package com.ai.restaurant.dao;

import com.ai.restaurant.model.Order;
import com.ai.restaurant.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAOImpl implements OrderDAO {

    @Override
    public int createOrder(Order order) {
        String query = "INSERT INTO orders (user_id, table_number, status, total_price, gst_amount, special_notes) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            if (order.getUserId() != null) {
                ps.setInt(1, order.getUserId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }

            ps.setInt(2, order.getTableNumber());
            ps.setString(3, order.getStatus());
            ps.setDouble(4, order.getTotalPrice());
            ps.setDouble(5, order.getGstAmount());
            ps.setString(6, order.getSpecialNotes());

            int rows = ps.executeUpdate();

            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    @Override
    public Order getPendingOrderByUserId(int userId) {
        String query = "SELECT * FROM orders WHERE user_id=? AND status='pending' ORDER BY created_at DESC LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return extractOrder(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public Order getOrderById(int id) {
        String query = "SELECT * FROM orders WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return extractOrder(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        String query = "SELECT * FROM orders WHERE user_id=? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(extractOrder(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public boolean updateOrderStatus(int orderId, String status) {
        String query = "UPDATE orders SET status=?, updated_at=NOW() WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, status);
            ps.setInt(2, orderId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean updateOrderAmount(int orderId, double totalPrice, double gstAmount) {
        String query = "UPDATE orders SET total_price=?, gst_amount=?, updated_at=NOW() WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setDouble(1, totalPrice);
            ps.setDouble(2, gstAmount);
            ps.setInt(3, orderId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public List<Order> getActiveOrders() {
        List<Order> list = new ArrayList<>();
        String query = "SELECT * FROM orders WHERE status IN ('pending','preparing') ORDER BY created_at ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(extractOrder(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    private Order extractOrder(ResultSet rs) throws SQLException {
        Order order = new Order();

        order.setId(rs.getInt("id"));
        order.setUserId((Integer) rs.getObject("user_id"));
        order.setTableNumber(rs.getInt("table_number"));
        order.setStatus(rs.getString("status"));
        order.setTotalPrice(rs.getDouble("total_price"));
        order.setGstAmount(rs.getDouble("gst_amount"));
        order.setSpecialNotes(rs.getString("special_notes"));
        order.setCreatedAt(rs.getTimestamp("created_at"));
        order.setUpdatedAt(rs.getTimestamp("updated_at"));

        return order;
    }
}