import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class WeeklyChart extends StatelessWidget {
  const WeeklyChart({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      (label: '一', hours: 6.5, onTarget: false),
      (label: '二', hours: 7.2, onTarget: true),
      (label: '三', hours: 5.8, onTarget: false),
      (label: '四', hours: 8.0, onTarget: true),
      (label: '五', hours: 7.5, onTarget: true),
      (label: '六', hours: 8.5, onTarget: true),
      (label: '日', hours: 7.0, onTarget: true),
    ];

    final maxH = data.map((d) => d.hours).reduce((a, b) => a > b ? a : b) + 1;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: data.map((d) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(children: [
              Container(
                height: 80 * d.hours / maxH,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter, end: Alignment.topCenter,
                    colors: d.onTarget
                        ? [AppColors.accent, AppColors.accentSoft]
                        : [AppColors.warning.withOpacity(0.6), AppColors.warning],
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 6),
              Text('周${d.label}', style: const TextStyle(
                  fontSize: 10, color: AppColors.textMuted, fontFamily: 'Sora')),
            ]),
          ),
        );
      }).toList(),
    );
  }
}
