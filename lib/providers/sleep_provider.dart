// lib/providers/sleep_provider.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/sleep_record.dart';
import '../services/supabase_service.dart';
import 'auth_provider.dart';

// ─── SupabaseService Provider ─────────────────────────────────────────────────

final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService(ref.watch(supabaseClientProvider));
});

// ─── Sleep Records List ───────────────────────────────────────────────────────

class SleepRecordsNotifier extends StateNotifier<AsyncValue<List<SleepRecord>>> {
  SleepRecordsNotifier(this._service, this._userId)
      : super(const AsyncValue.loading()) {
    _load();
    _subscribeRealtime();
  }

  final SupabaseService _service;
  final String _userId;
  RealtimeChannel? _channel;

  Future<void> _load({int limit = 30}) async {
    try {
      final records = await _service.getSleepRecords(
        userId: _userId,
        limit: limit,
      );
      state = AsyncValue.data(records);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void _subscribeRealtime() {
    _channel = _service.subscribeSleepRecords(_userId, (_) => _load());
  }

  Future<void> refresh() => _load();

  Future<void> loadMore() async {
    final current = state.value ?? [];
    final more = await _service.getSleepRecords(
      userId: _userId,
      limit: 30,
      to: current.isNotEmpty
          ? current.last.date.subtract(const Duration(days: 1))
          : null,
    );
    state = AsyncValue.data([...current, ...more]);
  }

  Future<SleepRecord> addRecord(SleepRecord record) async {
    final created = await _service.createSleepRecord(record);
    final current = state.value ?? [];
    state = AsyncValue.data([created, ...current]);
    return created;
  }

  Future<void> updateRecord(SleepRecord record) async {
    final updated = await _service.updateSleepRecord(record);
    final current = state.value ?? [];
    state = AsyncValue.data(
      current.map((r) => r.id == updated.id ? updated : r).toList(),
    );
  }

  Future<void> deleteRecord(String id) async {
    await _service.deleteSleepRecord(id);
    final current = state.value ?? [];
    state = AsyncValue.data(current.where((r) => r.id != id).toList());
  }

  @override
  void dispose() {
    _channel?.unsubscribe();
    super.dispose();
  }
}

final sleepRecordsProvider = StateNotifierProvider.autoDispose<
    SleepRecordsNotifier, AsyncValue<List<SleepRecord>>>((ref) {
  final service = ref.watch(supabaseServiceProvider);
  final user = ref.watch(currentUserProvider);
  return SleepRecordsNotifier(service, user?.id ?? '');
});

// ─── Today's Record ───────────────────────────────────────────────────────────

final todaySleepRecordProvider = FutureProvider.autoDispose<SleepRecord?>((ref) {
  final service = ref.watch(supabaseServiceProvider);
  final user = ref.watch(currentUserProvider);
  if (user == null) return Future.value(null);
  return service.getTodaySleepRecord(user.id);
});

// ─── Selected Record ──────────────────────────────────────────────────────────

final selectedRecordIdProvider = StateProvider<String?>((ref) => null);

final selectedRecordProvider = Provider<SleepRecord?>((ref) {
  final id = ref.watch(selectedRecordIdProvider);
  final records = ref.watch(sleepRecordsProvider).value ?? [];
  if (id == null) return null;
  try {
    return records.firstWhere((r) => r.id == id);
  } catch (_) {
    return null;
  }
});

// ─── Weekly Stats ─────────────────────────────────────────────────────────────

final weeklyStatsProvider =
    FutureProvider.autoDispose<List<WeeklySleepStats>>((ref) {
  final service = ref.watch(supabaseServiceProvider);
  final user = ref.watch(currentUserProvider);
  if (user == null) return Future.value([]);
  return service.getWeeklyStats(user.id);
});

// ─── Derived Metrics ──────────────────────────────────────────────────────────

/// 过去 7 天的记录
final recentWeekRecordsProvider = Provider<List<SleepRecord>>((ref) {
  final records = ref.watch(sleepRecordsProvider).value ?? [];
  final cutoff = DateTime.now().subtract(const Duration(days: 7));
  return records.where((r) => r.date.isAfter(cutoff)).toList();
});

/// 过去 7 天平均睡眠得分
final weeklyAvgScoreProvider = Provider<double>((ref) {
  final records = ref.watch(recentWeekRecordsProvider);
  if (records.isEmpty) return 0;
  return records.map((r) => r.sleepScore).reduce((a, b) => a + b) /
      records.length;
});

/// 过去 7 天平均睡眠时长（小时）
final weeklyAvgHoursProvider = Provider<double>((ref) {
  final records = ref.watch(recentWeekRecordsProvider);
  if (records.isEmpty) return 0;
  final totalMin = records.map((r) => r.durationMinutes ?? 0).reduce((a, b) => a + b);
  return totalMin / records.length / 60.0;
});

/// 睡眠连续记录天数（Streak）
final sleepStreakProvider = Provider<int>((ref) {
  final records = ref.watch(sleepRecordsProvider).value ?? [];
  if (records.isEmpty) return 0;

  int streak = 0;
  DateTime current = DateTime.now();

  for (final record in records) {
    final diff = current.difference(record.date).inDays;
    if (diff <= 1) {
      streak++;
      current = record.date;
    } else {
      break;
    }
  }
  return streak;
});

// ─── Insights ─────────────────────────────────────────────────────────────────

final insightsProvider = FutureProvider.autoDispose<List<SleepInsight>>((ref) {
  final service = ref.watch(supabaseServiceProvider);
  final user = ref.watch(currentUserProvider);
  if (user == null) return Future.value([]);
  return service.getInsights(user.id);
});

final unreadInsightCountProvider = Provider<int>((ref) {
  final insights = ref.watch(insightsProvider).value ?? [];
  return insights.where((i) => !i.isRead).length;
});

// ─── Sleep Stages for a Record ────────────────────────────────────────────────

final sleepStagesProvider =
    FutureProvider.autoDispose.family<List<SleepStage>, String>((ref, recordId) {
  final service = ref.watch(supabaseServiceProvider);
  return service.getSleepStages(recordId);
});

// ─── Chart Data Helpers ───────────────────────────────────────────────────────

class SleepChartPoint {
  final DateTime date;
  final double hours;
  final int score;
  final String label;

  SleepChartPoint({
    required this.date,
    required this.hours,
    required this.score,
    required this.label,
  });
}

final sleepChartDataProvider = Provider<List<SleepChartPoint>>((ref) {
  final records = ref.watch(recentWeekRecordsProvider);
  return records.map((r) => SleepChartPoint(
    date: r.date,
    hours: (r.durationMinutes ?? 0) / 60.0,
    score: r.sleepScore,
    label: _weekdayLabel(r.date.weekday),
  )).toList().reversed.toList();
});

String _weekdayLabel(int weekday) {
  const labels = ['', '周一', '周二', '周三', '周四', '周五', '周六', '周日'];
  return labels[weekday];
}
