package com.ai.restaurant.model;

import java.sql.Timestamp;

public class Order {

    private int id;
    private Integer userId; // can be null
    private int tableNumber;
    private String status;
    private double totalPrice;
    private double gstAmount;
    private String specialNotes;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Default Constructor
    public Order() {
    }

    // Full Constructor
    public Order(int id, Integer userId, int tableNumber, String status,
                 double totalPrice, double gstAmount, String specialNotes,
                 Timestamp createdAt, Timestamp updatedAt) {
        this.id = id;
        this.userId = userId;
        this.tableNumber = tableNumber;
        this.status = status;
        this.totalPrice = totalPrice;
        this.gstAmount = gstAmount;
        this.specialNotes = specialNotes;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Constructor (for creating new order)
    public Order(Integer userId, int tableNumber, String status,
                 double totalPrice, double gstAmount, String specialNotes) {
        this.userId = userId;
        this.tableNumber = tableNumber;
        this.status = status;
        this.totalPrice = totalPrice;
        this.gstAmount = gstAmount;
        this.specialNotes = specialNotes;
    }

    // Getters and Setters

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public int getTableNumber() {
        return tableNumber;
    }

    public void setTableNumber(int tableNumber) {
        this.tableNumber = tableNumber;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public double getGstAmount() {
        return gstAmount;
    }

    public void setGstAmount(double gstAmount) {
        this.gstAmount = gstAmount;
    }

    public String getSpecialNotes() {
        return specialNotes;
    }

    public void setSpecialNotes(String specialNotes) {
        this.specialNotes = specialNotes;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}