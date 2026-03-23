// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/sleep_record.dart';
import '../providers/sleep_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/all_widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(sleepRecordsProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.skyGradient),
        child: SafeArea(
          child: recordsAsync.when(
            loading: () => _buildLoading(),
            error: (e, _) => _buildError(e.toString()),
            data: (records) {
              // 最近一条记录作为"昨晚"
              final latest = records.isNotEmpty ? records.first : null;
              final weekRecords = records.take(7).toList();
              return _buildContent(context, ref, latest, weekRecords);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() => const Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.accent), strokeWidth: 2),
      );

  Widget _buildError(String msg) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text('加载失败\n$msg',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        ),
      );

  Widget _buildContent(BuildContext context, WidgetRef ref,
      SleepRecord? latest, List<SleepRecord> weekRecords) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _buildHeader(context)),
        SliverToBoxAdapter(child: _buildScoreCard(context, latest)),
        if (latest != null) ...[
          SliverToBoxAdapter(child: _buildQuickStats(latest)),
          SliverToBoxAdapter(child: _buildSleepStages(latest)),
        ],
        SliverToBoxAdapter(child: _buildWeeklyChart(context, weekRecords)),
        if (latest != null)
          SliverToBoxAdapter(child: _buildInsights(latest)),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  // ─── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? '早上好 ☀️' : hour < 18 ? '下午好 🌤' : '晚上好 🌙';

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(greeting,
                style: const TextStyle(
                    fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
            const Text('睡眠报告',
                style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          ]),
          const Spacer(),
          GestureDetector(
            onTap: () => context.push('/profile'),
            child: Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: [AppColors.accent, AppColors.remSleep]),
                boxShadow: [BoxShadow(
                    color: AppColors.accent.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: const Icon(Icons.person_outline_rounded, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0, curve: Curves.easeOutCubic);
  }

  // ─── 最近一次睡眠得分卡 ────────────────────────────────────────────────────

  Widget _buildScoreCard(BuildContext context, SleepRecord? record) {
    final fmt = DateFormat('HH:mm');

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: GestureDetector(
        onTap: record != null ? () => context.push('/sleep/${record.id}') : null,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Color(0xFF2D3561), Color(0xFF1E2444)],
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.accent.withOpacity(0.15)),
            boxShadow: [BoxShadow(
                color: AppColors.accent.withOpacity(0.1), blurRadius: 30, offset: const Offset(0, 10))],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: record == null
                ? _buildNoRecord(context)
                : Row(children: [
                    SleepScoreRing(score: record.sleepScore, size: 110),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('最近一次睡眠',
                            style: TextStyle(
                                fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          Text(
                            '${(record.durationMinutes ?? 0) ~/ 60}',
                            style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary, height: 1),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Text(' 小时',
                                style: TextStyle(fontSize: 16, color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500)),
                          ),
                          Text(
                            ' ${(record.durationMinutes ?? 0) % 60} 分',
                            style: const TextStyle(fontSize: 16, color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500, height: 1),
                          ),
                        ]),
                        const SizedBox(height: 8),
                        Row(children: [
                          _timeChip(Icons.bedtime_outlined, fmt.format(record.bedtime)),
                          const SizedBox(width: 8),
                          _timeChip(Icons.wb_sunny_outlined, fmt.format(record.wakeTime)),
                        ]),
                      ]),
                    ),
                  ]),
          ),
        ),
      ),
    ).animate(delay: 100.ms).fadeIn(duration: 700.ms).slideY(begin: 0.1, end: 0);
  }

  // 没有记录时的空状态
  Widget _buildNoRecord(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('还没有睡眠记录',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        const Text('点击追踪页开始记录第一次睡眠',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const SizedBox(height: 14),
        GestureDetector(
          onTap: () => context.go('/tracking'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('去记录',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _timeChip(IconData icon, String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: AppColors.primaryLight.withOpacity(0.6), borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 12, color: AppColors.accent),
        const SizedBox(width: 4),
        Text(time,
            style: const TextStyle(
                fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
      ]),
    );
  }

  // ─── 快速统计（心率/血氧/深睡）─────────────────────────────────────────────

  Widget _buildQuickStats(SleepRecord record) {
    final deepHours = record.deepSleepMinutes / 60;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(children: [
        Expanded(
          child: StatCard(
            icon: Icons.favorite_outline_rounded,
            label: '平均心率',
            value: record.avgHeartRate != null ? '${record.avgHeartRate}' : '--',
            unit: 'bpm',
            color: AppColors.error,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            icon: Icons.air_outlined,
            label: '血氧',
            value: record.avgSpo2 != null ? record.avgSpo2!.toStringAsFixed(1) : '--',
            unit: '%',
            color: AppColors.deepSleep,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            icon: Icons.nightlight_round,
            label: '深睡',
            value: deepHours.toStringAsFixed(1),
            unit: 'h',
            color: AppColors.deepSleep,
          ),
        ),
      ]),
    ).animate(delay: 200.ms).fadeIn(duration: 700.ms).slideY(begin: 0.1, end: 0);
  }

  // ─── 睡眠阶段 ──────────────────────────────────────────────────────────────

  Widget _buildSleepStages(SleepRecord record) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: _GlassCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _sectionTitle('睡眠阶段'),
          const SizedBox(height: 16),
          SleepStageBar(
            deepMinutes: record.deepSleepMinutes,
            lightMinutes: record.lightSleepMinutes,
            remMinutes: record.remSleepMinutes,
            awakeMinutes: record.awakeMinutes,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _legendItem('深睡', AppColors.deepSleep, '${record.deepSleepMinutes}分钟'),
              _legendItem('浅睡', AppColors.lightSleep, '${record.lightSleepMinutes}分钟'),
              _legendItem('REM',  AppColors.remSleep,   '${record.remSleepMinutes}分钟'),
              _legendItem('清醒', AppColors.awakeColor,  '${record.awakeMinutes}分钟'),
            ],
          ),
        ]),
      ),
    ).animate(delay: 300.ms).fadeIn(duration: 700.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _legendItem(String label, Color color, String value) {
    return Column(children: [
      Row(children: [
        Container(width: 8, height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ]),
      const SizedBox(height: 2),
      Text(value,
          style: const TextStyle(fontSize: 11, color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
    ]);
  }

  // ─── 近7天柱状图 ───────────────────────────────────────────────────────────

  Widget _buildWeeklyChart(BuildContext context, List<SleepRecord> records) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: _GlassCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            _sectionTitle('近7天睡眠'),
            const Spacer(),
            TextButton(
              onPressed: () => context.push('/analytics'),
              child: const Text('查看详情',
                  style: TextStyle(fontSize: 12, color: AppColors.accent, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 8),
          records.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text('暂无数据', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                  ),
                )
              : _RealWeeklyChart(records: records),
        ]),
      ),
    ).animate(delay: 400.ms).fadeIn(duration: 700.ms).slideY(begin: 0.1, end: 0);
  }

  // ─── 洞察（根据真实数据生成）──────────────────────────────────────────────

  Widget _buildInsights(SleepRecord record) {
    final insights = _generateInsights(record);
    if (insights.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionTitle('睡眠洞察'),
        const SizedBox(height: 12),
        ...insights.asMap().entries.map((e) => Padding(
              padding: EdgeInsets.only(top: e.key > 0 ? 10 : 0),
              child: _InsightCard(icon: e.value.$1, title: e.value.$2,
                  body: e.value.$3, color: e.value.$4),
            )),
      ]),
    ).animate(delay: 500.ms).fadeIn(duration: 700.ms).slideY(begin: 0.1, end: 0);
  }

  List<(String, String, String, Color)> _generateInsights(SleepRecord r) {
    final list = <(String, String, String, Color)>[];
    final total = r.durationMinutes ?? 0;
    final hours = total / 60.0;

    if (hours < 6) {
      list.add(('⚠️', '睡眠时长不足',
          '本次睡眠 ${hours.toStringAsFixed(1)} 小时，低于建议的 7 小时。', AppColors.warning));
    } else if (hours >= 7 && hours <= 9) {
      list.add(('✅', '睡眠时长达标',
          '本次睡眠 ${hours.toStringAsFixed(1)} 小时，处于理想范围（7-9小时）。', AppColors.success));
    }

    if (total > 0) {
      final deepPct = r.deepSleepMinutes / total;
      if (deepPct < 0.15) {
        list.add(('💡', '深睡比例偏低',
            '深睡占比 ${(deepPct * 100).round()}%，建议减少睡前咖啡因和屏幕时间。', AppColors.deepSleep));
      }
    }

    if (r.sleepQuality != null && r.sleepQuality! >= 4) {
      list.add(('😊', '睡眠质量不错', '你对这次睡眠的评分是 ${r.sleepQuality}/5，继续保持！', AppColors.success));
    } else if (r.sleepQuality != null && r.sleepQuality! <= 2) {
      list.add(('😞', '睡眠质量较差', '你对这次睡眠评分较低，可以尝试调整入睡时间或睡前习惯。', AppColors.warning));
    }

    return list.take(2).toList();
  }

  Widget _sectionTitle(String title) => Text(title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary));
}

