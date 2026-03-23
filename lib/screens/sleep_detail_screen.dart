// lib/screens/sleep_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/sleep_record.dart';
import '../providers/sleep_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/sleep_score_ring.dart';
import '../widgets/sleep_stage_bar.dart';

class SleepDetailScreen extends ConsumerWidget {
  final String recordId;

  const SleepDetailScreen({super.key, required this.recordId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(sleepRecordsProvider).value ?? [];
    final record = records.cast<SleepRecord?>().firstWhere(
          (r) => r?.id == recordId,
          orElse: () => null,
        );

    if (record == null) {
      return const Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: Text('未找到记录',
              style: TextStyle(color: AppColors.textSecondary)),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.skyGradient),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(context, record)),
              SliverToBoxAdapter(
                  child: _buildScoreHero(record)),
              SliverToBoxAdapter(
                  child: _buildTimelineCard(record)),
              SliverToBoxAdapter(
                  child: _buildVitalsCard(record)),
              SliverToBoxAdapter(
                  child: _buildStagesCard(record)),
              SliverToBoxAdapter(
                  child: _buildInsightCard(record)),
              if (record.notes != null && record.notes!.isNotEmpty)
                SliverToBoxAdapter(
                    child: _buildNotesCard(record.notes!)),
              SliverToBoxAdapter(
                  child: _buildActionsRow(context, ref, record)),
              const SliverToBoxAdapter(
                  child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, SleepRecord record) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('睡眠详情',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              Text(
                DateFormat('yyyy年M月d日 EEEE', 'zh_CN').format(record.date),
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreHero(SleepRecord record) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2D3561), Color(0xFF1E2444)],
          ),
          borderRadius: BorderRadius.circular(28),
          border:
              Border.all(color: AppColors.accent.withOpacity(0.15)),
        ),
        child: Row(
          children: [
            SleepScoreRing(score: record.sleepScore, size: 100),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.scoreLabel,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    record.formattedDuration,
                    style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  _qualityStars(record.sleepQuality ?? 0),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _qualityStars(int quality) {
    return Row(
      children: List.generate(5, (i) {
        return Icon(
          i < quality ? Icons.star_rounded : Icons.star_outline_rounded,
          color: i < quality ? AppColors.warning : AppColors.textMuted,
          size: 18,
        );
      }),
    );
  }

  Widget _buildTimelineCard(SleepRecord record) {
    final fmt = DateFormat('HH:mm');
    return _DetailCard(
      margin: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Row(
        children: [
          _timelineItem(
            icon: Icons.bedtime_outlined,
            label: '入睡',
            time: fmt.format(record.bedtime),
            color: AppColors.deepSleep,
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.deepSleep.withOpacity(0.5),
                        AppColors.accent,
                        AppColors.warning.withOpacity(0.5),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  record.formattedDuration,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          _timelineItem(
            icon: Icons.wb_sunny_outlined,
            label: '起床',
            time: fmt.format(record.wakeTime),
            color: AppColors.warning,
          ),
        ],
      ),
    ).animate(delay: 100.ms).fadeIn(duration: 500.ms);
  }

  Widget _timelineItem(
      {required IconData icon,
      required String label,
      required String time,
      required Color color}) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(time,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildVitalsCard(SleepRecord record) {
    return _DetailCard(
      margin: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      title: '健康指标',
      child: Row(
        children: [
          _vitalItem(
            '❤️',
            '平均心率',
            record.avgHeartRate != null
                ? '${record.avgHeartRate} bpm'
                : '—',
          ),
          _divider(),
          _vitalItem(
            '💙',
            '最低心率',
            record.minHeartRate != null
                ? '${record.minHeartRate} bpm'
                : '—',
          ),
          _divider(),
          _vitalItem(
            '🌬️',
            '平均血氧',
            record.avgSpo2 != null
                ? '${record.avgSpo2!.toStringAsFixed(1)}%'
                : '—',
          ),
          _divider(),
          _vitalItem(
            '🔊',
            '打鼾时长',
            '${record.snoringMinutes}分钟',
          ),
        ],
      ),
    ).animate(delay: 200.ms).fadeIn(duration: 500.ms);
  }

  Widget _vitalItem(String emoji, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 9, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 40,
        color: AppColors.textMuted.withOpacity(0.2),
      );

  Widget _buildStagesCard(SleepRecord record) {
    final total = record.durationMinutes ?? 1;

    return _DetailCard(
      margin: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      title: '睡眠阶段',
      child: Column(
        children: [
          SleepStageBar(
            deepMinutes: record.deepSleepMinutes,
            lightMinutes: record.lightSleepMinutes,
            remMinutes: record.remSleepMinutes,
            awakeMinutes: record.awakeMinutes,
          ),
          const SizedBox(height: 16),
          ...[
            _stageRow('深度睡眠', record.deepSleepMinutes, total,
                AppColors.deepSleep, '修复与恢复'),
            _stageRow('REM 睡眠', record.remSleepMinutes, total,
                AppColors.remSleep, '记忆与学习'),
            _stageRow('浅度睡眠', record.lightSleepMinutes, total,
                AppColors.lightSleep, '过渡阶段'),
            _stageRow('清醒时间', record.awakeMinutes, total,
                AppColors.awakeColor, '正常唤醒'),
          ],
        ],
      ),
    ).animate(delay: 300.ms).fadeIn(duration: 500.ms);
  }

  Widget _stageRow(String label, int minutes, int total,
      Color color, String desc) {
    final pct = total > 0 ? minutes / total : 0.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 72,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: pct,
                backgroundColor: AppColors.surfaceElevated,
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: Text(
              '${minutes}分  ${(pct * 100).round()}%',
              textAlign: TextAlign.right,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(SleepRecord record) {
    final insights = _generateInsights(record);
    if (insights.isEmpty) return const SizedBox.shrink();

    return _DetailCard(
      margin: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      title: '睡眠洞察',
      child: Column(
        children: insights
            .map((i) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(i.$1,
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          i.$2,
                          style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    ).animate(delay: 400.ms).fadeIn(duration: 500.ms);
  }

  List<(String, String)> _generateInsights(SleepRecord record) {
    final insights = <(String, String)>[];
    final total = record.durationMinutes ?? 0;
    if (total == 0) return insights;

    final hours = total / 60.0;
    if (hours < 6) {
      insights.add(('⚠️', '睡眠时长不足6小时，长期睡眠不足会影响免疫力和认知功能。'));
    } else if (hours >= 7 && hours <= 9) {
      insights.add(('✅', '睡眠时长处于理想范围（7-9小时），有助于身体恢复和记忆巩固。'));
    }

    final deepPct = record.deepSleepMinutes / total;
    if (deepPct < 0.15) {
      insights.add(('💡', '深睡比例偏低，尝试规律作息、睡前避免咖啡因来提升深睡质量。'));
    }

    final remPct = record.remSleepMinutes / total;
    if (remPct >= 0.20) {
      insights.add(('🧠', 'REM 睡眠充足，有助于情绪调节和记忆整合。'));
    }

    if (record.avgSpo2 != null && record.avgSpo2! < 95) {
      insights.add(('🔴', '血氧均值偏低（<95%），建议咨询医生排查睡眠呼吸暂停。'));
    }

    return insights;
  }

  Widget _buildNotesCard(String notes) {
    return _DetailCard(
      margin: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      title: '备注',
      child: Text(notes,
          style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6)),
    ).animate(delay: 450.ms).fadeIn(duration: 500.ms);
  }

  Widget _buildActionsRow(
      BuildContext context, WidgetRef ref, SleepRecord record) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => context.push('/log', extra: record),
              icon: const Icon(Icons.edit_outlined,
                  size: 16, color: AppColors.accent),
              label: const Text('编辑',
                  style: TextStyle(
                      color: AppColors.accent, fontFamily: 'Sora')),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(
                    color: AppColors.accent.withOpacity(0.4)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: AppColors.surface,
                    title: const Text('删除记录',
                        style:
                            TextStyle(color: AppColors.textPrimary)),
                    content: const Text(
                        '确定要删除此睡眠记录吗？此操作不可撤销。',
                        style: TextStyle(
                            color: AppColors.textSecondary)),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('取消')),
                      TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('删除',
                              style:
                                  TextStyle(color: AppColors.error))),
                    ],
                  ),
                );
                if (confirm == true && context.mounted) {
                  await ref
                      .read(sleepRecordsProvider.notifier)
                      .deleteRecord(record.id);
                  if (context.mounted) context.pop();
                }
              },
              icon: const Icon(Icons.delete_outline_rounded,
                  size: 16, color: AppColors.error),
              label: const Text('删除',
                  style: TextStyle(
                      color: AppColors.error, fontFamily: 'Sora')),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(
                    color: AppColors.error.withOpacity(0.4)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final EdgeInsets margin;

  const _DetailCard({
    required this.child,
    this.title,
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A3160), Color(0xFF1E2444)],
        ),
        borderRadius: BorderRadius.circular(22),
        border:
            Border.all(color: AppColors.accent.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title!,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }
}
