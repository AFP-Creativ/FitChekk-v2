-- ============================================================================
-- FitChekk Database Schema v1.0
-- ============================================================================
-- Run this in Supabase SQL Editor: https://supabase.com/dashboard/project/paufghpcdsvspznnygxo/editor
--
-- This script creates:
-- - 5 main tables (users, user_preferences, wardrobe_items, outfits, planner_entries)
-- - Row-Level Security (RLS) policies
-- - Performance indexes
-- - Automatic timestamp triggers
-- - User signup handler function
-- ============================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- TABLE: users
-- ============================================================================
-- Extends Supabase auth.users with app-specific profile data
-- ============================================================================

CREATE TABLE public.users (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  email TEXT,
  display_name TEXT,
  subscription_tier TEXT NOT NULL DEFAULT 'free' CHECK (subscription_tier IN ('free', 'premium')),
  subscription_status TEXT CHECK (subscription_status IN ('active', 'canceled', 'expired', 'trial')),
  trial_ends_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================================
-- TABLE: user_preferences
-- ============================================================================
-- Stores user's style preferences and app settings
-- ============================================================================

CREATE TABLE public.user_preferences (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
  style_preferences TEXT[] DEFAULT '{}',
  favorite_colors TEXT[] DEFAULT '{}',
  lifestyle_type TEXT,
  activity_level TEXT,
  occasions TEXT[] DEFAULT '{}',
  climate_type TEXT,
  measurement_system TEXT DEFAULT 'imperial',
  enable_notifications BOOLEAN DEFAULT true,
  notification_time TIME,
  onboarding_completed BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id)
);

-- ============================================================================
-- TABLE: wardrobe_items
-- ============================================================================
-- Stores individual clothing items with AI-extracted attributes
-- ============================================================================

CREATE TABLE public.wardrobe_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
  name TEXT,
  category TEXT NOT NULL,
  sub_category TEXT NOT NULL,
  brand TEXT,
  purchase_date DATE,
  purchase_price DECIMAL(10,2),
  
  -- Images
  image_url TEXT,
  thumbnail_url TEXT,
  
  -- AI attributes
  ai_generated BOOLEAN DEFAULT false,
  colors TEXT[] DEFAULT '{}',
  pattern TEXT,
  formality INTEGER CHECK (formality BETWEEN 1 AND 5),
  style_tags TEXT[] DEFAULT '{}',
  seasons TEXT[] DEFAULT '{}',
  material_type TEXT,
  ai_confidence DECIMAL(3,2),
  
  -- User metadata
  is_favorite BOOLEAN DEFAULT false,
  notes TEXT,
  is_archived BOOLEAN DEFAULT false,
  
  -- Usage stats
  times_worn INTEGER DEFAULT 0,
  last_worn_date DATE,
  
  -- Sync
  needs_sync BOOLEAN DEFAULT false,
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================================
-- TABLE: outfits
-- ============================================================================
-- Stores outfit combinations with AI-generated suggestions
-- ============================================================================

CREATE TABLE public.outfits (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  occasion TEXT,
  season TEXT,
  notes TEXT,
  
  -- AI attributes
  ai_generated BOOLEAN DEFAULT false,
  ai_reasoning TEXT,
  ai_style_score DECIMAL(3,2),
  
  -- Weather snapshot (at time of creation)
  weather_temp_high INTEGER,
  weather_temp_low INTEGER,
  weather_condition TEXT,
  
  -- Usage stats
  times_worn INTEGER DEFAULT 0,
  last_worn_date DATE,
  user_rating INTEGER CHECK (user_rating BETWEEN 1 AND 5),
  
  -- Item references (stored as array of UUIDs)
  item_ids UUID[] NOT NULL DEFAULT '{}',
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================================
-- TABLE: planner_entries
-- ============================================================================
-- Stores planned outfits by date with weather data
-- ============================================================================

CREATE TABLE public.planner_entries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
  date DATE NOT NULL,
  outfit_id UUID REFERENCES public.outfits(id) ON DELETE SET NULL,
  
  -- Status
  is_worn BOOLEAN DEFAULT false,
  marked_worn_at TIMESTAMPTZ,
  
  -- Cached weather
  weather_temp_high INTEGER,
  weather_temp_low INTEGER,
  weather_condition TEXT,
  weather_feels_like INTEGER,
  weather_humidity INTEGER,
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  UNIQUE(user_id, date)
);

-- ============================================================================
-- INDEXES
-- ============================================================================
-- Performance indexes for common queries
-- ============================================================================

CREATE INDEX idx_wardrobe_items_user_id ON public.wardrobe_items(user_id);
CREATE INDEX idx_wardrobe_items_category ON public.wardrobe_items(category);
CREATE INDEX idx_wardrobe_items_is_archived ON public.wardrobe_items(is_archived);
CREATE INDEX idx_outfits_user_id ON public.outfits(user_id);
CREATE INDEX idx_planner_entries_user_date ON public.planner_entries(user_id, date);

-- ============================================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================================
-- Enable RLS on all tables
-- ============================================================================

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.wardrobe_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.outfits ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.planner_entries ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- RLS POLICIES
-- ============================================================================

-- Users: Can only read/update own profile
CREATE POLICY "Users can view own profile" ON public.users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.users
  FOR UPDATE USING (auth.uid() = id);

-- User preferences: Full CRUD on own preferences
CREATE POLICY "Users can manage own preferences" ON public.user_preferences
  FOR ALL USING (auth.uid() = user_id);

-- Wardrobe items: Full CRUD on own items
CREATE POLICY "Users can manage own wardrobe" ON public.wardrobe_items
  FOR ALL USING (auth.uid() = user_id);

-- Outfits: Full CRUD on own outfits
CREATE POLICY "Users can manage own outfits" ON public.outfits
  FOR ALL USING (auth.uid() = user_id);

-- Planner entries: Full CRUD on own entries
CREATE POLICY "Users can manage own planner" ON public.planner_entries
  FOR ALL USING (auth.uid() = user_id);

-- ============================================================================
-- FUNCTIONS
-- ============================================================================

-- Auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to create user profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, display_name)
  VALUES (NEW.id, NEW.email, NEW.raw_user_meta_data->>'display_name');
  
  INSERT INTO public.user_preferences (user_id)
  VALUES (NEW.id);
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- TRIGGERS
-- ============================================================================

-- Triggers for updated_at auto-update
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_preferences_updated_at BEFORE UPDATE ON public.user_preferences
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_wardrobe_items_updated_at BEFORE UPDATE ON public.wardrobe_items
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_outfits_updated_at BEFORE UPDATE ON public.outfits
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_planner_entries_updated_at BEFORE UPDATE ON public.planner_entries
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Trigger to create profile on signup
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ============================================================================
-- SCHEMA DEPLOYMENT COMPLETE
-- ============================================================================
-- Next step: Create storage bucket 'wardrobe-images' via Supabase Dashboard
-- See: supabase_storage_policies.sql
-- ============================================================================

