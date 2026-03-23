// lib/screens/tracking_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/tracking_provider.dart';
import '../utils/app_theme.dart';

class TrackingScreen extends ConsumerStatefulWidget {
  const TrackingScreen({super.key});

  @override
  ConsumerState<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends ConsumerState<TrackingScreen> {
  // 用于实时刷新"已睡了多久"
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    // 每分钟刷新一次显示
    _ticker = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tracking = ref.watch(trackingProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.skyGradient),
        child: SafeArea(
          child: switch (tracking.phase) {
            TrackingPhase.idle     => _buildIdle(),
            TrackingPhase.sleeping => _buildSleeping(tracking),
            TrackingPhase.analyzing => _buildAnalyzing(),
            TrackingPhase.complete => _buildComplete(tracking),
          },
        ),
      ),
    );
  }

  // ─── 空闲：显示"我要睡了"按钮 ─────────────────────────────────────────────

  Widget _buildIdle() {
    final now = DateTime.now();
    final fmt = DateFormat('HH:mm');

    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('睡眠记录',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
          ),
          const Spacer(),

          // 月亮动画
          const Text('🌙', style: TextStyle(fontSize: 80))
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveY(begin: 0, end: -12, duration: 3.seconds, curve: Curves.easeInOut),

          const SizedBox(height: 32),
          const Text('准备睡觉了？',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          Text(
            '点击下方按钮，记录 ${fmt.format(now)} 为入睡时间',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.6),
          ),

          const Spacer(),

          // 大按钮
          _BigButton(
            emoji: '😴',
            label: '我要睡了',
            sublabel: '记录当前时间为入睡时间',
            color: AppColors.accent,
            onTap: () => ref.read(trackingProvider.notifier).startSleep(),
          ),

          const SizedBox(height: 20),

          // 手动补录入口
          TextButton.icon(
            onPressed: () => context.push('/log'),
            icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.textSecondary),
            label: const Text('手动填写历史记录',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          ),
          const SizedBox(height: 12),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  // ─── 睡眠中：显示已睡时长 + "我醒了"按钮 ──────────────────────────────────

  Widget _buildSleeping(TrackingState tracking) {
    final fmt = DateFormat('HH:mm');
    final sleepTime = tracking.sleepTime!;

    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          // 顶部状态栏
          Row(
            children: [
              Container(
                width: 8, height: 8,
                decoration: const BoxDecoration(
                    color: AppColors.success, shape: BoxShape.circle),
              ).animate(onPlay: (c) => c.repeat())
                  .fadeOut(duration: 900.ms).then().fadeIn(duration: 900.ms),
              const SizedBox(width: 8),
              const Text('睡眠记录中',
                  style: TextStyle(fontSize: 13, color: AppColors.success,
                      fontWeight: FontWeight.w600)),
            ],
          ),

          const Spacer(),

          // 入睡时间
          Text('入睡时间',
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          Text(fmt.format(sleepTime),
              style: const TextStyle(fontSize: 52, fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary, height: 1)),

          const SizedBox(height: 28),

          // 已睡时长
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.accent.withOpacity(0.25)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.schedule_outlined, color: AppColors.accent, size: 18),
                const SizedBox(width: 8),
                Text('已睡 ${tracking.elapsedText}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                        color: AppColors.accent)),
              ],
            ),
          ),

          const Spacer(),

          // 错误提示
          if (tracking.errorMessage != null)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(tracking.errorMessage!,
                  style: const TextStyle(fontSize: 13, color: AppColors.error)),
            ),

          // 醒来按钮
          _BigButton(
            emoji: '☀️',
            label: '我醒了',
            sublabel: '记录当前时间为起床时间',
            color: AppColors.warning,
            onTap: () => _showWakeDialog(),
          ),

          const SizedBox(height: 16),

          // 取消本次记录
          TextButton(
            onPressed: () => _confirmCancel(),
            child: const Text('取消本次记录',
                style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
          ),
          const SizedBox(height: 12),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  // ─── 分析中 ────────────────────────────────────────────────────────────────

  Widget _buildAnalyzing() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppColors.accent), strokeWidth: 3),
          SizedBox(height: 20),
          Text('正在保存睡眠记录...',
              style: TextStyle(fontSize: 16, color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ─── 完成：显示睡眠摘要 ────────────────────────────────────────────────────

  Widget _buildComplete(TrackingState tracking) {
    final record = tracking.completedRecord!;
    final fmt = DateFormat('HH:mm');
    final duration = record.totalDuration;

    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('睡眠记录完成',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
          ),
          const Spacer(),

          const Text('🎉', style: TextStyle(fontSize: 64))
              .animate().scale(begin: Offset(0.5, 0.5), end: Offset(1, 1),
                  duration: 500.ms, curve: Curves.elasticOut),

          const SizedBox(height: 32),

          // 摘要卡片
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF2A3160), Color(0xFF1E2444)]),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.accent.withOpacity(0.15)),
            ),
            child: Column(
              children: [
                // 时长
                Text(
                  '${duration.inHours} 小时 ${duration.inMinutes.remainder(60)} 分钟',
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                const Text('总睡眠时长',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 20),
                const Divider(color: AppColors.textMuted, height: 1),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _summaryItem('入睡', fmt.format(record.bedtime), Icons.bedtime_outlined),
                    _summaryItem('起床', fmt.format(record.wakeTime), Icons.wb_sunny_outlined),
                    _summaryItem('得分', '${record.sleepScore}', Icons.star_outline_rounded),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),

          const Spacer(),

          // 查看详情
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                ref.read(trackingProvider.notifier).reset();
                context.push('/sleep/${record.id}');
              },
              child: const Text('查看睡眠详情'),
            ),
          ),
          const SizedBox(height: 12),

          // 返回首页
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: () {
                ref.read(trackingProvider.notifier).reset();
                context.go('/');
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.accent.withOpacity(0.4)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('返回首页',
                  style: TextStyle(color: AppColors.accent)),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.accent, size: 20),
        const SizedBox(height: 6),
        Text(value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        Text(label,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }

  // ─── 醒来弹窗：可选填质量和备注 ───────────────────────────────────────────

  void _showWakeDialog() {
    int quality = 3;
    final notesController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.fromLTRB(
              24, 20, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 拖动条
              Center(
                child: Container(width: 40, height: 4,
                    decoration: BoxDecoration(color: AppColors.textMuted,
                        borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 20),

              const Text('早安 ☀️',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              Text('现在是 ${DateFormat('HH:mm').format(DateTime.now())}，记录为起床时间',
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),

              const SizedBox(height: 24),

              // 质量评分
              const Text('睡眠质量怎么样？',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (final item in [
                    (1, '😫', '很差'), (2, '😞', '较差'), (3, '😐', '一般'),
                    (4, '😊', '不错'), (5, '😄', '很好'),
                  ])
                    GestureDetector(
                      onTap: () => setModalState(() => quality = item.$1),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: quality == item.$1
                              ? AppColors.accent.withOpacity(0.2) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: quality == item.$1
                              ? Border.all(color: AppColors.accent.withOpacity(0.5)) : null,
                        ),
                        child: Column(children: [
                          Text(item.$2,
                              style: TextStyle(fontSize: quality == item.$1 ? 28 : 22)),
                          const SizedBox(height: 4),
                          Text(item.$3,
                              style: TextStyle(fontSize: 10,
                                  color: quality == item.$1
                                      ? AppColors.accent : AppColors.textMuted,
                                  fontWeight: quality == item.$1
                                      ? FontWeight.w700 : FontWeight.w400)),
                        ]),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 20),

              // 备注（可选）
              TextField(
                controller: notesController,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: '有什么想记录的？（可选）',
                  hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
                maxLines: 2,
              ),

              const SizedBox(height: 20),

              // 确认按钮
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ref.read(trackingProvider.notifier).wakeUp(
                      quality: quality,
                      notes: notesController.text.trim().isEmpty
                          ? null : notesController.text.trim(),
                    );
                  },
                  child: const Text('确认起床，保存记录'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── 取消确认弹窗 ──────────────────────────────────────────────────────────

  void _confirmCancel() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('取消本次记录',
            style: TextStyle(color: AppColors.textPrimary)),
        content: const Text('确定要取消这次睡眠记录吗？',
            style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('继续睡觉')),
          TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                ref.read(trackingProvider.notifier).reset();
              },
              child: const Text('取消记录',
                  style: TextStyle(color: AppColors.error))),
        ],
      ),
    );
  }
}

// ─── 大圆形按钮 ───────────────────────────────────────────────────────────────

class _BigButton extends StatefulWidget {
  final String emoji, label, sublabel;
  final Color color;
  final VoidCallback onTap;

  const _BigButton({
    required this.emoji, required this.label, required this.sublabel,
    required this.color, required this.onTap,
  });

  @override
  State<_BigButton> createState() => _BigButtonState();
}

class _BigButtonState extends State<_BigButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat(reverse: true);
  }

  @override
  void dispose() { _pulse.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: _pulse,
            builder: (_, child) => Transform.scale(
              scale: 1.0 + _pulse.value * 0.04,
              child: child,
            ),
            child: Container(
              width: 170, height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [widget.color, widget.color.withOpacity(0.7)],
                ),
                boxShadow: [BoxShadow(
                  color: widget.color.withOpacity(0.45),
                  blurRadius: 36, spreadRadius: 4,
                )],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.emoji, style: const TextStyle(fontSize: 44)),
                  const SizedBox(height: 8),
                  Text(widget.label,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(widget.sublabel,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}
