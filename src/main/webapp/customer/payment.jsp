<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="com.ai.restaurant.model.User"%>
<%@ page import="com.ai.restaurant.model.Order"%>
<%@ page import="com.ai.restaurant.service.OrderService"%>
<%
User user = (User) session.getAttribute("user");
if (user == null) { response.sendRedirect("../login.jsp"); return; }
String orderId = request.getParameter("orderId");
if (orderId == null) orderId = "0";
// Fetch real order total
OrderService os = new OrderService();
Order theOrder = os.getOrder(Integer.parseInt(orderId));
double orderTotal = (theOrder != null) ? theOrder.getTotalPrice() : 0.0;
String formattedTotal = String.format("%.2f", orderTotal);
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Scan &amp; Pay | Savor &amp; Sage</title>
  <link rel="stylesheet" href="../assets/css/theme.css">
  <script>(function(){var t=localStorage.getItem('ss_theme')||'dark';document.documentElement.setAttribute('data-theme',t);})();</script>
  <style>
    body {
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      background: var(--bg);
      font-family: 'Outfit', sans-serif;
      padding: 20px;
      transition: background var(--transition);
    }

    .pay-card {
      background: var(--bg-card);
      border: 1px solid var(--border);
      border-radius: 28px;
      padding: 44px 40px;
      text-align: center;
      max-width: 440px;
      width: 100%;
      box-shadow: var(--shadow-lg);
      position: relative;
      overflow: hidden;
      transition: background var(--transition), border-color var(--transition);
    }
    .pay-card::before {
      content: '';
      position: absolute;
      top: -60px; left: -60px;
      width: 180px; height: 180px;
      background: radial-gradient(circle, var(--orb1), transparent);
      border-radius: 50%;
    }

    .pay-title {
      font-size: 13px;
      font-weight: 700;
      letter-spacing: 0.14em;
      text-transform: uppercase;
      color: var(--gold);
      margin-bottom: 6px;
    }
    .pay-heading {
      font-size: 26px;
      font-weight: 800;
      color: var(--text-primary);
      margin-bottom: 6px;
    }
    .pay-sub {
      font-size: 14px;
      color: var(--text-muted);
      margin-bottom: 30px;
    }
    .order-id-badge {
      display: inline-block;
      background: var(--bg-input);
      border: 1px solid var(--border);
      border-radius: 8px;
      padding: 6px 16px;
      font-size: 13px;
      color: var(--text-secondary);
      margin-bottom: 28px;
    }

    /* QR WRAPPER */
    .qr-wrap {
      position: relative;
      width: 220px;
      height: 220px;
      margin: 0 auto 28px;
    }
    .qr-frame {
      position: absolute;
      inset: -8px;
      border: 2px solid var(--gold);
      border-radius: 18px;
      animation: framePulse 2s ease-in-out infinite;
    }
    @keyframes framePulse {
      0%,100% { box-shadow: 0 0 0 0 rgba(212,175,55,0.4); }
      50%      { box-shadow: 0 0 0 10px rgba(212,175,55,0); }
    }

    /* CORNER MARKERS */
    .qr-corner {
      position: absolute;
      width: 22px; height: 22px;
      border-color: var(--gold);
      border-style: solid;
    }
    .qr-corner.tl { top: -8px; left: -8px; border-width: 3px 0 0 3px; border-radius: 4px 0 0 0; }
    .qr-corner.tr { top: -8px; right: -8px; border-width: 3px 3px 0 0; border-radius: 0 4px 0 0; }
    .qr-corner.bl { bottom: -8px; left: -8px; border-width: 0 0 3px 3px; border-radius: 0 0 0 4px; }
    .qr-corner.br { bottom: -8px; right: -8px; border-width: 0 3px 3px 0; border-radius: 0 0 4px 0; }

    /* SCAN BEAM */
    .scan-beam {
      position: absolute;
      left: 0; right: 0;
      height: 3px;
      background: linear-gradient(90deg, transparent, var(--gold), var(--gold-light), var(--gold), transparent);
      border-radius: 2px;
      top: 0;
      animation: scanBeam 2.2s ease-in-out infinite;
      box-shadow: 0 0 16px var(--gold), 0 0 40px rgba(212,175,55,0.4);
    }
    @keyframes scanBeam {
      0%   { top: 0%; opacity:0; }
      10%  { opacity:1; }
      90%  { opacity:1; }
      100% { top: 100%; opacity:0; }
    }

    .qr-img {
      width: 220px; height: 220px;
      border-radius: 12px;
      display: block;
    }

    .pay-info {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      font-size: 13px;
      color: var(--text-muted);
      margin-bottom: 28px;
    }
    .upi-icons { display: flex; gap: 8px; }
    .upi-icon {
      width: 32px; height: 20px;
      background: var(--bg-input);
      border: 1px solid var(--border);
      border-radius: 4px;
      display: flex; align-items: center; justify-content: center;
      font-size: 9px; font-weight: 700;
      color: var(--text-secondary);
    }

    .pay-btn {
      width: 100%;
      padding: 16px;
      background: var(--gold);
      color: #fff;
      border: none;
      border-radius: 12px;
      font-size: 16px;
      font-weight: 700;
      font-family: 'Outfit', sans-serif;
      cursor: pointer;
      transition: all 0.3s;
      box-shadow: 0 6px 24px var(--gold-glow);
      margin-bottom: 14px;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
    }
    .pay-btn:hover { background: var(--gold-dark); transform: translateY(-2px); }
    .pay-btn:active { transform: scale(0.98); }

    .back-link {
      display: inline-block;
      color: var(--text-muted);
      text-decoration: none;
      font-size: 14px;
      transition: color 0.2s;
    }
    .back-link:hover { color: var(--gold); }

    /* SUCCESS OVERLAY */
    .success-overlay {
      display: none;
      position: fixed;
      inset: 0;
      background: rgba(0,0,0,0.85);
      z-index: 9999;
      align-items: center;
      justify-content: center;
      backdrop-filter: blur(8px);
    }
    .success-overlay.show { display: flex; }
    .success-card {
      background: var(--bg-card);
      border: 1px solid var(--border);
      border-radius: 28px;
      padding: 56px 48px;
      text-align: center;
      max-width: 380px;
      width: 90%;
      animation: popIn 0.5s cubic-bezier(0.34,1.56,0.64,1);
    }
    @keyframes popIn {
      from { transform: scale(0.5); opacity: 0; }
      to   { transform: scale(1);   opacity: 1; }
    }
    .success-icon {
      font-size: 72px;
      margin-bottom: 20px;
      display: block;
      animation: bounceIn 0.6s 0.3s both;
    }
    @keyframes bounceIn {
      from { transform: scale(0); }
      60%  { transform: scale(1.2); }
      to   { transform: scale(1); }
    }
    .success-card h2 {
      font-size: 28px;
      font-weight: 800;
      color: var(--text-primary);
      margin-bottom: 10px;
    }
    .success-card p {
      color: var(--text-secondary);
      font-size: 15px;
      margin-bottom: 30px;
    }
    .success-amount {
      font-size: 36px;
      font-weight: 800;
      color: var(--gold);
      margin-bottom: 6px;
    }
    .success-ref {
      font-size: 12px;
      color: var(--text-muted);
      margin-bottom: 28px;
    }

    /* CONFETTI */
    .confetti-piece {
      position: fixed;
      width: 10px; height: 10px;
      border-radius: 2px;
      animation: confettiFall linear forwards;
    }
    @keyframes confettiFall {
      0%   { transform: translateY(-20px) rotate(0deg); opacity: 1; }
      100% { transform: translateY(110vh) rotate(720deg); opacity: 0; }
    }
  </style>
