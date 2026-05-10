<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.sql.*"%>
<%@ page import="com.ai.restaurant.util.DBConnection"%>
<%@ page import="com.ai.restaurant.service.OrderService"%>
<%@ page import="com.ai.restaurant.model.Order"%>

<%
    /* ── Load all active orders with their food items via SQL JOIN ── */
    /* Structure: Map<orderId, {status, table, List<"Qty x ItemName">}> */

    LinkedHashMap<Integer, String[]> orderMeta  = new LinkedHashMap<>();  // orderId → [status, tableNo]
    LinkedHashMap<Integer, List<String>> orderItems = new LinkedHashMap<>();

    try (Connection conn = DBConnection.getConnection()) {
        String sql = "SELECT o.id AS oid, o.status, o.table_number, " +
                     "mi.name AS item_name, oi.quantity " +
                     "FROM orders o " +
                     "JOIN order_items oi ON o.id = oi.order_id " +
                     "JOIN menu_items mi  ON oi.menu_item_id = mi.id " +
                     "WHERE o.status != 'served' " +
                     "ORDER BY o.id ASC, mi.name ASC";

        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            int oid = rs.getInt("oid");
            String status = rs.getString("status");
            String tableNo = rs.getString("table_number");
            String itemName = rs.getString("item_name");
            int qty = rs.getInt("quantity");

            orderMeta.putIfAbsent(oid, new String[]{status, tableNo});
            orderItems.computeIfAbsent(oid, k -> new ArrayList<>())
                      .add(qty + " x " + itemName);
        }
    } catch (Exception e) {
        out.println("<p style='color:red'>DB Error: " + e.getMessage() + "</p>");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="refresh" content="10">
<title>Kitchen Dashboard — PlateUp</title>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&display=swap" rel="stylesheet">
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }

  body {
    font-family: 'Outfit', Arial, sans-serif;
    background: #0b0b0f;
    color: #f1f1f1;
    min-height: 100vh;
    padding: 24px 20px 48px;
  }

  /* ── HEADER ── */
  .header {
    text-align: center;
    margin-bottom: 32px;
    padding-bottom: 20px;
    border-bottom: 1px solid rgba(212,175,55,0.25);
  }
  .header h1 {
    font-size: 30px;
    font-weight: 800;
    color: #d4af37;
    letter-spacing: 1px;
  }
  .header p {
    font-size: 13px;
    color: #666;
    margin-top: 5px;
  }
  .live-dot {
    display: inline-block;
    width: 8px; height: 8px;
    background: #10b981;
    border-radius: 50%;
    margin-right: 6px;
    animation: blink 1.2s infinite;
    vertical-align: middle;
  }
  @keyframes blink { 0%,100%{opacity:1} 50%{opacity:0.3} }

  /* ── GRID ── */
  .grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 20px;
    max-width: 1100px;
    margin: 0 auto;
  }

  /* ── ORDER CARD ── */
  .card {
    background: #15151f;
    border-radius: 14px;
    border: 1px solid rgba(255,255,255,0.07);
    overflow: hidden;
  }

  .card-top {
    padding: 16px 18px 12px;
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    border-bottom: 1px solid rgba(255,255,255,0.06);
  }

  .order-id {
    font-size: 22px;
    font-weight: 800;
    color: #d4af37;
  }
  .order-table {
    font-size: 12px;
    color: #666;
    margin-top: 2px;
  }

  /* Status badge */
  .badge {
    padding: 5px 14px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.5px;
  }
  .badge-pending   { background: rgba(251,146,60,0.15); color: #fb923c; border: 1px solid rgba(251,146,60,0.3); }
  .badge-preparing { background: rgba(59,130,246,0.15); color: #60a5fa; border: 1px solid rgba(59,130,246,0.3); }
  .badge-ready     { background: rgba(16,185,129,0.15); color: #34d399; border: 1px solid rgba(16,185,129,0.3); }

  /* ── ITEMS LIST ── */
  .items {
    padding: 14px 18px;
    border-bottom: 1px solid rgba(255,255,255,0.06);
  }
  .items-label {
    font-size: 11px;
    color: #555;
    text-transform: uppercase;
    letter-spacing: 1px;
    margin-bottom: 8px;
  }
  .item-row {
    font-size: 14px;
    color: #ddd;
    padding: 5px 0;
    border-bottom: 1px solid rgba(255,255,255,0.04);
    display: flex;
    align-items: center;
    gap: 8px;
  }
  .item-row:last-child { border-bottom: none; }
  .item-dot {
    width: 6px; height: 6px;
    background: #d4af37;
    border-radius: 50%;
    flex-shrink: 0;
  }

  /* ── ACTION BUTTONS ── */
  .actions {
    padding: 14px 18px;
    display: flex;
    gap: 8px;
  }
  .btn {
    flex: 1;
    padding: 9px 6px;
    border: none;
    border-radius: 8px;
    font-family: 'Outfit', sans-serif;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
    transition: opacity 0.15s;
  }
  .btn:hover { opacity: 0.85; }
  .btn-prep  { background: #2563eb; color: #fff; }
  .btn-ready { background: #059669; color: #fff; }
  .btn-serve { background: #dc2626; color: #fff; }

  /* ── EMPTY ── */
  .empty {
    grid-column: 1/-1;
    text-align: center;
    padding: 80px 20px;
    color: #444;
  }
  .empty .emoji { font-size: 60px; margin-bottom: 16px; }
  .empty p { font-size: 18px; }
</style>
</head>
<body>

<div class="header">
  <h1>🍳 Kitchen Dashboard</h1>
  <p><span class="live-dot"></span>Live order queue — auto-refreshes every 10 seconds</p>
</div>

<div class="grid">

<% if (orderMeta.isEmpty()) { %>
  <div class="empty">
    <div class="emoji">✅</div>
    <p>No active orders right now</p>
  </div>
<% } else {
   for (Map.Entry<Integer, String[]> entry : orderMeta.entrySet()) {
       int oid = entry.getKey();
       String status  = entry.getValue()[0];
       String tableNo = entry.getValue()[1];
       List<String> items = orderItems.get(oid);
       String badgeClass = "badge-" + status;
%>

  <div class="card">
    <div class="card-top">
      <div>
        <div class="order-id">Order #<%= oid %></div>
        <div class="order-table">Table <%= tableNo %></div>
      </div>
      <div class="badge <%= badgeClass %>"><%= status %></div>
    </div>

    <div class="items">
      <div class="items-label">Items Ordered</div>
      <% for (String item : items) { %>
        <div class="item-row"><div class="item-dot"></div><%= item %></div>
      <% } %>
    </div>

    <div class="actions">
      <form action="<%= request.getContextPath() %>/staff" method="post" style="display:contents">
        <input type="hidden" name="orderId" value="<%= oid %>">
        <button type="submit" name="status" value="preparing" class="btn btn-prep">🔥 Preparing</button>
        <button type="submit" name="status" value="ready"     class="btn btn-ready">✅ Ready</button>
        <button type="submit" name="status" value="served"    class="btn btn-serve">🍽️ Served</button>
      </form>
    </div>
  </div>

<% } } %>

</div>
</body>
</html>