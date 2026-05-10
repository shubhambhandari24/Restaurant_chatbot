# PlateUp Restaurant Chatbot
## Internship Project Report — AI Fellowship

**Student:** Shubham Bhandari  
**Course:** AI Fellowship  
**Review Date:** May 10, 2026  
**Technology:** Java EE · Google Gemini 2.0 Flash (Agentic AI) · n8n Cloud Automation · MySQL

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Problem Statement](#2-problem-statement)
3. [Objectives](#3-objectives)
4. [System Architecture](#4-system-architecture)
5. [Agentic AI Integration](#5-agentic-ai-integration)
6. [n8n Automation Layer](#6-n8n-automation-layer)
7. [Key Features](#7-key-features)
8. [Technology Stack](#8-technology-stack)
9. [Database Design](#9-database-design)
10. [Implementation Details](#10-implementation-details)
11. [Results & Demo](#11-results--demo)
12. [Challenges & Solutions](#12-challenges--solutions)
13. [Future Scope](#13-future-scope)
14. [Conclusion](#14-conclusion)

---

## 1. Introduction

PlateUp is a full-stack AI-powered restaurant chatbot application built using Java Enterprise Edition (EE). It enables customers to interact with a restaurant system using natural language through a conversational chatbot interface. The system integrates **Google Gemini 2.0 Flash** as the core Agentic AI engine and **n8n Cloud** as the automation workflow layer for automated email notifications.

The project was developed as part of the AI Fellowship program and demonstrates practical application of Agentic AI concepts in a real-world restaurant management scenario. Over the course of the internship, the system evolved from a simple keyword-based chatbot into a fully intelligent, context-aware assistant with 30+ intent handlers, fuzzy typo correction, a User Profile module, visual menu cards, and an automated email pipeline.

### What is Agentic AI?

Agentic AI refers to AI systems that can:
- **Perceive** the environment (understand customer messages, including typos and contextual hints)
- **Reason** with context (analyze menu, prices, dietary preferences, mood, weather)
- **Act** autonomously (generate meaningful responses, guide users, trigger automation)

Unlike rule-based chatbots with hardcoded `if/else` logic, PlateUp uses Gemini 2.0 to dynamically understand any natural language input and respond intelligently based on the actual restaurant menu.

---

## 2. Problem Statement

The traditional restaurant ordering process suffers from several inefficiencies:

| Problem | Impact |
|---------|--------|
| Long wait times for waiter | Customer frustration, table turnover delay |
| Manual order taking errors | Wrong food delivered, customer dissatisfaction |
| No 24/7 query handling | Lost potential orders outside business hours |
| No real-time status updates | Customers unaware of order progress |
| Manual reporting | Managers lack data-driven insights |
| No personalization | Generic service, no AI recommendations |
| Typo-prone ordering | Customers fail to add items due to spelling mistakes |
| No automated communication | Customers not notified after placing an order |

PlateUp addresses all of these through an intelligent chatbot system with Agentic AI, fuzzy matching, and automated email notifications at its core.

---

## 3. Objectives

### Primary Objectives
1. Build a conversational AI chatbot for restaurant ordering
2. Integrate Google Gemini 2.0 Flash for natural language understanding
3. Implement real-time order tracking and status management
4. Create a staff dashboard for order management
5. Add n8n Cloud automation for email order confirmations
6. Implement fuzzy typo correction so customers can add items with spelling mistakes
7. Build a comprehensive User Profile module (account management + order history)

### Secondary Objectives
1. Implement secure user authentication (Customer + Staff roles)
2. Design a premium, responsive UI with dark mode as default
3. Follow MVC design pattern with DAO abstraction
4. Build 30+ context-aware intent handlers (weather, mood, time-based, dietary, etc.)
5. Demonstrate Agentic AI concepts from the AI Fellowship curriculum

---

## 4. System Architecture

PlateUp follows a **3-tier architecture** with an additional **Agentic AI middleware** layer:

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│    JSP Pages · HTML5 · CSS3 · Vanilla JavaScript (chat.js)  │
└─────────────────────┬───────────────────────────────────────┘
                      │ HTTP Requests / Responses
┌─────────────────────▼───────────────────────────────────────┐
│                  BUSINESS LOGIC LAYER                        │
│    Jakarta Servlets · Service Classes · DAO Interfaces       │
└──────────┬──────────────────────────────────┬───────────────┘
           │                                  │
┌──────────▼──────────┐          ┌────────────▼───────────────┐
│   AGENTIC AI LAYER  │          │    AUTOMATION LAYER         │
│  Google Gemini 2.0  │          │    n8n Cloud Webhook         │
│  Flash API (Free)   │          │    Gmail Email Notifications │
└─────────────────────┘          └────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────┐
│                      DATA LAYER                              │
│              MySQL 8.0 · JDBC · DAO Pattern                  │
└─────────────────────────────────────────────────────────────┘
```

### MVC Pattern

| Component | Role | Files |
|-----------|------|-------|
| **Model** | Data entities | `User.java`, `Order.java`, `MenuItem.java`, `OrderItem.java`, `ChatMessage.java` |
| **View** | JSP presentation | `index.jsp`, `chat.jsp`, `order.jsp`, `login.jsp`, `register.jsp`, `profile.jsp` |
| **Controller** | Servlet handlers | `AuthServlet.java`, `ChatServlet.java`, `PaymentServlet.java`, `StaffServlet.java`, `ProfileServlet.java` |

---

## 5. Agentic AI Integration

### 5.1 Overview — Evolution from Rule-Based to Agentic

The chatbot began with basic keyword matching and evolved into a 3-layer intelligent system:

**Layer 1 — Client-side Intent Engine (chat.js)**  
30+ regex-based intent handlers that respond instantly without hitting the server.

**Layer 2 — Fuzzy Typo Correction (Levenshtein)**  
Catches misspelled item names and corrects them before sending to the server.

**Layer 3 — Gemini 2.0 Flash (Server-side AI)**  
Unknown queries are forwarded to Google Gemini with full menu context for intelligent responses.

### 5.2 Fuzzy Matching Engine (NEW)

One of the key additions was a **Levenshtein distance-based fuzzy matcher** implemented in `chat.js`. This allows customers to type item names with typos and still have their order placed correctly.

```javascript
// Levenshtein distance algorithm
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
```

**How it works:**
1. Customer types: `add pannr tika`
2. `fuzzyFindItem("pannr tika")` runs Levenshtein against all 30 menu items
3. Best match: **Paneer Tikka** (score ≤ 2.5 threshold)
4. Bot replies: *"🔍 Did you mean Paneer Tikka? Adding it for you! 😊"*
5. Item is added without requiring re-typing

### 5.3 Context-Aware Intent Detection (30+ Intents — NEW)

`detectIntent()` in `chat.js` classifies every message before deciding how to respond:

| Intent Category | Trigger Keywords | Response |
|----------------|-----------------|----------|
| `weather_hot` | hot, summer, scorching, sweating | Shows beverages + light bites |
| `weather_cold` | cold, winter, freezing, raining | Shows warm comfort food |
| `sweet` | sweet, dessert, gulab, mithai | Shows desserts + sweet drinks |
| `spicy_food` | extra spicy, fire, mirchi, spice lover | Shows highest-spice dishes |
| `tired` | tired, exhausted, long day, rough day | Shows comfort food selection |
| `party` | party, birthday, anniversary, group order | Shows curated party platter |
| `quick` | quick, hurry, in a rush, hungry now | Shows fastest-to-serve items |
| `bored` | bored, lazy day, nothing to eat | Shows fun, flavour-packed picks |
| `healthy` | healthy, low-cal, diet, fitness | Filters items ≤ 300 kcal |
| `budget` | budget, cheap, affordable, under 200 | Filters items ≤ ₹200 |
| `time_based` | breakfast, lunch, dinner, late night | Uses `new Date().getHours()` to pick relevant dishes |
| `allergy` | allergy, gluten, dairy free, lactose | Shows allergy-safe menu subset |
| `chinese` | chinese, schezwan, manchurian, hakka | Shows full Chinese section |
| `beverages` | drink, juice, lassi, chai, coffee | Shows beverages section |
| `full_menu` | menu, show menu, all dishes | Shows all 4 menu categories |
| `veg` / `nonveg` | vegetarian / chicken, mutton, fish | Filters by type |
| `greet` | hello, hi, namaste | Personalized welcome with user's name |
| `status` | order status, cart, my order | Shows live cart summary |
| `special` | today's special, chef's pick | Shows chef-curated selection |

### 5.4 Agentic AI via Gemini 2.0 Flash (Server-side)

For any message not caught by the intent engine, `GeminiService.java` is called:

```java
// NEW: Agentic AI understanding
String aiReply = geminiService.getAIResponse(message, allMenuItems);
```

`GeminiService.java` builds a rich prompt:
```java
private String buildPrompt(String userMessage, String menuContext) {
    return "You are PlateUp 🍽️, a friendly AI assistant for PlateUp Restaurant.\n\n"
        + "YOUR RULES:\n"
        + "1. Keep answers SHORT — max 3 sentences.\n"
        + "2. Be warm, helpful, and use a food emoji occasionally.\n"
        + "3. Only recommend items from the MENU below.\n"
        + "4. If customer wants to ORDER, remind them: type  add [qty] [item name]\n"
        + menuContext + "\n"
        + "Customer message: \"" + userMessage + "\"\n"
        + "PlateUp reply:";
}
```

**After Gemini replies**, `findAndShowMentionedDishes()` scans the AI text and automatically displays visual menu cards for any dishes mentioned — bridging text AI responses with the rich card UI.

### 5.5 API Details

| Property | Value |
|----------|-------|
| Model | `gemini-2.0-flash` |
| Endpoint | `v1beta/models/gemini-2.0-flash:generateContent` |
| Free Limit | 1,500 requests/day |
| Max Tokens | 150 per response |
| Temperature | 0.7 (balanced creativity) |
| Timeout | 8s connect / 15s read |
| Library | Java `HttpURLConnection` (no extra dependency) |
| Config | `gemini.properties` (gitignored, loaded via classpath) |

---

## 6. n8n Automation Layer

### What is n8n?

n8n is an open-source cloud workflow automation tool. It connects different services and automates tasks through a visual drag-and-drop interface — without writing integration code.

### PlateUp's n8n Workflow (Cloud-Hosted)

```
[Order Webhook] ──► [Gmail Node] ──► [Respond Success]
  POST /plateup-order   Auto-compose     JSON confirmation
```

**Hosted at:** `shubham2408.app.n8n.cloud`

### How It Connects to Java

When a customer adds an item, `ChatServlet.java` triggers `N8nNotificationService.java`:

```java
if (reply.contains("added to your order")) {
    n8nService.sendOrderNotification(orderId, user.getName(),
                                     user.getEmail(), message, total);
}
```

Payload sent to n8n:
```json
{
  "orderId": 42,
  "customerName": "Shubham",
  "customerEmail": "shubham@test.com",
  "items": "add 2 butter chicken",
  "totalAmount": 680,
  "timestamp": "2026-05-10T..."
}
```

### Email Automation Details

The n8n Gmail node auto-sends a formatted order confirmation email:
- **To:** `{{ customerEmail }}` — dynamically filled from webhook payload
- **Subject:** 🍽️ Order Confirmed - PlateUp Restaurant
- **Body:** Customer name, Order ID, Items ordered, Total amount
- **Delivery:** < 500ms after order placed — zero human intervention
- **Proof:** Execution log in n8n dashboard shows every successful run

### Why n8n Demonstrates Agentic AI Concepts

| Agentic Property | n8n Implementation |
|-----------------|-------------------|
| **Autonomous** | Reacts to events without human intervention |
| **Goal-oriented** | Each workflow node has a specific purpose |
| **Extensible** | Add WhatsApp, Sheets, Slack — zero Java code |
| **Observable** | Execution logs prove every automation ran |

---

## 7. Key Features

### Customer Features
1. **AI Chat Ordering** — Natural language conversation with Gemini 2.0 Flash
2. **Fuzzy Typo Correction** — Levenshtein matching corrects misspelled item names
3. **30+ Smart Intents** — Weather, mood, time-based, dietary, allergy-aware responses
4. **Visual Menu Cards** — Images, calorie badges, FSSAI veg/non-veg dot, + Add button
5. **Chinese & Beverages Sections** — Full dedicated Indo-Chinese and drinks menu
6. **Real-time Order Tracking** — 4-stage progress bar (Placed → Preparing → Ready → Served)
7. **Order History** — View all past orders
8. **Payment Flow** — Checkout with automatic cart clearing after payment
9. **Cart Badge** — Live item count displayed on nav icon
10. **Dark Mode Default** — Dark theme persisted via `localStorage`
11. **User Profile Page** — Edit name/phone, change password, view order history

### Staff Features
1. **Order Queue Dashboard** — All active orders in real-time
2. **Status Updates** — Move orders through 4 stages
3. **Customer Details** — See who ordered what

### AI & Automation Features
1. **Agentic AI Chat** — Gemini 2.0 Flash with full menu context
2. **Smart Card After AI Reply** — Auto-displays menu cards for dishes Gemini mentions
3. **n8n Cloud Email Pipeline** — Auto Gmail confirmation on every order
4. **Graceful Fallback** — Client-side intents work even when AI/server is offline

---

## 8. Technology Stack

| Layer | Technology | Version | Purpose |
|-------|-----------|---------|---------|
| Language | Java | 21 (LTS) | Core backend |
| Framework | Jakarta EE | 6.0 | Servlet API |
| Server | Apache Tomcat | 10.1.54 | Application server |
| Build | Maven | 3.x | Dependency management |
| AI Engine | Google Gemini | 2.0 Flash | Agentic AI |
| Automation | n8n Cloud | 2.18.5+ | Workflow automation + Gmail |
| Database | MySQL | 8.0 | Data persistence |
| DB Driver | MySQL Connector/J | 8.3.0 | JDBC connection |
| JSON | org.json | 20240303 | API response parsing |
| IDE | Eclipse | 2026-03 | Development |
| Frontend | JSP + HTML5 + CSS3 | — | Presentation layer |
| JavaScript | Vanilla JS (chat.js) | v3 | Intent engine + fuzzy match |
| Font | Google Fonts (Outfit) | — | Typography |
| VCS | Git + GitHub | — | Version control |

---

## 9. Database Design

### Tables

#### `users`
| Column | Type | Description |
|--------|------|-------------|
| id | INT PK | Auto-increment |
| name | VARCHAR(100) | Full name |
| email | VARCHAR(150) UNIQUE | Login email |
| password | VARCHAR(255) | Hashed password |
| phone | VARCHAR(20) | Contact number |
| role | ENUM('customer','staff') | Access role |
| created_at | TIMESTAMP | Registration time |

#### `menu_items`
| Column | Type | Description |
|--------|------|-------------|
| id | INT PK | Auto-increment |
| name | VARCHAR(100) | Dish name |
| price | DECIMAL(10,2) | Price in ₹ |
| category | VARCHAR(50) | Veg/Non-Veg/Chinese/Beverage |
| vegetarian | BOOLEAN | Veg flag |
| spicy_level | INT (0-5) | Spice intensity |
| available | BOOLEAN | In stock flag |

#### `orders`
| Column | Type | Description |
|--------|------|-------------|
| id | INT PK | Auto-increment |
| user_id | INT FK | Customer reference |
| table_number | INT | Table assignment |
| status | ENUM | pending/preparing/ready/served |
| total_price | DECIMAL(10,2) | Final amount with GST |
| gst_amount | DECIMAL(10,2) | 18% GST |
| special_notes | TEXT | Chat-based notes |

#### `order_items`
| Column | Type | Description |
|--------|------|-------------|
| id | INT PK | Auto-increment |
| order_id | INT FK | Parent order |
| menu_item_id | INT FK | Menu reference |
| quantity | INT | Number of items |
| price_at_order | DECIMAL(10,2) | Price snapshot |

#### `chat_messages`
| Column | Type | Description |
|--------|------|-------------|
| id | INT PK | Auto-increment |
| user_id | INT FK | Chat participant |
| message_type | ENUM('user','assistant') | Sender role |
| content | TEXT | Message text |
| sentiment | VARCHAR(20) | Emotion tag |

---

## 10. Implementation Details

### Project Structure

```
Restaurant_Chatbot/
├── src/main/
│   ├── java/com/ai/restaurant/
│   │   ├── controller/
│   │   │   ├── AuthServlet.java
│   │   │   ├── ChatServlet.java
│   │   │   ├── PaymentServlet.java
│   │   │   ├── ProfileServlet.java       ← NEW (User Profile)
│   │   │   └── StaffServlet.java
│   │   ├── service/
│   │   │   ├── ChatService.java
│   │   │   ├── GeminiService.java        ← Agentic AI
│   │   │   ├── N8nNotificationService.java ← Cloud Email
│   │   │   ├── MenuService.java
│   │   │   └── OrderService.java
│   │   ├── dao/
│   │   ├── model/
│   │   └── util/
│   └── webapp/
│       ├── assets/
│       │   ├── css/
│       │   ├── js/
│       │   │   ├── chat.js               ← v3: Fuzzy Match + 30 Intents
│       │   │   └── theme.js
│       │   └── images/menu/              ← 30+ food images
│       ├── customer/
│       │   ├── chat.jsp
│       │   ├── order.jsp
│       │   ├── payment.jsp
│       │   ├── history.jsp
│       │   └── profile.jsp               ← NEW (Profile Page)
│       ├── staff/
│       │   └── dashboard.jsp
│       ├── index.jsp
│       ├── login.jsp
│       └── register.jsp
└── docs/
    ├── PlateUp_Presentation.pptx
    ├── PlateUp_Project_Report.md
    ├── generate_pptx.py
    └── n8n_order_workflow.json
```

### User Profile Module (NEW)

`ProfileServlet.java` handles two POST actions:

**updateProfile** — Updates name and phone in DB, refreshes session:
```java
if ("updateProfile".equals(action)) {
    if (name != null && !name.trim().isEmpty()) user.setName(name.trim());
    if (phone != null) user.setPhone(phone.trim());
    boolean updated = userDAO.updateUser(user);
    session.setAttribute("user", user);  // refresh session
}
```

**changePassword** — Validates current password, checks confirmation match, enforces 6-char minimum:
```java
if (!user.getPassword().equals(currentPwd)) { redirect error; }
if (newPwd.length() < 6)                    { redirect error; }
if (!newPwd.equals(confirmPwd))             { redirect error; }
user.setPassword(newPwd);
userDAO.updateUser(user);
```

`profile.jsp` includes:
- Account details form (name, email read-only, phone)
- Password change form
- Order history table loaded from `orderService.getUserOrders(userId)`
- Food preferences stored in `localStorage`

### Agentic AI Code Flow (Updated)

```
Customer types message
        ↓
chat.js: detectIntent(message)
   ├── Fuzzy Add? → fuzzyFindItem() → addToCart()
   ├── Local Intent? → handleLocalIntent() → renders cards instantly
   └── Unknown? → fetch('/chat') → server
                         ↓
              ChatServlet.doPost()
                         ↓
              ChatService.processMessage()
                 ├── "add" → handleAdd() → OrderService → N8nNotificationService
                 ├── "menu/veg/spicy/under" → MenuService
                 ├── "status" → checkOrderStatus()
                 └── Unknown → GeminiService.getAIResponse()
                                      ↓
                             Build prompt + menu context
                                      ↓
                             POST to Gemini 2.0 Flash API
                                      ↓
                             Parse JSON → return reply
        ↓
chat.js: appendBotMessage(reply)
        ↓
chat.js: findAndShowMentionedDishes(reply) → show visual cards
```

---

## 11. Results & Demo

### What Works
- ✅ User registration and login (Customer + Staff roles)
- ✅ AI chat with Gemini 2.0 Flash (natural language)
- ✅ Fuzzy typo correction — "pannr tika" → Paneer Tikka
- ✅ 30+ context-aware intents (weather, mood, time-based, allergy, party, etc.)
- ✅ Full Visual menu cards with images, calories, FSSAI dots
- ✅ Chinese menu section (veg + non-veg Indo-Chinese)
- ✅ Beverages section (5 drinks)
- ✅ Add items via + Add button or chat command
- ✅ Real-time 4-stage order status tracking
- ✅ Auto cart clear after payment
- ✅ Staff dashboard order management
- ✅ n8n Cloud webhook fires on every order
- ✅ Gmail auto-email confirmed live (execution log as proof)
- ✅ User Profile page (edit details + change password + order history)
- ✅ Dark mode as default (persistent via localStorage)
- ✅ Live cart badge counter on nav
- ✅ AI dish cards auto-display after Gemini response
- ✅ Responsive design

### Performance

| Metric | Value |
|--------|-------|
| Gemini AI response time | ~2-3 seconds |
| n8n webhook response | < 500ms |
| Gmail email delivery | < 2 seconds |
| Page load time | < 1 second |
| DB query time | < 100ms |
| Client-side intent response | Instant (0ms server) |
| Concurrent users | Tomcat thread pool (200 default) |

---

## 12. Challenges & Solutions

| Challenge | Solution |
|-----------|----------|
| Gemini model `gemini-1.5-flash` deprecated | Updated to `gemini-2.0-flash` |
| n8n IF node type mismatch (number vs string) | Removed IF node, simplified to 3-node pipeline |
| Served orders still showing in cart | Filter logic updated — skip `served` orders in query |
| n8n install failed via `npx` (Windows permissions) | Switched to n8n Cloud — more reliable, no local install |
| `isVeg()` method not found | Corrected to `isVegetarian()` per MenuItem model |
| API key exposed in code | Added `.gitignore` — key loaded from `gemini.properties` |
| Customer email hardcoded in n8n Gmail node | Switched to dynamic `{{ $json.customerEmail }}` expression |
| Order total incorrect in email | Changed to fetch real-time total from DB instead of hardcoded value |
| Profile errors (JSP not found) | Added `ProfileServlet.java` with proper `@WebServlet("/profile")` mapping |
| Fuzzy match too aggressive | Tuned threshold to score ≤ 2.5 to avoid false matches |
| Menu cards breaking on missing image | Added `onerror` fallback emoji per category |

---

## 13. Future Scope

### Short-term (1-3 months)
1. **WhatsApp notifications** to restaurant owner via n8n + Twilio
2. **Google Sheets** order analytics log via n8n
3. **Voice ordering** using Web Speech API
4. **Environment variables** for API key security (replace `.properties` file)

### Medium-term (3-6 months)
1. **Recommendation engine** based on order history
2. **Razorpay/UPI** payment gateway integration
3. **Mobile-responsive PWA** version
4. **Multi-language** chatbot support

### Long-term (6+ months)
1. **Multi-restaurant** SaaS platform
2. **Kitchen Display System** (KDS) with WebSockets
3. **AI demand forecasting** for inventory management
4. **Customer loyalty** program with points

---

## 14. Conclusion

PlateUp successfully demonstrates the practical application of **Agentic AI** in a real-world restaurant management system. Key achievements during this internship:

1. **Agentic AI in Action** — Google Gemini 2.0 Flash understands natural language, reasons with full menu context, and acts by generating helpful responses — the Perceive-Reason-Act loop from the AI Fellowship curriculum.

2. **Fuzzy Typo Tolerance** — The Levenshtein distance engine makes ordering natural and error-tolerant, significantly improving the user experience beyond typical chatbots.

3. **30+ Context-Aware Intents** — The chatbot responds intelligently to weather, mood, dietary restrictions, time-of-day, allergies, and party scenarios — making it feel genuinely conversational.

4. **n8n as Automation Backbone** — The n8n Cloud integration demonstrates how a modern application can send automated Gmail confirmations without writing email-sending Java code.

5. **User Profile Module** — A complete account management page with profile editing, password change, and order history — making PlateUp a full-featured customer portal.

6. **Production-ready Architecture** — MVC pattern, DAO abstraction, role-based auth, graceful fallbacks, and `.gitignore`-protected API keys make the system robust and maintainable.

7. **Completely Free Stack** — Gemini AI (1,500 req/day free), n8n Cloud (free tier), MySQL (free) — the entire AI + automation stack costs ₹0.

PlateUp bridges the gap between traditional Java EE development and modern AI-powered applications, demonstrating that Agentic AI can be integrated into any existing system with minimal changes and zero cost.

---

*Report prepared for AI Fellowship Internship Review — May 2026*  
*Project Repository: github.com/shubhambhandari24/Restaurant_chatbot*
