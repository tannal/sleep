-- =============================================
-- 测试种子数据（在 Supabase SQL Editor 执行）
-- 注意：请先替换 user_id 为你的实际 auth.uid()
-- =============================================

-- 获取当前用户 ID（执行后复制结果）
-- SELECT auth.uid();

-- 以下 user_id 请替换为你的实际 UUID
DO $$
DECLARE
  v_user_id UUID := 'YOUR_USER_UUID_HERE'; -- 替换这里
  v_base_date DATE := CURRENT_DATE - INTERVAL '7 days';
BEGIN

-- 插入7天睡眠记录
INSERT INTO public.sleep_records (
  user_id, date, bedtime, wake_time,
  sleep_quality,
  deep_sleep_minutes, light_sleep_minutes, rem_sleep_minutes, awake_minutes,
  avg_heart_rate, min_heart_rate, avg_spo2,
  mood_before_sleep, mood_after_wake,
  notes
) VALUES
  -- Day 1: 优质睡眠
  (v_user_id, v_base_date + 1,
   (v_base_date + 1)::timestamp + time '22:50',
   (v_base_date + 2)::timestamp + time '07:10',
   5, 110, 225, 130, 15, 52, 46, 98.5, 4, 5,
   '状态很好，早睡早起'),

  -- Day 2: 一般睡眠
  (v_user_id, v_base_date + 2,
   (v_base_date + 2)::timestamp + time '23:30',
   (v_base_date + 3)::timestamp + time '07:00',
   3, 80, 210, 95, 28, 58, 50, 97.8, 3, 3,
   '昨天喝了咖啡，入睡稍慢'),

  -- Day 3: 短睡
  (v_user_id, v_base_date + 3,
   (v_base_date + 3)::timestamp + time '00:20',
   (v_base_date + 4)::timestamp + time '06:30',
   2, 65, 175, 75, 35, 62, 54, 97.2, 2, 2,
   '加班到很晚'),

  -- Day 4: 好睡眠
  (v_user_id, v_base_date + 4,
   (v_base_date + 4)::timestamp + time '22:45',
   (v_base_date + 5)::timestamp + time '07:20',
   4, 105, 240, 120, 20, 54, 47, 98.8, 4, 4,
   NULL),

  -- Day 5: 较好
  (v_user_id, v_base_date + 5,
   (v_base_date + 5)::timestamp + time '23:10',
   (v_base_date + 6)::timestamp + time '07:30',
   4, 98, 230, 115, 22, 55, 48, 98.3, 3, 4,
   '运动后睡眠质量不错'),

  -- Day 6: 周末长睡
  (v_user_id, v_base_date + 6,
   (v_base_date + 6)::timestamp + time '00:00',
   (v_base_date + 7)::timestamp + time '09:00',
   4, 115, 280, 135, 30, 53, 46, 98.6, 3, 4,
   '周末补觉'),

  -- Day 7: 昨晚
  (v_user_id, v_base_date + 7,
   (v_base_date + 7)::timestamp + time '23:14',
   (v_base_date + 8)::timestamp + time '06:44',
   4, 92, 186, 108, 14, 54, 47, 98.2, 4, 4,
   NULL)

ON CONFLICT (user_id, date) DO NOTHING;

-- 插入睡眠洞察
INSERT INTO public.sleep_insights (
  user_id, insight_type, title, content, data
) VALUES
  (v_user_id, 'weekly_report', '本周睡眠报告', '本周平均睡眠时长 7.2 小时，比上周提升 0.3 小时。深睡比例达到 18%，继续保持！',
   '{"avg_hours": 7.2, "avg_score": 78, "nights_tracked": 7}'::jsonb),

  (v_user_id, 'pattern', '发现规律：周三睡眠质量偏低', '你的数据显示每逢周三睡眠时间较短（平均 6.2 小时），可能与工作压力相关。',
   '{"day": "Wednesday", "avg_hours": 6.2}'::jsonb),

  (v_user_id, 'recommendation', '改善建议：减少睡前屏幕时间', '检测到你在入睡前约 45 分钟仍在使用设备。建议睡前 1 小时减少屏幕曝光，有助于提升褪黑素分泌。',
   '{"type": "screen_time"}'::jsonb)

ON CONFLICT DO NOTHING;

-- 插入提醒设置
INSERT INTO public.sleep_reminders (
  user_id, reminder_type, enabled, time, days_of_week, message
) VALUES
  (v_user_id, 'bedtime', true, '23:00', '{1,2,3,4,5,6,7}', '🌙 该睡觉了，保持规律作息'),
  (v_user_id, 'wake', true, '07:00', '{1,2,3,4,5}', '☀️ 早安！查看昨晚睡眠报告'),
  (v_user_id, 'wind_down', true, '22:30', '{1,2,3,4,5,6,7}', '🧘 30 分钟后到达睡眠时间，开始放松')

ON CONFLICT DO NOTHING;

RAISE NOTICE '种子数据插入完成，user_id: %', v_user_id;
END $$;

-- 验证插入结果
SELECT
  date,
  to_char(bedtime, 'HH24:MI') AS "入睡",
  to_char(wake_time, 'HH24:MI') AS "起床",
  duration_minutes AS "时长(分)",
  sleep_quality AS "质量",
  deep_sleep_minutes AS "深睡",
  rem_sleep_minutes AS "REM"
FROM public.sleep_records
ORDER BY date DESC
LIMIT 10;
