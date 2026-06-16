-- ============================================================
-- PlateUp Restaurant Chatbot — Full Database Schema + Seed Data
-- Compatible: MySQL 8.0+ | Aiven defaultdb
-- ============================================================

-- ─── TABLE: users ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(100)  NOT NULL,
    email      VARCHAR(150)  NOT NULL UNIQUE,
    password   VARCHAR(255)  NOT NULL,
    phone      VARCHAR(15),
    role       ENUM('customer','staff') NOT NULL DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ─── TABLE: menu_items ───────────────────────────────────────
CREATE TABLE IF NOT EXISTS menu_items (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(150)  NOT NULL,
    description TEXT,
    price       DOUBLE        NOT NULL,
    category    VARCHAR(50),
    vegetarian  TINYINT(1)    DEFAULT 0,
    vegan       TINYINT(1)    DEFAULT 0,
    gluten_free TINYINT(1)    DEFAULT 0,
    spicy_level INT           DEFAULT 0,
    available   TINYINT(1)    DEFAULT 1,
    created_at  TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ─── TABLE: orders ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS orders (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    user_id       INT,
    table_number  INT          NOT NULL DEFAULT 1,
    status        ENUM('pending','preparing','ready','served') NOT NULL DEFAULT 'pending',
    total_price   DOUBLE,
    gst_amount    DOUBLE,
    special_notes TEXT,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ─── TABLE: order_items ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS order_items (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    order_id       INT    NOT NULL,
    menu_item_id   INT    NOT NULL,
    quantity       INT    NOT NULL DEFAULT 1,
    price_at_order DOUBLE NOT NULL,
    FOREIGN KEY (order_id)     REFERENCES orders(id)     ON DELETE CASCADE,
    FOREIGN KEY (menu_item_id) REFERENCES menu_items(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ─── TABLE: chat_messages ────────────────────────────────────
CREATE TABLE IF NOT EXISTS chat_messages (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    user_id      INT NOT NULL,
    order_id     INT,
    message_type ENUM('user','assistant') NOT NULL,
    content      TEXT NOT NULL,
    sentiment    VARCHAR(20) DEFAULT 'neutral',
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)  REFERENCES users(id)  ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- SEED DATA — Menu Items (30 original + Chinese & Beverages)
-- ============================================================

INSERT INTO menu_items (name, description, price, category, vegetarian, vegan, gluten_free, spicy_level, available) VALUES
-- Starters
('Paneer Tikka',      'Chargrilled cottage cheese cubes marinated in spiced yogurt',         280, 'Starter',     1, 0, 1, 2, 1),
('Chicken Tikka',     'Tender chicken marinated in aromatic spices & grilled in tandoor',     300, 'Starter',     0, 0, 1, 3, 1),
('Samosa',            'Crispy pastry filled with spiced potatoes & peas',                      80, 'Starter',     1, 1, 0, 2, 1),
('Veg Manchurian',    'Crispy vegetable balls in tangy manchurian sauce',                     200, 'Starter',     1, 1, 0, 3, 1),
('Chicken Wings',     'Spiced chicken wings tossed in chilli sauce',                          220, 'Starter',     0, 0, 1, 3, 1),
('Chicken Soup',      'Hearty clear soup with shredded chicken & vegetables',                 160, 'Starter',     0, 0, 1, 1, 1),

-- Main Course (Veg)
('Dal Makhani',       'Slow-cooked black lentils with butter, cream & spices',                220, 'Main Course', 1, 0, 1, 1, 1),
('Veg Biryani',       'Fragrant basmati rice layered with vegetables & saffron',              260, 'Main Course', 1, 1, 1, 2, 1),
('Palak Paneer',      'Fresh spinach gravy with soft cottage cheese cubes',                   240, 'Main Course', 1, 0, 1, 1, 1),
('Mushroom Masala',   'Button mushrooms in rich onion-tomato masala',                         230, 'Main Course', 1, 1, 1, 2, 1),
('Chana Masala',      'Robust chickpea curry with tangy tomato base',                         200, 'Main Course', 1, 1, 1, 2, 1),
('Pav Bhaji',         'Spiced mashed vegetable curry served with buttered pav',               160, 'Main Course', 1, 0, 0, 2, 1),
('Chole Bhature',     'Spiced chickpeas served with fluffy deep-fried bread',                 220, 'Main Course', 1, 1, 0, 2, 1),

-- Main Course (Non-Veg)
('Butter Chicken',    'Tender chicken in velvety tomato-butter gravy',                        340, 'Main Course', 0, 0, 1, 2, 1),
('Mutton Rogan Josh', 'Slow-cooked Kashmiri-style mutton with whole spices',                  420, 'Main Course', 0, 0, 1, 3, 1),
('Chicken Biryani',   'Fragrant basmati rice layered with spiced chicken',                    320, 'Main Course', 0, 0, 1, 3, 1),
('Fish Curry',        'Coastal-style fish in tangy tamarind coconut gravy',                   360, 'Main Course', 0, 0, 1, 3, 1),
('Mutton Keema',      'Minced mutton cooked with peas & warming spices',                      380, 'Main Course', 0, 0, 1, 3, 1),
('Prawn Masala',      'Juicy prawns in fiery onion-tomato masala',                            440, 'Main Course', 0, 0, 1, 4, 1),
('Egg Curry',         'Hard-boiled eggs in a spiced tomato gravy',                            200, 'Main Course', 0, 0, 1, 2, 1),

-- Bread
('Butter Naan',       'Soft leavened bread brushed with butter from the tandoor',              60, 'Bread',       1, 0, 0, 0, 1),
('Garlic Naan',       'Tandoor-baked naan loaded with garlic & coriander butter',              70, 'Bread',       1, 0, 0, 0, 1),
('Tandoori Roti',     'Whole wheat flatbread baked fresh in the tandoor',                      40, 'Bread',       1, 1, 0, 0, 1),
('Aloo Paratha',      'Whole wheat flatbread stuffed with spiced mashed potatoes',            160, 'Bread',       1, 0, 0, 1, 1),

-- Desserts
('Gulab Jamun',       'Soft milk-solid dumplings soaked in rose-cardamom sugar syrup',        120, 'Dessert',     1, 0, 0, 0, 1),
('Rasgulla',          'Spongy chenna balls in light sugar syrup',                             100, 'Dessert',     1, 0, 0, 0, 1),
('Chocolate Brownie', 'Warm fudgy brownie with a scoop of vanilla ice cream',                 150, 'Dessert',     1, 0, 0, 0, 1),

-- Beverages
('Mango Lassi',       'Thick chilled yogurt blended with Alphonso mango pulp & saffron',      120, 'Beverages',   1, 0, 1, 0, 1),
('Masala Chai',       'Aromatic spiced tea with cardamom, ginger & cinnamon in clay cup',      60, 'Beverages',   1, 1, 1, 0, 1),
('Cold Coffee',       'Rich iced coffee with whipped cream & chocolate drizzle',              140, 'Beverages',   1, 0, 1, 0, 1),
('Fresh Lime Soda',   'Sparkling lime soda with mint, chaat masala & ice',                     80, 'Beverages',   1, 1, 1, 0, 1),
('Watermelon Juice',  'Fresh cold-pressed watermelon juice with a pinch of black salt',        90, 'Beverages',   1, 1, 1, 0, 1),

-- Chinese (Veg)
('Schezwan Noodles',  'Fiery schezwan sauce noodles tossed with vegetables & spring onions',  220, 'Chinese',     1, 1, 0, 4, 1),
('Chilli Paneer',     'Crispy paneer cubes in bold Indo-Chinese chilli sauce',                280, 'Chinese',     1, 0, 0, 3, 1),
('Veg Spring Rolls',  'Golden crispy rolls stuffed with spiced vegetables & glass noodles',   180, 'Chinese',     1, 1, 0, 2, 1),
('Hakka Noodles',     'Stir-fried noodles with cabbage, carrots & soy sauce glaze',           200, 'Chinese',     1, 1, 0, 2, 1),
('Veg Fried Rice',    'Wok-tossed basmati rice with vegetables, soy & sesame oil',            210, 'Chinese',     1, 1, 0, 1, 1),
('Honey Chilli Potato','Crispy potato strips glazed in sweet-spicy honey chilli sauce',       190, 'Chinese',     1, 1, 0, 3, 1),

-- Chinese (Non-Veg)
('Chicken Manchurian','Crispy chicken balls in dark glossy manchurian sauce',                  300, 'Chinese',     0, 0, 0, 3, 1),
('Kung Pao Chicken',  'Spicy Chinese stir-fry with peanuts & dried red chilies',              320, 'Chinese',     0, 0, 0, 4, 1),
('Chicken Fried Rice','Classic wok-tossed rice with chicken strips, egg & soy sauce',         280, 'Chinese',     0, 0, 0, 2, 1);

-- ─── Seed: Default staff account ─────────────────────────────
-- Password: admin123  (change immediately after first login!)
INSERT IGNORE INTO users (name, email, password, role)
VALUES ('Admin', 'admin@plateup.com', 'admin123', 'staff');
