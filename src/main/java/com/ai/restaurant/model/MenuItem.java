package com.ai.restaurant.model;

import java.sql.Timestamp;

public class MenuItem {

    private int id;
    private String name;
    private String description;
    private double price;
    private String category;
    private boolean vegetarian;
    private boolean vegan;
    private boolean glutenFree;
    private int spicyLevel;
    private boolean available;
    private Timestamp createdAt;

    // Default Constructor
    public MenuItem() {
    }

    // Full Constructor
    public MenuItem(int id, String name, String description, double price, String category,
                    boolean vegetarian, boolean vegan, boolean glutenFree,
                    int spicyLevel, boolean available, Timestamp createdAt) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.price = price;
        this.category = category;
        this.vegetarian = vegetarian;
        this.vegan = vegan;
        this.glutenFree = glutenFree;
        this.spicyLevel = spicyLevel;
        this.available = available;
        this.createdAt = createdAt;
    }

    // Constructor (without id & timestamp)
    public MenuItem(String name, String description, double price, String category,
                    boolean vegetarian, boolean vegan, boolean glutenFree,
                    int spicyLevel, boolean available) {
        this.name = name;
        this.description = description;
        this.price = price;
        this.category = category;
        this.vegetarian = vegetarian;
        this.vegan = vegan;
        this.glutenFree = glutenFree;
        this.spicyLevel = spicyLevel;
        this.available = available;
    }

    // Getters and Setters

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public boolean isVegetarian() {
        return vegetarian;
    }

    public void setVegetarian(boolean vegetarian) {
        this.vegetarian = vegetarian;
    }

    public boolean isVegan() {
        return vegan;
    }

    public void setVegan(boolean vegan) {
        this.vegan = vegan;
    }

    public boolean isGlutenFree() {
        return glutenFree;
    }

    public void setGlutenFree(boolean glutenFree) {
        this.glutenFree = glutenFree;
    }

    public int getSpicyLevel() {
        return spicyLevel;
    }

    public void setSpicyLevel(int spicyLevel) {
        this.spicyLevel = spicyLevel;
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}