<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ai.restaurant.model.User"%>

<%
User user = (User) session.getAttribute("user");
if (user == null) {
    response.sendRedirect("../login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>AI Menu Chatbot | PlateUp</title>
  <meta name="description" content="Chat with Savor & Sage's AI chatbot — browse the menu, place orders, and more.">
  <link rel="stylesheet" href="../assets/css/theme.css?v=5">
  <link rel="stylesheet" href="../assets/css/chat.css?v=5">
  <script>
    (function(){var t=localStorage.getItem('ss_theme')||'dark';document.documentElement.setAttribute('data-theme',t);})();
  </script>
</head>
<body>

<!-- ═══ THEME TOGGLE ═══ -->
<button id="themeToggle" class="theme-toggle" aria-label="Toggle dark/light mode">
  <span class="icon sun">☀️</span>
  <span class="track"><span class="thumb"></span></span>
  <span class="icon moon">🌙</span>
</button>

<!-- ═══ APP LAYOUT ═══ -->
<div class="app" id="app">

  <!-- ────────────────────────────────────────────
       SIDEBAR
  ──────────────────────────────────────────── -->
  <aside class="sidebar" id="sidebar">

    <div class="brand">
      <a href="../index.jsp" title="Go to PlateUp Home" style="display:flex;align-items:center;gap:10px;text-decoration:none">
        <img src="../assets/images/plateup_logo.png" alt="PlateUp" style="width:32px;height:32px;object-fit:contain" onerror="this.style.display='none'">
        <div>
          <h2 style="color:var(--text-primary)">PlateUp</h2>
          <span>AI Food Ordering</span>
        </div>
      </a>
    </div>

    <div class="user-box">
      <div class="avatar"><%= user.getName().charAt(0) %></div>
      <div>
        <p>Welcome back</p>
        <h3><%= user.getName() %></h3>
      </div>
    </div>

    <nav class="sidebar-nav">
      <a href="chat.jsp" class="active" id="nav-chat">
        <span class="nav-icon">🤖</span> Chatbot
      </a>
      <a href="order.jsp" id="nav-order">
        <span class="nav-icon">🛒</span> My Order
        <span class="cart-badge" id="cartBadge" style="display:none">0</span>
      </a>
      <a href="history.jsp" id="nav-history">
        <span class="nav-icon">📋</span> Order History
      </a>
      <a href="../profile" id="nav-profile">
        <span class="nav-icon">👤</span> My Profile
      </a>
      <a href="../logout" id="nav-logout" class="logout-link">
        <span class="nav-icon">🚪</span> Logout
      </a>
    </nav>

    <!-- SIDEBAR BOTTOM TIP -->
    <div class="sidebar-tip">
      <span class="tip-icon">💡</span>
      <span>Try: <em>"chinese food"</em> or <em>"healthy picks"</em></span>
    </div>

  </aside>

  <!-- ────────────────────────────────────────────
       MAIN CHAT AREA
  ──────────────────────────────────────────── -->
  <main class="chat-area">

    <!-- CHAT HEADER -->
    <div class="chat-header">
      <div class="chat-header-left">
        <div class="bot-avatar">🤖</div>
        <div>
          <h1>AI Menu Chatbot</h1>
          <p class="online-status"><span class="online-dot"></span> Online · Ready to help</p>
        </div>
      </div>
      <div class="chat-header-right">
        <button class="header-btn" onclick="clearChat()" title="Clear chat">🗑</button>
      </div>
    </div>

    <!-- CHAT MESSAGES -->
    <div id="chatBox" class="chat-box">
      <div class="message bot" id="welcomeMsg">
        <span class="msg-avatar">🤖</span>
        <div class="msg-content">
          <p>Hello <strong><%= user.getName() %></strong>! 👋</p>
          <p>I'm your AI dining assistant. Explore our menu, try <strong>Chinese food 🥡</strong>, order <strong>beverages 🥤</strong>, get healthy picks, and more!</p>
          <p style="margin-top:8px;font-size:13px;opacity:0.7">Try a quick action below ↓</p>
        </div>
      </div>
    </div>

    <!-- QUICK CHIPS -->
    <div class="quick-chips" id="quickChips">
      <button class="chip" onclick="sendQuick('show menu')">📋 Full Menu</button>
      <button class="chip" onclick="sendQuick('veg dishes')">🌿 Veg</button>
      <button class="chip" onclick="sendQuick('non-veg')">🍗 Non-Veg</button>
      <button class="chip" onclick="sendQuick('chinese food')">🥡 Chinese</button>
      <button class="chip" onclick="sendQuick('beverages')">🥤 Drinks</button>
      <button class="chip" onclick="sendQuick('healthy food')">🥗 Healthy</button>
      <button class="chip" onclick="sendQuick('budget picks')">💰 Budget</button>
      <button class="chip" onclick="sendQuick('order status')">🛒 My Cart</button>
    </div>

    <!-- CHAT INPUT -->
    <div class="chat-input-area">
      <input
        type="text"
        id="messageInput"
        placeholder="Ask about our menu, veg dishes, prices…"
        autocomplete="off"
        aria-label="Type a message"
      >
      <button class="send-btn" onclick="sendMessage()" id="sendBtn" aria-label="Send message">
        <span class="send-icon">➤</span>
      </button>
    </div>

  </main>
</div>

<!-- Cart data store -->
<script>
  window.SS_CART = [];
  window.SS_USER = '<%= user.getName() %>';
</script>

<script src="../assets/js/theme.js?v=6"></script>
<script src="../assets/js/chat.js?v=6"></script>

</body>
</html>