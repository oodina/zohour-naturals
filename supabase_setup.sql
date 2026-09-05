-- ============================================================
-- Zohour Naturals: products table + policies + data migration
-- Paste this whole file into Supabase SQL Editor and click Run.
-- ============================================================

create table if not exists products (
  id text primary key,
  category text not null,
  brand text,
  icon text not null default 'i-jar',
  accent text not null default 'gold',
  in_stock boolean not null default true,
  price numeric not null default 0,
  discount numeric not null default 0,
  multi boolean not null default false,
  sort_order integer not null default 0,
  name_en text not null default '',
  name_ar text not null default '',
  name_ru text not null default '',
  tagline_en text not null default '',
  tagline_ar text not null default '',
  tagline_ru text not null default '',
  desc_en text not null default '',
  desc_ar text not null default '',
  desc_ru text not null default '',
  howto_en text not null default '',
  howto_ar text not null default '',
  howto_ru text not null default '',
  skin text[] not null default '{}',
  updated_at timestamptz not null default now()
);

alter table products enable row level security;

drop policy if exists "Public can view products" on products;
create policy "Public can view products"
  on products for select
  to anon, authenticated
  using (true);

drop policy if exists "Authenticated can manage products" on products;
create policy "Authenticated can manage products"
  on products for all
  to authenticated
  using (true)
  with check (true);

-- one-time data migration from the site's current hardcoded catalog
insert into products (id, category, brand, icon, accent, in_stock, price, discount, multi, sort_order, name_en, name_ar, name_ru, tagline_en, tagline_ar, tagline_ru, desc_en, desc_ar, desc_ru, howto_en, howto_ar, howto_ru, skin)
values (
  'black-soap', 'soaps', null, 'i-jar', 'gold',
  true, 0, 0, false, 0,
  'Moroccan Black Soap (Beldi)', 'صابون بلدي مغربي أصلي', 'Марокканское чёрное мыло (Бельди)',
  'Traditional olive-oil savon beldi', 'صابون بلدي تقليدي بزيت الزيتون', 'Традиционное мыло бельди на оливковом масле',
  'A warm, olive-oil-based paste soap used to open and soften skin before exfoliating. Worked in circles over damp skin, it melts away impurities and leaves the surface ready for the kessa glove.', 'صابون عجيني دافئ بزيت الزيتون يُستخدم لتنعيم البشرة وفتح مساماتها قبل التقشير. يُدلّك بحركات دائرية على بشرة مبللة ليزيل الشوائب ويجهزها لكيس التقشير.', 'Тёплое пастообразное мыло на оливковом масле, которое размягчает и раскрывает поры перед пилингом. Круговыми движениями наносится на влажную кожу, растворяет загрязнения и готовит кожу к рукавице кесса.',
  'Apply a thick layer on damp skin, leave 5–10 minutes in a warm, steamy room, then rinse and follow with the kessa glove.', 'يوضع بسخاء على بشرة مبللة، يُترك 5-10 دقائق في مكان دافئ ورطب، ثم يُشطف ويُتبع بكيس التقشير.', 'Нанесите толстым слоем на влажную кожу, оставьте на 5–10 минут в тёплом влажном помещении, затем смойте и продолжите рукавицей кесса.',
  ARRAY['dry','normal','combination']
)
on conflict (id) do nothing;

insert into products (id, category, brand, icon, accent, in_stock, price, discount, multi, sort_order, name_en, name_ar, name_ru, tagline_en, tagline_ar, tagline_ru, desc_en, desc_ar, desc_ru, howto_en, howto_ar, howto_ru, skin)
values (
  'kessa-glove', 'hammam-tools', null, 'i-mitt', 'maroon',
  true, 0, 0, false, 1,
  'Traditional Kessa Exfoliating Glove', 'كيس الحمام المغربي التقليدي', 'Традиционная рукавица кесса для пилинга',
  'Hand-woven hammam exfoliating mitt', 'كيس تقشير حماكي منسوج يدويًا', 'Тканая рукавица для хаммама ручной работы',
  'The woven glove used in every Moroccan hammam. Once the skin has been softened with black soap and steam, it lifts away dead skin in long, visible rolls, leaving the whole body smooth.', 'الكيس المنسوج المستخدم في كل حمام مغربي. بعد تليين البشرة بالصابون البلدي والبخار، يزيل خلايا الجلد الميتة ليترك الجسم كله ناعمًا.', 'Тканая рукавица, которую используют в каждом марокканском хаммаме. После того как кожа размягчена чёрным мылом и паром, она снимает омертвевшие клетки длинными заметными «скрутками», оставляя тело гладким.',
  'Use only on skin that has been soaked or steamed and coated with black soap. Rub gently in circular motions — no need to press hard.', 'يُستخدم فقط على بشرة مُبللة أو مُبخّرة ومغطاة بالصابون البلدي. افركي بلطف بحركات دائرية دون الحاجة للضغط.', 'Используйте только на распаренной или размоченной коже, покрытой чёрным мылом. Мягко трите круговыми движениями — сильно давить не нужно.',
  ARRAY['oily','combination','normal']
)
on conflict (id) do nothing;

