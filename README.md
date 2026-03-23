# 🌙 睡眠精灵 — Flutter + Supabase 全栈睡眠监测应用

一款基于 Flutter 与 Supabase 构建的现代化全栈睡眠健康管理应用，融合 AI 睡眠分析、实时心率监测与云端数据同步。

---

## ✨ 核心功能

| 功能模块 | 描述 |
|---------|------|
| 🌙 **全夜睡眠追踪** | 基于加速计 + 心率传感器实时分析睡眠阶段 |
| 📊 **深度数据分析** | 睡眠时长趋势、质量评分、阶段占比图表 |
| ❤️ **健康指标监测** | 心率波形、血氧饱和度 (SpO₂) 实时显示 |
| 🧠 **AI 个性化洞察** | 基于历史数据生成睡眠改善建议 |
| ☁️ **云端数据同步** | Supabase Realtime 跨设备实时同步 |
| 🔐 **安全认证** | Supabase Auth 邮箱/密码登录 + RLS 数据隔离 |

---

## 🗂 项目结构

```
sleep_tracker/
├── lib/
│   ├── main.dart                    # 应用入口 + GoRouter 路由 + 底部导航
│   ├── models/
│   │   └── sleep_record.dart        # 数据模型 (Freezed 不可变对象)
│   ├── services/
│   │   ├── supabase_service.dart    # 数据层：CRUD + Realtime + Auth
│   │   └── sleep_tracking_service.dart  # 传感器采集 + 睡眠阶段算法
│   ├── screens/
│   │   ├── auth_screen.dart         # 登录 / 注册页面
│   │   ├── home_screen.dart         # 首页仪表盘
│   │   ├── tracking_screen.dart     # 实时追踪页面
│   │   ├── analytics_screen.dart    # 数据分析（柱状图/折线图/饼图）
│   │   └── profile_screen.dart      # 个人设置页面
│   ├── widgets/
│   │   └── all_widgets.dart         # 全部自定义组件
│   └── utils/
│       ├── app_theme.dart           # 深夜星空主题设计系统
│       └── logger.dart              # 日志工具
└── supabase/
    └── migrations/
        └── 001_initial_schema.sql   # 完整数据库 Schema + RLS + 函数
```

---

## 🗄 数据库设计

```sql
user_profiles       -- 用户个人信息 & 目标设置
sleep_records       -- 睡眠记录主表（含计算列）
sleep_stages        -- 每分钟睡眠阶段时序数据
sleep_reminders     -- 智能闹钟 & 睡前提醒
sleep_insights      -- AI 分析洞察与建议
sleep_tags          -- 睡前活动标签
weekly_sleep_stats  -- 周统计视图（自动聚合）
```

**安全性：** 所有表启用 Row Level Security，用户仅能访问自己的数据。

---

## 🚀 快速开始

### 1. 准备 Supabase 项目

```bash
# 登录 Supabase Dashboard: https://app.supabase.com
# 创建新项目，记录 Project URL 和 anon key
```

### 2. 初始化数据库

在 Supabase Dashboard → SQL Editor 中执行：
```sql
-- 粘贴 supabase/migrations/001_initial_schema.sql 全部内容
```

### 3. 配置应用

编辑 `lib/main.dart`，替换 Supabase 连接信息：

```dart
await Supabase.initialize(
  url: 'https://YOUR_PROJECT_ID.supabase.co',
  anonKey: 'YOUR_ANON_KEY',
);
```

**或者** 使用环境变量（推荐生产环境）：
```bash
flutter run \
  --dart-define=SUPABASE_URL=https://xxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJ...
```

### 4. 安装依赖并运行

```bash
flutter pub get
flutter run
```

---

## 📦 核心依赖

| 包 | 用途 |
|----|------|
| `supabase_flutter` | 数据库、Auth、Realtime |
| `flutter_riverpod` | 状态管理 |
| `go_router` | 声明式路由 |
| `fl_chart` | 专业图表组件 |
| `flutter_animate` | 流畅动画系统 |
| `freezed` | 不可变数据模型 |
| `sensors_plus` | 加速计传感器 |
| `flutter_local_notifications` | 本地推送通知 |

---

## 🏗 代码生成

使用 `freezed` 和 `riverpod_generator` 需要运行代码生成：

```bash
# 一次性生成
flutter pub run build_runner build --delete-conflicting-outputs

# 监听模式（开发时）
flutter pub run build_runner watch --delete-conflicting-outputs
```

---

## 🎨 设计系统

应用采用**深夜星空**主题，核心设计变量：

```dart
AppColors.primary       // #1A1F3A 深夜蓝
AppColors.accent        // #6C63FF 月光紫
AppColors.deepSleep     // #3D5AFE 深睡蓝
AppColors.remSleep      // #AB47BC 梦境紫
AppColors.lightSleep    // #7C9EFF 浅睡蓝
```

字体：**Sora**（需在 pubspec.yaml 中引入字体文件）

---

## 📱 应用截图预览

```
[首页仪表盘]          [实时追踪]           [睡眠分析]
┌────────────┐    ┌────────────┐    ┌────────────┐
│ 早上好 ☀️  │    │ ● 正在监测│    │  睡眠分析  │
│ 睡眠报告   │    │  ⏱ 06:32 │    │ ┌──────────┐│
│ ┌────────┐ │    │            │    │ │  柱状图  ││
│ │ 82分  │ │    │   💓 54bpm │    │ └──────────┘│
│ │ 7.5小时│ │    │            │    │  深睡  22% │
│ └────────┘ │    │  [深度睡眠]│    │  REM   20% │
│            │    │  ████████  │    │  浅睡  53% │
│ [阶段图]   │    │            │    │            │
└────────────┘    └────────────┘    └────────────┘
```

---

## 🔧 扩展建议

- **Apple Watch / Wear OS** 接入真实心率传感器
- **睡前白噪音** 播放功能（集成 just_audio）
- **AI 建议** 调用 OpenAI / Gemini API 生成个性化报告
- **家庭共享** 利用 Supabase shared policies 共享数据
- **离线支持** 集成 Hive 本地缓存 + 后台同步

---

## 📄 License

MIT © 2024 Sleep Tracker
