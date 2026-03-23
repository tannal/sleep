import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class SleepStageIndicator extends StatelessWidget {
  final String stage;
  const SleepStageIndicator({super.key, required this.stage});

  @override
  Widget build(BuildContext context) {
    const stages = ['awake', 'light', 'deep', 'rem'];
    const labels = ['清醒', '浅睡', '深睡', 'REM'];
    const icons  = ['😴', '💫', '🌑', '🧠'];
    final colors = [AppColors.awakeColor, AppColors.lightSleep,
        AppColors.deepSleep, AppColors.remSleep];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.surfaceCard, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: stages.asMap().entries.map((e) {
          final active = e.value == stage;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: active ? colors[e.key].withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: active ? Border.all(color: colors[e.key].withOpacity(0.4)) : null,
            ),
            child: Column(children: [
              Text(icons[e.key], style: TextStyle(fontSize: active ? 22 : 18)),
              const SizedBox(height: 4),
              Text(labels[e.key], style: TextStyle(fontSize: 11, fontFamily: 'Sora',
                  fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                  color: active ? colors[e.key] : AppColors.textMuted)),
            ]),
          );
        }).toList(),
      ),
    );
  }
}
