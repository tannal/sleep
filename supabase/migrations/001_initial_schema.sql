-- =============================================
-- 睡眠监测应用 Supabase 数据库架构
-- =============================================

-- 启用必要扩展
create extension if not exists "uuid-ossp";
create extension if not exists "pgcrypto";

-- =============================================
-- 用户配置表
-- =============================================
create table public.user_profiles (
  id uuid references auth.users(id) on delete cascade primary key,
  username text unique,
  avatar_url text,
  age integer,
  gender text check (gender in ('male', 'female', 'other')),
  target_sleep_hours numeric(3,1) default 8.0,
  target_bedtime time default '23:00',
  target_wake_time time default '07:00',
  timezone text default 'Asia/Shanghai',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- =============================================
-- 睡眠记录主表
-- =============================================
create table public.sleep_records (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.user_profiles(id) on delete cascade not null,
  date date not null,                          -- 睡眠日期（以起床日期为准）
  bedtime timestamptz not null,                -- 入睡时间
  wake_time timestamptz not null,              -- 起床时间
  duration_minutes integer generated always as (
    cast(extract(epoch from (wake_time - bedtime)) / 60 as integer)
  ) stored,                                    -- 总睡眠时长（分钟）
  sleep_quality integer check (sleep_quality between 1 and 5), -- 主观评分 1-5
  
  -- 睡眠阶段统计（分钟）
  deep_sleep_minutes integer default 0,
  light_sleep_minutes integer default 0,
  rem_sleep_minutes integer default 0,
  awake_minutes integer default 0,
  
  -- 健康指标
  avg_heart_rate integer,                      -- 平均心率
  min_heart_rate integer,                      -- 最低心率（深睡时）
  avg_spo2 numeric(4,1),                       -- 平均血氧饱和度
  snoring_minutes integer default 0,           -- 打鼾时长
  
  -- 环境数据
  room_temperature numeric(4,1),
  room_humidity integer,
  noise_level integer,                         -- 0-100
  
  -- 用户备注
  notes text,
  mood_before_sleep integer check (mood_before_sleep between 1 and 5),
  mood_after_wake integer check (mood_after_wake between 1 and 5),
  
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  
  unique(user_id, date)
);

-- =============================================
-- 睡眠阶段详细记录表（时序数据）
-- =============================================
create table public.sleep_stages (
  id uuid default uuid_generate_v4() primary key,
  sleep_record_id uuid references public.sleep_records(id) on delete cascade not null,
  user_id uuid references public.user_profiles(id) on delete cascade not null,
  timestamp timestamptz not null,
  stage text not null check (stage in ('awake', 'light', 'deep', 'rem')),
  heart_rate integer,
  spo2 numeric(4,1),
  movement_score integer check (movement_score between 0 and 100),
  created_at timestamptz default now()
);

-- =============================================
-- 睡眠目标与提醒设置
-- =============================================
create table public.sleep_reminders (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.user_profiles(id) on delete cascade not null,
  reminder_type text check (reminder_type in ('bedtime', 'wake', 'wind_down')),
  enabled boolean default true,
  time time not null,
  days_of_week integer[] default '{1,2,3,4,5,6,7}', -- 1=周一
  message text,
  created_at timestamptz default now()
);

-- =============================================
-- 睡眠洞察与建议记录
-- =============================================
create table public.sleep_insights (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.user_profiles(id) on delete cascade not null,
  insight_type text not null, -- 'weekly_report', 'pattern', 'recommendation'
  title text not null,
  content text not null,
  data jsonb,                 -- 附加数据
  is_read boolean default false,
  generated_at timestamptz default now()
);

-- =============================================
-- 健康标签（睡前活动记录）
-- =============================================
create table public.sleep_tags (
  id uuid default uuid_generate_v4() primary key,
  sleep_record_id uuid references public.sleep_records(id) on delete cascade not null,
  user_id uuid references public.user_profiles(id) on delete cascade not null,
  tag text not null, -- 'exercise', 'caffeine', 'alcohol', 'stress', 'screen_time', etc.
  created_at timestamptz default now()
);

-- =============================================
-- 视图：最近7天睡眠统计
-- =============================================
create view public.weekly_sleep_stats as
select
  user_id,
  date_trunc('week', date) as week_start,
  count(*) as nights_tracked,
  round(avg(duration_minutes) / 60.0, 1) as avg_hours,
  round(avg(sleep_quality), 1) as avg_quality,
  round(avg(deep_sleep_minutes)::numeric, 0) as avg_deep_sleep_min,
  round(avg(rem_sleep_minutes)::numeric, 0) as avg_rem_min,
  round(avg(avg_heart_rate)::numeric, 0) as avg_heart_rate,
  round(avg(avg_spo2)::numeric, 1) as avg_spo2
from public.sleep_records
group by user_id, date_trunc('week', date);

-- =============================================
-- RLS（Row Level Security）策略
-- =============================================
alter table public.user_profiles enable row level security;
alter table public.sleep_records enable row level security;
alter table public.sleep_stages enable row level security;
alter table public.sleep_reminders enable row level security;
alter table public.sleep_insights enable row level security;
alter table public.sleep_tags enable row level security;

-- 用户只能访问自己的数据
create policy "users_own_profile" on public.user_profiles
  for all using (auth.uid() = id);

create policy "users_own_sleep_records" on public.sleep_records
  for all using (auth.uid() = user_id);

create policy "users_own_sleep_stages" on public.sleep_stages
  for all using (auth.uid() = user_id);

create policy "users_own_reminders" on public.sleep_reminders
  for all using (auth.uid() = user_id);

create policy "users_own_insights" on public.sleep_insights
  for all using (auth.uid() = user_id);

create policy "users_own_tags" on public.sleep_tags
  for all using (auth.uid() = user_id);

-- =============================================
-- 函数：新用户注册时自动创建 profile
-- =============================================
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.user_profiles (id, username)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'username', split_part(new.email, '@', 1))
  );
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- =============================================
-- 函数：获取用户睡眠得分（综合评分）
-- =============================================
create or replace function public.calculate_sleep_score(record_id uuid)
returns integer language plpgsql as $$
declare
  rec public.sleep_records;
  score integer := 0;
  duration_hours numeric;
  deep_pct numeric;
  rem_pct numeric;
