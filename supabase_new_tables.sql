-- ============================================================
-- SOLESTRIDE — SUPABASE SQL (STEP 2 — Naye Tables)
-- SQL Editor mein yeh poora code paste karein aur Run karein
-- ============================================================

-- ============================================================
-- TABLE 1: site_sections
-- Admin se "Our Story", "Premium Quality" images + text control
-- ============================================================
CREATE TABLE IF NOT EXISTS public.site_sections (
  id          BIGSERIAL PRIMARY KEY,
  section_key TEXT UNIQUE NOT NULL,   -- e.g. 'story', 'premium_quality', 'cat_men', 'cat_women', 'cat_kids'
  title       TEXT,
  subtitle    TEXT,
  description TEXT,
  image_url   TEXT,
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- TABLE 2: gallery_images
-- Admin se Gallery section ki 4 images
-- ============================================================
CREATE TABLE IF NOT EXISTS public.gallery_images (
  id          BIGSERIAL PRIMARY KEY,
  position    INTEGER NOT NULL DEFAULT 1,  -- 1,2,3,4
  image_url   TEXT NOT NULL,
  caption     TEXT DEFAULT '',
  is_active   BOOLEAN DEFAULT TRUE,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- TABLE 3: instagram_images
-- Admin se Instagram section ki 4 images
-- ============================================================
CREATE TABLE IF NOT EXISTS public.instagram_images (
  id          BIGSERIAL PRIMARY KEY,
  position    INTEGER NOT NULL DEFAULT 1,  -- 1,2,3,4
  image_url   TEXT NOT NULL,
  link_url    TEXT DEFAULT '#',
  is_active   BOOLEAN DEFAULT TRUE,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- RLS: Enable on all new tables
-- ============================================================
ALTER TABLE public.site_sections      ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.gallery_images     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.instagram_images   ENABLE ROW LEVEL SECURITY;

-- Public READ access
CREATE POLICY "Public read site_sections"
  ON public.site_sections FOR SELECT USING (TRUE);

CREATE POLICY "Public read gallery"
  ON public.gallery_images FOR SELECT USING (is_active = TRUE);

CREATE POLICY "Public read instagram"
  ON public.instagram_images FOR SELECT USING (is_active = TRUE);

-- Admin full access (anon key se)
CREATE POLICY "Admin all site_sections"
  ON public.site_sections FOR ALL USING (TRUE) WITH CHECK (TRUE);

CREATE POLICY "Admin all gallery"
  ON public.gallery_images FOR ALL USING (TRUE) WITH CHECK (TRUE);

CREATE POLICY "Admin all instagram"
  ON public.instagram_images FOR ALL USING (TRUE) WITH CHECK (TRUE);

-- ============================================================
-- DEFAULT DATA: site_sections ke liye default rows
-- ============================================================
INSERT INTO public.site_sections (section_key, title, subtitle, description, image_url)
VALUES
  (
    'cat_men',
    'Men''s Collection',
    'Sports, Casual & Formal',
    '',
    ''
  ),
  (
    'cat_women',
    'Women''s Collection',
    'Heels, Flats & Sneakers',
    '',
    ''
  ),
  (
    'cat_kids',
    'Kids'' Collection',
    'Comfy & Durable Styles',
    '',
    ''
  ),
  (
    'story',
    'Passion for Every Step',
    'Our Story',
    'SoleStride was born from a simple belief: everyone deserves footwear that feels as good as it looks. We partner with trusted manufacturers to bring you authentic, high-quality footwear for the entire family.',
    ''
  ),
  (
    'premium_quality',
    'Built to Last, Made to Impress',
    'Premium Quality',
    'Each pair of SoleStride shoes is carefully selected for durability, comfort, and style. We work only with manufacturers who meet our strict quality standards.',
    ''
  )
ON CONFLICT (section_key) DO NOTHING;

-- ============================================================
-- Verify
-- ============================================================
SELECT * FROM public.site_sections;
SELECT * FROM public.gallery_images;
SELECT * FROM public.instagram_images;
