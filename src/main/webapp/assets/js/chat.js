/* ============================================================
   chat.js — AI Menu Chatbot v3
   Smart intents: contextual/weather/mood + fuzzy typo correction
   ============================================================ */

// ─── FUZZY MATCH ENGINE (Levenshtein) ────────────────────────
function levenshtein(a, b) {
  const m = a.length, n = b.length;
  const dp = [];
  for (let i = 0; i <= m; i++) {
    dp[i] = [i];
    for (let j = 1; j <= n; j++) dp[i][j] = i === 0 ? j : 0;
  }
  for (let i = 1; i <= m; i++)
    for (let j = 1; j <= n; j++)
      dp[i][j] = a[i-1] === b[j-1] ? dp[i-1][j-1]
        : 1 + Math.min(dp[i-1][j], dp[i][j-1], dp[i-1][j-1]);
  return dp[m][n];
}

// Returns the closest matching menu item for a user-typed name
function fuzzyFindItem(userInput) {
  const all = [...MENU.veg, ...MENU.nonveg, ...MENU.chinese, ...MENU.beverages];
  const inp = userInput.toLowerCase().trim();
  let best = null, bestScore = Infinity;
  all.forEach(function(item) {
    const name = item.name.toLowerCase();
    if (name.includes(inp) || inp.includes(name)) { best = item; bestScore = -1; return; }
    const nWords = name.split(' '), iWords = inp.split(' ');
    let total = 0;
    nWords.forEach(function(nw) {
      var minD = Infinity;
      iWords.forEach(function(iw) { minD = Math.min(minD, levenshtein(nw, iw)); });
      total += minD;
    });
    const score = total / nWords.length;
    if (score < bestScore) { bestScore = score; best = item; }
  });
  return bestScore <= 2.5 ? best : null;
}