begin
  select * into rec from public.sleep_records where id = record_id;

  -- 时长评分 (0-40分)
  duration_hours := rec.duration_minutes / 60.0;
  if duration_hours >= 7 and duration_hours <= 9 then
    score := score + 40;
  elsif duration_hours >= 6 and duration_hours < 7 then
    score := score + 30;
  elsif duration_hours > 9 and duration_hours <= 10 then
    score := score + 30;
  elsif duration_hours >= 5 and duration_hours < 6 then
    score := score + 15;
  else
    score := score + 5;
  end if;

  -- 深睡评分 (0-25分)
  if rec.duration_minutes > 0 then
    deep_pct := rec.deep_sleep_minutes::numeric / rec.duration_minutes;
    if deep_pct >= 0.15 and deep_pct <= 0.25 then score := score + 25;
    elsif deep_pct >= 0.10 then score := score + 15;
    elsif deep_pct >= 0.05 then score := score + 8;
    end if;
  end if;

  -- REM评分 (0-20分)
  if rec.duration_minutes > 0 then
    rem_pct := rec.rem_sleep_minutes::numeric / rec.duration_minutes;
    if rem_pct >= 0.20 and rem_pct <= 0.25 then score := score + 20;
    elsif rem_pct >= 0.15 then score := score + 12;
    elsif rem_pct >= 0.10 then score := score + 6;
    end if;
  end if;

  -- 主观质量评分 (0-15分)
  score := score + coalesce(rec.sleep_quality, 3) * 3;

  return least(score, 100);
end;
$$;

-- 索引优化
create index idx_sleep_records_user_date on public.sleep_records(user_id, date desc);
create index idx_sleep_stages_record on public.sleep_stages(sleep_record_id, timestamp);
create index idx_sleep_insights_user on public.sleep_insights(user_id, generated_at desc);
