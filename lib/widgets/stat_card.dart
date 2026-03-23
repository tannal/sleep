import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String label, value, unit;
  final Color color;
  const StatCard({super.key, required this.icon, required this.label,
      required this.value, required this.unit, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: color.withOpacity(0.15)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: color, size: 18),
      const SizedBox(height: 8),
      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700,
            color: AppColors.textPrimary, fontFamily: 'Sora')),
        const SizedBox(width: 2),
        Padding(padding: const EdgeInsets.only(bottom: 2),
            child: Text(unit, style: const TextStyle(fontSize: 11,
                color: AppColors.textSecondary, fontFamily: 'Sora'))),
      ]),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(fontSize: 11,
          color: AppColors.textSecondary, fontFamily: 'Sora')),
    ]),
  );
}
