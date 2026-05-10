package com.ai.restaurant.service;

import com.ai.restaurant.dao.MenuDAO;
import com.ai.restaurant.dao.MenuDAOImpl;
import com.ai.restaurant.model.MenuItem;

import java.util.ArrayList;
import java.util.List;

public class MenuService {

    private MenuDAO menuDAO = new MenuDAOImpl();

    // =========================
    // GET ALL AVAILABLE ITEMS
    // =========================
    public List<MenuItem> getAvailableMenu() {
        return menuDAO.getAvailableMenuItems();
    }

    // =========================
    // SIMPLE SEARCH
    // =========================
    public List<MenuItem> searchItems(String keyword) {
        if (keyword == null || keyword.isEmpty()) {
            return new ArrayList<>();
        }
        return menuDAO.searchByName(keyword);
    }

    // =========================
    // SMART FILTER (CHATBOT CORE)
    // =========================
    public List<MenuItem> filterMenu(Boolean veg, Boolean vegan, Boolean glutenFree,
                                     Integer spicyLevel, Double minPrice, Double maxPrice,
                                     String category) {

        List<MenuItem> items = menuDAO.getAvailableMenuItems();

        List<MenuItem> filtered = new ArrayList<>();

        for (MenuItem item : items) {

            if (veg != null && veg && !item.isVegetarian()) continue;
            if (vegan != null && vegan && !item.isVegan()) continue;
            if (glutenFree != null && glutenFree && !item.isGlutenFree()) continue;
            if (spicyLevel != null && item.getSpicyLevel() < spicyLevel) continue;
            if (minPrice != null && item.getPrice() < minPrice) continue;
            if (maxPrice != null && item.getPrice() > maxPrice) continue;
            if (category != null && !category.equalsIgnoreCase(item.getCategory())) continue;

            filtered.add(item);
        }

        return filtered;
    }

    // =========================
    // GET BY ID
    // =========================
    public MenuItem getItemById(int id) {
        return menuDAO.getMenuItemById(id);
    }
}