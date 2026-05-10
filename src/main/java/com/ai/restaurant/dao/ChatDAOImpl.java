package com.ai.restaurant.dao;

import com.ai.restaurant.model.ChatMessage;
import com.ai.restaurant.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ChatDAOImpl implements ChatDAO {

    // =========================
    // SAVE MESSAGE
    // =========================
    @Override
    public boolean saveMessage(ChatMessage message) {
        String query = "INSERT INTO chat_history (user_id, order_id, message_type, content, sentiment) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, message.getUserId());

            if (message.getOrderId() != null) {
                ps.setInt(2, message.getOrderId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }

            ps.setString(3, message.getMessageType());
            ps.setString(4, message.getContent());
            ps.setString(5, message.getSentiment());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // =========================
    // GET BY USER
    // =========================
    @Override
    public List<ChatMessage> getMessagesByUserId(int userId) {
        List<ChatMessage> list = new ArrayList<>();
        String query = "SELECT * FROM chat_history WHERE user_id=? ORDER BY created_at ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(extractMessage(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // =========================
    // GET BY ORDER
    // =========================
    @Override
    public List<ChatMessage> getMessagesByOrderId(int orderId) {
        List<ChatMessage> list = new ArrayList<>();
        String query = "SELECT * FROM chat_history WHERE order_id=? ORDER BY created_at ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(extractMessage(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // =========================
    // GET RECENT MESSAGES (FOR LLM CONTEXT)
    // =========================
    @Override
    public List<ChatMessage> getRecentMessages(int userId, int limit) {
        List<ChatMessage> list = new ArrayList<>();
        String query = "SELECT * FROM chat_history WHERE user_id=? ORDER BY created_at DESC LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, userId);
            ps.setInt(2, limit);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(0, extractMessage(rs)); // reverse order (oldest first)
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // =========================
    // DELETE BY USER
    // =========================
    @Override
    public boolean deleteMessagesByUserId(int userId) {
        String query = "DELETE FROM chat_history WHERE user_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // =========================
    // DELETE BY ORDER
    // =========================
    @Override
    public boolean deleteMessagesByOrderId(int orderId) {
        String query = "DELETE FROM chat_history WHERE order_id=?";

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
    // GET LAST USER MESSAGE
    // =========================
    @Override
    public String getLastUserMessage(int userId) {
        String query = "SELECT content FROM chat_history WHERE user_id=? AND message_type='user' ORDER BY created_at DESC LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getString("content");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // =========================
    // GET LAST BOT RESPONSE
    // =========================
    @Override
    public String getLastBotResponse(int userId) {
        String query = "SELECT content FROM chat_history WHERE user_id=? AND message_type='assistant' ORDER BY created_at DESC LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getString("content");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // =========================
    // RESULTSET MAPPER
    // =========================
    private ChatMessage extractMessage(ResultSet rs) throws SQLException {
        ChatMessage msg = new ChatMessage();

        msg.setId(rs.getInt("id"));
        msg.setUserId(rs.getInt("user_id"));
        msg.setOrderId((Integer) rs.getObject("order_id"));
        msg.setMessageType(rs.getString("message_type"));
        msg.setContent(rs.getString("content"));
        msg.setSentiment(rs.getString("sentiment"));
        msg.setCreatedAt(rs.getTimestamp("created_at"));

        return msg;
    }
}