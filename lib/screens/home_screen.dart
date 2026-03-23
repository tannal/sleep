// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../utils/app_theme.dart';
import '../widgets/all_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 示例数据
  final _lastNight = _MockSleepData(
    score: 82,
    hours: 7.5,
    bedtime: '23:14',
    wakeTime: '06:44',
    deepMinutes: 92,
    remMinutes: 108,
    lightMinutes: 186,
    awakeMinutes: 14,
    avgHR: 54,
    spo2: 98.2,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.skyGradient),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildScoreCard()),
              SliverToBoxAdapter(child: _buildQuickStats()),
              SliverToBoxAdapter(child: _buildSleepStages()),
              SliverToBoxAdapter(child: _buildWeeklyChart()),
              SliverToBoxAdapter(child: _buildInsights()),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getGreeting(),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                '睡眠报告',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => context.push('/profile'),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.accent, AppColors.remSleep],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: const Icon(Icons.person_outline_rounded,
                  color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: -0.2, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildScoreCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2D3561), Color(0xFF1E2444)],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: AppColors.accent.withOpacity(0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.1),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              SleepScoreRing(
                score: _lastNight.score,
                size: 110,
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '昨晚睡眠',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${_lastNight.hours}',
                          style: const TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            height: 1,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 6),
                          child: Text(
                            ' 小时',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _timeChip(
                            Icons.bedtime_outlined, _lastNight.bedtime),
                        const SizedBox(width: 8),
                        _timeChip(
                            Icons.wb_sunny_outlined, _lastNight.wakeTime),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate(delay: 100.ms)
        .fadeIn(duration: 700.ms)
        .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _timeChip(IconData icon, String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.accent),
          const SizedBox(width: 4),
          Text(
            time,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: StatCard(
              icon: Icons.favorite_outline_rounded,
              label: '平均心率',
              value: '${_lastNight.avgHR}',
              unit: 'bpm',
              color: AppColors.error,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatCard(
              icon: Icons.air_outlined,
              label: '血氧',
              value: '${_lastNight.spo2}',
              unit: '%',
              color: AppColors.deepSleep,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatCard(
              icon: Icons.nightlight_round,
              label: '深睡',
              value: '${(_lastNight.deepMinutes / 60).toStringAsFixed(1)}',
              unit: 'h',
              color: AppColors.deepSleep,
            ),
          ),
        ],
      ),
    )
        .animate(delay: 200.ms)
        .fadeIn(duration: 700.ms)
        .slideY(begin: 0.1, end: 0);
  }

  Widget _buildSleepStages() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: _GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('睡眠阶段'),
            const SizedBox(height: 16),
            SleepStageBar(
              deepMinutes: _lastNight.deepMinutes,
              lightMinutes: _lastNight.lightMinutes,
              remMinutes: _lastNight.remMinutes,
              awakeMinutes: _lastNight.awakeMinutes,
            ),
            const SizedBox(height: 16),
            _stageLegend(),
          ],
        ),
      ),
    )
        .animate(delay: 300.ms)
        .fadeIn(duration: 700.ms)
        .slideY(begin: 0.1, end: 0);
  }

  Widget _stageLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _legendItem('深睡', AppColors.deepSleep,
            '${_lastNight.deepMinutes}分钟'),
        _legendItem('浅睡', AppColors.lightSleep,
            '${_lastNight.lightMinutes}分钟'),
        _legendItem('REM', AppColors.remSleep,
            '${_lastNight.remMinutes}分钟'),
        _legendItem('清醒', AppColors.awakeColor,
            '${_lastNight.awakeMinutes}分钟'),
      ],
    );
  }

  Widget _legendItem(String label, Color color, String value) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                  color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                fontSize: 11,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildWeeklyChart() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: _GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _sectionTitle('近7天睡眠'),
                const Spacer(),
                TextButton(
                  onPressed: () => context.push('/analytics'),
                  child: const Text(
                    '查看详情',
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            WeeklyChart(),
          ],
        ),
      ),
    )
        .animate(delay: 400.ms)
        .fadeIn(duration: 700.ms)
        .slideY(begin: 0.1, end: 0);
  }

  Widget _buildInsights() {
    final insights = [
      _InsightData(
        icon: '🌙',
        title: '睡眠规律有所改善',
        body: '过去7天，你的入睡时间波动减少了14分钟，继续保持！',
        color: AppColors.deepSleep,
      ),
      _InsightData(
        icon: '⚠️',
        title: '深睡比例偏低',
        body: '昨晚深睡占比18%，略低于理想的20-25%。建议减少睡前屏幕时间。',
        color: AppColors.warning,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('个性化洞察'),
          const SizedBox(height: 12),
          ...insights
              .asMap()
              .entries
              .map((e) => Padding(
                    padding: EdgeInsets.only(
                        top: e.key > 0 ? 10 : 0),
                    child: _InsightCard(data: e.value),
                  ))
              .toList(),
        ],
      ),
    )
        .animate(delay: 500.ms)
        .fadeIn(duration: 700.ms)
        .slideY(begin: 0.1, end: 0);
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return '早上好 ☀️';
    if (hour < 18) return '下午好 🌤';
    return '晚上好 🌙';
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A3160), Color(0xFF1E2444)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}

class _InsightCard extends StatelessWidget {
  final _InsightData data;
  const _InsightCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: data.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: data.color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data.icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.body,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MockSleepData {
  final int score;
  final double hours;
  final String bedtime;
  final String wakeTime;
  final int deepMinutes;
  final int remMinutes;
  final int lightMinutes;
  final int awakeMinutes;
  final int avgHR;
  final double spo2;

  _MockSleepData({
    required this.score,
    required this.hours,
    required this.bedtime,
    required this.wakeTime,
    required this.deepMinutes,
    required this.remMinutes,
    required this.lightMinutes,
    required this.awakeMinutes,
    required this.avgHR,
    required this.spo2,
  });
}

class _InsightData {
  final String icon;
  final String title;
  final String body;
  final Color color;

  _InsightData({
    required this.icon,
    required this.title,
    required this.body,
    required this.color,
  });
}
