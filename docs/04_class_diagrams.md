# PlateUp Restaurant Chatbot — Class Diagrams

---

## 1. Model Layer — All Entities

```mermaid
classDiagram
    class User {
        -int id
        -String name
        -String email
        -String password
        -String phone
        -String role
        -Timestamp createdAt
        +getId() int
        +getName() String
        +getEmail() String
        +getPassword() String
        +getPhone() String
        +getRole() String
        +getCreatedAt() Timestamp
    }

    class Order {
        -int id
        -Integer userId
        -int tableNumber
        -String status
        -double totalPrice
        -double gstAmount
        -String specialNotes
        -Timestamp createdAt
        -Timestamp updatedAt
        +getId() int
        +getUserId() Integer
        +getTableNumber() int
        +getStatus() String
        +getTotalPrice() double
        +getGstAmount() double
    }

    class OrderItem {
        -int id
        -int orderId
        -int menuItemId
        -int quantity
        -double priceAtOrder
        +getId() int
        +getOrderId() int
        +getMenuItemId() int
        +getQuantity() int
        +getPriceAtOrder() double
    }

    class MenuItem {
        -int id
        -String name
        -String description
        -double price
        -String category
        -boolean vegetarian
        -boolean vegan
        -boolean glutenFree
        -int spicyLevel
        -boolean available
        -Timestamp createdAt
        +getId() int
        +getName() String
        +getPrice() double
        +getCategory() String
        +isVegetarian() boolean
        +isAvailable() boolean
    }

    class ChatMessage {
        -int id
        -int userId
        -Integer orderId
        -String messageType
        -String content
        -String sentiment
        -Timestamp createdAt
        +getId() int
        +getUserId() int
        +getMessageType() String
        +getContent() String
    }

    User "1" --> "0..*" Order : places
    User "1" --> "0..*" ChatMessage : sends
    Order "1" --> "1..*" OrderItem : contains
    MenuItem "1" --> "0..*" OrderItem : referenced in
    Order "1" --> "0..*" ChatMessage : linked to
```

---

## 2. DAO Layer — Interfaces and Implementations

```mermaid
classDiagram
    class UserDAO {
        <<interface>>
        +registerUser(User) boolean
        +loginUser(String, String) User
        +getUserById(int) User
        +isEmailExists(String) boolean
        +getAllUsers() List~User~
        +updateUser(User) boolean
        +deleteUser(int) boolean
    }

    class UserDAOImpl {
        +registerUser(User) boolean
        +loginUser(String, String) User
        +getUserById(int) User
        +isEmailExists(String) boolean
        +getAllUsers() List~User~
        -extractUser(ResultSet) User
    }

    class OrderDAO {
        <<interface>>
        +createOrder(Order) int
        +getOrderById(int) Order
        +getOrdersByUserId(int) List~Order~
        +getPendingOrderByUserId(int) Order
        +updateOrderStatus(int, String) boolean
        +updateOrderAmount(int, double, double) boolean
        +getActiveOrders() List~Order~
    }

    class OrderDAOImpl {
        +createOrder(Order) int
        +getOrderById(int) Order
        +getOrdersByUserId(int) List~Order~
        +getPendingOrderByUserId(int) Order
        +updateOrderStatus(int, String) boolean
        +updateOrderAmount(int, double, double) boolean
        +getActiveOrders() List~Order~
        -extractOrder(ResultSet) Order
    }

    class OrderItemDAO {
        <<interface>>
        +addOrderItem(OrderItem) boolean
        +addMultipleItems(List~OrderItem~) boolean
        +getItemsByOrderId(int) List~OrderItem~
        +calculateTotalByOrderId(int) double
    }

    class OrderItemDAOImpl {
        +addOrderItem(OrderItem) boolean
        +addMultipleItems(List~OrderItem~) boolean
        +getItemsByOrderId(int) List~OrderItem~
        +calculateTotalByOrderId(int) double
    }

    class MenuDAO {
        <<interface>>
        +getAllMenuItems() List~MenuItem~
        +getAvailableMenuItems() List~MenuItem~
        +getMenuItemById(int) MenuItem
        +getMenuItemByName(String) MenuItem
        +filterMenu(Boolean, Boolean, Boolean, Integer, String, Double, String) List~MenuItem~
    }

    class MenuDAOImpl {
        +getAllMenuItems() List~MenuItem~
        +getAvailableMenuItems() List~MenuItem~
        +getMenuItemById(int) MenuItem
        +getMenuItemByName(String) MenuItem
        +filterMenu(...) List~MenuItem~
        -extractMenuItem(ResultSet) MenuItem
    }

    class ChatDAO {
        <<interface>>
        +saveMessage(ChatMessage) boolean
        +getMessagesByUserId(int) List~ChatMessage~
    }

    class ChatDAOImpl {
        +saveMessage(ChatMessage) boolean
        +getMessagesByUserId(int) List~ChatMessage~
    }

    UserDAO <|.. UserDAOImpl
    OrderDAO <|.. OrderDAOImpl
    OrderItemDAO <|.. OrderItemDAOImpl
    MenuDAO <|.. MenuDAOImpl
    ChatDAO <|.. ChatDAOImpl
```

