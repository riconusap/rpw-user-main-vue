-- Storage Policies for Clients Bucket
-- Run these SQL commands in your Supabase SQL Editor after creating the 'clients' bucket

-- Allow public to view client logos
CREATE POLICY "Allow public to view client logos"
ON storage.objects FOR SELECT
USING (bucket_id = 'clients');

-- Allow authenticated users to upload client logos
CREATE POLICY "Allow authenticated users to upload client logos"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'clients');

-- Allow authenticated users to update client logos
CREATE POLICY "Allow authenticated users to update client logos"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'clients');

-- Allow authenticated users to delete client logos
CREATE POLICY "Allow authenticated users to delete client logos"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'clients');
