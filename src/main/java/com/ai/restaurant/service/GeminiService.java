package com.ai.restaurant.service;

import com.ai.restaurant.model.MenuItem;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.util.List;
import java.util.Properties;

/**
 * GeminiService — calls Google Gemini 1.5 Flash API (FREE tier)
 * to generate intelligent, context-aware restaurant chatbot responses.
 *
 * Free limit: 1,500 requests/day
 * API Key configured via: src/main/resources/gemini.properties
 */
public class GeminiService {

    // 🔐 Loaded securely from src/main/resources/gemini.properties (gitignored)
    private static final String API_KEY;
    private static final String MODEL;
    private static final String API_URL;

    static {
        Properties props = new Properties();
        try (InputStream is = GeminiService.class
                .getClassLoader()
                .getResourceAsStream("gemini.properties")) {
            if (is == null) {
                throw new RuntimeException("[GeminiService] gemini.properties not found in classpath!");
            }
            props.load(is);
        } catch (IOException e) {
            throw new RuntimeException("[GeminiService] Failed to load gemini.properties", e);
        }
        API_KEY = props.getProperty("gemini.api.key");
        MODEL   = props.getProperty("gemini.model", "gemini-2.0-flash");
        API_URL = "https://generativelanguage.googleapis.com/v1beta/models/"
                  + MODEL + ":generateContent?key=" + API_KEY;
    }

    private static final int CONNECT_TIMEOUT_MS = 8000;
    private static final int READ_TIMEOUT_MS = 15000;

    /**
     * Ask Gemini AI for a smart response to the customer's message.
     *
     * @param userMessage what the customer typed
     * @param menuItems   current menu (for context)
     * @return AI-generated response, or null if API call fails (caller will use
     *         fallback)
     */
    public String getAIResponse(String userMessage, List<MenuItem> menuItems) {
        try {
            String menuContext = buildMenuContext(menuItems);
            String prompt = buildPrompt(userMessage, menuContext);
            return callGeminiAPI(prompt);
        } catch (Exception e) {
            System.err.println("[GeminiService] API error: " + e.getMessage());
            return null; // ChatService will use its fallback message
        }
    }

    // ─── Private helpers ────────────────────────────────────────────────────

    private String buildMenuContext(List<MenuItem> items) {
        if (items == null || items.isEmpty()) {
            return "Menu is currently unavailable.";
        }

        StringBuilder sb = new StringBuilder("MENU:\n");
        for (MenuItem item : items) {
            sb.append("  • ")
                    .append(item.getName())
                    .append(" — ₹").append((int) item.getPrice())
                    .append(" | ").append(item.getCategory())
                    .append(" | ").append(item.isVegetarian() ? "Veg" : "Non-Veg")
                    .append(" | Spicy Level: ").append(item.getSpicyLevel()).append("/5")
                    .append("\n");
        }
        return sb.toString();
    }

    private String buildPrompt(String userMessage, String menuContext) {
        return "You are PlateUp 🍽️, a friendly AI assistant for PlateUp Restaurant.\n\n"
                + "YOUR RULES:\n"
                + "1. Keep answers SHORT — max 3 sentences.\n"
                + "2. Be warm, helpful, and use a food emoji occasionally.\n"
                + "3. Only recommend items from the MENU below.\n"
                + "4. If customer wants to ORDER, remind them: type  add [qty] [item name]\n"
                + "5. If customer asks for order STATUS, remind them: type  status\n"
                + "6. If question is unrelated to food/restaurant, politely redirect.\n"
                + "7. Never make up prices or items not in the menu.\n\n"
                + menuContext + "\n"
                + "Customer message: \"" + userMessage + "\"\n"
                + "PlateUp reply:";
    }

    private String callGeminiAPI(String prompt) throws IOException {
        URL url = URI.create(API_URL).toURL();
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json; charset=utf-8");
        conn.setDoOutput(true);
        conn.setConnectTimeout(CONNECT_TIMEOUT_MS);
        conn.setReadTimeout(READ_TIMEOUT_MS);

        // Build JSON body
        JSONObject part = new JSONObject();
        part.put("text", prompt);

        JSONArray parts = new JSONArray();
        parts.put(part);

        JSONObject content = new JSONObject();
        content.put("parts", parts);

        JSONArray contents = new JSONArray();
        contents.put(content);

        // Safety / generation config (keep responses concise)
        JSONObject generationConfig = new JSONObject();
        generationConfig.put("maxOutputTokens", 150);
        generationConfig.put("temperature", 0.7);

        JSONObject body = new JSONObject();
        body.put("contents", contents);
        body.put("generationConfig", generationConfig);

        // Send request
        try (OutputStream os = conn.getOutputStream()) {
            os.write(body.toString().getBytes("utf-8"));
        }

        int statusCode = conn.getResponseCode();

        if (statusCode != 200) {
            InputStream errStream = conn.getErrorStream();
            if (errStream != null) {
                try (BufferedReader br = new BufferedReader(new InputStreamReader(errStream))) {
                    StringBuilder err = new StringBuilder();
                    String line;
                    while ((line = br.readLine()) != null)
                        err.append(line);
                    System.err.println("[GeminiService] HTTP " + statusCode + " — " + err);
                }
            }
            return null;
        }

        // Read response
        StringBuilder responseStr = new StringBuilder();
        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), "utf-8"))) {
            String line;
            while ((line = br.readLine()) != null)
                responseStr.append(line);
        }

        // Parse: candidates[0].content.parts[0].text
        JSONObject json = new JSONObject(responseStr.toString());
        return json.getJSONArray("candidates")
                .getJSONObject(0)
                .getJSONObject("content")
                .getJSONArray("parts")
                .getJSONObject(0)
                .getString("text")
                .trim();
    }
}
