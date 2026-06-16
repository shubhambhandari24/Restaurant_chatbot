package com.ai.restaurant.service;

import org.json.JSONObject;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;

/**
 * N8nNotificationService — fires n8n webhooks for automation triggers.
 *
 * Currently used for:
 *  - Order confirmation notifications (Webhook → Email)
 *
 * Local Docker: http://n8n:5678/webhook/plateup-order  (set via N8N_WEBHOOK_URL env var)
 * Dashboard:    http://localhost:5678
 */
public class N8nNotificationService {

    // Read from env var — set in docker-compose.yml or Render environment
    private static final String ORDER_WEBHOOK;
    private static final int    TIMEOUT_MS = 5000;

    static {
        String envUrl = System.getenv("N8N_WEBHOOK_URL");
        ORDER_WEBHOOK = (envUrl != null && !envUrl.isBlank())
                        ? envUrl
                        : "http://localhost:5678/webhook/plateup-order"; // local fallback
    }

    /**
     * Sends order details to n8n which then sends a confirmation email.
     *
     * @param orderId       the new order ID
     * @param customerName  customer's display name
     * @param customerEmail customer's email address
     * @param items         comma-separated list of ordered items
     * @param total         total order amount in ₹
     */
    public void sendOrderNotification(int orderId, String customerName,
                                      String customerEmail, String items,
                                      double total) {
        try {
            JSONObject payload = new JSONObject();
            payload.put("orderId",       orderId);
            payload.put("customerName",  customerName);
            payload.put("customerEmail", customerEmail);
            payload.put("items",         items);
            payload.put("total",         (int) total);

            sendWebhook(ORDER_WEBHOOK, payload);
            System.out.println("[N8n] Order notification sent for Order #" + orderId);

        } catch (Exception e) {
            // Non-critical — log but don't crash the app
            System.err.println("[N8n] Notification failed (is n8n running?): " + e.getMessage());
        }
    }

    // ─── Private helper ─────────────────────────────────────────────────────

    private void sendWebhook(String webhookUrl, JSONObject payload) throws Exception {
        URL url = URI.create(webhookUrl).toURL();
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json; charset=utf-8");
        conn.setDoOutput(true);
        conn.setConnectTimeout(TIMEOUT_MS);
        conn.setReadTimeout(TIMEOUT_MS);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(payload.toString().getBytes("utf-8"));
        }

        int statusCode = conn.getResponseCode();
        if (statusCode < 200 || statusCode >= 300) {
            throw new RuntimeException("n8n webhook returned HTTP " + statusCode);
        }
    }
}
