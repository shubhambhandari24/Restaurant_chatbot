# PlateUp Restaurant Chatbot — Architecture Documentation

> **Stack:** Jakarta EE 5.0 · Java 24 · Apache Tomcat 10.1 · MySQL 8.0 · HTML/CSS/JS (Vanilla)
> **Pattern:** MVC (Model-View-Controller) with DAO-Service layering

---

## 1. High-Level Architecture

```mermaid
graph TD
    subgraph Browser["🌐 Browser - View"]
        V1[index.jsp Landing Page]
        V2[login.jsp / register.jsp]
        V3[customer/chat.jsp]
        V4[customer/order.jsp]
        V5[customer/payment.jsp]
        V6[customer/history.jsp]
        V7[staff/dashboard.jsp]
        JS[chat.js Frontend Intent Engine]
    end

    subgraph Tomcat["🖥 Apache Tomcat 10.1 - Controller"]
        C1["AuthServlet /auth"]
        C2["ChatServlet /chat"]
        C3["PaymentServlet /pay"]
        C4["StaffServlet /staff"]
        C5["LogoutServlet /logout"]
    end

    subgraph Service["⚙️ Service Layer"]
        S1[AuthService]
        S2[ChatService]
        S3[OrderService]
        S4[MenuService]
    end

    subgraph DAO["🗄 DAO Layer"]
        D1[UserDAOImpl]
        D2[ChatDAOImpl]
        D3[OrderDAOImpl]
        D4[OrderItemDAOImpl]
        D5[MenuDAOImpl]
    end

    subgraph DB["🐬 MySQL Database"]
        T1[(users)]
        T2[(orders)]
        T3[(order_items)]
        T4[(menu_items)]
        T5[(chat_messages)]
    end

    Browser -->|HTTP POST/GET| Tomcat
    JS -->|fetch POST /chat| C2
    Tomcat --> Service
    Service --> DAO
    DAO -->|JDBC PreparedStatement| DB
```

---

## 2. MVC Layer Responsibilities

| Layer | Package | Responsibility |
|-------|---------|----------------|
| **View** | `src/main/webapp/` | JSP pages render UI using session attributes; `chat.js` handles frontend intent detection |
| **Controller** | `com.ai.restaurant.controller` | Servlets receive HTTP requests, delegate to Services, redirect/respond |
| **Service** | `com.ai.restaurant.service` | Business logic — validation, orchestration, GST calculation (18%) |
| **DAO** | `com.ai.restaurant.dao` | Data access — all SQL via `PreparedStatement`, returns model objects |
| **Model** | `com.ai.restaurant.model` | Pure POJOs — `User`, `Order`, `OrderItem`, `MenuItem`, `ChatMessage` |
| **Util** | `com.ai.restaurant.util` | `DBConnection` — single-point JDBC connection factory |

---

## 3. Complete File Structure

```
Restaurant_Chatbot/src/main/
├── java/com/ai/restaurant/
│   ├── controller/
│   │   ├── AuthServlet.java        @WebServlet("/auth")
│   │   ├── ChatServlet.java        @WebServlet("/chat")
│   │   ├── LogoutServlet.java      @WebServlet("/logout")
│   │   ├── PaymentServlet.java     @WebServlet("/pay")
│   │   └── StaffServlet.java       @WebServlet("/staff")
│   ├── dao/
│   │   ├── ChatDAO.java / ChatDAOImpl.java
│   │   ├── MenuDAO.java / MenuDAOImpl.java
│   │   ├── OrderDAO.java / OrderDAOImpl.java
│   │   ├── OrderItemDAO.java / OrderItemDAOImpl.java
│   │   └── UserDAO.java / UserDAOImpl.java
│   ├── model/
│   │   ├── User.java
│   │   ├── Order.java
│   │   ├── OrderItem.java
│   │   ├── MenuItem.java
│   │   └── ChatMessage.java
│   ├── service/
│   │   ├── AuthService.java
│   │   ├── ChatService.java
│   │   ├── MenuService.java
│   │   └── OrderService.java
│   └── util/
│       └── DBConnection.java
└── webapp/
    ├── index.jsp               Landing page (PlateUp)
    ├── login.jsp / register.jsp
    ├── customer/
    │   ├── chat.jsp            AI Chatbot UI
    │   ├── order.jsp           Current order + status tracker
    │   ├── payment.jsp         QR scan and pay
    │   └── history.jsp         Past orders
    ├── staff/
    │   └── dashboard.jsp
    ├── assets/
    │   ├── css/ theme.css · style.css · chat.css
    │   ├── js/  theme.js · chat.js
    │   └── images/menu/ (16 food PNGs)
    └── WEB-INF/lib/
        ├── mysql-connector-j-8.3.0.jar
        └── json-20240303.jar
```

---

## 4. Controller → Service → DAO Call Map

```mermaid
graph LR
    A[AuthServlet] -->|login/register| AS[AuthService]
    AS --> UD[UserDAOImpl]

    B[ChatServlet] -->|processMessage| CS[ChatService]
    CS --> CD[ChatDAOImpl]
    CS --> MS[MenuService]
    CS --> OS[OrderService]
    MS --> MD[MenuDAOImpl]
    OS --> OD[OrderDAOImpl]
    OS --> OID[OrderItemDAOImpl]
    OS --> MD

    C[PaymentServlet] -->|updateStatus| OS
    D[StaffServlet] -->|updateStatus| OS
    E[LogoutServlet] -->|invalidateSession| E
```

---

## 5. Authentication State Flow

```mermaid
stateDiagram-v2
    [*] --> LandingPage
    LandingPage --> LoginPage : Click Login
    LoginPage --> AuthServlet : POST /auth?action=login
    AuthServlet --> AuthService : login(email, pwd)
    AuthService --> UserDAO : loginUser()
    UserDAO --> MySQL : SELECT FROM users WHERE email AND password

    MySQL --> UserDAO : ResultSet
    UserDAO --> AuthService : User or null
    AuthService --> AuthServlet : User or null

    AuthServlet --> ChatPage : role==customer, session set
    AuthServlet --> StaffDashboard : role==staff
    AuthServlet --> LoginError : null → redirect error=1

    ChatPage --> LogoutServlet : GET /logout
    LogoutServlet --> LandingPage : session.invalidate
```
