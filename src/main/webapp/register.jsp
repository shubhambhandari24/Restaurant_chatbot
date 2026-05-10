<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Register | PlateUp</title>
  <meta name="description" content="Create your Savor & Sage account and experience AI-powered dining.">
  <link rel="stylesheet" href="assets/css/theme.css">
  <link rel="stylesheet" href="assets/css/auth.css">
  <script>
    (function(){var t=localStorage.getItem('ss_theme');if(!t){t='dark';localStorage.setItem('ss_theme','dark');}document.documentElement.setAttribute('data-theme',t);})();
  </script>
</head>
<body>

  <button id="themeToggle" class="theme-toggle" aria-label="Toggle dark/light mode">
    <span class="icon sun">☀️</span>
    <span class="track"><span class="thumb"></span></span>
    <span class="icon moon">🌙</span>
  </button>

  <div class="orbs" aria-hidden="true">
    <div class="orb orb-1"></div>
    <div class="orb orb-2"></div>
    <div class="orb orb-3"></div>
    <div class="orb orb-4"></div>
  </div>

  <div class="auth-container">

    <div class="auth-brand">
      <a href="index.jsp" class="brand-link">
        🍽️ <span style="font-size:20px;font-weight:700;letter-spacing:-0.5px">Plate<strong style="color:var(--gold)">Up</strong></span>
      </a>
    </div>

    <div class="auth-box">
      <div class="auth-ring ring-a"></div>
      <div class="auth-ring ring-b"></div>

      <div class="auth-inner">
        <div class="auth-icon">✨</div>
        <h1>Create Account</h1>
        <p class="auth-sub">Join us and start your culinary journey</p>

        <form action="auth" method="post" id="registerForm" novalidate>
          <input type="hidden" name="action" value="register">

          <div class="field">
            <label for="name">Full Name</label>
            <div class="input-wrap">
              <span class="input-icon">👤</span>
              <input type="text" id="name" name="name" placeholder="John Doe" required autocomplete="name">
            </div>
          </div>

          <div class="field">
            <label for="email">Email</label>
            <div class="input-wrap">
              <span class="input-icon">📧</span>
              <input type="email" id="email" name="email" placeholder="you@example.com" required autocomplete="email">
            </div>
          </div>

          <div class="field">
            <label for="password">Password</label>
            <div class="input-wrap">
              <span class="input-icon">🔒</span>
              <input type="password" id="password" name="password" placeholder="Create a strong password" required autocomplete="new-password">
              <button type="button" class="eye-btn" onclick="togglePwd()" id="eyeBtn" aria-label="Toggle password visibility">👁</button>
            </div>
          </div>

          <div class="field">
            <label for="phone">Phone Number</label>
            <div class="input-wrap">
              <span class="input-icon">📱</span>
              <input type="tel" id="phone" name="phone" placeholder="+91 9876543210" required autocomplete="tel">
            </div>
          </div>

          <button type="submit" class="btn-primary auth-submit" id="submitBtn">
            <span class="btn-text">Create Account</span>
            <span class="btn-arrow">→</span>
          </button>
        </form>

        <p class="auth-footer-link">
          Already have an account? <a href="login.jsp">Sign in</a>
        </p>

        <%
          String msg = request.getParameter("msg");
          if (msg != null) {
        %>
        <div class="auth-error">⚠️ <%= msg %></div>
        <% } %>
      </div>
    </div>

    <p class="auth-legal">By registering, you agree to our <a href="#">Terms</a> &amp; <a href="#">Privacy Policy</a></p>
  </div>

  <script src="assets/js/theme.js"></script>
  <script>
    function togglePwd() {
      const input = document.getElementById('password');
      const btn   = document.getElementById('eyeBtn');
      input.type  = input.type === 'password' ? 'text' : 'password';
      btn.textContent = input.type === 'password' ? '👁' : '🙈';
    }
    document.getElementById('registerForm').addEventListener('submit', () => {
      const btn = document.getElementById('submitBtn');
      btn.querySelector('.btn-text').textContent = 'Creating…';
      btn.disabled = true;
    });
  </script>
</body>
</html>