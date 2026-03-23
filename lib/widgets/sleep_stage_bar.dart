import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class SleepStageBar extends StatelessWidget {
  final int deepMinutes, lightMinutes, remMinutes, awakeMinutes;
  const SleepStageBar({super.key, required this.deepMinutes,
      required this.lightMinutes, required this.remMinutes, required this.awakeMinutes});

  @override
  Widget build(BuildContext context) {
    final total = deepMinutes + lightMinutes + remMinutes + awakeMinutes;
    if (total == 0) return const SizedBox(height: 24);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Row(children: [
        _seg(deepMinutes, total, AppColors.deepSleep),
        _seg(lightMinutes, total, AppColors.lightSleep),
        _seg(remMinutes, total, AppColors.remSleep),
        _seg(awakeMinutes, total, AppColors.awakeColor),
      ]),
    );
  }

  Widget _seg(int min, int total, Color color) {
    if (min == 0) return const SizedBox.shrink();
    return Expanded(flex: min, child: Container(height: 24, color: color));
  }
}
