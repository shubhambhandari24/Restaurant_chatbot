<%@ page language="java" contentType="text/html; charset=UTF-8" %>
  <!DOCTYPE html>
  <html lang="en">

  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PlateUp — Order Food, Anytime</title>
    <meta name="description"
      content="PlateUp — AI-powered food ordering. Browse menus, chat with our bot, and get food fast.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link
      href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800;900&family=Playfair+Display:ital,wght@1,700&display=swap"
      rel="stylesheet">
    <link rel="stylesheet" href="assets/css/theme.css">
    <script>(function () { var t = localStorage.getItem('ss_theme') || 'dark'; document.documentElement.setAttribute('data-theme', t); })();</script>
    <style>
      *,
      *::before,
      *::after {
        margin: 0;
        padding: 0;
        box-sizing: border-box
      }

      html {
        scroll-behavior: smooth
      }

      body {
        font-family: 'Outfit', sans-serif;
        background: var(--bg);
        color: var(--text-primary);
        overflow-x: hidden
      }

      /* ── NAVBAR ── */
      .navbar {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        z-index: 900;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 18px 60px;
        transition: all .3s
      }

      .navbar.scrolled {
        background: rgba(10, 10, 15, .92);
        backdrop-filter: blur(20px);
        border-bottom: 1px solid var(--border-soft)
      }

      .logo {
        display: flex;
        align-items: center;
        gap: 10px;
        text-decoration: none;
        cursor: pointer
      }

      .logo img {
        width: 36px;
        height: 36px;
        object-fit: contain
      }

      .logo-text {
        font-size: 22px;
        font-weight: 800;
        color: var(--text-primary)
      }

      .logo-text span {
        color: var(--gold)
      }

      .nav-links {
        display: flex;
        gap: 36px;
        list-style: none
      }

      .nav-links a {
        text-decoration: none;
        color: var(--text-secondary);
        font-size: 15px;
        font-weight: 600;
        transition: color .2s
      }

      .nav-links a:hover {
        color: var(--gold)
      }

      .nav-right {
        display: flex;
        align-items: center;
        gap: 14px
      }

      .btn-login {
        background: transparent;
        border: 1.5px solid var(--gold);
        color: var(--gold);
        padding: 9px 22px;
        border-radius: 24px;
        font-size: 14px;
        font-weight: 700;
        text-decoration: none;
        transition: all .25s;
        font-family: 'Outfit', sans-serif
      }

      .btn-login:hover {
        background: var(--gold);
        color: #fff
      }

      .btn-signup {
        background: var(--gold);
        color: #fff;
        padding: 9px 22px;
        border-radius: 24px;
        font-size: 14px;
        font-weight: 700;
        text-decoration: none;
        transition: all .25s
      }

      .btn-signup:hover {
        background: var(--gold-dark);
        transform: translateY(-1px)
      }

      /* ── HERO ── */
      .hero {
        min-height: 100vh;
        display: flex;
        align-items: center;
        position: relative;
        overflow: hidden;
        padding: 100px 60px 60px
      }

      /* Animated gradient bg blobs */
      .blob {
        position: absolute;
        border-radius: 50%;
        filter: blur(80px);
        animation: blobFloat 8s ease-in-out infinite;
        pointer-events: none
      }

      .blob-1 {
        width: 600px;
        height: 600px;
        background: rgba(212, 175, 55, .12);
        top: -100px;
        right: -100px;
        animation-delay: 0s
      }

      .blob-2 {
        width: 400px;
        height: 400px;
        background: rgba(255, 80, 50, .08);
        bottom: 0;
        left: -80px;
        animation-delay: -3s
      }

      .blob-3 {
        width: 300px;
        height: 300px;
        background: rgba(212, 175, 55, .07);
        top: 40%;
        left: 30%;
        animation-delay: -5s
      }

      @keyframes blobFloat {

        0%,
        100% {
          transform: translate(0, 0) scale(1)
        }

        33% {
          transform: translate(30px, -20px) scale(1.05)
        }

        66% {
          transform: translate(-20px, 15px) scale(.97)
        }
      }

      .hero-content {
        position: relative;
        z-index: 2;
        max-width: 580px
      }

      .hero-pill {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        background: rgba(212, 175, 55, .12);
        border: 1px solid rgba(212, 175, 55, .3);
        border-radius: 20px;
        padding: 6px 16px;
        font-size: 13px;
        font-weight: 600;
        color: var(--gold);
        margin-bottom: 24px
      }

      .pill-dot {
        width: 7px;
        height: 7px;
        background: var(--gold);
        border-radius: 50%;
        animation: blink 1.5s infinite
      }

      @keyframes blink {

        0%,
        100% {
          opacity: 1
        }

        50% {
          opacity: .3
        }
      }

      h1.hero-title {
        font-size: clamp(42px, 6vw, 72px);
        font-weight: 900;
        line-height: 1.08;
        margin-bottom: 20px
      }

      h1.hero-title .highlight {
        color: var(--gold)
      }

      h1.hero-title .italic {
        font-family: 'Playfair Display', serif;
        font-style: italic;
        color: var(--gold)
      }

      .hero-sub {
        font-size: 18px;
        color: var(--text-secondary);
        line-height: 1.6;
        margin-bottom: 36px;
        max-width: 460px
      }

      .hero-btns {
        display: flex;
        gap: 14px;
        flex-wrap: wrap;
        margin-bottom: 48px
      }

      .btn-hero-primary {
        background: var(--gold);
        color: #fff;
        padding: 15px 30px;
        border-radius: 12px;
        font-size: 16px;
        font-weight: 700;
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 8px;
        transition: all .3s;
        box-shadow: 0 8px 30px rgba(212, 175, 55, .35)
      }

      .btn-hero-primary:hover {
        background: var(--gold-dark);
        transform: translateY(-2px);
        box-shadow: 0 12px 40px rgba(212, 175, 55, .45)
      }

      .btn-hero-secondary {
        background: var(--bg-card);
        border: 1px solid var(--border);
        color: var(--text-primary);
        padding: 15px 30px;
        border-radius: 12px;
        font-size: 16px;
        font-weight: 700;
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 8px;
        transition: all .3s
      }

      .btn-hero-secondary:hover {
        border-color: var(--gold);
        color: var(--gold)
      }

      /* STATS */
      .hero-stats {
        display: flex;
        gap: 32px
      }

      .hstat {
        text-align: left
      }

      .hstat-num {
        display: block;
        font-size: 26px;
        font-weight: 800;
        color: var(--text-primary)
      }

      .hstat-lbl {
        font-size: 12px;
        color: var(--text-muted);
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: .06em
      }

      .hstat-divider {
        width: 1px;
        background: var(--border);
        align-self: stretch
      }

      /* FOOD ANIMATION AREA */
      .hero-visual {
        position: absolute;
        right: 0;
        top: 0;
        bottom: 0;
        width: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 1;
        overflow: hidden
      }

      .spline-container {
        width: 100%;
        height: 100%;
        position: relative
      }

      /* Floating food cards (Swiggy-inspired) */
      .food-card-float {
        position: absolute;
        background: var(--bg-card);
        border: 1px solid var(--border);
        border-radius: 16px;
        padding: 12px 16px;
        display: flex;
        align-items: center;
        gap: 10px;
        backdrop-filter: blur(12px);
        box-shadow: 0 8px 32px rgba(0, 0, 0, .25);
        animation: cardFloat 4s ease-in-out infinite
      }

      .food-card-float img {
        width: 44px;
        height: 44px;
        border-radius: 10px;
        object-fit: cover
      }

      .fcard-info .name {
        font-size: 13px;
        font-weight: 700;
        color: var(--text-primary)
      }

      .fcard-info .price {
        font-size: 12px;
        color: var(--gold);
        font-weight: 700
      }

      /* Cards sit on the 3rd ring (r3: 240px radius from plate center) */
      .fc1 {
        top: 22%;
        left: 14%;
        animation-delay: 0s
      }

      .fc2 {
        bottom: 22%;
        left: 14%;
        animation-delay: -1.5s
      }

      .fc3 {
        top: 22%;
        right: 14%;
        animation-delay: -.8s
      }

      .fc4 {
        bottom: 22%;
        right: 14%;
        animation-delay: -2.2s
      }

      @keyframes cardFloat {

        0%,
        100% {
          transform: translateY(0)
        }

        50% {
          transform: translateY(-12px)
        }
      }

      /* Big central plate */
      .center-plate {
        position: relative;
        width: 300px;
        height: 300px;
        margin: auto
      }

      .plate-ring {
        position: absolute;
        border-radius: 50%;
        border: 1px solid rgba(212, 175, 55, .2);
        animation: spin linear infinite
      }

      .plate-ring.r1 {
        inset: -30px;
        animation-duration: 18s
      }

      .plate-ring.r2 {
        inset: -60px;
        border-style: dashed;
        animation-duration: 28s;
        animation-direction: reverse
      }

      .plate-ring.r3 {
        inset: -90px;
        animation-duration: 40s
      }

      @keyframes spin {
        to {
          transform: rotate(360deg)
        }
      }

      .plate-glow {
        position: absolute;
        inset: 0;
        border-radius: 50%;
        background: radial-gradient(circle, rgba(212, 175, 55, .18), transparent 70%);
        animation: glowPulse 3s ease-in-out infinite
      }

      @keyframes glowPulse {

        0%,
        100% {
          opacity: .7;
          transform: scale(1)
        }

        50% {
          opacity: 1;
          transform: scale(1.06)
        }
      }

      .plate-img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        border-radius: 50%;
        position: relative;
        z-index: 2
      }

      /* Sprinkle particles */
      .sprinkle {
        position: absolute;
        border-radius: 50%;
        pointer-events: none;
        animation: sprinkleAnim linear infinite
      }

      @keyframes sprinkleAnim {
        0% {
          opacity: 0;
          transform: translate(0, 0) scale(0) rotate(0deg)
        }

        20% {
          opacity: 1
        }

        80% {
          opacity: .6
        }

        100% {
          opacity: 0;
          transform: translate(var(--tx), var(--ty)) scale(1) rotate(var(--tr))
        }
      }

      /* ── CATEGORIES STRIP (Swiggy style) ── */
      .categories {
        padding: 80px 60px 40px;
        text-align: center
      }

      .section-tag {
        font-size: 12px;
        font-weight: 700;
        letter-spacing: .12em;
        text-transform: uppercase;
        color: var(--gold);
        margin-bottom: 12px
      }

      .section-h2 {
        font-size: 36px;
        font-weight: 800;
        color: var(--text-primary);
        margin-bottom: 40px
      }

      .cat-grid {
        display: flex;
        gap: 18px;
        overflow-x: auto;
        padding-bottom: 12px;
        justify-content: center;
        flex-wrap: wrap
      }

      .cat-card {
        background: var(--bg-card);
        border: 1px solid var(--border);
        border-radius: 20px;
        overflow: hidden;
        text-align: center;
        min-width: 130px;
        cursor: pointer;
        transition: all .3s;
        text-decoration: none;
        display: flex;
        flex-direction: column;
        align-items: center
      }

      .cat-card:hover {
        border-color: var(--gold);
        transform: translateY(-4px);
        box-shadow: 0 12px 32px rgba(212, 175, 55, .15)
      }

      .cat-img-wrap {
        width: 100%;
        height: 88px;
        overflow: hidden;
        position: relative
      }

      .cat-img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform .4s ease
      }

      .cat-card:hover .cat-img {
        transform: scale(1.1)
      }

      .cat-label {
        font-size: 13px;
        font-weight: 700;
        color: var(--text-primary);
        padding: 10px 12px 12px;
        display: block
      }

      /* ── HOW IT WORKS ── */
      .how {
        padding: 80px 60px;
        background: var(--bg-2)
      }

      .steps {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        gap: 32px;
        margin-top: 48px
      }

      .step-card {
        background: var(--bg-card);
        border: 1px solid var(--border);
        border-radius: 20px;
        padding: 32px 24px;
        text-align: center;
        transition: all .3s;
        opacity: 0;
        transform: translateY(30px);
        text-decoration: none;
        display: block;
        cursor: pointer
      }

      .step-card.visible {
        opacity: 1;
        transform: translateY(0);
        transition: opacity .6s ease, transform .6s ease
      }

      .step-card:hover {
        border-color: var(--gold);
        transform: translateY(-6px)
      }

      .step-num {
        width: 48px;
        height: 48px;
        border-radius: 50%;
        background: rgba(212, 175, 55, .12);
        border: 2px solid rgba(212, 175, 55, .3);
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 16px;
        font-size: 20px;
        font-weight: 800;
        color: var(--gold)
      }

      .step-card h3 {
        font-size: 18px;
        font-weight: 700;
        color: var(--text-primary);
        margin-bottom: 10px
      }

      .step-card p {
        font-size: 14px;
        color: var(--text-muted);
        line-height: 1.6
      }

      /* ── MARQUEE STRIP (Zomato-inspired) ── */
      .marquee-wrap {
        padding: 40px 0;
        overflow: hidden;
        background: var(--gold);
        display: flex
      }

      .marquee-track {
        display: flex;
        gap: 40px;
        white-space: nowrap;
        animation: marquee 18s linear infinite
      }

      .marquee-track span {
        font-size: 16px;
        font-weight: 700;
        color: #fff;
        display: flex;
        align-items: center;
        gap: 10px
      }

      @keyframes marquee {
        from {
          transform: translateX(0)
        }

        to {
          transform: translateX(-50%)
        }
      }

      /* ── CTA ── */
      .cta {
        padding: 100px 60px;
        text-align: center;
        position: relative;
        overflow: hidden
      }

      .cta h2 {
        font-size: 48px;
        font-weight: 900;
        margin-bottom: 18px
      }

      .cta p {
        font-size: 18px;
        color: var(--text-secondary);
        margin-bottom: 36px
      }

      /* ── FOOTER ── */
      .footer {
        padding: 40px 60px;
        border-top: 1px solid var(--border);
        display: flex;
        align-items: center;
        justify-content: space-between;
        flex-wrap: wrap;
        gap: 16px
      }

      .footer-logo {
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 18px;
        font-weight: 800;
        color: var(--text-primary)
      }

      .footer-logo img {
        width: 28px;
        height: 28px;
        object-fit: contain
      }

      .footer-copy {
        font-size: 13px;
        color: var(--text-muted)
      }

      /* THEME TOGGLE */
      .theme-toggle-fixed {
        position: fixed;
        bottom: 30px;
        right: 30px;
        z-index: 999;
        background: var(--bg-card);
        border: 1px solid var(--border);
        border-radius: 50px;
        display: flex;
        align-items: center;
        padding: 8px 14px;
        gap: 8px;
        cursor: pointer;
        box-shadow: var(--shadow);
        transition: all .3s
      }

      .theme-toggle-fixed:hover {
        border-color: var(--gold)
      }

      .theme-toggle-fixed .icon {
        font-size: 16px
      }

      @media(max-width:768px) {
        .navbar {
          padding: 16px 24px
        }

        .hero {
          padding: 100px 24px 60px;
          flex-direction: column
        }

        .hero-visual {
          position: relative;
          width: 100%;
          height: 300px
        }

        .categories,
        .how,
        .cta {
          padding: 60px 24px
        }

        h1.hero-title {
          font-size: 38px
        }
      }
    </style>
  </head>

  <body class="hero-page">

    <!-- NAVBAR -->
    <nav class="navbar" id="navbar">
      <a class="logo" href="index.jsp" title="Go to PlateUp Home">
        <img src="assets/images/plateup_logo.png" alt="PlateUp Logo" onerror="this.style.display='none'">
        <span class="logo-text">Plate<span>Up</span></span>
      </a>
      <ul class="nav-links">
        <li><a href="#categories">Menu</a></li>
        <li><a href="#how">How It Works</a></li>
        <li><a href="#cta">Contact</a></li>
      </ul>
      <div class="nav-right">
        <a href="login.jsp" class="btn-login">Login</a>
        <a href="register.jsp" class="btn-signup">Sign Up Free</a>
      </div>
    </nav>

    <!-- HERO -->
    <section class="hero" id="hero">
      <!-- BG BLOBS -->
      <div class="blob blob-1"></div>
      <div class="blob blob-2"></div>
      <div class="blob blob-3"></div>

      <!-- LEFT COPY -->
      <div class="hero-content">
        <div class="hero-pill"><span class="pill-dot"></span>🤖 AI-Powered Food Ordering</div>
        <h1 class="hero-title">
          Hungry?<br>
          <span class="italic">Chat, Order</span><br>
          <span class="highlight">&amp; Enjoy.</span>
        </h1>
        <p class="hero-sub">Browse 120+ dishes, chat with our AI to find exactly what you crave, and get your order
          delivered to your table — fast.</p>
        <div class="hero-btns">
          <a href="login.jsp" class="btn-hero-primary">🍽 Order Now</a>
          <a href="register.jsp" class="btn-hero-secondary">📖 Explore Menu</a>
        </div>
        <div class="hero-stats">
          <div class="hstat"><span class="hstat-num">4.9⭐</span><span class="hstat-lbl">Rating</span></div>
          <div class="hstat-divider"></div>
          <div class="hstat"><span class="hstat-num">30+</span><span class="hstat-lbl">Dishes</span></div>
          <div class="hstat-divider"></div>
          <div class="hstat"><span class="hstat-num">15k+</span><span class="hstat-lbl">Customers</span></div>
        </div>
      </div>

      <!-- RIGHT VISUAL -->
      <div class="hero-visual">
        <div class="center-plate">
          <div class="plate-ring r1"></div>
          <div class="plate-ring r2"></div>
          <div class="plate-ring r3"></div>
          <div class="plate-glow"></div>
          <img class="plate-img" src="assets/images/menu/butter_chicken.png" alt="Signature Dish"
            onerror="this.src='assets/images/food.png'">
          <!-- Sprinkle canvas -->
          <canvas id="sprinkleCanvas"
            style="position:absolute;inset:0;width:100%;height:100%;z-index:3;pointer-events:none;border-radius:50%"></canvas>
        </div>

        <!-- FLOATING FOOD CARDS -->
        <div class="food-card-float fc1">
          <img src="assets/images/menu/paneer_tikka.png" alt="Paneer Tikka">
          <div class="fcard-info">
            <div class="name">Paneer Tikka</div>
            <div class="price">₹280</div>
          </div>
        </div>
        <div class="food-card-float fc2">
          <img src="assets/images/menu/chana_masala.png" alt="Chana Masala">
          <div class="fcard-info">
            <div class="name">Chana Masala</div>
            <div class="price">₹200</div>
          </div>
        </div>
        <div class="food-card-float fc3">
          <img src="assets/images/menu/chicken_biryani.png" alt="Biryani">
          <div class="fcard-info">
            <div class="name">Chicken Biryani</div>
            <div class="price">₹320</div>
          </div>
        </div>
        <div class="food-card-float fc4">
          <img src="assets/images/menu/gulab_jamun.png" alt="Gulab Jamun">
          <div class="fcard-info">
            <div class="name">Gulab Jamun</div>
            <div class="price">₹120</div>
          </div>
        </div>
      </div>
    </section>

    <!-- MARQUEE STRIP -->
    <div class="marquee-wrap">
      <div class="marquee-track" id="marquee">
        <span>🍗 Butter Chicken</span><span>•</span>
        <span>🥬 Palak Paneer</span><span>•</span>
        <span>🍚 Chicken Biryani</span><span>•</span>
        <span>🫘 Chana Masala</span><span>•</span>
        <span>🥩 Mutton Rogan Josh</span><span>•</span>
        <span>🦐 Prawn Masala</span><span>•</span>
        <span>🧀 Paneer Tikka</span><span>•</span>
        <span>🍮 Gulab Jamun</span><span>•</span>
        <span>🍗 Butter Chicken</span><span>•</span>
        <span>🥬 Palak Paneer</span><span>•</span>
        <span>🍚 Chicken Biryani</span><span>•</span>
        <span>🫘 Chana Masala</span><span>•</span>
        <span>🥩 Mutton Rogan Josh</span><span>•</span>
        <span>🦐 Prawn Masala</span><span>•</span>
        <span>🧀 Paneer Tikka</span><span>•</span>
        <span>🍮 Gulab Jamun</span><span>•</span>
      </div>
    </div>

    <!-- CATEGORIES -->
    <section class="categories" id="categories">
      <div class="section-tag">What We Serve</div>
      <h2 class="section-h2">Explore Our Menu</h2>
      <div class="cat-grid">
        <a href="login.jsp" class="cat-card">
          <div class="cat-img-wrap"><img src="assets/images/menu/paneer_tikka.png" class="cat-img" alt="Starters"
              onerror="this.parentElement.innerHTML='<span style=font-size:44px>🍗</span>'"></div>
          <span class="cat-label">Starters</span>
        </a>
        <a href="login.jsp" class="cat-card">
          <div class="cat-img-wrap"><img src="assets/images/menu/butter_chicken.png" class="cat-img" alt="Main Course"
              onerror="this.parentElement.innerHTML='<span style=font-size:44px>🍛</span>'"></div>
          <span class="cat-label">Main Course</span>
        </a>
        <a href="login.jsp" class="cat-card">
          <div class="cat-img-wrap"><img src="assets/images/menu/aloo_paratha.png" class="cat-img" alt="Breads"
              onerror="this.parentElement.innerHTML='<span style=font-size:44px>🫓</span>'"></div>
          <span class="cat-label">Breads</span>
        </a>
        <a href="login.jsp" class="cat-card">
          <div class="cat-img-wrap"><img src="assets/images/menu/gulab_jamun.png" class="cat-img" alt="Desserts"
              onerror="this.parentElement.innerHTML='<span style=font-size:44px>🍮</span>'"></div>
          <span class="cat-label">Desserts</span>
        </a>
        <a href="login.jsp" class="cat-card">
          <div class="cat-img-wrap"><img src="assets/images/menu/mango_lassi.png" class="cat-img" alt="Beverages"
              onerror="this.parentElement.innerHTML='<span style=font-size:44px>🥤</span>'"></div>
          <span class="cat-label">Beverages</span>
        </a>
        <a href="login.jsp" class="cat-card">
          <div class="cat-img-wrap"><img src="assets/images/menu/schezwan_noodles.png" class="cat-img" alt="Chinese"
              onerror="this.parentElement.innerHTML='<span style=font-size:44px>🥡</span>'"></div>
          <span class="cat-label">Chinese</span>
        </a>
        <a href="login.jsp" class="cat-card">
          <div class="cat-img-wrap"><img src="assets/images/menu/palak_paneer.png" class="cat-img" alt="Veg Only"
              onerror="this.parentElement.innerHTML='<span style=font-size:44px>🌿</span>'"></div>
          <span class="cat-label">Veg Only</span>
        </a>
        <a href="login.jsp" class="cat-card">
          <div class="cat-img-wrap"><img src="assets/images/menu/chicken_tikka.png" class="cat-img" alt="Non-Veg"
              onerror="this.parentElement.innerHTML='<span style=font-size:44px>🥩</span>'"></div>
          <span class="cat-label">Non-Veg</span>
        </a>
        <a href="login.jsp" class="cat-card">
          <div class="cat-img-wrap"
            style="background:linear-gradient(135deg,#1a1a2e,#16213e);display:flex;align-items:center;justify-content:center;">
            <span style="font-size:44px">🤖</span></div>
          <span class="cat-label">Ask AI</span>
        </a>
      </div>
    </section>

    <!-- HOW IT WORKS -->
    <section class="how" id="how">
      <div style="text-align:center">
        <div class="section-tag">Simple &amp; Fast</div>
        <h2 class="section-h2">How PlateUp Works</h2>
      </div>
      <div class="steps">
        <a href="login.jsp" class="step-card">
          <div class="step-num">1</div>
          <h3>Login or Register</h3>
          <p>Create a free account in seconds. No credit card required to browse.</p>
          <div style="margin-top:14px;font-size:13px;color:var(--gold);font-weight:700">Get Started →</div>
        </a>
        <a href="login.jsp" class="step-card">
          <div class="step-num">2</div>
          <h3>Chat with AI</h3>
          <p>Tell our AI bot what you're craving — veg, spicy, Chinese, under ₹200 — it instantly shows options.</p>
          <div style="margin-top:14px;font-size:13px;color:var(--gold);font-weight:700">Try the Bot →</div>
        </a>
        <a href="login.jsp" class="step-card">
          <div class="step-num">3</div>
          <h3>Add to Order</h3>
          <p>Tap + Add on any dish. Your order is saved instantly to the kitchen.</p>
          <div style="margin-top:14px;font-size:13px;color:var(--gold);font-weight:700">Order Now →</div>
        </a>
        <a href="login.jsp" class="step-card">
          <div class="step-num">4</div>
          <h3>Scan &amp; Pay</h3>
          <p>Pay via UPI by scanning our QR code. Done in seconds, confirmation immediately.</p>
          <div style="margin-top:14px;font-size:13px;color:var(--gold);font-weight:700">See Payment →</div>
        </a>
      </div>
    </section>

    <!-- CTA -->
    <section class="cta" id="cta">
      <div class="blob blob-1" style="opacity:.5"></div>
      <h2>Ready to <span style="color:var(--gold)">PlateUp</span>?</h2>
      <p>Join 15,000+ customers who order smarter with AI.</p>
      <a href="register.jsp" class="btn-hero-primary" style="display:inline-flex;font-size:18px;padding:18px 40px">🚀
        Get Started Free</a>
    </section>

    <!-- FOOTER -->
    <footer class="footer">
      <div class="footer-logo">
        <img src="assets/images/plateup_logo.png" alt="PlateUp" onerror="this.style.display='none'">
        PlateUp
      </div>
      <span class="footer-copy">© 2025 PlateUp. All rights reserved.</span>
      <span class="footer-copy" style="color:var(--gold)">🍽 Eat Happy.</span>
    </footer>

    <!-- THEME TOGGLE -->
    <button class="theme-toggle-fixed" id="themeToggle" aria-label="Toggle theme">
      <span class="icon sun">☀️</span>
      <span class="track"><span class="thumb"></span></span>
      <span class="icon moon">🌙</span>
    </button>

    <script src="assets/js/theme.js"></script>
    <script>
      // Navbar scroll
      window.addEventListener('scroll', () => {
        document.getElementById('navbar').classList.toggle('scrolled', window.scrollY > 40);
      });

      // Scroll reveal for step cards
      const io = new IntersectionObserver(entries => {
        entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
      }, { threshold: 0.15 });
      document.querySelectorAll('.step-card').forEach(c => io.observe(c));

      // ── SPRINKLE CANVAS ANIMATION ──
      const canvas = document.getElementById('sprinkleCanvas');
      const ctx = canvas.getContext('2d');
      const particles = [];
      const colors = ['#d4af37', '#f0d060', '#ff6b35', '#22c55e', '#fff', '#f97316'];

      function resize() {
        canvas.width = canvas.offsetWidth;
        canvas.height = canvas.offsetHeight;
      }
      resize();
      window.addEventListener('resize', resize);

      function spawnParticle() {
        const cx = canvas.width / 2;
        const cy = canvas.height / 2;
        const angle = Math.random() * Math.PI * 2;
        const speed = 1.2 + Math.random() * 2.5;
        particles.push({
          x: cx, y: cy,
          vx: Math.cos(angle) * speed,
          vy: Math.sin(angle) * speed - 1.5,
          size: 3 + Math.random() * 5,
          color: colors[Math.floor(Math.random() * colors.length)],
          life: 1,
          decay: 0.012 + Math.random() * 0.01,
          gravity: 0.06,
          shape: Math.random() > 0.5 ? 'circle' : 'rect'
        });
      }

      function drawParticles() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        for (let i = particles.length - 1; i >= 0; i--) {
          const p = particles[i];
          p.x += p.vx;
          p.y += p.vy;
          p.vy += p.gravity;
          p.life -= p.decay;
          if (p.life <= 0) { particles.splice(i, 1); continue; }
          ctx.globalAlpha = p.life;
          ctx.fillStyle = p.color;
          ctx.beginPath();
          if (p.shape === 'circle') {
            ctx.arc(p.x, p.y, p.size / 2, 0, Math.PI * 2);
          } else {
            ctx.rect(p.x - p.size / 2, p.y - p.size / 2, p.size, p.size * 0.6);
          }
          ctx.fill();
        }
        ctx.globalAlpha = 1;
      }

      let frame = 0;
      function animate() {
        frame++;
        if (frame % 3 === 0) spawnParticle();
        drawParticles();
        requestAnimationFrame(animate);
      }
      animate();
    </script>
  </body>

  </html>