// ─── MENU DATA ───────────────────────────────────────────────
const MENU = {
  veg: [
    { name: "Paneer Tikka",    desc: "Marinated cottage cheese, charcoal grill",    price: 280, cal: 320, img: "../assets/images/menu/paneer_tikka.png" },
    { name: "Dal Makhani",     desc: "Black lentils slow-cooked overnight",          price: 220, cal: 280, img: "../assets/images/menu/dal_makhani.png" },
    { name: "Veg Biryani",     desc: "Basmati rice, seasonal vegetables, dum",       price: 260, cal: 350, img: "../assets/images/menu/veg_biryani.png" },
    { name: "Palak Paneer",    desc: "Cottage cheese in creamy spinach gravy",       price: 240, cal: 290, img: "../assets/images/menu/palak_paneer.png" },
    { name: "Aloo Paratha",    desc: "Spiced potato stuffed flatbread + butter",     price: 160, cal: 310, img: "../assets/images/menu/aloo_paratha.png" },
    { name: "Mushroom Masala", desc: "Button mushrooms in tomato-based gravy",       price: 230, cal: 220, img: "../assets/images/menu/mushroom_masala.png" },
    { name: "Chana Masala",    desc: "Chickpea curry with aromatic spices",          price: 200, cal: 260, img: "../assets/images/menu/chana_masala.png" },
    { name: "Gulab Jamun",     desc: "Soft milk solids in rose sugar syrup",         price: 120, cal: 180, img: "../assets/images/menu/gulab_jamun.png" },
  ],
  nonveg: [
    { name: "Butter Chicken",    desc: "Tender chicken in rich tomato-butter sauce", price: 340, cal: 480, img: "../assets/images/menu/butter_chicken.png" },
    { name: "Mutton Rogan Josh", desc: "Slow-cooked Kashmiri mutton curry",          price: 420, cal: 520, img: "../assets/images/menu/mutton_rogan_josh.png" },
    { name: "Chicken Biryani",   desc: "Dum biryani with whole spices & saffron",    price: 320, cal: 560, img: "../assets/images/menu/chicken_biryani.png" },
    { name: "Fish Curry",        desc: "Coastal style curry with coconut milk",       price: 360, cal: 390, img: "../assets/images/menu/fish_curry.png" },
    { name: "Chicken Tikka",     desc: "Tandoor-grilled marinated chicken pieces",    price: 300, cal: 340, img: "../assets/images/menu/chicken_tikka.png" },
    { name: "Mutton Keema",      desc: "Minced mutton with ginger, peas & spices",   price: 380, cal: 460, img: "../assets/images/menu/mutton_keema.png" },
    { name: "Prawn Masala",      desc: "Juicy prawns in spicy Goan masala",           price: 440, cal: 380, img: "../assets/images/menu/prawn_masala.png" },
    { name: "Egg Curry",         desc: "Boiled eggs in tangy onion-tomato gravy",     price: 200, cal: 290, img: "../assets/images/menu/egg_curry.png" },
  ],
  chinese: [
    { name: "Schezwan Noodles",   desc: "Fiery schezwan noodles with veggies & spring onions", price: 220, cal: 420, img: "../assets/images/menu/schezwan_noodles.png",  veg: true },
    { name: "Chilli Paneer",      desc: "Crispy paneer in bold Indo-Chinese chilli sauce",      price: 280, cal: 380, img: "../assets/images/menu/chilli_paneer.png",      veg: true },
    { name: "Veg Spring Rolls",   desc: "Golden crispy rolls stuffed with spiced vegetables",   price: 180, cal: 290, img: "../assets/images/menu/spring_rolls.png",        veg: true },
    { name: "Hakka Noodles",      desc: "Stir-fried noodles with cabbage, carrots & soy sauce", price: 200, cal: 360, img: "../assets/images/menu/hakka_noodles.png",      veg: true },
    { name: "Veg Fried Rice",     desc: "Wok-tossed basmati rice with veggies & sesame oil",    price: 210, cal: 390, img: "../assets/images/menu/veg_fried_rice_chinese.png", veg: true },
    { name: "Honey Chilli Potato",desc: "Crispy potato in sweet-spicy honey chilli glaze",       price: 190, cal: 330, img: "../assets/images/menu/schezwan_noodles.png",  veg: true },
    { name: "Chicken Manchurian", desc: "Crispy chicken balls in dark glossy manchurian sauce", price: 300, cal: 460, img: "../assets/images/menu/chicken_manchurian.png", veg: false },
    { name: "Kung Pao Chicken",   desc: "Spicy stir-fry with peanuts & dried red chilies",      price: 320, cal: 490, img: "../assets/images/menu/kung_pao_chicken.png",   veg: false },
    { name: "Chicken Fried Rice", desc: "Classic wok-tossed rice with chicken strips & egg",    price: 280, cal: 510, img: "../assets/images/menu/hakka_noodles.png",       veg: false },
  ],
  beverages: [
    { name: "Mango Lassi",      desc: "Thick chilled yogurt blended with Alphonso mango & saffron", price: 120, cal: 180, img: "../assets/images/menu/mango_lassi.png" },
    { name: "Masala Chai",      desc: "Aromatic spiced tea with cardamom, ginger & cinnamon",        price: 60,  cal: 80,  img: "../assets/images/menu/masala_chai.png" },
    { name: "Cold Coffee",      desc: "Iced coffee with whipped cream, chocolate drizzle & foam",    price: 140, cal: 220, img: "../assets/images/menu/cold_coffee.png" },
    { name: "Fresh Lime Soda",  desc: "Sparkling lime soda with mint & chaat masala — sweet/salted", price: 80,  cal: 60,  img: "../assets/images/menu/fresh_lime_soda.png" },
    { name: "Watermelon Juice", desc: "Cold-pressed watermelon juice with a pinch of black salt",    price: 90,  cal: 90,  img: "../assets/images/menu/watermelon_juice.png" },
  ]
};

