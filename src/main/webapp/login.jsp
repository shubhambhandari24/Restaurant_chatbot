<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login | PlateUp</title>
  <meta name="description" content="Login to PlateUp — your AI-powered restaurant experience.">
  <link rel="stylesheet" href="assets/css/theme.css">
  <link rel="stylesheet" href="assets/css/auth.css">
  <script>
    (function(){var t=localStorage.getItem('ss_theme');if(!t){t='dark';localStorage.setItem('ss_theme','dark');}document.documentElement.setAttribute('data-theme',t);})();
  </script>
</head>
<body>

  <!-- ═══ THEME TOGGLE ═══ -->
  <button id="themeToggle" class="theme-toggle" aria-label="Toggle dark/light mode">
    <span class="icon sun">☀️</span>
    <span class="track"><span class="thumb"></span></span>
    <span class="icon moon">🌙</span>
  </button>

  <!-- ═══ ANIMATED ORBS ═══ -->
  <div class="orbs" aria-hidden="true">
    <div class="orb orb-1"></div>
    <div class="orb orb-2"></div>
    <div class="orb orb-3"></div>
    <div class="orb orb-4"></div>
  </div>

  <!-- ═══ AUTH CONTAINER ═══ -->
  <div class="auth-container">

    <!-- BRANDING TOP -->
    <div class="auth-brand">
      <a href="index.jsp" class="brand-link">
        🍽️ <span style="font-size:20px;font-weight:700;letter-spacing:-0.5px">Plate<strong style="color:var(--gold)">Up</strong></span>
      </a>
    </div>

    <!-- CARD -->
    <div class="auth-box">

      <!-- SPINNING RING DECORATION -->
      <div class="auth-ring ring-a"></div>
      <div class="auth-ring ring-b"></div>

      <div class="auth-inner">
        <div class="auth-icon">👤</div>
        <h1>Welcome Back</h1>
        <p class="auth-sub">Sign in to continue your dining experience</p>

        <form action="auth" method="post" id="loginForm" novalidate>
          <input type="hidden" name="action" value="login">

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
              <input type="password" id="password" name="password" placeholder="Enter your password" required autocomplete="current-password">
              <button type="button" class="eye-btn" onclick="togglePwd()" id="eyeBtn" aria-label="Toggle password visibility">👁</button>
            </div>
          </div>

          <button type="submit" class="btn-primary auth-submit" id="submitBtn">
            <span class="btn-text">Login</span>
            <span class="btn-arrow">→</span>
          </button>
        </form>

        <p class="auth-footer-link">
          Don't have an account? <a href="register.jsp">Create one</a>
        </p>

        <%
          String error = request.getParameter("error");
          if (error != null) {
        %>
        <div class="auth-error">
          ⚠️ Invalid email or password. Please try again.
        </div>
        <% } %>
      </div>
    </div>

    <p class="auth-legal">By continuing, you agree to our <a href="#">Terms</a> &amp; <a href="#">Privacy Policy</a></p>
  </div>

  <script src="assets/js/theme.js"></script>
  <script>
    function togglePwd() {
      const input = document.getElementById('password');
      const btn   = document.getElementById('eyeBtn');
      if (input.type === 'password') {
        input.type = 'text';
        btn.textContent = '🙈';
      } else {
        input.type = 'password';
        btn.textContent = '👁';
      }
    }

    // Subtle submit animation
    document.getElementById('loginForm').addEventListener('submit', () => {
      const btn = document.getElementById('submitBtn');
      btn.querySelector('.btn-text').textContent = 'Logging in…';
      btn.disabled = true;
    });
  </script>
</body>
</html>