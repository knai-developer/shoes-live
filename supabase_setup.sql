-- ============================================================
-- SOLESTRIDE — SUPABASE SQL SETUP
-- Supabase SQL Editor mein yeh poora code paste karein
-- ============================================================

-- ============================================================
-- STEP 1: PRODUCTS TABLE BANAO
-- ============================================================
CREATE TABLE IF NOT EXISTS public.products (
  id            BIGSERIAL PRIMARY KEY,
  name          TEXT        NOT NULL,
  category      TEXT        NOT NULL CHECK (category IN ('Men', 'Women', 'Kids')),
  price         INTEGER     NOT NULL CHECK (price > 0),
  original_price INTEGER     DEFAULT NULL,
  description   TEXT        DEFAULT '',
  image_url     TEXT        DEFAULT NULL,
  badge         TEXT        DEFAULT NULL,
  is_active     BOOLEAN     DEFAULT TRUE,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- STEP 2: AUTO UPDATE "updated_at" TRIGGER
-- ============================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS set_updated_at ON products;
CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON products
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ============================================================
-- STEP 3: ROW LEVEL SECURITY (RLS) ON KARO
-- ============================================================
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

-- Public (index.html) sirf active products padh sakta hai
CREATE POLICY "Public can read active products"
  ON public.products
  FOR SELECT
  USING (is_active = TRUE);

-- Anon key se sab kuch allow karo (admin ke liye)
-- NOTE: Production mein service_role key use karein admin ke liye
CREATE POLICY "Allow all for anon"
  ON public.products
  FOR ALL
  USING (TRUE)
  WITH CHECK (TRUE);

-- ============================================================
-- STEP 4: STORAGE BUCKET BANAO (SQL se nahi hota, manually karo)
-- ============================================================
-- Supabase Dashboard → Storage → New Bucket
-- Bucket Name: product-images
-- Public Bucket: YES (toggle on karo)

-- Lekin Storage Policy SQL se add kar sakte hain:
-- (Pehle bucket banao, phir yeh run karo)

-- Public can read images
-- INSERT INTO storage.policies (name, bucket_id, operation, definition)
-- VALUES (
--   'Public Read Images',
--   'product-images',
--   'SELECT',
--   'TRUE'
-- );

-- ============================================================
-- STEP 5: TEST DATA (OPTIONAL — delete kar sakte ho baad mein)
-- ============================================================
INSERT INTO public.products (name, category, price, original_price, description, badge, is_active)
VALUES
  (
    'Nike Air Max 270',
    'Men',
    8500,
    12000,
    'Lightweight and breathable running shoes with exceptional cushioning. Perfect for daily use and sports activities.',
    'Best Seller',
    TRUE
  ),
  (
    'Adidas Ultra Boost',
    'Men',
    9200,
    NULL,
    'Premium running shoes with responsive Boost midsole. Ideal for long distance running and gym workouts.',
    'New Arrival',
    TRUE
  ),
  (
    'Puma Suede Classic',
    'Women',
    5500,
    7000,
    'Iconic suede upper with timeless style. These versatile sneakers pair perfectly with any casual outfit.',
    'Sale',
    TRUE
  ),
  (
    'Converse Chuck Taylor',
    'Women',
    4800,
    NULL,
    'The classic canvas sneaker that never goes out of style. Available in multiple colors.',
    NULL,
    TRUE
  ),
  (
    'Skechers Go Walk',
    'Kids',
    3200,
    4000,
    'Super lightweight and flexible kids shoes. Perfect for school and play with slip-resistant sole.',
    'Hot',
    TRUE
  ),
  (
    'Nike Revolution',
    'Kids',
    3800,
    NULL,
    'Durable and comfortable kids sneakers with easy on/off design. Great for active children.',
    NULL,
    TRUE
  );

-- ============================================================
-- STEP 6: VERIFY TABLE
-- ============================================================
SELECT * FROM public.products ORDER BY created_at DESC;

-- ============================================================
-- USEFUL QUERIES (Admin ke liye reference)
-- ============================================================

-- Sab products dekhna:
-- SELECT * FROM products;

-- Sirf active products:
-- SELECT * FROM products WHERE is_active = TRUE;

-- Category filter:
-- SELECT * FROM products WHERE category = 'Men';

-- Product delete karna:
-- DELETE FROM products WHERE id = 1;

-- Product update karna:
-- UPDATE products SET price = 5000 WHERE id = 1;

-- Product inactive karna (hide from website):
-- UPDATE products SET is_active = FALSE WHERE id = 1;

-- Sab products count:
-- SELECT COUNT(*) FROM products;

-- Category wise count:
-- SELECT category, COUNT(*) FROM products GROUP BY category;

-- Average price:
-- SELECT AVG(price) FROM products WHERE is_active = TRUE;
