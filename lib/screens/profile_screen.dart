// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import '../utils/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.skyGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildAvatar(user?.email ?? ''),
                const SizedBox(height: 32),
                _buildStats(),
                const SizedBox(height: 24),
                _buildSettings(context),
                const SizedBox(height: 24),
                _buildLogout(context),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(String email) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.sleepScoreGradient,
          ),
          child: Center(
            child: Text(
              email.isNotEmpty ? email[0].toUpperCase() : '?',
              style: const TextStyle(
                  fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(email,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
        const SizedBox(height: 4),
        const Text('使用 7 天',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        Expanded(child: _statTile('追踪夜数', '7', AppColors.accent)),
        const SizedBox(width: 12),
        Expanded(child: _statTile('平均得分', '78', AppColors.success)),
        const SizedBox(width: 12),
        Expanded(child: _statTile('平均时长', '7.2h', AppColors.deepSleep)),
      ],
    );
  }

  Widget _statTile(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildSettings(BuildContext context) {
    final items = [
      (Icons.notifications_outlined, '睡眠提醒设置', AppColors.accent),
      (Icons.flag_outlined, '睡眠目标', AppColors.success),
      (Icons.cloud_outlined, '数据备份', AppColors.lightSleep),
      (Icons.info_outline_rounded, '关于应用', AppColors.textSecondary),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final isLast = e.key == items.length - 1;
          return Column(
            children: [
              ListTile(
                leading: Icon(e.value.$1, color: e.value.$3, size: 22),
                title: Text(e.value.$2,
                    style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                        fontFamily: 'Sora')),
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textMuted, size: 20),
                onTap: () {},
              ),
              if (!isLast)
                const Divider(
                  height: 1,
                  indent: 56,
                  color: AppColors.textMuted,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLogout(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () async {
          await Supabase.instance.client.auth.signOut();
          if (context.mounted) context.go('/auth');
        },
        icon: const Icon(Icons.logout_rounded, size: 18, color: AppColors.error),
        label: const Text('退出登录',
            style: TextStyle(color: AppColors.error, fontFamily: 'Sora')),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: BorderSide(color: AppColors.error.withOpacity(0.3)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
