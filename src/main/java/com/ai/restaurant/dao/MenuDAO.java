package com.ai.restaurant.dao;

import com.ai.restaurant.model.MenuItem;
import java.util.List;

public interface MenuDAO {

    // Create
    boolean addMenuItem(MenuItem item);

    // Read
    MenuItem getMenuItemById(int id);
    List<MenuItem> getAllMenuItems();
    List<MenuItem> getAvailableMenuItems();

    // Filtering (VERY IMPORTANT for chatbot)
    List<MenuItem> getByCategory(String category);
    List<MenuItem> getVegetarianItems();
    List<MenuItem> getVeganItems();
    List<MenuItem> getGlutenFreeItems();
    List<MenuItem> getBySpicyLevel(int level);
    List<MenuItem> getByPriceRange(double minPrice, double maxPrice);

    // Search (for chatbot text matching)
    List<MenuItem> searchByName(String keyword);

    // Update
    boolean updateMenuItem(MenuItem item);

    // Delete
    boolean deleteMenuItem(int id);
}