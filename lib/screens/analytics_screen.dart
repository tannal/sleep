// lib/screens/analytics_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/app_theme.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedPeriod = 7; // 7 or 30 days

  // 模拟数据
  final _weekData = [
    _DayData('周一', 6.5, 72),
    _DayData('周二', 7.2, 78),
    _DayData('周三', 5.8, 65),
    _DayData('周四', 8.0, 88),
    _DayData('周五', 7.5, 82),
    _DayData('周六', 8.5, 90),
    _DayData('周日', 7.0, 75),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.skyGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildPeriodSelector(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildSleepDurationTab(),
                    _buildSleepQualityTab(),
                    _buildStagesTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('睡眠分析',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: '睡眠时长'),
              Tab(text: '睡眠质量'),
              Tab(text: '睡眠阶段'),
            ],
            indicator: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(10),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: const TextStyle(
              fontFamily: 'Sora',
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(fontFamily: 'Sora', fontSize: 13),
            dividerColor: Colors.transparent,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        children: [
          _periodButton('7天', 7),
          const SizedBox(width: 8),
          _periodButton('30天', 30),
          const Spacer(),
          _summaryChip('平均 7.2h', AppColors.accent),
          const SizedBox(width: 8),
          _summaryChip('得分 79', AppColors.success),
        ],
      ),
    );
  }

  Widget _periodButton(String label, int days) {
    final selected = _selectedPeriod == days;
    return GestureDetector(
      onTap: () => setState(() => _selectedPeriod = days),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.accent : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _summaryChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label,
          style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildSleepDurationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildBarChart(),
          const SizedBox(height: 20),
          _buildSleepStats(),
          const SizedBox(height: 20),
          _buildBedtimeChart(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2A3160), Color(0xFF1E2444)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('每日睡眠时长',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          const Text('小时',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 10,
                minY: 0,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                        BarTooltipItem(
                      '${rod.toY.toStringAsFixed(1)}h',
                      const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Sora',
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= _weekData.length) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _weekData[idx].label,
                            style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                                fontFamily: 'Sora'),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}',
                        style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textMuted,
                            fontFamily: 'Sora'),
                      ),
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: AppColors.textMuted.withOpacity(0.2),
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                  drawVerticalLine: false,
                ),
                borderData: FlBorderData(show: false),
                barGroups: _weekData.asMap().entries.map((e) {
                  final isAboveTarget = e.value.hours >= 7;
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value.hours,
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: isAboveTarget
                              ? [AppColors.accent, AppColors.accentSoft]
                              : [AppColors.warning.withOpacity(0.7), AppColors.warning],
                        ),
                        width: 22,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      ),
                    ],
                  );
                }).toList(),
                // 目标线
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: 8,
                      color: AppColors.success.withOpacity(0.4),
                      strokeWidth: 1.5,
                      dashArray: [6, 4],
                      label: HorizontalLineLabel(
                        show: true,
                        alignment: Alignment.topRight,
                        labelResolver: (_) => '目标 8h',
                        style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.success,
                            fontFamily: 'Sora'),
                      ),
                    ),
                  ],
                ),
              ),
              swapAnimationDuration: const Duration(milliseconds: 600),
              swapAnimationCurve: Curves.easeOutCubic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepStats() {
    return Row(
      children: [
        Expanded(
          child: _statBox('平均时长', '7小时 12分', Icons.schedule_outlined,
              AppColors.accent),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statBox(
              '最长睡眠', '8小时 30分', Icons.trending_up_rounded, AppColors.success),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statBox(
              '最短睡眠', '5小时 48分', Icons.trending_down_rounded, AppColors.warning),
        ),
      ],
    );
  }

  Widget _statBox(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildBedtimeChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2A3160), Color(0xFF1E2444)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('入睡 / 起床时间',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 20),
          ..._weekData.map((d) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _bedtimeRow(d.label, '23:${10 + d.hours.toInt()}',
                    '0${6 + (d.hours / 2).round()}:30'),
              )),
        ],
      ),
    );
  }

  Widget _bedtimeRow(String day, String bedtime, String wakeTime) {
    return Row(
      children: [
        SizedBox(
            width: 36,
            child: Text(day,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
        const SizedBox(width: 8),
        Expanded(
          child: Stack(
            children: [
              Container(height: 8, decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(4),
              )),
              FractionallySizedBox(
                widthFactor: 0.7,
                child: Container(height: 8, decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.remSleep, AppColors.deepSleep],
                  ),
                  borderRadius: BorderRadius.circular(4),
                )),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text('$bedtime → $wakeTime',
            style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
      ],
    );
  }

  Widget _buildSleepQualityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildLineChart(),
          const SizedBox(height: 20),
          _buildQualityFactors(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    final spots = _weekData.asMap().entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.score.toDouble()))
        .toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF2A3160), Color(0xFF1E2444)]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('睡眠质量得分',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.4,
                    gradient: const LinearGradient(
                      colors: [AppColors.accent, AppColors.remSleep],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                        radius: 4,
                        color: AppColors.accent,
                        strokeColor: AppColors.primary,
                        strokeWidth: 2,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.accent.withOpacity(0.3),
                          AppColors.accent.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ],
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= _weekData.length) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(_weekData[idx].label,
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                  fontFamily: 'Sora')),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 25,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}',
                        style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textMuted,
                            fontFamily: 'Sora'),
                      ),
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 25,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: AppColors.textMuted.withOpacity(0.2),
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                  drawVerticalLine: false,
                ),
                borderData: FlBorderData(show: false),
              ),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQualityFactors() {
    final factors = [
      _FactorData('规律性', 0.78, AppColors.accent),
      _FactorData('深睡比例', 0.65, AppColors.deepSleep),
      _FactorData('REM 质量', 0.82, AppColors.remSleep),
      _FactorData('醒觉次数', 0.91, AppColors.success),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF2A3160), Color(0xFF1E2444)]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('影响因素',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          ...factors.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _factorRow(f),
              )),
        ],
      ),
    );
  }

  Widget _factorRow(_FactorData factor) {
    return Column(
      children: [
        Row(
          children: [
            Text(factor.label,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary)),
            const Spacer(),
            Text('${(factor.value * 100).round()}',
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: factor.value,
            backgroundColor: AppColors.surfaceElevated,
            valueColor: AlwaysStoppedAnimation(factor.color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildStagesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildPieChart(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF2A3160), Color(0xFF1E2444)]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Text('平均睡眠阶段分布',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 50,
                sections: [
                  PieChartSectionData(
                    value: 20,
                    color: AppColors.deepSleep,
                    title: '20%',
                    titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Sora'),
                    radius: 60,
                  ),
                  PieChartSectionData(
                    value: 22,
                    color: AppColors.remSleep,
                    title: '22%',
                    titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Sora'),
                    radius: 60,
                  ),
                  PieChartSectionData(
                    value: 53,
                    color: AppColors.lightSleep,
                    title: '53%',
                    titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Sora'),
                    radius: 60,
                  ),
                  PieChartSectionData(
                    value: 5,
                    color: AppColors.awakeColor,
                    title: '5%',
                    titleStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Sora'),
                    radius: 60,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _pieLegend(),
        ],
      ),
    );
  }

  Widget _pieLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _pieItem('深睡', AppColors.deepSleep, '20%', '1h 26m'),
        _pieItem('REM', AppColors.remSleep, '22%', '1h 36m'),
        _pieItem('浅睡', AppColors.lightSleep, '53%', '3h 49m'),
        _pieItem('清醒', AppColors.awakeColor, '5%', '22m'),
      ],
    );
  }

  Widget _pieItem(String label, Color color, String pct, String time) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 4),
            Text(label,
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
        const SizedBox(height: 2),
        Text(pct,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        Text(time,
            style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
      ],
    );
  }
}

class _DayData {
  final String label;
  final double hours;
  final int score;
  _DayData(this.label, this.hours, this.score);
}

class _FactorData {
  final String label;
  final double value;
  final Color color;
  _FactorData(this.label, this.value, this.color);
}
