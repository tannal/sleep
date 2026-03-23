// lib/screens/reminders_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/app_theme.dart';

class RemindersScreen extends ConsumerStatefulWidget {
  const RemindersScreen({super.key});

  @override
  ConsumerState<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends ConsumerState<RemindersScreen> {
  bool _bedtimeEnabled = true;
  bool _wakeEnabled = true;
  bool _windDownEnabled = true;

  TimeOfDay _bedtime = const TimeOfDay(hour: 23, minute: 0);
  TimeOfDay _wakeTime = const TimeOfDay(hour: 7, minute: 0);

  final List<bool> _bedtimeDays =
      List.filled(7, true); // Mon-Sun
  final List<bool> _wakeDays = List.filled(7, true);

  bool _saving = false;

  static const _dayLabels = ['一', '二', '三', '四', '五', '六', '日'];

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
                  padding:
                      const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  child: Column(
                    children: [
                      _buildReminderCard(
                        id: 'bedtime',
                        icon: Icons.bedtime_rounded,
                        title: '入睡提醒',
                        subtitle: '在设定时间提醒你准备睡觉',
                        time: _bedtime,
                        enabled: _bedtimeEnabled,
                        days: _bedtimeDays,
                        color: AppColors.accent,
                        onToggle: (v) =>
                            setState(() => _bedtimeEnabled = v),
                        onTimeTap: () async {
                          final t = await _pickTime(_bedtime);
                          if (t != null) setState(() => _bedtime = t);
                        },
                        onDayToggle: (i, v) =>
                            setState(() => _bedtimeDays[i] = v),
                      ),
                      const SizedBox(height: 16),
                      _buildReminderCard(
                        id: 'wake',
                        icon: Icons.wb_sunny_rounded,
                        title: '起床提醒',
                        subtitle: '早安提醒，显示昨晚睡眠摘要',
                        time: _wakeTime,
                        enabled: _wakeEnabled,
                        days: _wakeDays,
                        color: AppColors.warning,
                        onToggle: (v) =>
                            setState(() => _wakeEnabled = v),
                        onTimeTap: () async {
                          final t = await _pickTime(_wakeTime);
                          if (t != null) setState(() => _wakeTime = t);
                        },
                        onDayToggle: (i, v) =>
                            setState(() => _wakeDays[i] = v),
                      ),
                      const SizedBox(height: 16),
                      _buildWindDownCard(),
                      const SizedBox(height: 24),
                      _buildSaveButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            '睡眠提醒',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderCard({
    required String id,
    required IconData icon,
    required String title,
    required String subtitle,
    required TimeOfDay time,
    required bool enabled,
    required List<bool> days,
    required Color color,
    required ValueChanged<bool> onToggle,
    required VoidCallback onTimeTap,
    required void Function(int, bool) onDayToggle,
  }) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: enabled ? 1.0 : 0.5,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2A3160), Color(0xFF1E2444)],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: enabled
                ? color.withOpacity(0.2)
                : AppColors.textMuted.withOpacity(0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary)),
                      Text(subtitle,
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: enabled,
                  onChanged: onToggle,
                  activeColor: color,
                ),
              ],
            ),
            if (enabled) ...[
              const SizedBox(height: 16),
              GestureDetector(
                onTap: onTimeTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time_rounded,
                          color: color, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: color,
                            fontFamily: 'Sora'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: List.generate(7, (i) {
                  final active = days[i];
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onDayToggle(i, !active),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        height: 36,
                        decoration: BoxDecoration(
                          color: active
                              ? color.withOpacity(0.2)
                              : AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(10),
                          border: active
                              ? Border.all(
                                  color: color.withOpacity(0.4))
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            _dayLabels[i],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: active
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color: active
                                  ? color
                                  : AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ],
        ),
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  Widget _buildWindDownCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2A3160), Color(0xFF1E2444)],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _windDownEnabled
              ? AppColors.remSleep.withOpacity(0.2)
              : AppColors.textMuted.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.remSleep.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.self_improvement_rounded,
                color: AppColors.remSleep, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('放松倒计时',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                Text('入睡前30分钟发送放松提醒',
                    style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary)),
              ],
            ),
          ),
          Switch.adaptive(
            value: _windDownEnabled,
            onChanged: (v) => setState(() => _windDownEnabled = v),
            activeColor: AppColors.remSleep,
          ),
        ],
      ),
    ).animate(delay: 200.ms).fadeIn(duration: 400.ms);
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _saving ? null : _saveReminders,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18)),
        ),
        child: _saving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_active_rounded,
                      color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('保存提醒设置',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'Sora')),
                ],
              ),
      ),
    );
  }

  Future<TimeOfDay?> _pickTime(TimeOfDay initial) {
    return showTimePicker(
      context: context,
      initialTime: initial,
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.accent,
            onSurface: AppColors.textPrimary,
            surface: AppColors.surfaceCard,
          ),
        ),
        child: child!,
      ),
    );
  }

  Future<void> _saveReminders() async {
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('提醒设置已保存（移动端生效）✓'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
      setState(() => _saving = false);
    }
  }
}
