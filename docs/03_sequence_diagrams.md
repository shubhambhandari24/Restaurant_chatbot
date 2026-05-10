# PlateUp Restaurant Chatbot — Sequence Diagrams

> Each diagram below shows a complete end-to-end flow for a key user interaction.

---

## 1. User Registration Flow

```mermaid
sequenceDiagram
    actor User
    participant register.jsp
    participant AuthServlet
    participant AuthService
    participant UserDAOImpl
    participant MySQL

    User->>register.jsp: Fill form (name, email, password, phone)
    register.jsp->>AuthServlet: POST /auth?action=register
    AuthServlet->>AuthService: register(User)
    AuthService->>AuthService: Validate fields not null
    AuthService->>UserDAOImpl: isEmailExists(email)
    UserDAOImpl->>MySQL: SELECT COUNT(*) WHERE email=?
    MySQL-->>UserDAOImpl: 0 (not exists)
    UserDAOImpl-->>AuthService: false
    AuthService->>UserDAOImpl: registerUser(User)
    UserDAOImpl->>MySQL: INSERT INTO users (name,email,password,phone,role)
    MySQL-->>UserDAOImpl: 1 row affected
    UserDAOImpl-->>AuthService: true
    AuthService-->>AuthServlet: "SUCCESS"
    AuthServlet-->>User: redirect → login.jsp
```

---

## 2. User Login Flow

```mermaid
sequenceDiagram
    actor User
    participant login.jsp
    participant AuthServlet
    participant AuthService
    participant UserDAOImpl
    participant MySQL
    participant HttpSession

    User->>login.jsp: Enter email + password
    login.jsp->>AuthServlet: POST /auth?action=login
    AuthServlet->>AuthService: login(email, password)
    AuthService->>UserDAOImpl: loginUser(email, password)
    UserDAOImpl->>MySQL: SELECT * FROM users WHERE email=? AND password=?
    MySQL-->>UserDAOImpl: ResultSet (1 row)
    UserDAOImpl-->>AuthService: User object

    AuthService-->>AuthServlet: User object
    AuthServlet->>HttpSession: setAttribute("user", user)
    AuthServlet->>HttpSession: setAttribute("userId", user.id)
    AuthServlet->>HttpSession: setAttribute("role", user.role)

    alt role == customer
        AuthServlet-->>User: redirect → customer/chat.jsp
    else role == staff
        AuthServlet-->>User: redirect → staff/dashboard.jsp
    end
```

---

## 3. Chatbot — Show Menu Flow

```mermaid
sequenceDiagram
    actor User
    participant chat.jsp
    participant chat.js
    participant ChatServlet
    participant ChatService
    participant MenuService
    participant MenuDAOImpl
    participant MySQL

    User->>chat.jsp: Types "show menu" or clicks chip
    chat.jsp->>chat.js: sendMessage("show menu")
    chat.js->>chat.js: detectIntent("show menu") → "full_menu"
    chat.js->>chat.js: handleLocalIntent("full_menu")
    Note over chat.js: Renders veg + non-veg cards\nfrom local MENU[] array\nNO server call needed
    chat.js-->>User: Display menu cards with images
```

> **Design note:** The frontend `chat.js` has a local `MENU[]` array for all 16 display items, so "show menu", "veg", "non-veg" are handled entirely client-side — zero server latency.

---

## 4. Chatbot — Add Item to Order Flow

```mermaid
sequenceDiagram
    actor User
    participant chat.js
    participant ChatServlet
    participant ChatService
    participant OrderService
    participant OrderDAOImpl
    participant OrderItemDAOImpl
    participant MenuDAOImpl
    participant MySQL

    User->>chat.js: Clicks "+ Add" on Paneer Tikka card
    chat.js->>chat.js: addToCart("Paneer Tikka", 280)
    chat.js->>chat.js: Optimistic UI update (badge++)
    chat.js->>ChatServlet: POST /chat message="add 1 Paneer Tikka"
    ChatServlet->>ChatService: processMessage(userId, "add 1 Paneer Tikka")
    ChatService->>ChatService: handleAdd(userId, message)
    ChatService->>OrderService: addItemToOrder(userId, "paneer tikka", 1)

    OrderService->>MenuDAOImpl: getAllMenuItems()
    MenuDAOImpl->>MySQL: SELECT * FROM menu_items WHERE available=1
    MySQL-->>MenuDAOImpl: List of MenuItems
    MenuDAOImpl-->>OrderService: MenuItem list
    OrderService->>OrderService: fuzzy match "paneer tikka" → found

    OrderService->>OrderDAOImpl: getPendingOrderByUserId(userId)
    MySQL-->>OrderDAOImpl: null (no pending order)

    OrderService->>OrderDAOImpl: createOrder(new Order)
    MySQL-->>OrderDAOImpl: orderId = 5

    OrderService->>OrderItemDAOImpl: addOrderItem(orderId, menuItemId, qty, price)
    MySQL-->>OrderItemDAOImpl: 1 row affected

    OrderService->>OrderItemDAOImpl: calculateTotalByOrderId(5)
    MySQL-->>OrderItemDAOImpl: 280.0
    OrderService->>OrderDAOImpl: updateOrderAmount(5, 330.4, 50.4)

    OrderService-->>ChatService: "1 x Paneer Tikka added. Order ID: 5"
    ChatService->>ChatDAOImpl: saveMessage(user msg)
    ChatService->>ChatDAOImpl: saveMessage(bot reply)
    ChatService-->>ChatServlet: reply string
    ChatServlet-->>chat.js: "1 x Paneer Tikka added. Order ID: 5"
    chat.js-->>User: Button shows ✓, bot message appears
```