insert into products (id, category, brand, icon, accent, in_stock, price, discount, multi, sort_order, name_en, name_ar, name_ru, tagline_en, tagline_ar, tagline_ru, desc_en, desc_ar, desc_ru, howto_en, howto_ar, howto_ru, skin)
values (
  'ghassoul-clay', 'face-hair', null, 'i-stones', 'sage',
  true, 0, 0, false, 2,
  'Moroccan Clay (Ghassoul)', 'طين مغربي طبيعي (الغاسول)', 'Марокканская глина (Гассуль)',
  'Mineral clay from the Atlas mountains', 'طين معدني من جبال الأطلس', 'Минеральная глина из гор Атлас',
  'Raw mineral clay stones, traditionally dissolved in water into a smooth paste. Used as a mask for the face and hair, it draws out excess oil and buildup without stripping the skin with soap.', 'حجارة طين معدني خام تُذاب تقليديًا في الماء لتشكيل عجينة ناعمة. تُستخدم كقناع للوجه والشعر، وتمتص الزيوت الزائدة والشوائب دون تجريد البشرة.', 'Куски необработанной минеральной глины, которые традиционно растворяют в воде до гладкой пасты. Используется как маска для лица и волос, впитывает лишний жир и загрязнения, не пересушивая кожу мылом.',
  'Dissolve a few pieces in warm water until smooth. Apply to face or scalp, let it dry slightly, then rinse thoroughly. 1–2 times a week is enough.', 'أذيبي بضع قطع في ماء دافئ حتى تصبح العجينة ناعمة. ضعيها على الوجه أو فروة الرأس، اتركيها حتى تجف قليلًا، ثم اشطفي جيدًا. مرة أو مرتين أسبوعيًا كافية.', 'Растворите несколько кусочков в тёплой воде до однородности. Нанесите на лицо или кожу головы, дайте слегка подсохнуть, затем тщательно смойте. Достаточно 1–2 раз в неделю.',
  ARRAY['oily','combination']
)
on conflict (id) do nothing;

insert into products (id, category, brand, icon, accent, in_stock, price, discount, multi, sort_order, name_en, name_ar, name_ru, tagline_en, tagline_ar, tagline_ru, desc_en, desc_ar, desc_ru, howto_en, howto_ar, howto_ru, skin)
values (
  'moroccan-soap', 'soaps', null, 'i-jar', 'maroon',
  true, 0, 0, false, 3,
  'Natural Moroccan Soap', 'الصابون المغربي الطبيعي', 'Натуральное марокканское мыло',
  'Handmade daily soap', 'صابون يدوي للاستخدام اليومي', 'Мыло ручной работы для ежедневного ухода',
  'A natural bar-style soap made by Moroccan hands for gentle, everyday cleansing — a softer, quicker alternative to a full black-soap hammam ritual.', 'صابون طبيعي مصنوع يدويًا من طرف حرفيات مغربيات، للتنظيف اليومي اللطيف — بديل أسرع وألطف عن طقوس الصابون البلدي الكاملة.', 'Натуральное мыло в виде бруска, сделанное вручную марокканскими мастерицами, для бережного ежедневного очищения — более мягкая и быстрая альтернатива полному ритуалу с чёрным мылом.',
  'Lather with water and use daily on body or hands.', 'يُرغّى بالماء ويُستخدم يوميًا للجسم أو اليدين.', 'Вспеньте с водой и используйте ежедневно для тела или рук.',
  ARRAY['dry','sensitive','normal']
)
on conflict (id) do nothing;

