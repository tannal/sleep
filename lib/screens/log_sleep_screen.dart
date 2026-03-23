// lib/screens/log_sleep_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../models/sleep_record.dart';
import '../providers/sleep_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/app_theme.dart';

class LogSleepScreen extends ConsumerStatefulWidget {
  final SleepRecord? existing;
  const LogSleepScreen({super.key, this.existing});

  @override
  ConsumerState<LogSleepScreen> createState() => _LogSleepScreenState();
}

class _LogSleepScreenState extends ConsumerState<LogSleepScreen> {
  late DateTime _bedtime;
  late DateTime _wakeTime;
  int _quality = 3;
  int _moodBefore = 3;
  int _moodAfter = 3;
  final _notesController = TextEditingController();
  final Set<String> _selectedTags = {};
  bool _isSaving = false;

  static const _allTags = [
    ('☕', '咖啡因'),
    ('🍺', '饮酒'),
    ('🏃', '运动'),
    ('😰', '压力'),
    ('📱', '屏幕时间'),
    ('🍽️', '晚餐过晚'),
    ('💊', '药物'),
    ('🧘', '冥想'),
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _bedtime = widget.existing?.bedtime ??
        DateTime(now.year, now.month, now.day, 23, 0);
    _wakeTime = widget.existing?.wakeTime ??
        DateTime(now.year, now.month, now.day + 1, 7, 0);
    _quality = widget.existing?.sleepQuality ?? 3;
    _moodBefore = widget.existing?.moodBeforeSleep ?? 3;
    _moodAfter = widget.existing?.moodAfterWake ?? 3;
    _notesController.text = widget.existing?.notes ?? '';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Duration get _duration => _wakeTime.difference(_bedtime);

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get _durationText {
    final d = _duration;
    if (d.isNegative) return '时间设置有误';
    return '${d.inHours} 小时 ${d.inMinutes.remainder(60)} 分钟';
  }

  Future<void> _pickTime(bool isBedtime) async {
    final initial = isBedtime ? _bedtime : _wakeTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.accent,
            onSurface: AppColors.textPrimary,
            surface: AppColors.surfaceCard,
          ),
          timePickerTheme: TimePickerThemeData(
            backgroundColor: AppColors.surface,
            hourMinuteTextColor: AppColors.textPrimary,
            dayPeriodTextColor: AppColors.accent,
            dialHandColor: AppColors.accent,
            dialBackgroundColor: AppColors.surfaceCard,
            entryModeIconColor: AppColors.accent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
        child: child!,
      ),
    );

