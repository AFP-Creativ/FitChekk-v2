-- ============================================================================
-- FitChekk Storage Bucket Policies
-- ============================================================================
-- Run this AFTER creating the 'wardrobe-images' bucket in Supabase Storage
--
-- To create the bucket:
-- 1. Go to: Storage → Create new bucket
-- 2. Name: wardrobe-images
-- 3. Settings:
--    - Private: Yes
--    - Max file size: 10MB
--    - Allowed MIME types: image/jpeg, image/png, image/heic, image/webp
-- 4. Create bucket
-- 5. Then run this SQL in SQL Editor
-- ============================================================================

-- Users can upload images to their own folder
CREATE POLICY "Users can upload own images" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'wardrobe-images' 
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

-- Users can view their own images
CREATE POLICY "Users can view own images" ON storage.objects
  FOR SELECT USING (
    bucket_id = 'wardrobe-images' 
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

-- Users can update their own images
CREATE POLICY "Users can update own images" ON storage.objects
  FOR UPDATE USING (
    bucket_id = 'wardrobe-images' 
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

-- Users can delete their own images
CREATE POLICY "Users can delete own images" ON storage.objects
  FOR DELETE USING (
    bucket_id = 'wardrobe-images' 
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

-- ============================================================================
-- STORAGE POLICIES COMPLETE
-- ============================================================================
-- Images will be stored with path structure: {user_id}/{item_id}.jpg
-- This ensures automatic RLS enforcement via folder name matching
-- ============================================================================

