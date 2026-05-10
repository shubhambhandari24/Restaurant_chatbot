-- ============================================================
-- PlateUp — NEW MENU ITEMS: Chinese + Beverages
-- Run this in your MySQL database (plateup / restaurant DB)
-- ============================================================

-- ── BEVERAGES ──────────────────────────────────────────────
INSERT INTO menu_items (name, description, price, category, vegetarian, vegan, gluten_free, spicy_level, available) VALUES
('Mango Lassi',      'Thick chilled yogurt blended with Alphonso mango pulp & saffron',  120, 'Beverages', 1, 0, 1, 0, 1),
('Masala Chai',      'Aromatic spiced tea with cardamom, ginger & cinnamon in clay cup',  60, 'Beverages', 1, 1, 1, 0, 1),
('Cold Coffee',      'Rich iced coffee with whipped cream, chocolate drizzle & coffee foam', 140, 'Beverages', 1, 0, 1, 0, 1),
('Fresh Lime Soda',  'Sparkling lime soda with mint, chaat masala & ice — sweet or salted', 80, 'Beverages', 1, 1, 1, 0, 1),
('Watermelon Juice', 'Fresh cold-pressed watermelon juice with a pinch of black salt',      90, 'Beverages', 1, 1, 1, 0, 1);

-- ── CHINESE (Veg) ──────────────────────────────────────────
INSERT INTO menu_items (name, description, price, category, vegetarian, vegan, gluten_free, spicy_level, available) VALUES
('Schezwan Noodles',         'Fiery schezwan sauce noodles tossed with vegetables & spring onions', 220, 'Chinese', 1, 1, 0, 4, 1),
('Chilli Paneer',            'Crispy paneer cubes in bold Indo-Chinese chilli sauce with peppers',   280, 'Chinese', 1, 0, 0, 3, 1),
('Veg Spring Rolls',         'Golden crispy rolls stuffed with spiced vegetables & glass noodles',   180, 'Chinese', 1, 1, 0, 2, 1),
('Hakka Noodles',            'Stir-fried noodles with cabbage, carrots & soy sauce glaze',          200, 'Chinese', 1, 1, 0, 2, 1),
('Veg Fried Rice',           'Wok-tossed basmati rice with vegetables, soy & sesame oil',           210, 'Chinese', 1, 1, 0, 1, 1),
('Honey Chilli Potato',      'Crispy potato strips glazed in sweet-spicy honey chilli sauce',        190, 'Chinese', 1, 1, 0, 3, 1);

-- ── CHINESE (Non-Veg) ─────────────────────────────────────
INSERT INTO menu_items (name, description, price, category, vegetarian, vegan, gluten_free, spicy_level, available) VALUES
('Chicken Manchurian',  'Crispy chicken balls in dark glossy manchurian sauce with spring onions', 300, 'Chinese', 0, 0, 0, 3, 1),
('Kung Pao Chicken',    'Spicy Chinese stir-fry with peanuts, dried red chilies & vegetables',    320, 'Chinese', 0, 0, 0, 4, 1),
('Chicken Fried Rice',  'Classic wok-tossed rice with chicken strips, egg & soy sauce',           280, 'Chinese', 0, 0, 0, 2, 1);