    if (picked == null) return;
    setState(() {
      if (isBedtime) {
        _bedtime = DateTime(
          _bedtime.year,
          _bedtime.month,
          _bedtime.day,
          picked.hour,
          picked.minute,
        );
        // Auto-advance wake time if bedtime > wake
        if (_bedtime.isAfter(_wakeTime)) {
          _wakeTime = _bedtime.add(const Duration(hours: 8));
        }
      } else {
        _wakeTime = DateTime(
          _wakeTime.year,
          _wakeTime.month,
          _wakeTime.day,
          picked.hour,
          picked.minute,
        );
        // If wake is before bed, add one day
        if (_wakeTime.isBefore(_bedtime)) {
          _wakeTime = _wakeTime.add(const Duration(days: 1));
        }
      }
    });
  }

  Future<void> _save() async {
    if (_duration.isNegative) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('起床时间必须晚于入睡时间'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final user = ref.read(currentUserProvider)!;
      final record = SleepRecord(
        id: widget.existing?.id ?? const Uuid().v4(),
        userId: user.id,
        date: _wakeTime,
        bedtime: _bedtime,
        wakeTime: _wakeTime,
        sleepQuality: _quality,
        moodBeforeSleep: _moodBefore,
        moodAfterWake: _moodAfter,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        tags: _selectedTags.toList(),
      );

      if (widget.existing != null) {
        await ref.read(sleepRecordsProvider.notifier).updateRecord(record);
      } else {
        await ref.read(sleepRecordsProvider.notifier).addRecord(record);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('睡眠记录已保存 ✓'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 2),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存失败: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.skyGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTimeSection(),
                      _buildDurationBadge(),
                      const SizedBox(height: 20),
                      _buildQualitySection(),
                      const SizedBox(height: 20),
                      _buildMoodSection(),
                      const SizedBox(height: 20),
                      _buildTagsSection(),
                      const SizedBox(height: 20),
                      _buildNotesSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildSaveButton(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
          Text(
            widget.existing != null ? '编辑睡眠记录' : '手动记录睡眠',
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSection() {
    return _SectionCard(
      title: '睡眠时间',
      child: Row(
        children: [
          Expanded(child: _timeButton('入睡时间', _bedtime, true)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                const Icon(Icons.arrow_forward_rounded,
                    color: AppColors.textMuted, size: 20),
                const SizedBox(height: 2),
                Text(
                  _durationText,
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Expanded(child: _timeButton('起床时间', _wakeTime, false)),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _timeButton(String label, DateTime dt, bool isBedtime) {
    return GestureDetector(
      onTap: () => _pickTime(isBedtime),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.accent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.accent.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Icon(
              isBedtime
                  ? Icons.bedtime_outlined
                  : Icons.wb_sunny_outlined,
              color: AppColors.accent,
              size: 20,
            ),
            const SizedBox(height: 6),
            Text(
              _formatTime(dt),
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontFamily: 'Sora'),
            ),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationBadge() {
    final d = _duration;
    final isOk = !d.isNegative && d.inHours >= 5 && d.inHours <= 10;

    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isOk
              ? AppColors.success.withOpacity(0.1)
              : AppColors.warning.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isOk
                  ? AppColors.success.withOpacity(0.3)
                  : AppColors.warning.withOpacity(0.3)),
        ),
        child: Text(
          '总时长: $_durationText',
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isOk ? AppColors.success : AppColors.warning),
        ),
      ),
    );
  }

  Widget _buildQualitySection() {
    return _SectionCard(
      title: '睡眠质量',
      subtitle: '你觉得昨晚睡得怎么样？',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(5, (i) {
          final val = i + 1;
          final selected = _quality == val;
          final labels = ['很差', '较差', '一般', '较好', '很好'];
          final colors = [
            AppColors.error,
            AppColors.warning,
            AppColors.textSecondary,
            AppColors.lightSleep,
            AppColors.success,
          ];
          return GestureDetector(
            onTap: () => setState(() => _quality = val),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: selected
                    ? colors[i].withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: selected
                    ? Border.all(color: colors[i].withOpacity(0.5))
                    : null,
              ),
              child: Column(
                children: [
                  Text(
                    ['😫', '😞', '😐', '😊', '😄'][i],
                    style: TextStyle(
                        fontSize: selected ? 30 : 24),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    labels[i],
                    style: TextStyle(
                      fontSize: 10,
                      color: selected
                          ? colors[i]
                          : AppColors.textMuted,
                      fontWeight: selected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    ).animate(delay: 100.ms).fadeIn(duration: 400.ms);
  }

  Widget _buildMoodSection() {
    return _SectionCard(
      title: '心情指数',
      child: Column(
        children: [
          _moodRow('睡前心情', _moodBefore,
              (v) => setState(() => _moodBefore = v)),
          const SizedBox(height: 12),
          _moodRow('醒来心情', _moodAfter,
              (v) => setState(() => _moodAfter = v)),
        ],
      ),
    ).animate(delay: 150.ms).fadeIn(duration: 400.ms);
  }

  Widget _moodRow(String label, int value, ValueChanged<int> onChanged) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(label,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textSecondary)),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (i) {
              final val = i + 1;
              final selected = value == val;
              return GestureDetector(
                onTap: () => onChanged(val),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.accent.withOpacity(0.2)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: selected
                        ? Border.all(
                            color: AppColors.accent.withOpacity(0.5))
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '$val',
                      style: TextStyle(
                          fontSize: selected ? 18 : 16,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: selected
                              ? AppColors.accent
                              : AppColors.textMuted),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return _SectionCard(
      title: '睡前活动',
      subtitle: '选择影响睡眠的因素（可多选）',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _allTags.map((tag) {
          final selected = _selectedTags.contains(tag.$2);
          return GestureDetector(
            onTap: () => setState(() => selected
                ? _selectedTags.remove(tag.$2)
                : _selectedTags.add(tag.$2)),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.accent.withOpacity(0.2)
                    : AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected
                      ? AppColors.accent.withOpacity(0.5)
                      : AppColors.textMuted.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(tag.$1,
                      style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(
                    tag.$2,
                    style: TextStyle(
                      fontSize: 12,
                      color: selected
                          ? AppColors.accent
                          : AppColors.textSecondary,
                      fontWeight: selected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    ).animate(delay: 200.ms).fadeIn(duration: 400.ms);
  }

  Widget _buildNotesSection() {
    return _SectionCard(
      title: '备注',
      child: TextField(
        controller: _notesController,
        maxLines: 3,
        style: const TextStyle(
            color: AppColors.textPrimary, fontFamily: 'Sora', fontSize: 14),
        decoration: InputDecoration(
          hintText: '记录睡眠感受、梦境或其他备注...',
          hintStyle: const TextStyle(
              color: AppColors.textMuted,
              fontFamily: 'Sora',
              fontSize: 13),
          filled: true,
          fillColor: AppColors.surfaceElevated,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(14),
        ),
      ),
    ).animate(delay: 250.ms).fadeIn(duration: 400.ms);
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: _isSaving ? null : _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            elevation: 0,
          ),
          child: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_rounded, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      widget.existing != null ? '更新记录' : '保存记录',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'Sora'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ─── Helper Widget ─────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const _SectionCard({
    required this.title,
    this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A3160), Color(0xFF1E2444)],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 3),
            Text(
              subtitle!,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
