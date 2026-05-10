# PlateUp Restaurant Chatbot — Documentation Index

> **Version:** 1.0 · **Last Updated:** May 2025
> **Stack:** Jakarta EE 5.0 · Java 24 · Apache Tomcat 10.1 · MySQL 8.0

---

## 📂 Documents in This Folder

| # | File | Contents |
|---|------|----------|
| 1 | [01_architecture.md](./01_architecture.md) | High-level MVC diagram, file structure, controller→service→DAO call map, auth state flow |
| 2 | [02_database.md](./02_database.md) | ER diagram, all 5 table schemas, relationships, Java class mappings, 30 seeded items |
| 3 | [03_sequence_diagrams.md](./03_sequence_diagrams.md) | 8 end-to-end flow diagrams (register, login, menu, add item, order, payment, staff, logout) |
| 4 | [04_class_diagrams.md](./04_class_diagrams.md) | UML class diagrams for models, DAOs, services, controllers |

---

## ⚡ Quick Reference

### URL Endpoints
| URL | Servlet | Method | Action |
|-----|---------|--------|--------|
| `/auth` | AuthServlet | POST | Login / Register |
| `/chat` | ChatServlet | POST | Process chatbot message |
| `/pay` | PaymentServlet | POST | Mark order as served |
| `/staff` | StaffServlet | POST | Update order status |
| `/logout` | LogoutServlet | GET | Invalidate session |

### Pages
| Path | Access |
|------|--------|
| `/index.jsp` | Public — Landing page |
| `/login.jsp` | Public |
| `/register.jsp` | Public |
| `/customer/chat.jsp` | 🔒 Customer session required |
| `/customer/order.jsp` | 🔒 Customer session required |
| `/customer/payment.jsp` | 🔒 Customer session required |
| `/customer/history.jsp` | 🔒 Customer session required |
| `/staff/dashboard.jsp` | 🔒 Staff session required |

### Environment
| Item | Value |
|------|-------|
| Server | Apache Tomcat 10.1 |
| Java | 24 |
| DB Host | localhost:3306 |
| DB Name | `ai_restaurant_chatbot` |
| DB User | `root` |
| JDBC Driver | `mysql-connector-j-8.3.0.jar` |
