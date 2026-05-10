package com.ai.restaurant.dao;

import com.ai.restaurant.model.ChatMessage;
import java.util.List;

public interface ChatDAO {

    // Create
    boolean saveMessage(ChatMessage message);

    // Read
    List<ChatMessage> getMessagesByUserId(int userId);
    List<ChatMessage> getMessagesByOrderId(int orderId);

    // Recent chat (IMPORTANT for LLM context)
    List<ChatMessage> getRecentMessages(int userId, int limit);

    // Delete
    boolean deleteMessagesByUserId(int userId);
    boolean deleteMessagesByOrderId(int orderId);

    // Utility
    String getLastUserMessage(int userId);
    String getLastBotResponse(int userId);
}