---

## 5. View Order Flow

```mermaid
sequenceDiagram
    actor User
    participant order.jsp
    participant OrderService
    participant OrderDAOImpl
    participant OrderItemDAOImpl
    participant MenuDAOImpl
    participant MySQL

    User->>order.jsp: Navigate to My Order
    order.jsp->>order.jsp: Read session.getAttribute("user")
    order.jsp->>OrderService: getUserOrders(userId)
    OrderService->>OrderDAOImpl: getOrdersByUserId(userId)
    OrderDAOImpl->>MySQL: SELECT * FROM orders WHERE user_id=? ORDER BY created_at DESC
    MySQL-->>OrderDAOImpl: List of Orders
    OrderDAOImpl-->>OrderService: orders list
    OrderService-->>order.jsp: orders

    order.jsp->>OrderService: getOrderItems(latestOrder.id)
    OrderService->>OrderItemDAOImpl: getItemsByOrderId(orderId)
    OrderItemDAOImpl->>MySQL: SELECT * FROM order_items WHERE order_id=?
    MySQL-->>OrderItemDAOImpl: List of OrderItems
    OrderItemDAOImpl-->>order.jsp: items

    loop For each OrderItem
        order.jsp->>MenuDAOImpl: getMenuItemById(menuItemId)
        MenuDAOImpl->>MySQL: SELECT * FROM menu_items WHERE id=?
        MySQL-->>MenuDAOImpl: MenuItem
        MenuDAOImpl-->>order.jsp: item name
    end

    order.jsp-->>User: Render order table + progress tracker + GST total
```

---

## 6. Payment Flow

```mermaid
sequenceDiagram
    actor User
    participant order.jsp
    participant payment.jsp
    participant payment.js
    participant PaymentServlet
    participant OrderService
    participant OrderDAOImpl
    participant MySQL

    User->>order.jsp: Click "Proceed to Payment"
    order.jsp-->>payment.jsp: redirect payment.jsp?orderId=5
    payment.jsp-->>User: Show QR code + scanning animation

    User->>payment.jsp: Click "I Have Paid"
    payment.jsp->>payment.js: handlePay(event, form)
    payment.js->>payment.js: Show spinner for 2000ms
    payment.js->>payment.js: Generate dummy ref code
    payment.js-->>User: Show success overlay + confetti

    payment.js->>PaymentServlet: POST /pay?orderId=5 (background fetch)
    PaymentServlet->>OrderService: updateOrderStatus(5, "served")
    OrderService->>OrderService: Validate status in allowed list
    OrderService->>OrderDAOImpl: updateOrderStatus(5, "served")
    OrderDAOImpl->>MySQL: UPDATE orders SET status='served' WHERE id=5
    MySQL-->>OrderDAOImpl: 1 row affected
    OrderDAOImpl-->>PaymentServlet: true
    PaymentServlet-->>payment.js: redirect (ignored, already showing success)
```

---

## 7. Staff — Update Order Status Flow

```mermaid
sequenceDiagram
    actor Staff
    participant dashboard.jsp
    participant StaffServlet
    participant OrderService
    participant OrderDAOImpl
    participant MySQL

    Staff->>dashboard.jsp: Select order, change status to "preparing"
    dashboard.jsp->>StaffServlet: POST /staff?orderId=3&status=preparing
    StaffServlet->>OrderService: updateOrderStatus(3, "preparing")
    OrderService->>OrderService: Validate: status in [pending,preparing,ready,served]
    OrderService->>OrderDAOImpl: updateOrderStatus(3, "preparing")
    OrderDAOImpl->>MySQL: UPDATE orders SET status=? WHERE id=?
    MySQL-->>OrderDAOImpl: 1 row affected
    OrderDAOImpl-->>OrderService: true
    OrderService-->>StaffServlet: true
    StaffServlet-->>Staff: redirect → staff/dashboard.jsp
```

---

## 8. Logout Flow

```mermaid
sequenceDiagram
    actor User
    participant chat.jsp
    participant LogoutServlet
    participant HttpSession
    participant index.jsp

    User->>chat.jsp: Click 🚪 Logout in sidebar
    chat.jsp->>LogoutServlet: GET /logout
    LogoutServlet->>HttpSession: getSession(false)
    LogoutServlet->>HttpSession: invalidate()
    LogoutServlet->>LogoutServlet: Clear all cookies (maxAge=0)
    LogoutServlet-->>User: redirect → index.jsp (Landing Page)
```
