<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.ai.restaurant.model.Order" %>
<%@ page import="com.ai.restaurant.model.OrderItem" %>
<%@ page import="com.ai.restaurant.service.OrderService" %>
<%@ page import="com.ai.restaurant.dao.MenuDAO" %>
<%@ page import="com.ai.restaurant.dao.MenuDAOImpl" %>
<%@ page import="com.ai.restaurant.model.MenuItem" %>
<%@ page import="com.ai.restaurant.model.User" %>

<%
User user = (User) session.getAttribute("user");
if (user == null) { response.sendRedirect("../login.jsp"); return; }

OrderService orderService = new OrderService();
MenuDAO menuDAO = new MenuDAOImpl();

List<Order> orders = orderService.getUserOrders(user.getId());

Order lastOrder = null;
List<OrderItem> items = null;

// ✅ Only show orders that are NOT yet served (active orders)
if (orders != null && !orders.isEmpty()) {
    for (Order o : orders) {
        if (!"served".equals(o.getStatus())) {
            lastOrder = o;
            break;
        }
    }
    if (lastOrder != null) {
        items = orderService.getOrderItems(lastOrder.getId());
    }
}

String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Order | Savor &amp; Sage</title>
  <link rel="stylesheet" href="../assets/css/theme.css">
  <script>(function(){var t=localStorage.getItem('ss_theme')||'dark';document.documentElement.setAttribute('data-theme',t);})();</script>
  <style>
    body { min-height:100vh; padding:40px 24px; background:var(--bg); font-family:'Outfit',sans-serif; transition:background var(--transition); }
    .wrapper { max-width:860px; margin:0 auto; }

    /* TOP BAR */
    .top-bar { display:flex; align-items:center; justify-content:space-between; margin-bottom:32px; flex-wrap:wrap; gap:14px; }
    .top-bar h1 { font-size:28px; font-weight:800; color:var(--text-primary); }
    .top-bar h1 span { color:var(--gold); }
    .top-actions { display:flex; gap:10px; }
    .btn-gold { background:var(--gold); color:#fff; padding:10px 20px; border-radius:10px; text-decoration:none; font-size:14px; font-weight:700; border:none; cursor:pointer; transition:all 0.3s; }
    .btn-gold:hover { background:var(--gold-dark); transform:translateY(-1px); }
    .btn-outline-sm { border:1px solid var(--border); color:var(--text-secondary); padding:10px 18px; border-radius:10px; text-decoration:none; font-size:14px; font-weight:600; background:var(--bg-card); transition:all 0.3s; }
    .btn-outline-sm:hover { border-color:var(--gold); color:var(--gold); }

    /* STATUS CARD */
    .status-card { background:var(--bg-card); border:1px solid var(--border); border-radius:18px; padding:20px 28px; margin-bottom:24px; display:flex; align-items:center; justify-content:space-between; flex-wrap:wrap; gap:14px; box-shadow:var(--shadow); transition:background var(--transition); }
    .status-info { display:flex; align-items:center; gap:14px; }
    .status-badge { padding:7px 16px; border-radius:20px; font-size:13px; font-weight:700; text-transform:capitalize; }
    .status-badge.pending   { background:rgba(251,191,36,0.15); color:#f59e0b; border:1px solid rgba(251,191,36,0.3); }
    .status-badge.preparing { background:rgba(59,130,246,0.15); color:#3b82f6; border:1px solid rgba(59,130,246,0.3); }
    .status-badge.ready     { background:rgba(34,197,94,0.15);  color:#22c55e; border:1px solid rgba(34,197,94,0.3); }
    .status-badge.served    { background:rgba(168,85,247,0.15); color:#a855f7; border:1px solid rgba(168,85,247,0.3); }
    .order-meta { font-size:13px; color:var(--text-muted); margin-top:4px; }

    /* PROGRESS TRACK */
    .progress-track { margin-bottom:28px; }
    .progress-steps { display:flex; align-items:center; gap:0; }
    .pstep { flex:1; text-align:center; position:relative; }
    .pstep-dot { width:28px; height:28px; border-radius:50%; border:2px solid var(--border); background:var(--bg-card); display:flex; align-items:center; justify-content:center; margin:0 auto 6px; font-size:13px; transition:all 0.3s; }
    .pstep-line { position:absolute; top:14px; left:50%; right:-50%; height:2px; background:var(--border); z-index:0; }
    .pstep:last-child .pstep-line { display:none; }
    .pstep.done .pstep-dot { background:var(--gold); border-color:var(--gold); color:#fff; box-shadow:0 0 12px var(--gold-glow); }
    .pstep.done .pstep-line { background:var(--gold); }
    .pstep-lbl { font-size:11px; color:var(--text-muted); font-weight:600; text-transform:uppercase; letter-spacing:0.06em; }

    /* ITEMS TABLE */
    .order-card { background:var(--bg-card); border:1px solid var(--border); border-radius:18px; overflow:hidden; box-shadow:var(--shadow); transition:background var(--transition); }
    .order-card-header { padding:18px 24px; border-bottom:1px solid var(--border-soft); display:flex; align-items:center; gap:10px; }
    .order-card-header h2 { font-size:16px; font-weight:700; color:var(--text-primary); }

    table { width:100%; border-collapse:collapse; }
    th { padding:14px 24px; text-align:left; font-size:12px; font-weight:700; text-transform:uppercase; letter-spacing:0.08em; color:var(--text-muted); background:var(--bg-2); }
    td { padding:16px 24px; border-bottom:1px solid var(--border-soft); font-size:14px; color:var(--text-primary); }
    tr:last-child td { border-bottom:none; }
    .item-name { font-weight:600; }
    .price-col { color:var(--gold); font-weight:700; }

    /* SUMMARY */
    .summary-box { padding:20px 24px; border-top:1px solid var(--border-soft); background:var(--bg-2); }
    .summary-row { display:flex; justify-content:space-between; align-items:center; margin-bottom:10px; font-size:14px; color:var(--text-secondary); }
    .summary-row.total { font-size:18px; font-weight:800; color:var(--text-primary); border-top:1px solid var(--border); padding-top:14px; margin-top:6px; }
    .summary-row.total span:last-child { color:var(--gold); }

    /* EMPTY STATE */
    .empty-state { text-align:center; padding:70px 40px; background:var(--bg-card); border:1px solid var(--border); border-radius:18px; }
    .empty-icon { font-size:56px; margin-bottom:16px; display:block; }
    .empty-state h2 { font-size:22px; font-weight:700; color:var(--text-primary); margin-bottom:8px; }
    .empty-state p { color:var(--text-muted); font-size:15px; margin-bottom:24px; }

    /* SUCCESS MSG */
    .success-msg { background:rgba(34,197,94,0.1); border:1px solid rgba(34,197,94,0.3); border-radius:10px; padding:14px 20px; font-size:14px; color:#22c55e; margin-bottom:20px; display:flex; align-items:center; gap:8px; }

    /* PAYMENT GATEWAY */
    .payment-gateway { background:var(--bg-card); border:1px solid var(--border); border-radius:20px; padding:28px; box-shadow:var(--shadow); }
    .pg-header { display:flex; align-items:center; gap:18px; margin-bottom:24px; }
    .pg-icon { font-size:48px; }
    .pg-header h2 { font-size:22px; font-weight:800; color:var(--text-primary); margin-bottom:4px; }
    .pg-header p { font-size:14px; color:var(--text-muted); }
    .bev-upsell { background:var(--bg-2); border:1px solid var(--border-soft); border-radius:14px; padding:20px; margin-bottom:24px; }
    .bev-upsell-title { font-size:15px; font-weight:700; color:var(--text-primary); margin-bottom:14px; }
    .bev-grid { display:flex; gap:12px; overflow-x:auto; padding-bottom:8px; }
    .bev-card { background:var(--bg-card); border:1px solid var(--border); border-radius:14px; padding:14px; text-align:center; min-width:120px; flex-shrink:0; transition:all 0.3s; }
    .bev-card:hover { border-color:var(--gold); transform:translateY(-3px); box-shadow:0 8px 24px rgba(212,175,55,.15); }
    .bev-card img { width:80px; height:80px; object-fit:cover; border-radius:10px; margin:0 auto 8px; display:block; }
    .bev-name { font-size:13px; font-weight:700; color:var(--text-primary); margin-bottom:4px; }
    .bev-price { font-size:13px; font-weight:700; color:var(--gold); margin-bottom:8px; }
    .bev-add-btn { background:var(--gold); color:#fff; border:none; border-radius:8px; padding:6px 14px; font-size:12px; font-weight:700; cursor:pointer; transition:all 0.2s; font-family:'Outfit',sans-serif; }
    .bev-add-btn:hover { background:var(--gold-dark); }
    .pg-amount { display:flex; justify-content:space-between; align-items:center; padding:18px 0; border-top:1px solid var(--border-soft); border-bottom:1px solid var(--border-soft); margin-bottom:20px; font-size:15px; color:var(--text-secondary); font-weight:600; }
    .pg-total { font-size:26px; font-weight:800; color:var(--gold); }
    .pg-methods { display:flex; flex-direction:column; gap:12px; }
    .pg-btn { display:flex; align-items:center; justify-content:center; gap:10px; padding:16px; border-radius:12px; font-size:15px; font-weight:700; text-decoration:none; transition:all 0.3s; border:2px solid transparent; }
    .pg-upi  { background:linear-gradient(135deg,#6366f1,#4f46e5); color:#fff; }
    .pg-upi:hover  { transform:translateY(-2px); box-shadow:0 8px 24px rgba(99,102,241,.4); }
    .pg-card { background:linear-gradient(135deg,#0ea5e9,#0284c7); color:#fff; }
    .pg-card:hover { transform:translateY(-2px); box-shadow:0 8px 24px rgba(14,165,233,.4); }
    .pg-cash { background:var(--bg-2); color:var(--text-primary); border-color:var(--border); }
    .pg-cash:hover { border-color:var(--gold); color:var(--gold); }
  </style>
</head>
<body>
  <button id="themeToggle" class="theme-toggle" aria-label="Toggle theme">
    <span class="icon sun">☀️</span><span class="track"><span class="thumb"></span></span><span class="icon moon">🌙</span>
  </button>

  <div class="wrapper">

    <div class="top-bar">
      <h1>My <span>Order</span></h1>
      <div class="top-actions">
        <a href="chat.jsp" class="btn-outline-sm">🤖 Chatbot</a>
        <a href="history.jsp" class="btn-outline-sm">📋 History</a>
      </div>
    </div>

    <% if (msg != null) { %>
    <div class="success-msg">✅ <%= msg %></div>
    <% } %>

    <% if (lastOrder == null || items == null || items.isEmpty()) { %>

    <div class="empty-state">
      <span class="empty-icon">🛒</span>
      <h2>No active order</h2>
      <p>Go to the chatbot and type <strong>"show menu"</strong> to browse dishes and add items to your order.</p>
      <a href="chat.jsp" class="btn-gold">🤖 Start Ordering</a>
    </div>

    <% } else {
       double subtotal = 0;
       for (OrderItem item : items) { subtotal += item.getQuantity() * item.getPriceAtOrder(); }
       double gst = lastOrder.getGstAmount();
       double total = lastOrder.getTotalPrice();
       String status = lastOrder.getStatus() != null ? lastOrder.getStatus() : "pending";

       // ✅ If order is already served — show completion screen, not old items
       if ("served".equals(status)) {
    %>
    <div class="payment-gateway">
      <div class="pg-header">
        <span class="pg-icon">🎉</span>
        <div>
          <h2>Order Ready — Time to Pay!</h2>
          <p>Order <strong>#<%= lastOrder.getId() %></strong> has been served. Choose your payment method below.</p>
        </div>
      </div>
      <!-- BEVERAGE UPSELL -->
      <div class="bev-upsell">
        <div class="bev-upsell-title">🥤 Add a Refreshing Drink?</div>
        <div class="bev-grid">
          <div class="bev-card">
            <img src="../assets/images/menu/mango_lassi.png" alt="Mango Lassi">
            <div class="bev-name">Mango Lassi</div><div class="bev-price">₹120</div>
            <button class="bev-add-btn" onclick="addBeverage('Mango Lassi',120,this)">+ Add</button>
          </div>
          <div class="bev-card">
            <img src="../assets/images/menu/cold_coffee.png" alt="Cold Coffee">
            <div class="bev-name">Cold Coffee</div><div class="bev-price">₹140</div>
            <button class="bev-add-btn" onclick="addBeverage('Cold Coffee',140,this)">+ Add</button>
          </div>
          <div class="bev-card">
            <img src="../assets/images/menu/masala_chai.png" alt="Masala Chai">
            <div class="bev-name">Masala Chai</div><div class="bev-price">₹60</div>
            <button class="bev-add-btn" onclick="addBeverage('Masala Chai',60,this)">+ Add</button>
          </div>
          <div class="bev-card">
            <img src="../assets/images/menu/fresh_lime_soda.png" alt="Lime Soda">
            <div class="bev-name">Lime Soda</div><div class="bev-price">₹80</div>
            <button class="bev-add-btn" onclick="addBeverage('Fresh Lime Soda',80,this)">+ Add</button>
          </div>
          <div class="bev-card">
            <img src="../assets/images/menu/watermelon_juice.png" alt="Watermelon Juice">
            <div class="bev-name">Watermelon</div><div class="bev-price">₹90</div>
            <button class="bev-add-btn" onclick="addBeverage('Watermelon Juice',90,this)">+ Add</button>
          </div>
        </div>
      </div>
      <!-- PAYMENT OPTIONS -->
      <div class="pg-amount">
        <span>Total Payable</span>
        <span class="pg-total">₹<%= String.format("%.2f", lastOrder.getTotalPrice()) %></span>
      </div>
      <div class="pg-methods">
        <a href="payment.jsp?orderId=<%= lastOrder.getId() %>" class="pg-btn pg-upi">📱 Pay via UPI / PhonePe / GPay</a>
        <a href="payment.jsp?orderId=<%= lastOrder.getId() %>" class="pg-btn pg-card">💳 Debit / Credit Card</a>
        <a href="payment.jsp?orderId=<%= lastOrder.getId() %>" class="pg-btn pg-cash">💵 Pay at Counter</a>
      </div>
    </div>
    <script>
    function addBeverage(name, price, btn) {
      btn.textContent = '⏳'; btn.disabled = true;
      fetch('../chat', { method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'},
        body:'message='+encodeURIComponent('add 1 '+name)
      }).then(()=>{ btn.textContent='✓ Added!'; btn.style.background='#22c55e'; })
        .catch(()=>{ btn.textContent='+ Add'; btn.disabled=false; });
    }
    </script>
    <%
       } else {
         // Active order — show items
         String[] steps = {"pending","preparing","ready","served"};
         int curStep = 0;
         for (int i = 0; i < steps.length; i++) { if (steps[i].equals(status)) curStep = i; }
    %>

    <!-- STATUS CARD -->
    <div class="status-card">
      <div class="status-info">
        <div>
          <div style="font-size:15px;font-weight:700;color:var(--text-primary)">Order #<%= lastOrder.getId() %></div>
          <div class="order-meta">Table <%= lastOrder.getTableNumber() %> · <%= lastOrder.getCreatedAt() %></div>
        </div>
        <span class="status-badge <%= status %>"><%= status %></span>
      </div>
      <div style="font-size:20px;font-weight:800;color:var(--gold)">₹<%= String.format("%.2f", total) %></div>
    </div>

    <!-- PROGRESS TRACK -->
    <div class="progress-track">
      <div class="progress-steps">
        <% for (int i = 0; i < steps.length; i++) {
             String[] icons = {"⏳","👨‍🍳","✅","🍽"};
             String[] labels = {"Placed","Preparing","Ready","Served"};
             boolean done = i <= curStep;
        %>
        <div class="pstep <%= done ? "done" : "" %>">
          <div class="pstep-line"></div>
          <div class="pstep-dot"><%= icons[i] %></div>
          <div class="pstep-lbl"><%= labels[i] %></div>
        </div>
        <% } %>
      </div>
    </div>

    <!-- ORDER ITEMS -->
    <div class="order-card">
      <div class="order-card-header">
        <span style="font-size:20px">🧾</span>
        <h2>Order Items (<%= items.size() %> item<%= items.size() != 1 ? "s" : "" %>)</h2>
      </div>
      <table>
        <tr>
          <th>Item</th>
          <th>Qty</th>
          <th>Price</th>
          <th>Total</th>
        </tr>
        <% for (OrderItem item : items) {
             MenuItem menuItem = menuDAO.getMenuItemById(item.getMenuItemId());
             String itemName = menuItem != null ? menuItem.getName() : "Unknown Item";
             double lineTotal = item.getQuantity() * item.getPriceAtOrder();
        %>
        <tr>
          <td class="item-name"><%= itemName %></td>
          <td><span style="background:var(--bg-input);padding:3px 10px;border-radius:6px;font-weight:700">×<%= item.getQuantity() %></span></td>
          <td>₹<%= String.format("%.2f", item.getPriceAtOrder()) %></td>
          <td class="price-col">₹<%= String.format("%.2f", lineTotal) %></td>
        </tr>
        <% } %>
      </table>

      <div class="summary-box">
        <div class="summary-row"><span>Subtotal</span><span>₹<%= String.format("%.2f", subtotal) %></span></div>
        <div class="summary-row"><span>GST (18%)</span><span>₹<%= String.format("%.2f", gst) %></span></div>
        <div class="summary-row total"><span>Total Payable</span><span>₹<%= String.format("%.2f", total) %></span></div>
        <% if (!"served".equals(status)) { %>
        <form action="payment.jsp" method="get" style="margin-top:18px;">
          <input type="hidden" name="orderId" value="<%= lastOrder.getId() %>">
          <button class="btn-gold" style="width:100%;padding:15px;font-size:16px;border-radius:12px;">💳 Proceed to Payment</button>
        </form>
        <% } else { %>
        <div style="text-align:center;padding:14px;color:#22c55e;font-weight:700;font-size:15px;">✅ Order Completed &amp; Paid</div>
        <% } %>
      </div>
    </div>

        <% } %> <%-- end inner else: active order items --%>
    <% } %> <%-- end outer else: has order --%>
  </div>

  <script src="../assets/js/theme.js"></script>
</body>
</html>