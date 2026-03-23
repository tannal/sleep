// lib/screens/history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/sleep_record.dart';
import '../providers/sleep_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/sleep_stage_bar.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  String _filterQuality = 'all'; // all, good, avg, poor
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SleepRecord> _filtered(List<SleepRecord> records) {
    return records.where((r) {
      // Quality filter
      if (_filterQuality == 'good' && r.sleepScore < 75) return false;
      if (_filterQuality == 'avg' &&
          (r.sleepScore < 55 || r.sleepScore >= 75)) return false;
      if (_filterQuality == 'poor' && r.sleepScore >= 55) return false;

      // Search filter
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final noteMatch =
            (r.notes ?? '').toLowerCase().contains(q);
        final dateMatch =
            DateFormat('yyyy-M-d').format(r.date).contains(q);
        if (!noteMatch && !dateMatch) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final asyncRecords = ref.watch(sleepRecordsProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.skyGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSearch(),
              _buildFilters(),
              Expanded(
                child: asyncRecords.when(
                  data: (records) {
                    final filtered = _filtered(records);
                    if (filtered.isEmpty) {
                      return _buildEmpty();
                    }
                    return _buildList(filtered);
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation(AppColors.accent),
                    ),
                  ),
                  error: (e, _) => Center(
                    child: Text('加载失败: $e',
                        style: const TextStyle(
                            color: AppColors.textSecondary)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/log'),
        backgroundColor: AppColors.accent,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('记录睡眠',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Sora',
                fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
          const Text('睡眠记录',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(
            color: AppColors.textPrimary, fontFamily: 'Sora'),
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: InputDecoration(
          hintText: '搜索日期或备注...',
          hintStyle: const TextStyle(
              color: AppColors.textMuted, fontFamily: 'Sora'),
          prefixIcon: const Icon(Icons.search_rounded,
              color: AppColors.textMuted, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded,
                      color: AppColors.textMuted, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    final options = [
      ('all', '全部', null),
      ('good', '优良', AppColors.success),
      ('avg', '一般', AppColors.warning),
      ('poor', '较差', AppColors.error),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: options.map((o) {
            final selected = _filterQuality == o.$1;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _filterQuality = o.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: selected
                        ? (o.$3 ?? AppColors.accent)
                            .withOpacity(0.2)
                        : AppColors.surfaceCard,
                    borderRadius: BorderRadius.circular(20),
                    border: selected
                        ? Border.all(
                            color: (o.$3 ?? AppColors.accent)
                                .withOpacity(0.5))
                        : null,
                  ),
                  child: Text(
                    o.$2,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: selected
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: selected
                          ? (o.$3 ?? AppColors.accent)
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildList(List<SleepRecord> records) {
    // Group by month
    final grouped = <String, List<SleepRecord>>{};
    for (final r in records) {
      final key = DateFormat('yyyy年M月', 'zh_CN').format(r.date);
      grouped.putIfAbsent(key, () => []).add(r);
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: grouped.length,
      itemBuilder: (ctx, i) {
        final month = grouped.keys.elementAt(i);
        final monthRecords = grouped[month]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(month,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary)),
            ),
            ...monthRecords.asMap().entries.map((e) =>
                _RecordTile(
                  record: e.value,
                  delay: e.key * 40,
                ).animate(delay: (e.key * 40).ms).fadeIn(
                    duration: 400.ms).slideX(begin: 0.05, end: 0)),
          ],
        );
      },
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🌙', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          const Text('暂无睡眠记录',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          const Text('点击下方按钮开始记录你的第一次睡眠',
              style: TextStyle(
                  fontSize: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _RecordTile extends ConsumerWidget {
  final SleepRecord record;
  final int delay;

  const _RecordTile({required this.record, required this.delay});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = record.sleepScore;
    final scoreColor = score >= 75
        ? AppColors.success
        : score >= 55
            ? AppColors.warning
            : AppColors.error;

    return GestureDetector(
      onTap: () => context.push('/sleep/${record.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2A3160), Color(0xFF1E2444)],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: AppColors.accent.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            // Score badge
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: scoreColor.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                    color: scoreColor.withOpacity(0.3)),
              ),
              child: Center(
                child: Text(
                  '$score',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: scoreColor),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('M月d日 EEEE', 'zh_CN')
                        .format(record.date),
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.schedule_outlined,
                          size: 12,
                          color: AppColors.textSecondary),
                      const SizedBox(width: 3),
                      Text(
                        record.formattedDuration,
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.bedtime_outlined,
                          size: 12,
                          color: AppColors.textSecondary),
                      const SizedBox(width: 3),
                      Text(
                        DateFormat('HH:mm').format(record.bedtime),
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Mini stage bar
            SizedBox(
              width: 60,
              child: Column(
                children: [
                  SleepStageBar(
                    deepMinutes: record.deepSleepMinutes,
                    lightMinutes: record.lightSleepMinutes,
                    remMinutes: record.remSleepMinutes,
                    awakeMinutes: record.awakeMinutes,
                  ),
                  const SizedBox(height: 4),
                  const Icon(Icons.chevron_right_rounded,
                      color: AppColors.textMuted, size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
