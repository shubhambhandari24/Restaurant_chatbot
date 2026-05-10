<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="com.ai.restaurant.model.User"%>
<%@ page import="com.ai.restaurant.model.Order"%>
<%@ page import="java.util.List"%>
<%
User user = (User) session.getAttribute("user");
if (user == null) { response.sendRedirect("../login.jsp"); return; }
@SuppressWarnings("unchecked")
List<Order> orders = (List<Order>) request.getAttribute("orders");
String errorMsg   = (String) request.getAttribute("error");
String successMsg = (String) request.getAttribute("success");
String initials   = user.getName() != null && user.getName().length() > 0
                    ? String.valueOf(user.getName().charAt(0)).toUpperCase() : "U";
%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Profile | PlateUp</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Playfair+Display:wght@700&display=swap">
  <link rel="stylesheet" href="../assets/css/theme.css">
  <!-- Apply saved theme BEFORE CSS renders (prevents light flash) -->
  <script>(function(){var t=localStorage.getItem('ss_theme');if(!t){t='dark';localStorage.setItem('ss_theme','dark');}document.documentElement.setAttribute('data-theme',t);})();</script>
  <style>
    /* ── HARDCODED DARK THEME ── */
    :root {
      --gold:       #d4af37;
      --gold-dark:  #b8952a;
      --gold-glow:  rgba(212,175,55,0.25);
      --bg:         #0e0c09;
      --bg-2:       #13110d;
      --bg-card:    #1a1710;
      --bg-input:   #111108;
      --bg-sidebar: #111108;
      --border:     rgba(212,175,55,0.28);
      --border-soft:rgba(212,175,55,0.10);
      --text-primary:   #f5ead0;
      --text-secondary: #c8b07a;
      --text-muted:     #7a6a4a;
      --shadow:     0 8px 32px rgba(0,0,0,0.50);
      --transition: 0.4s cubic-bezier(.4,0,.2,1);
    }

    * { box-sizing: border-box; margin: 0; padding: 0; }
    html, body { background: #0e0c09 !important; color: #f5ead0 !important; }
    body { font-family: 'Outfit', sans-serif; min-height: 100vh; }

    .app { display: grid; grid-template-columns: 260px 1fr; min-height: 100vh; }

    /* ── SIDEBAR ── */
    .sidebar { background: #111108; border-right: 1px solid rgba(212,175,55,0.28); padding: 28px 20px; display: flex; flex-direction: column; gap: 0; }
    .brand { display: flex; align-items: center; gap: 12px; margin-bottom: 28px; padding-bottom: 22px; border-bottom: 1px solid rgba(212,175,55,0.10); }
    .brand-icon { font-size: 26px; width: 42px; height: 42px; background: rgba(212,175,55,0.15); border: 1px solid rgba(212,175,55,0.28); border-radius: 12px; display: flex; align-items: center; justify-content: center; }
    .brand h2 { font-family: 'Playfair Display', serif; font-size: 17px; font-weight: 700; color: #d4af37; line-height: 1.2; }
    .brand span { font-size: 11px; color: #7a6a4a; }
    .sidebar-nav { display: flex; flex-direction: column; gap: 6px; flex: 1; }
    .sidebar-nav a { display: flex; align-items: center; gap: 12px; padding: 11px 14px; border-radius: 10px; color: #c8b07a; text-decoration: none; font-size: 14px; font-weight: 500; border: 1px solid transparent; transition: all 0.25s; }
    .sidebar-nav a:hover { background: #1a1710; color: #f5ead0; border-color: rgba(212,175,55,0.10); }
    .sidebar-nav a.active { background: #1a1710; color: #d4af37; border-color: rgba(212,175,55,0.28); box-shadow: 0 8px 32px rgba(0,0,0,0.50); }
    .logout-link { color: #ef4444 !important; margin-top: 8px; }
    .logout-link:hover { background: rgba(239,68,68,.12) !important; }

    /* ── MAIN ── */
    .main { padding: 32px 36px; overflow-y: auto; background: #0e0c09; }
    .page-header { margin-bottom: 32px; }
    .page-header h1 { font-size: 28px; font-weight: 800; color: #f5ead0; }
    .page-header h1 span { color: #d4af37; }
    .page-header p { font-size: 14px; color: #7a6a4a; margin-top: 4px; }

    /* ── ALERT ── */
    .alert { padding: 14px 18px; border-radius: 12px; font-size: 14px; font-weight: 600; margin-bottom: 24px; display: flex; align-items: center; gap: 10px; }
    .alert-success { background: rgba(34,197,94,.12); border: 1px solid rgba(34,197,94,.3); color: #22c55e; }
    .alert-error   { background: rgba(239,68,68,.12);  border: 1px solid rgba(239,68,68,.3);  color: #ef4444; }

    /* ── GRID ── */
    .profile-grid { display: grid; grid-template-columns: 340px 1fr; gap: 24px; }

    /* ── PROFILE CARD ── */
    .profile-card { background: #1a1710; border: 1px solid rgba(212,175,55,0.28); border-radius: 20px; padding: 32px 24px; text-align: center; }
    .avatar-wrap { position: relative; display: inline-block; margin-bottom: 20px; }
    .avatar-big { width: 96px; height: 96px; border-radius: 50%; background: linear-gradient(135deg, #d4af37, #b8952a); color: #fff; font-size: 40px; font-weight: 800; display: flex; align-items: center; justify-content: center; box-shadow: 0 8px 32px rgba(212,175,55,0.25); }
    .avatar-badge { position: absolute; bottom: 2px; right: 2px; background: #22c55e; border: 3px solid #1a1710; border-radius: 50%; width: 20px; height: 20px; }
    .profile-name { font-size: 20px; font-weight: 800; color: #f5ead0; margin-bottom: 4px; }
    .profile-email { font-size: 13px; color: #7a6a4a; margin-bottom: 20px; }
    .profile-stats { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
    .stat-box { background: #13110d; border: 1px solid rgba(212,175,55,0.10); border-radius: 12px; padding: 14px 10px; text-align: center; }
    .stat-num { font-size: 22px; font-weight: 800; color: #d4af37; }
    .stat-label { font-size: 11px; color: #7a6a4a; margin-top: 2px; }

    /* FOOD PREFS */
    .pref-section { margin-top: 20px; text-align: left; }
    .pref-title { font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: .08em; color: #7a6a4a; margin-bottom: 10px; }
    .pref-chips { display: flex; flex-wrap: wrap; gap: 6px; }
    .pref-chip { background: #13110d; border: 1px solid rgba(212,175,55,0.10); border-radius: 20px; padding: 5px 12px; font-size: 12px; color: #c8b07a; cursor: pointer; transition: all .2s; }
    .pref-chip.active { background: #d4af37; color: #0e0c09; border-color: #d4af37; font-weight: 700; }

    /* ── FORMS PANEL ── */
    .forms-panel { display: flex; flex-direction: column; gap: 20px; }
    .form-card { background: #1a1710; border: 1px solid rgba(212,175,55,0.28); border-radius: 20px; padding: 28px; }
    .form-card-title { font-size: 16px; font-weight: 700; color: #f5ead0; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
    .form-card-title span { font-size: 20px; }
    .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
    .form-group { display: flex; flex-direction: column; gap: 6px; }
    .form-group label { font-size: 12px; font-weight: 600; color: #7a6a4a; text-transform: uppercase; letter-spacing: .06em; }
    .form-group input { background: #111108 !important; border: 1px solid rgba(212,175,55,0.28); border-radius: 10px; padding: 12px 14px; font-size: 14px; color: #f5ead0 !important; font-family: 'Outfit', sans-serif; outline: none; transition: border-color .2s; -webkit-text-fill-color: #f5ead0; }
    .form-group input:focus { border-color: #d4af37; box-shadow: 0 0 0 3px rgba(212,175,55,0.25); }
    .form-group input[readonly] { opacity: .5; cursor: not-allowed; }
    .save-btn { margin-top: 18px; padding: 13px 28px; background: #d4af37; color: #0e0c09; border: none; border-radius: 10px; font-size: 14px; font-weight: 700; font-family: 'Outfit', sans-serif; cursor: pointer; transition: all .2s; }
    .save-btn:hover { background: #b8952a; transform: translateY(-1px); }

    /* ── ORDER HISTORY ── */
    .history-card { background: #1a1710; border: 1px solid rgba(212,175,55,0.28); border-radius: 20px; padding: 28px; }
    .history-title { font-size: 16px; font-weight: 700; color: #f5ead0; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
    .order-row { display: flex; align-items: center; justify-content: space-between; padding: 14px 0; border-bottom: 1px solid rgba(212,175,55,0.10); gap: 12px; }
    .order-row:last-child { border-bottom: none; }
    .order-num { font-size: 13px; font-weight: 700; color: #f5ead0; }
    .order-date { font-size: 12px; color: #7a6a4a; margin-top: 2px; }
    .order-status { font-size: 11px; font-weight: 700; border-radius: 6px; padding: 3px 10px; }
    .status-served   { background: rgba(34,197,94,.15);  color: #22c55e; }
    .status-pending  { background: rgba(251,191,36,.15); color: #fbbf24; }
    .status-preparing{ background: rgba(59,130,246,.15); color: #3b82f6; }
    .status-ready    { background: rgba(168,85,247,.15); color: #a855f7; }
    .order-total { font-size: 15px; font-weight: 800; color: #d4af37; }
    .empty-history { text-align: center; padding: 32px 0; color: #7a6a4a; font-size: 14px; }

    /* THEME TOGGLE */
    .theme-toggle { position: fixed; top: 20px; right: 20px; width: 40px; height: 40px; border-radius: 50%; background: #1a1710; border: 1px solid rgba(212,175,55,0.28); cursor: pointer; z-index: 999; box-shadow: 0 8px 32px rgba(0,0,0,0.5); font-size: 18px; display: flex; align-items: center; justify-content: center; transition: all .2s; }
    .theme-toggle:hover { border-color: #d4af37; transform: scale(1.1); }
  </style>
</head>
<body>

<button id="themeToggle" class="theme-toggle" aria-label="Toggle theme" title="Toggle dark/light mode">
  <span id="themeIcon">🌙</span>
</button>

<div class="app">

  <!-- SIDEBAR -->
  <aside class="sidebar">
    <div class="brand">
      <div class="brand-icon">🍽️</div>
      <div><h2>PlateUp</h2><span>AI Restaurant</span></div>
    </div>
    <nav class="sidebar-nav">
      <a href="customer/chat.jsp"><span>🤖</span> Chatbot</a>
      <a href="customer/order.jsp"><span>🛒</span> My Order</a>
      <a href="customer/history.jsp"><span>📋</span> Order History</a>
      <a href="profile" class="active"><span>👤</span> My Profile</a>
      <a href="logout" class="logout-link"><span>🚪</span> Logout</a>
    </nav>
  </aside>

  <!-- MAIN -->
  <main class="main">
    <div class="page-header">
      <h1>My <span>Profile</span></h1>
      <p>Manage your account details, preferences and order history</p>
    </div>

    <% if (successMsg != null) { %>
    <div class="alert alert-success">✅ <%= successMsg %></div>
    <% } %>
    <% if (errorMsg != null) { %>
    <div class="alert alert-error">⚠️ <%= errorMsg %></div>
    <% } %>

    <div class="profile-grid">

      <!-- LEFT: PROFILE AVATAR + STATS -->
      <div>
        <div class="profile-card">
          <div class="avatar-wrap">
            <div class="avatar-big"><%= initials %></div>
            <div class="avatar-badge"></div>
          </div>
          <div class="profile-name"><%= user.getName() %></div>
          <div class="profile-email"><%= user.getEmail() %></div>

          <div class="profile-stats">
            <div class="stat-box">
              <div class="stat-num"><%= orders != null ? orders.size() : 0 %></div>
              <div class="stat-label">Total Orders</div>
            </div>
            <div class="stat-box">
              <% double totalSpent = 0;
                 if (orders != null) for (Order o : orders) totalSpent += o.getTotalPrice(); %>
              <div class="stat-num">₹<%= String.format("%.0f", totalSpent) %></div>
              <div class="stat-label">Total Spent</div>
            </div>
          </div>

          <!-- FOOD PREFERENCES -->
          <div class="pref-section">
            <div class="pref-title">🌿 Food Preferences</div>
            <div class="pref-chips">
              <span class="pref-chip" onclick="togglePref(this)">Vegetarian</span>
              <span class="pref-chip" onclick="togglePref(this)">Spicy</span>
              <span class="pref-chip" onclick="togglePref(this)">Healthy</span>
              <span class="pref-chip" onclick="togglePref(this)">Chinese</span>
              <span class="pref-chip" onclick="togglePref(this)">Low-Calorie</span>
              <span class="pref-chip" onclick="togglePref(this)">Non-Veg</span>
              <span class="pref-chip" onclick="togglePref(this)">Gluten-Free</span>
              <span class="pref-chip" onclick="togglePref(this)">Budget</span>
            </div>
          </div>
        </div>
      </div>

      <!-- RIGHT: FORMS + HISTORY -->
      <div class="forms-panel">

        <!-- UPDATE PROFILE FORM -->
        <div class="form-card">
          <div class="form-card-title"><span>✏️</span> Basic Details</div>
          <form method="post" action="profile">
            <input type="hidden" name="action" value="updateProfile">
            <div class="form-row">
              <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="name" value="<%= user.getName() != null ? user.getName() : "" %>" placeholder="Your full name" required>
              </div>
              <div class="form-group">
                <label>Email (read-only)</label>
                <input type="text" value="<%= user.getEmail() != null ? user.getEmail() : "" %>" readonly>
              </div>
            </div>
            <div class="form-row" style="margin-top:14px">
              <div class="form-group">
                <label>Phone Number</label>
                <input type="tel" name="phone" value="<%= user.getPhone() != null ? user.getPhone() : "" %>" placeholder="+91 9876543210">
              </div>
              <div class="form-group">
                <label>Member Since</label>
                <input type="text" value="<%= user.getCreatedAt() != null ? user.getCreatedAt().toString().substring(0,10) : "N/A" %>" readonly>
              </div>
            </div>
            <button type="submit" class="save-btn">💾 Save Changes</button>
          </form>
        </div>

        <!-- CHANGE PASSWORD FORM -->
        <div class="form-card">
          <div class="form-card-title"><span>🔐</span> Change Password</div>
          <form method="post" action="profile">
            <input type="hidden" name="action" value="changePassword">
            <div class="form-group" style="margin-bottom:14px">
              <label>Current Password</label>
              <input type="password" name="currentPassword" placeholder="Enter current password" required>
            </div>
            <div class="form-row">
              <div class="form-group">
                <label>New Password</label>
                <input type="password" name="newPassword" placeholder="Min. 6 characters" required>
              </div>
              <div class="form-group">
                <label>Confirm Password</label>
                <input type="password" name="confirmPassword" placeholder="Repeat new password" required>
              </div>
            </div>
            <button type="submit" class="save-btn" style="background:#6366f1">🔑 Change Password</button>
          </form>
        </div>

        <!-- ORDER HISTORY -->
        <div class="history-card">
          <div class="history-title"><span>📋</span> Order History</div>
          <% if (orders == null || orders.isEmpty()) { %>
          <div class="empty-history">🍽️ No orders yet. <a href="chat.jsp" style="color:var(--gold)">Start ordering!</a></div>
          <% } else {
             int shown = 0;
             for (Order o : orders) {
               if (shown >= 8) break; shown++;
               String st = o.getStatus() != null ? o.getStatus() : "pending";
               String stClass = "status-" + st;
          %>
          <div class="order-row">
            <div>
              <div class="order-num">Order #<%= o.getId() %></div>
              <div class="order-date"><%= o.getCreatedAt() != null ? o.getCreatedAt().toString().substring(0,16).replace("T"," ") : "N/A" %></div>
            </div>
            <span class="order-status <%= stClass %>"><%= st.toUpperCase() %></span>
            <div class="order-total">₹<%= String.format("%.2f", o.getTotalPrice()) %></div>
          </div>
          <% } } %>
        </div>

      </div>
    </div>
  </main>
</div>

<script src="../assets/js/theme.js?v=6"></script>
<script>
/* <![CDATA[ */
// Override initThemeToggle for simple icon button
document.addEventListener('DOMContentLoaded', function() {
  var btn  = document.getElementById('themeToggle');
  var icon = document.getElementById('themeIcon');
  function update() {
    icon.textContent = document.documentElement.getAttribute('data-theme') === 'dark' ? '\u2600\ufe0f' : '\ud83c\udf19';
  }
  update();
  btn.addEventListener('click', function() {
    var next = document.documentElement.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
    document.documentElement.setAttribute('data-theme', next);
    localStorage.setItem('ss_theme', next);
    update();
  });
});

function togglePref(chip) {
  chip.classList.toggle('active');
  var prefs = [];
  document.querySelectorAll('.pref-chip.active').forEach(function(c) { prefs.push(c.textContent); });
  localStorage.setItem('plateup_prefs', JSON.stringify(prefs));
}

document.addEventListener('DOMContentLoaded', function() {
  var saved = JSON.parse(localStorage.getItem('plateup_prefs') || '[]');
  document.querySelectorAll('.pref-chip').forEach(function(chip) {
    if (saved.indexOf(chip.textContent) !== -1) chip.classList.add('active');
  });
});
/* ]]> */
</script>
</body>
</html>