---

## 3. Service Layer

```mermaid
classDiagram
    class AuthService {
        -UserDAO userDAO
        +register(User) String
        +login(String, String) User
        +getUserById(int) User
    }

    class ChatService {
        -ChatDAO chatDAO
        -MenuService menuService
        -OrderService orderService
        +processMessage(int, String) String
        -handleAdd(int, String) String
        -checkOrderStatus(int) String
        -formatMenu(List~MenuItem~) String
        -extractPrice(String) double
        +getChatHistory(int) List~ChatMessage~
    }

    class OrderService {
        -OrderDAO orderDAO
        -OrderItemDAO orderItemDAO
        +placeOrder(Order, List~OrderItem~) int
        +addItemToOrder(int, String, int) String
        +getOrder(int) Order
        +getOrderItems(int) List~OrderItem~
        +getUserOrders(int) List~Order~
        +updateOrderStatus(int, String) boolean
        +getActiveOrders() List~Order~
        +calculateTotal(int) double
    }

    class MenuService {
        -MenuDAO menuDAO
        +getAvailableMenu() List~MenuItem~
        +filterMenu(Boolean,Boolean,Boolean,Integer,String,Double,String) List~MenuItem~
        +getMenuItemById(int) MenuItem
    }

    AuthService --> UserDAOImpl
    ChatService --> ChatDAOImpl
    ChatService --> MenuService
    ChatService --> OrderService
    OrderService --> OrderDAOImpl
    OrderService --> OrderItemDAOImpl
    OrderService --> MenuDAOImpl
    MenuService --> MenuDAOImpl
```

---

## 4. Controller Layer

```mermaid
classDiagram
    class AuthServlet {
        -AuthService authService
        +doPost(HttpServletRequest, HttpServletResponse)
        -login(HttpServletRequest, HttpServletResponse)
        -register(HttpServletRequest, HttpServletResponse)
    }

    class ChatServlet {
        -ChatService chatService
        +doPost(HttpServletRequest, HttpServletResponse)
    }

    class PaymentServlet {
        -OrderService orderService
        +doPost(HttpServletRequest, HttpServletResponse)
    }

    class StaffServlet {
        -OrderService orderService
        +doPost(HttpServletRequest, HttpServletResponse)
    }

    class LogoutServlet {
        +doGet(HttpServletRequest, HttpServletResponse)
        +doPost(HttpServletRequest, HttpServletResponse)
    }

    AuthServlet --> AuthService
    ChatServlet --> ChatService
    PaymentServlet --> OrderService
    StaffServlet --> OrderService
```

---

## 5. Full System Class Diagram (Simplified)

```mermaid
classDiagram
    direction TB

    AuthServlet --> AuthService
    ChatServlet --> ChatService
    PaymentServlet --> OrderService
    StaffServlet --> OrderService

    AuthService --> UserDAOImpl
    ChatService --> ChatDAOImpl
    ChatService --> MenuService
    ChatService --> OrderService
    MenuService --> MenuDAOImpl
    OrderService --> OrderDAOImpl
    OrderService --> OrderItemDAOImpl
    OrderService --> MenuDAOImpl

    UserDAOImpl --> User
    OrderDAOImpl --> Order
    OrderItemDAOImpl --> OrderItem
    MenuDAOImpl --> MenuItem
    ChatDAOImpl --> ChatMessage
```