insert into products (id, category, brand, icon, accent, in_stock, price, discount, multi, sort_order, name_en, name_ar, name_ru, tagline_en, tagline_ar, tagline_ru, desc_en, desc_ar, desc_ru, howto_en, howto_ar, howto_ru, skin)
values (
  'soap-collection', 'soaps', null, 'i-jar', 'rose',
  true, 0, 0, true, 4,
  'Scrub Soap Collection', 'مجموعة صابون التقشير الملون', 'Коллекция мыла-скраба',
  '4 scented exfoliating creams to choose from', '4 روائح لصابون التقشير الكريمي', '4 аромата кремового мыла-скраба на выбор',
  'Our creamy exfoliating soap in four scents and colors. Softer than a clay mask and more scented than plain black soap — a nice everyday scrub for the shower.', 'صابون تقشير كريمي بأربع روائح وألوان. أخف من قناع الطين وبرائحة أجمل من الصابون البلدي العادي — مقشر يومي لطيف للاستحمام.', 'Наше кремовое мыло-скраб в четырёх ароматах и цветах. Мягче, чем маска из глины, и ароматнее, чем обычное чёрное мыло — приятный ежедневный скраб для душа.',
  'Massage onto wet skin in the shower, focusing on elbows, knees and heels, then rinse.', 'يُدلّك على بشرة مبللة أثناء الاستحمام، مع التركيز على المرفقين والركبتين والكعبين، ثم يُشطف.', 'Массирующими движениями нанесите на влажную кожу в душе, уделяя внимание локтям, коленям и пяткам, затем смойте.',
  ARRAY['oily','combination','normal']
)
on conflict (id) do nothing;

insert into products (id, category, brand, icon, accent, in_stock, price, discount, multi, sort_order, name_en, name_ar, name_ru, tagline_en, tagline_ar, tagline_ru, desc_en, desc_ar, desc_ru, howto_en, howto_ar, howto_ru, skin)
values (
  'herbal-powder', 'face-hair', null, 'i-powder', 'sage',
  true, 0, 0, false, 5,
  'Natural Herbal Powder', 'مسحوق أعشاب طبيعي', 'Натуральный травяной порошок',
  'Fine ground herbal blend for hair & skin', 'مسحوق أعشاب ناعم للشعر والبشرة', 'Мелкомолотая травяная смесь для волос и кожи',
  'A finely milled natural herbal powder used in Moroccan beauty rituals, mixed with water into a paste for a hair or skin treatment. Exact herb blend to be confirmed with the shop owner.', 'مسحوق أعشاب طبيعي ناعم يُستخدم في طقوس الجمال المغربية، يُمزج بالماء ليصبح عجينة للشعر أو البشرة. سيتم تأكيد تركيبة الأعشاب بالضبط مع صاحبة المتجر.', 'Мелко смолотый натуральный травяной порошок, используемый в марокканских ритуалах красоты, смешивается с водой до состояния пасты для ухода за волосами или кожей. Точный состав трав уточняется у владелицы магазина.',
  'Mix with warm water (or argan oil for hair) into a paste, apply, leave 20–30 minutes, then rinse well.', 'يُمزج بالماء الدافئ (أو بزيت الأركان للشعر) ليصبح عجينة، يُوضع ويُترك 20-30 دقيقة، ثم يُشطف جيدًا.', 'Смешайте с тёплой водой (или маслом арганы для волос) до состояния пасты, нанесите, оставьте на 20–30 минут, затем тщательно смойте.',
  ARRAY['oily','normal']
)
on conflict (id) do nothing;

insert into products (id, category, brand, icon, accent, in_stock, price, discount, multi, sort_order, name_en, name_ar, name_ru, tagline_en, tagline_ar, tagline_ru, desc_en, desc_ar, desc_ru, howto_en, howto_ar, howto_ru, skin)
values (
  'parfum', 'fragrance', null, 'i-spray', 'gold',
  true, 0, 0, false, 6,
  'Bain de Parfum — French', 'عطر باين دو بارفان الفرنسي', 'Bain de Parfum — французский аромат',
  'Fine fragrance spray, 80ml', 'عطر بخاخ فاخر، 80 مل', 'Изысканный парфюмерный спрей, 80 мл',
  'A light, long-lasting fragrance spray in the French eau-de-parfum style. Perfect for finishing off a hammam day with a soft, lingering scent.', 'عطر خفيف وثابت على طريقة العطور الفرنسية الفاخرة. مثالي لإنهاء يوم الحمام برائحة ناعمة تدوم طويلًا.', 'Лёгкий стойкий парфюмерный спрей во французском стиле eau de parfum. Идеален, чтобы завершить день в хаммаме мягким, долгим ароматом.',
  'Spray on pulse points — wrists, neck — after showering, on clean skin.', 'يُرش على نقاط النبض — المعصمين والرقبة — بعد الاستحمام وعلى بشرة نظيفة.', 'Распылите на пульсирующие точки — запястья, шею — после душа, на чистую кожу.',
  '{}'
)
on conflict (id) do nothing;