// ─── 真实数据周图表 ──────────────────────────────────────────────────────────

class _RealWeeklyChart extends StatelessWidget {
  final List<SleepRecord> records;
  const _RealWeeklyChart({required this.records});

  @override
  Widget build(BuildContext context) {
    // 补齐7天，没有记录的天显示0
    final days = List.generate(7, (i) {
      final date = DateTime.now().subtract(Duration(days: 6 - i));
      final record = records.cast<SleepRecord?>().firstWhere(
            (r) => r != null &&
                r.date.year == date.year &&
                r.date.month == date.month &&
                r.date.day == date.day,
            orElse: () => null,
          );
      return (
        date: date,
        hours: record != null ? (record.durationMinutes ?? 0) / 60.0 : 0.0,
        hasData: record != null,
      );
    });

    const targetHours = 8.0;
    const maxH = 10.0;
    final weekdays = ['一', '二', '三', '四', '五', '六', '日'];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: days.map((d) {
        final barHeight = (80 * d.hours / maxH).clamp(0.0, 80.0);
        final onTarget = d.hours >= targetHours;
        final isToday = d.date.day == DateTime.now().day;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(children: [
              // 时长标签
              Text(
                d.hasData ? '${d.hours.toStringAsFixed(1)}' : '',
                style: const TextStyle(fontSize: 8, color: AppColors.textMuted),
              ),
              const SizedBox(height: 2),
              // 柱子
              Container(
                height: d.hasData ? barHeight : 4,
                decoration: BoxDecoration(
                  gradient: d.hasData
                      ? LinearGradient(
                          begin: Alignment.bottomCenter, end: Alignment.topCenter,
                          colors: onTarget
                              ? [AppColors.accent, AppColors.accentSoft]
                              : [AppColors.warning.withOpacity(0.6), AppColors.warning],
                        )
                      : null,
                  color: d.hasData ? null : AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(6),
                  border: isToday ? Border.all(color: AppColors.accent, width: 1.5) : null,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                weekdays[d.date.weekday - 1],
                style: TextStyle(
                  fontSize: 10,
                  color: isToday ? AppColors.accent : AppColors.textMuted,
                  fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ]),
          ),
        );
      }).toList(),
    );
  }
}

// ─── 复用组件 ─────────────────────────────────────────────────────────────────

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity, padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFF2A3160), Color(0xFF1E2444)],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.accent.withOpacity(0.1)),
        ),
        child: child,
      );
}

class _InsightCard extends StatelessWidget {
  final String icon, title, body;
  final Color color;
  const _InsightCard({required this.icon, required this.title, required this.body, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              Text(body,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary, height: 1.5)),
            ]),
          ),
        ]),
      );
}
