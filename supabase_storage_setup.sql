-- ============================================================
-- Zohour Naturals: photo storage for the admin panel
-- Paste this whole file into Supabase SQL Editor and click Run.
-- ============================================================

-- a public bucket to hold product photos uploaded from admin.html
insert into storage.buckets (id, name, public)
values ('product-photos', 'product-photos', true)
on conflict (id) do nothing;

-- anyone can view photos (needed for the public storefront)
drop policy if exists "Public can view product photos" on storage.objects;
create policy "Public can view product photos"
  on storage.objects for select
  to anon, authenticated
  using (bucket_id = 'product-photos');

-- only a signed-in admin can upload/replace/remove photos
drop policy if exists "Authenticated can upload product photos" on storage.objects;
create policy "Authenticated can upload product photos"
  on storage.objects for insert
  to authenticated
  with check (bucket_id = 'product-photos');

drop policy if exists "Authenticated can update product photos" on storage.objects;
create policy "Authenticated can update product photos"
  on storage.objects for update
  to authenticated
  using (bucket_id = 'product-photos');

drop policy if exists "Authenticated can delete product photos" on storage.objects;
create policy "Authenticated can delete product photos"
  on storage.objects for delete
  to authenticated
  using (bucket_id = 'product-photos');

-- a place on each product row to remember its uploaded photo's URL
alter table products add column if not exists photo_url text;