insert into products (id, category, brand, icon, accent, in_stock, price, discount, multi, sort_order, name_en, name_ar, name_ru, tagline_en, tagline_ar, tagline_ru, desc_en, desc_ar, desc_ru, howto_en, howto_ar, howto_ru, skin)
values (
  'hammam-box', 'gifts', null, 'i-gift', 'gold',
  true, 0, 0, false, 7,
  'Hammam Ritual Gift Box', 'صندوق هدية طقوس الحمام', 'Подарочный набор для ритуала хаммама',
  'Kessa glove, clay, rose oil & black soap', 'كيس تقشير، طين، زيت ورد وصابون بلدي', 'Рукавица кесса, глина, розовое масло и чёрное мыло',
  'Everything needed for a full at-home hammam ritual, packed as a gift: exfoliating glove, Moroccan clay, rose oil and black soap. A popular first purchase for someone new to Moroccan beauty rituals.', 'كل ما يلزم لطقوس حمام كاملة في المنزل، معبأة كهدية: كيس تقشير، طين مغربي، زيت ورد وصابون بلدي. هدية مثالية لمن يكتشف طقوس الجمال المغربية لأول مرة.', 'Всё необходимое для полного ритуала хаммама дома, упаковано как подарок: рукавица для пилинга, марокканская глина, розовое масло и чёрное мыло. Популярная первая покупка для тех, кто открывает для себя марокканские ритуалы красоты.',
  'Follow the order inside: black soap first, then the glove, then rinse, then the clay mask, finished with rose oil.', 'اتبعي الترتيب بالداخل: الصابون البلدي أولًا، ثم الكيس، ثم الشطف، ثم قناع الطين، وأخيرًا زيت الورد.', 'Следуйте порядку внутри: сначала чёрное мыло, затем рукавица, затем ополаскивание, затем маска из глины, и в завершение — розовое масло.',
  '{}'
)
on conflict (id) do nothing;

insert into products (id, category, brand, icon, accent, in_stock, price, discount, multi, sort_order, name_en, name_ar, name_ru, tagline_en, tagline_ar, tagline_ru, desc_en, desc_ar, desc_ru, howto_en, howto_ar, howto_ru, skin)
values (
  'bikini-balm', 'intimate', 'Moulin Rouge', 'i-drop', 'rose',
  true, 0, 0, false, 8,
  'Bikini Balm', 'بلسم البكيني', 'Бальзам Bikini Balm',
  'Soothing balm after hair removal, 30ml', 'بلسم مهدئ بعد إزالة الشعر، 30 مل', 'Успокаивающий бальзам после депиляции, 30 мл',
  'A moisturising balm formulated to calm skin right after waxing or shaving and help prevent ingrown hairs.', 'بلسم مرطب مصمم لتهدئة البشرة مباشرة بعد إزالة الشعر بالشمع أو الحلاقة، ويساعد على منع نمو الشعر تحت الجلد.', 'Увлажняющий бальзам, разработанный для успокоения кожи сразу после депиляции воском или бритья, помогает предотвратить врастание волос.',
  'Apply a thin layer to clean, dry skin right after hair removal, and again the next day.', 'يوضع بطبقة رقيقة على بشرة نظيفة وجافة مباشرة بعد إزالة الشعر، ويُكرر في اليوم التالي.', 'Нанесите тонким слоем на чистую сухую кожу сразу после депиляции и повторите на следующий день.',
  ARRAY['sensitive']
)
on conflict (id) do nothing;

insert into products (id, category, brand, icon, accent, in_stock, price, discount, multi, sort_order, name_en, name_ar, name_ru, tagline_en, tagline_ar, tagline_ru, desc_en, desc_ar, desc_ru, howto_en, howto_ar, howto_ru, skin)
values (
  'musk-wash', 'intimate', 'Kayan Cosmetics', 'i-spray', 'rose',
  true, 0, 0, false, 9,
  'Zahara Musk Intimate Wash', 'غسول مسك الطهارة زهرة', 'Интимный гель Zahara Musk',
  'Gentle pH-balanced intimate cleanser', 'غسول لطيف متوازن الحموضة للعناية الحميمة', 'Мягкое средство для интимной гигиены с pH-балансом',
  'A gentle, pH-balanced daily wash with a soft musk scent, formulated specifically for intimate skin.', 'غسول يومي لطيف متوازن الحموضة برائحة مسك ناعمة، مخصص للبشرة الحساسة في المناطق الحميمة.', 'Мягкое ежедневное средство для интимной гигиены с pH-балансом и нежным мускусным ароматом, разработано специально для деликатной зоны.',
  'Use daily during showering, external use only, rinse with water.', 'يُستخدم يوميًا أثناء الاستحمام، للاستخدام الخارجي فقط، ويُشطف بالماء.', 'Используйте ежедневно во время душа, только наружно, смывайте водой.',
  ARRAY['sensitive']
)
on conflict (id) do nothing;