// ─── INTENT DETECTION ────────────────────────────────────────
function detectIntent(msg) {
  const m = msg.toLowerCase().trim();
  // Add with number → server-side
  if (/\badd\b/.test(m) && /\d/.test(m)) return 'server';
  // Add without number → fuzzy client-side
  if (/^add\b/.test(m)) return 'fuzzy_add';
  // Contextual / weather / mood
  if (/(hot weather|too hot|feeling hot|summer|humid|scorching|sweating|heat wave|boiling)/.test(m)) return 'weather_hot';
  if (/(cold weather|too cold|winter|chilly|freezing|raining|foggy|shivering)/.test(m)) return 'weather_cold';
  if (/(sweet|dessert|something sweet|craving sweet|sugar|mithai|gulab)/.test(m)) return 'sweet';
  if (/(extra spicy|very spicy|spice lover|spicy food|fire|mirchi)/.test(m)) return 'spicy_food';
  if (/(tired|exhausted|long day|hard day|stressed|work stress|rough day)/.test(m)) return 'tired';
  if (/(party|celebration|birthday|anniversary|group order|friends coming|get together)/.test(m)) return 'party';
  if (/(quick|fast|hurry|in a rush|hungry now|no time|quickly)/.test(m)) return 'quick';
  if (/(bored|lazy day|free time|nothing to eat|suggest something)/.test(m)) return 'bored';
  // Standard intents
  if (/(full menu|show menu|\bmenu\b|all dishes|see menu|everything)/.test(m)) return 'full_menu';
  if (/(chinese|schezwan|manchurian|noodle|fried rice|chilli paneer|hakka|spring roll|kung pao|honey chilli)/.test(m)) return 'chinese';
  if (/(beverage|drink|juice|lassi|chai|coffee|soda|cold drink|thirst|refreshing)/.test(m)) return 'beverages';
  if (/(non.?veg|chicken|mutton|fish|\begg\b|prawn|meat|seafood)/.test(m)) return 'nonveg';
  if (/(\bveg\b|vegetarian|veg only|plant.based)/.test(m)) return 'veg';
  if (/(healthy|low.?cal|diet|light food|fitness|low fat|nutritious|weight)/.test(m)) return 'healthy';
  if (/(budget|cheap|afford|cheapest|economical|under 200|pocket friendly)/.test(m)) return 'budget';
  if (/(mood|comfort|sad|happy|celebrat|date night|romantic|chill|cozy)/.test(m)) return 'mood';
  if (/(breakfast|morning|lunch|afternoon|dinner|evening|late night|midnight)/.test(m)) return 'time_based';
  if (/(allerg|gluten|nut free|dairy free|intolerant|lactose)/.test(m)) return 'allergy';
  if (/(today.?s? special|chef.?s pick|recommend|signature dish)/.test(m)) return 'special';
  if (/(order status|\bstatus\b|my order|\bcart\b|what.?s in my)/.test(m)) return 'status';
  if (/(\bhello\b|\bhi\b|\bhey\b|good morning|good evening|namaste)/.test(m)) return 'greet';
  if (/(thank you|\bthanks\b|\bthx\b)/.test(m)) return 'thanks';
  if (/(\bhelp\b|what can you|how to use|\boptions\b)/.test(m)) return 'help';
  if (/(\bprice\b|\bcost\b|how much|\brate\b)/.test(m)) return 'prices';
  if (/(\bhours\b|\bopen\b|\btiming\b|when.*open|\bclose\b|location|\bwhere\b|address|wifi|parking)/.test(m)) return 'about';
  return 'server';
}

