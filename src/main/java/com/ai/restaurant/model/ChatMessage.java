package com.ai.restaurant.model;

import java.sql.Timestamp;

public class ChatMessage {

    private int id;
    private int userId;
    private Integer orderId; // can be null
    private String messageType; // user / assistant
    private String content;
    private String sentiment;
    private Timestamp createdAt;

    // Default Constructor
    public ChatMessage() {
    }

    // Full Constructor
    public ChatMessage(int id, int userId, Integer orderId,
                       String messageType, String content,
                       String sentiment, Timestamp createdAt) {
        this.id = id;
        this.userId = userId;
        this.orderId = orderId;
        this.messageType = messageType;
        this.content = content;
        this.sentiment = sentiment;
        this.createdAt = createdAt;
    }

    // Constructor (for new message)
    public ChatMessage(int userId, Integer orderId,
                       String messageType, String content,
                       String sentiment) {
        this.userId = userId;
        this.orderId = orderId;
        this.messageType = messageType;
        this.content = content;
        this.sentiment = sentiment;
    }

    // Getters and Setters

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public String getMessageType() {
        return messageType;
    }

    public void setMessageType(String messageType) {
        this.messageType = messageType;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getSentiment() {
        return sentiment;
    }

    public void setSentiment(String sentiment) {
        this.sentiment = sentiment;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}