</head>
<body>

  <!-- THEME TOGGLE -->
  <button id="themeToggle" class="theme-toggle" aria-label="Toggle theme">
    <span class="icon sun">☀️</span>
    <span class="track"><span class="thumb"></span></span>
    <span class="icon moon">🌙</span>
  </button>

  <!-- PAYMENT CARD -->
  <div class="pay-card">
    <div class="pay-title">Secure Payment</div>
    <h1 class="pay-heading">Scan &amp; Pay</h1>
    <p class="pay-sub">Use any UPI app to scan and complete payment</p>
    <div class="order-id-badge">🧾 Order #<%= orderId %></div>

    <!-- QR CODE -->
    <div class="qr-wrap">
      <div class="qr-frame"></div>
      <div class="qr-corner tl"></div>
      <div class="qr-corner tr"></div>
      <div class="qr-corner bl"></div>
      <div class="qr-corner br"></div>
      <div class="scan-beam"></div>
      <img class="qr-img"
           src="https://api.qrserver.com/v1/create-qr-code/?size=220x220&data=upi://pay?pa=savorandsage@upi%26pn=PlateUp%26tn=Order<%= orderId %>%26am=<%= formattedTotal %>&bgcolor=FFFFFF&color=1a1208&margin=10"
           alt="QR Code for payment">
    </div>

    <div class="pay-info">
      <span>Accepted:</span>
      <div class="upi-icons">
        <div class="upi-icon">GPay</div>
        <div class="upi-icon">PhPe</div>
        <div class="upi-icon">BHIM</div>
        <div class="upi-icon">Paytm</div>
      </div>
    </div>

    <form action="../pay" method="post" onsubmit="handlePay(event, this)">
      <input type="hidden" name="orderId" value="<%= orderId %>">
      <button type="submit" class="pay-btn" id="payBtn">
        ✅ I Have Paid
      </button>
    </form>

    <a href="order.jsp" class="back-link">← Back to Order</a>
  </div>

  <!-- SUCCESS OVERLAY -->
  <div class="success-overlay" id="successOverlay">
    <div class="success-card">
      <span class="success-icon">🎉</span>
      <h2>Payment Successful!</h2>
      <div class="success-amount">₹<span id="paidAmount"><%= formattedTotal %></span></div>
      <p>Thank you, <strong><%= user.getName() %></strong>! Your order is complete.</p>
      <p class="success-ref">Ref: PU<%= orderId %>-<span id="refCode"></span></p>
      <a href="chat.jsp" class="pay-btn" style="text-decoration:none;justify-content:center;">
        🍽 Back to Chatbot
      </a>
    </div>
  </div>

  <script src="../assets/js/theme.js"></script>
  <script>
    function handlePay(e, form) {
      e.preventDefault();

      // Show spinner on button
      const btn = document.getElementById('payBtn');
      btn.textContent = '⏳ Processing…';
      btn.disabled = true;

      setTimeout(() => {
        const ref = Math.random().toString(36).substring(2, 10).toUpperCase();
        document.getElementById('refCode').textContent = ref;
        // Amount already filled from server-side

        // Show success overlay
        document.getElementById('successOverlay').classList.add('show');

        // Confetti burst
        launchConfetti();

        // Submit to server in background — mark as served
        fetch(form.action, {
          method: 'POST',
          body: new FormData(form)
        }).catch(() => {});

        // Redirect to new order page after 3s
        setTimeout(() => {
          window.location.href = 'chat.jsp';
        }, 4000);

      }, 2000);
    }

    function launchConfetti() {
      const colors = ['#d4af37','#f0d060','#fff','#22c55e','#3b82f6','#f97316'];
      for (let i = 0; i < 80; i++) {
        const el = document.createElement('div');
        el.className = 'confetti-piece';
        el.style.cssText = `
          left: ${Math.random() * 100}vw;
          top: -10px;
          background: ${colors[Math.floor(Math.random() * colors.length)]};
          width: ${6 + Math.random() * 8}px;
          height: ${6 + Math.random() * 8}px;
          border-radius: ${Math.random() > 0.5 ? '50%' : '2px'};
          animation-duration: ${2 + Math.random() * 2}s;
          animation-delay: ${Math.random() * 0.8}s;
        `;
        document.body.appendChild(el);
        el.addEventListener('animationend', () => el.remove());
      }
    }
  </script>
</body>
</html>