// ─── CARD BUILDER ────────────────────────────────────────────
function buildMenuCards(items, type) {
  const container = document.createElement('div');
  container.className = 'menu-cards';
  items.forEach(item => {
    const safeId = item.name.replace(/\s/g, '-').replace(/['"]/g, '');
    const dotClass = type === 'veg' ? 'veg' : type === 'beverages' ? 'veg' : item.veg === true ? 'veg' : 'nonveg';
    const card = document.createElement('div');
    card.className = 'menu-card';
    card.innerHTML = `
      <div class="menu-card-left">
        <div class="fssai-dot ${dotClass}"></div>
        <div class="menu-thumb-wrap">
          <img class="menu-thumb" src="${item.img}" alt="${item.name}"
               onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
          <div class="menu-thumb-fallback" style="display:none">${type === 'beverages' ? '🥤' : dotClass === 'veg' ? '🌿' : '🍗'}</div>
        </div>
        <div class="menu-card-info">
          <h4>${item.name}</h4>
          <p>${item.desc}</p>
          ${item.cal ? `<span class="cal-badge">🔥 ${item.cal} kcal</span>` : ''}
        </div>
      </div>
      <div class="menu-card-right">
        <span class="menu-price">₹${item.price}</span>
        <button class="add-btn"
          onclick="addToCart('${item.name.replace(/'/g,"\\'").replace(/"/g,'\\"')}', ${item.price})"
          id="add-${safeId}">+ Add</button>
      </div>
    `;
    container.appendChild(card);
  });
  return container;
}

function buildSectionTitle(text) {
  const el = document.createElement('div');
  el.className = 'menu-section-title';
  el.textContent = text;
  return el;
}

function appendMenuSection(title, items, type) {
  const chatBox = document.getElementById('chatBox');
  const section = document.createElement('div');
  section.className = 'message bot';
  section.innerHTML = '<span class="msg-avatar">🤖</span>';
  const content = document.createElement('div');
  content.className = 'msg-content';
  content.appendChild(buildSectionTitle(title));
  content.appendChild(buildMenuCards(items, type));
  section.appendChild(content);
  chatBox.appendChild(section);
  chatBox.scrollTop = chatBox.scrollHeight;
}

// ─── INTENT HANDLERS ─────────────────────────────────────────
function handleLocalIntent(intent) {
  const chatBox = document.getElementById('chatBox');

  if (intent === 'full_menu') {
    appendBotMessage(`🍽️ **Full Menu — PlateUp**\n\nHere's everything we serve today. Tap **+ Add** to order!`);
    setTimeout(() => { appendMenuSection('🌿 Vegetarian',    MENU.veg,       'veg');      }, 200);
    setTimeout(() => { appendMenuSection('🍗 Non-Vegetarian', MENU.nonveg,   'nonveg');   }, 400);
    setTimeout(() => { appendMenuSection('🥡 Chinese',        MENU.chinese,  'chinese');  }, 600);
    setTimeout(() => { appendMenuSection('🥤 Beverages',      MENU.beverages,'beverages');}, 800);
    return true;
  }

  if (intent === 'veg') {
    appendBotMessage('🌿 **Vegetarian Dishes**\n\nFreshly prepared, FSSAI certified:');
    setTimeout(() => appendMenuSection('🌿 Veg Dishes', MENU.veg, 'veg'), 300);
    return true;
  }

  if (intent === 'nonveg') {
    appendBotMessage('🍗 **Non-Vegetarian Dishes**\n\nPremium cuts, freshly prepared:');
    setTimeout(() => appendMenuSection('🍗 Non-Veg Dishes', MENU.nonveg, 'nonveg'), 300);
    return true;
  }

  if (intent === 'chinese') {
    appendBotMessage('🥡 **Chinese Menu**\n\nIndo-Chinese specialties — bold flavours, wok-tossed fresh:');
    const vegChinese = MENU.chinese.filter(i => i.veg);
    const nonvegChinese = MENU.chinese.filter(i => !i.veg);
    setTimeout(() => appendMenuSection('🌿 Veg Chinese', vegChinese, 'veg'), 300);
    setTimeout(() => appendMenuSection('🍗 Non-Veg Chinese', nonvegChinese, 'nonveg'), 500);
    return true;
  }

  if (intent === 'beverages') {
    appendBotMessage('🥤 **Beverages**\n\nRefreshing drinks to go with your meal:');
    setTimeout(() => appendMenuSection('🥤 Cold Drinks & More', MENU.beverages, 'beverages'), 300);
    return true;
  }

  if (intent === 'healthy') {
    const healthy = [
      ...MENU.veg.filter(i => i.cal <= 290),
      ...MENU.beverages.filter(i => i.cal <= 100)
    ];
    appendBotMessage('🥗 **Healthy Picks**\n\nLight, nutritious options under 300 kcal — great for a balanced meal:');
    setTimeout(() => appendMenuSection('🥗 Healthy Options', healthy, 'veg'), 300);
    return true;
  }

  if (intent === 'budget') {
    const cheap = [
      ...MENU.veg.filter(i => i.price <= 200),
      ...MENU.beverages.filter(i => i.price <= 100),
      ...MENU.chinese.filter(i => i.price <= 200)
    ];
    appendBotMessage('💰 **Budget-Friendly Picks**\n\nDelicious meals under ₹200:');
    setTimeout(() => appendMenuSection('💰 Under ₹200', cheap, 'veg'), 300);
    return true;
  }

  if (intent === 'mood') {
    const picks = [MENU.veg[0], MENU.nonveg[0], MENU.nonveg[2], MENU.veg[7]];
    appendBotMessage('🌟 **Comfort Food Picks**\n\nWhatever your mood — these always hit the spot 😊:');
    setTimeout(() => appendMenuSection('🌟 Comfort Favourites', picks, 'mixed'), 300);
    return true;
  }

  if (intent === 'time_based') {
    const hour = new Date().getHours();
    let picks, label, heading;
    if (hour < 11) {
      picks = [MENU.veg[4], MENU.beverages[1], MENU.beverages[2]];
      label = '🌅 Good Morning Picks'; heading = 'Perfect for breakfast!';
    } else if (hour < 16) {
      picks = [MENU.veg[2], MENU.nonveg[2], MENU.beverages[0], MENU.chinese[3]];
      label = '☀️ Lunch Specials'; heading = 'Power up your afternoon!';
    } else if (hour < 21) {
      picks = [MENU.nonveg[0], MENU.veg[0], MENU.chinese[0], MENU.beverages[4]];
      label = '🌆 Dinner Favourites'; heading = 'Perfect for a satisfying dinner!';
    } else {
      picks = [MENU.veg[6], MENU.nonveg[7], MENU.beverages[1]];
      label = '🌙 Late Night Bites'; heading = 'Light options for the night owl!';
    }
    appendBotMessage(`⏰ **${label}**\n\n${heading}`);
    setTimeout(() => appendMenuSection(label, picks, 'mixed'), 300);
    return true;
  }

  if (intent === 'allergy') {
    const safe = [...MENU.veg.filter(i => i.name !== 'Aloo Paratha'), ...MENU.beverages];
    appendBotMessage('⚠️ **Allergy-Safe Options**\n\nHere are our gluten-free & nut-free friendly items. Always let our staff know about specific allergies:');
    setTimeout(() => appendMenuSection('✅ Allergy-Friendly', safe, 'veg'), 300);
    return true;
  }

  if (intent === 'special') {
    const picks = [MENU.veg[0], MENU.nonveg[0], MENU.nonveg[2], MENU.chinese[1]];
    appendBotMessage("⭐ **Today's Chef's Picks**\n\nHandpicked by our head chef:");
    setTimeout(() => appendMenuSection("⭐ Chef's Specials", picks, 'mixed'), 300);
    return true;
  }

  if (intent === 'status') {
    const cart = window.SS_CART || [];
    if (cart.length === 0) {
      appendBotMessage("🛒 Your cart is empty.\n\nType **show menu** to browse. Use **+ Add** on any dish to order!");
    } else {
      let summary = "🛒 **Your Current Cart**\n\n";
      let total = 0;
      cart.forEach(item => {
        summary += `• ${item.name} ×${item.qty}  —  ₹${item.price * item.qty}\n`;
        total += item.price * item.qty;
      });
      summary += `\n**Total: ₹${total}**\n\nHead to **My Order** to checkout!`;
      appendBotMessage(summary);
    }
    return true;
  }

  if (intent === 'greet') {
    const name = window.SS_USER || 'Guest';
    appendBotMessage(`Hey **${name}**! 👋 Welcome to PlateUp!\n\nI can help you:\n• **show menu** — full menu with images\n• **chinese food** — Indo-Chinese section 🥡\n• **beverages** — cold drinks & chai 🥤\n• **healthy food** — low-cal options 🥗\n• **budget picks** — under ₹200 💰\n• **add 2 Paneer Tikka** — to place order\n\nWhat would you like today?`);
    return true;
  }

  if (intent === 'thanks') {
    appendBotMessage("You're most welcome! 😊 Enjoy your meal at PlateUp. Anything else?");
    return true;
  }

  if (intent === 'help') {
    appendBotMessage("🤖 **What I can do:**\n\n• **show menu** — Full menu\n• **veg / non-veg** — Filter by type\n• **chinese food** — Chinese section 🥡\n• **beverages / cold drink** — Drinks 🥤\n• **healthy food** — Low calorie picks\n• **budget picks** — Under ₹200\n• **today's special** — Chef's picks\n• **add 2 Paneer Tikka** — Add to cart\n• **order status** — See your cart");
    return true;
  }

  if (intent === 'prices') {
    appendBotMessage("💰 **Price Range at PlateUp**\n\n🌿 Veg: ₹120 – ₹280\n🍗 Non-Veg: ₹200 – ₹440\n🥡 Chinese: ₹180 – ₹320\n🥤 Beverages: ₹60 – ₹140\n\nType **show menu** to see full pricing!");
    return true;
  }

  if (intent === 'about') {
    appendBotMessage("📍 **PlateUp Restaurant**\n\n🕐 Hours: Mon–Fri 11AM–11PM | Sat–Sun 10AM–11:30PM\n📶 Free WiFi available\n🅿️ Parking available\n\nFor reservations or queries, speak to our staff. Enjoy your visit! 🍽️");
    return true;
  }

  if (intent === 'weather_hot') {
    const cold = [...MENU.beverages, MENU.veg.find(i => i.name==='Gulab Jamun')].filter(Boolean);
    appendBotMessage('☀️ **Yes, it\'s really hot today!** 🥵\n\nFor your refreshment, here are some cool drinks & light bites perfect for beating the heat:');
    setTimeout(() => appendMenuSection('🧊 Cool Down Picks', cold, 'beverages'), 300);
    return true;
  }
  if (intent === 'weather_cold') {
    const warm = [MENU.beverages[1], MENU.nonveg[0], MENU.veg[1], MENU.veg[3]].filter(Boolean);
    appendBotMessage('🌧️ **Cold & cozy weather!** Perfect for something warm ☕\n\nHere are our best comfort picks to warm you right up:');
    setTimeout(() => appendMenuSection('☕ Warm Comfort Picks', warm, 'mixed'), 300);
    return true;
  }
  if (intent === 'sweet') {
    const sweets = [MENU.veg[7], MENU.beverages[0], MENU.beverages[2]].filter(Boolean);
    appendBotMessage('🍬 **Sweet tooth calling!** 😋\n\nHere are our sweetest picks just for you:');
    setTimeout(() => appendMenuSection('🍮 Sweet Treats', sweets, 'veg'), 300);
    return true;
  }
  if (intent === 'spicy_food') {
    const spicy = [MENU.nonveg[1], MENU.chinese[0], MENU.chinese[7], MENU.nonveg[6]].filter(Boolean);
    appendBotMessage('🌶️ **Ohh, you like it HOT!** 🔥\n\nBrace yourself — these are our most fiery picks:');
    setTimeout(() => appendMenuSection('🌶️ Extra Spicy Picks', spicy, 'nonveg'), 300);
    return true;
  }
  if (intent === 'tired') {
    const comfort = [MENU.nonveg[0], MENU.veg[1], MENU.beverages[1], MENU.veg[0]].filter(Boolean);
    appendBotMessage('😮‍💨 **Tough day? You deserve a treat!** 🤗\n\nHere\'s some comfort food — proven to make everything better:');
    setTimeout(() => appendMenuSection('🫂 Comfort Food', comfort, 'mixed'), 300);
    return true;
  }
  if (intent === 'party') {
    const party = [MENU.veg[0], MENU.nonveg[4], MENU.chinese[1], MENU.nonveg[2], MENU.beverages[0]].filter(Boolean);
    appendBotMessage('🎉 **Party time!** 🥳 Let\'s get the spread ready!\n\nHere\'s a curated party platter — starters, mains & drinks:');
    setTimeout(() => appendMenuSection('🎊 Party Platter', party, 'mixed'), 300);
    return true;
  }
  if (intent === 'quick') {
    const quick = [MENU.veg[4], MENU.veg[6], MENU.chinese[2], MENU.beverages[3]].filter(Boolean);
    appendBotMessage('⚡ **In a hurry?** No worries — these are our quickest-to-serve items! 🏃');
    setTimeout(() => appendMenuSection('⚡ Quick Bites', quick, 'mixed'), 300);
    return true;
  }
  if (intent === 'bored') {
    const fun = [MENU.chinese[0], MENU.chinese[1], MENU.beverages[2], MENU.veg[0]].filter(Boolean);
    appendBotMessage('😴 **Bored? Let\'s fix that!** 🎉\n\nTreat yourself to something fun & flavour-packed:');
    setTimeout(() => appendMenuSection('🎯 Beat the Boredom', fun, 'mixed'), 300);
    return true;
  }
  return false;
}

// ─── CART MANAGEMENT ─────────────────────────────────────────
function addToCart(name, price, qty) {
  qty = qty || 1;
  const cart = window.SS_CART;
  const existing = cart.find(i => i.name === name);
  if (existing) { existing.qty += qty; } else { cart.push({ name, price, qty }); }
  updateCartBadge();

  const safeId = name.replace(/\s/g, '-').replace(/['"]/g, '');
  const btn = document.getElementById('add-' + safeId);
  if (btn) { btn.textContent = '⏳'; btn.disabled = true; }

  fetch('../chat', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: 'message=' + encodeURIComponent('add ' + qty + ' ' + name)
  })
  .then(function(res) { return res.text(); })
  .then(function(reply) {
    if (btn) { btn.textContent = '✓'; btn.style.background = '#22c55e'; btn.disabled = false; }
    setTimeout(function() { if (btn) { btn.textContent = '+ Add'; btn.style.background = ''; } }, 1600);
    const totalQty = cart.reduce(function(s,i) { return s + i.qty; }, 0);
    appendBotMessage('✅ **' + (qty > 1 ? qty + 'x ' : '') + name + '** added to cart!\n\n🛒 ' + totalQty + ' item(s) · Go to **My Order** to checkout.');
  })
  .catch(function() {
    if (btn) { btn.textContent = '+ Add'; btn.disabled = false; }
    appendBotMessage('⚠️ Couldn\'t reach server. Try again!');
  });
}

function updateCartBadge() {
  const badge = document.getElementById('cartBadge');
  const total = (window.SS_CART || []).reduce((s,i) => s + i.qty, 0);
  badge.textContent = total;
  badge.style.display = total > 0 ? 'flex' : 'none';
}

// ─── MESSAGE RENDERING ────────────────────────────────────────
function appendUserMessage(text) {
  const chatBox = document.getElementById('chatBox');
  const msg = document.createElement('div');
  msg.className = 'message user';
  msg.innerHTML = `<div class="msg-content">${escapeHtml(text)}</div><span class="msg-avatar">👤</span>`;
  chatBox.appendChild(msg);
  chatBox.scrollTop = chatBox.scrollHeight;
}

function appendBotMessage(text) {
  const chatBox = document.getElementById('chatBox');
  const msg = document.createElement('div');
  msg.className = 'message bot';
  const content = document.createElement('div');
  content.className = 'msg-content';
  content.innerHTML = text.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>').replace(/\n/g, '<br>');
  msg.innerHTML = '<span class="msg-avatar">🤖</span>';
  msg.appendChild(content);
  chatBox.appendChild(msg);
  chatBox.scrollTop = chatBox.scrollHeight;
}

function showTyping() {
  const chatBox = document.getElementById('chatBox');
  const msg = document.createElement('div');
  msg.className = 'message bot';
  msg.id = 'typingIndicator';
  msg.innerHTML = `<span class="msg-avatar">🤖</span><div class="msg-content"><div class="typing-dots"><span></span><span></span><span></span></div></div>`;
  chatBox.appendChild(msg);
  chatBox.scrollTop = chatBox.scrollHeight;
  return msg;
}

function removeTyping() {
  const el = document.getElementById('typingIndicator');
  if (el) el.remove();
}

function escapeHtml(str) {
  return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}

// ─── SMART DISH SUGGESTION AFTER AI REPLY ────────────────────
function findAndShowMentionedDishes(aiText) {
  const allItems = [...MENU.veg, ...MENU.nonveg, ...MENU.chinese, ...MENU.beverages];
  const mentioned = allItems.filter(item => aiText.toLowerCase().includes(item.name.toLowerCase()));
  if (mentioned.length > 0 && mentioned.length <= 4) {
    setTimeout(() => {
      const chatBox = document.getElementById('chatBox');
      const section = document.createElement('div');
      section.className = 'message bot';
      section.innerHTML = '<span class="msg-avatar">🤖</span>';
      const content = document.createElement('div');
      content.className = 'msg-content';
      content.appendChild(buildSectionTitle('🍽️ Mentioned Dishes'));
      content.appendChild(buildMenuCards(mentioned, 'mixed'));
      section.appendChild(content);
      chatBox.appendChild(section);
      chatBox.scrollTop = chatBox.scrollHeight;
    }, 400);
  }
}

// ─── MAIN SEND ────────────────────────────────────────────────
function sendMessage() {
  const input = document.getElementById('messageInput');
  const message = input.value.trim();
  if (!message) return;
  appendUserMessage(message);
  input.value = '';
  const intent = detectIntent(message);

  // ── FUZZY ADD: "add pannr tika" → corrects to "Paneer Tikka" ──
  if (intent === 'fuzzy_add' || (intent === 'server' && /^add\s/i.test(message))) {
    const raw = message.replace(/^add\s+\d*\s*/i, '').trim();
    if (raw.length > 1) {
      const match = fuzzyFindItem(raw);
      if (match) {
        const isExact = match.name.toLowerCase().includes(raw.toLowerCase());
        if (!isExact) {
          appendBotMessage('🔍 Did you mean **' + match.name + '**? Adding it for you! 😊');
        }
        const qtyM = message.match(/\d+/);
        addToCart(match.name, match.price, qtyM ? parseInt(qtyM[0]) : 1);
        return;
      }
    }
  }

  // ── LOCAL INTENT (menus, weather, mood, etc.) ──
  if (intent !== 'server' && intent !== 'fuzzy_add') {
    handleLocalIntent(intent);
    return;
  }

  // ── FALLBACK: Gemini AI via server ──
  const typing = showTyping();
  fetch('../chat', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: 'message=' + encodeURIComponent(message)
  })
  .then(function(res) { return res.text(); })
  .then(function(data) {
    removeTyping();
    const reply = data || "I'm not sure about that. Try **show menu**, **chinese food**, or **beverages**!";
    appendBotMessage(reply);
    findAndShowMentionedDishes(reply);
  })
  .catch(function() {
    removeTyping();
    appendBotMessage('⚠️ Server unavailable. Try: **show menu**, **veg**, **chinese food**, or **beverages**.');
  });
}

function sendQuick(text) {
  document.getElementById('messageInput').value = text;
  sendMessage();
}

function clearChat() {
  const chatBox = document.getElementById('chatBox');
  chatBox.innerHTML = '';
  const name = window.SS_USER || 'there';
  appendBotMessage(`Chat cleared! 🧹\n\nHey **${name}**, I'm still here. What would you like?`);
}

document.addEventListener('DOMContentLoaded', () => {
  const input = document.getElementById('messageInput');
  if (input) input.addEventListener('keypress', e => { if (e.key === 'Enter') sendMessage(); });
});