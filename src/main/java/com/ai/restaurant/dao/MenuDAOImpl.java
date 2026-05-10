package com.ai.restaurant.dao;

import com.ai.restaurant.model.MenuItem;
import com.ai.restaurant.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MenuDAOImpl implements MenuDAO {

    // =========================
    // ADD MENU ITEM
    // =========================
    @Override
    public boolean addMenuItem(MenuItem item) {
        String query = "INSERT INTO menu_items (name, description, price, category, vegetarian, vegan, gluten_free, spicy_level, available) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, item.getName());
            ps.setString(2, item.getDescription());
            ps.setDouble(3, item.getPrice());
            ps.setString(4, item.getCategory());
            ps.setBoolean(5, item.isVegetarian());
            ps.setBoolean(6, item.isVegan());
            ps.setBoolean(7, item.isGlutenFree());
            ps.setInt(8, item.getSpicyLevel());
            ps.setBoolean(9, item.isAvailable());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // =========================
    // GET MENU ITEM BY ID
    // =========================
    @Override
    public MenuItem getMenuItemById(int id) {
        String query = "SELECT * FROM menu_items WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return extractMenuItem(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // =========================
    // GET ALL MENU ITEMS
    // =========================
    @Override
    public List<MenuItem> getAllMenuItems() {
        List<MenuItem> list = new ArrayList<>();
        String query = "SELECT * FROM menu_items";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(extractMenuItem(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // =========================
    // GET AVAILABLE ITEMS
    // =========================
    @Override
    public List<MenuItem> getAvailableMenuItems() {
        List<MenuItem> list = new ArrayList<>();
        String query = "SELECT * FROM menu_items WHERE available = true";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(extractMenuItem(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // =========================
    // FILTERING METHODS
    // =========================
    @Override
    public List<MenuItem> getByCategory(String category) {
        return getByCondition("category = ?", ps -> ps.setString(1, category));
    }

    @Override
    public List<MenuItem> getVegetarianItems() {
        return getByCondition("vegetarian = true", null);
    }

    @Override
    public List<MenuItem> getVeganItems() {
        return getByCondition("vegan = true", null);
    }

    @Override
    public List<MenuItem> getGlutenFreeItems() {
        return getByCondition("gluten_free = true", null);
    }

    @Override
    public List<MenuItem> getBySpicyLevel(int level) {
        return getByCondition("spicy_level = ?", ps -> ps.setInt(1, level));
    }

    @Override
    public List<MenuItem> getByPriceRange(double min, double max) {
        return getByCondition("price BETWEEN ? AND ?", ps -> {
            ps.setDouble(1, min);
            ps.setDouble(2, max);
        });
    }

    // =========================
    // SEARCH
    // =========================
    @Override
    public List<MenuItem> searchByName(String keyword) {
        return getByCondition("name LIKE ?", ps -> ps.setString(1, "%" + keyword + "%"));
    }

    // =========================
    // UPDATE
    // =========================
    @Override
    public boolean updateMenuItem(MenuItem item) {
        String query = "UPDATE menu_items SET name=?, description=?, price=?, category=?, vegetarian=?, vegan=?, gluten_free=?, spicy_level=?, available=? WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, item.getName());
            ps.setString(2, item.getDescription());
            ps.setDouble(3, item.getPrice());
            ps.setString(4, item.getCategory());
            ps.setBoolean(5, item.isVegetarian());
            ps.setBoolean(6, item.isVegan());
            ps.setBoolean(7, item.isGlutenFree());
            ps.setInt(8, item.getSpicyLevel());
            ps.setBoolean(9, item.isAvailable());
            ps.setInt(10, item.getId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // =========================
    // DELETE
    // =========================
    @Override
    public boolean deleteMenuItem(int id) {
        String query = "DELETE FROM menu_items WHERE id=?";

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
    // GENERIC FILTER HELPER
    // =========================
    private List<MenuItem> getByCondition(String condition, ParameterSetter setter) {
        List<MenuItem> list = new ArrayList<>();
        String query = "SELECT * FROM menu_items WHERE " + condition;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            if (setter != null) {
                setter.setParameters(ps);
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(extractMenuItem(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // =========================
    // HELPER INTERFACE
    // =========================
    private interface ParameterSetter {
        void setParameters(PreparedStatement ps) throws SQLException;
    }

    // =========================
    // RESULTSET MAPPER
    // =========================
    private MenuItem extractMenuItem(ResultSet rs) throws SQLException {
        MenuItem item = new MenuItem();

        item.setId(rs.getInt("id"));
        item.setName(rs.getString("name"));
        item.setDescription(rs.getString("description"));
        item.setPrice(rs.getDouble("price"));
        item.setCategory(rs.getString("category"));
        item.setVegetarian(rs.getBoolean("vegetarian"));
        item.setVegan(rs.getBoolean("vegan"));
        item.setGlutenFree(rs.getBoolean("gluten_free"));
        item.setSpicyLevel(rs.getInt("spicy_level"));
        item.setAvailable(rs.getBoolean("available"));
        item.setCreatedAt(rs.getTimestamp("created_at"));

        return item;
    }
}