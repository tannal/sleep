// lib/providers/tracking_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/sleep_record.dart';
import '../providers/auth_provider.dart';
import '../providers/sleep_provider.dart';

enum TrackingPhase { idle, sleeping, analyzing, complete }

class TrackingState {
  final TrackingPhase phase;
  final DateTime? sleepTime;   // 点"我要睡了"的时间
  final DateTime? wakeTime;    // 点"我醒了"的时间
  final SleepRecord? completedRecord;
  final String? errorMessage;

  const TrackingState({
    this.phase = TrackingPhase.idle,
    this.sleepTime,
    this.wakeTime,
    this.completedRecord,
    this.errorMessage,
  });

  TrackingState copyWith({
    TrackingPhase? phase,
    DateTime? sleepTime,
    DateTime? wakeTime,
    SleepRecord? completedRecord,
    String? errorMessage,
  }) => TrackingState(
    phase: phase ?? this.phase,
    sleepTime: sleepTime ?? this.sleepTime,
    wakeTime: wakeTime ?? this.wakeTime,
    completedRecord: completedRecord ?? this.completedRecord,
    errorMessage: errorMessage,
  );

  // 已睡了多久（实时）
  Duration get elapsed {
    if (sleepTime == null) return Duration.zero;
    final end = wakeTime ?? DateTime.now();
    return end.difference(sleepTime!);
  }

  String get elapsedText {
    final d = elapsed;
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    if (h > 0) return '$h 小时 $m 分钟';
    return '$m 分钟';
  }

  bool get isSleeping => phase == TrackingPhase.sleeping;
  bool get isIdle => phase == TrackingPhase.idle;
  bool get isComplete => phase == TrackingPhase.complete;
}

class TrackingNotifier extends StateNotifier<TrackingState> {
  TrackingNotifier(this._ref) : super(const TrackingState());

  final Ref _ref;
  final _uuid = const Uuid();

  /// 用户点"我要睡了" —— 记录当前时间为入睡时间
  void startSleep() {
    state = TrackingState(
      phase: TrackingPhase.sleeping,
      sleepTime: DateTime.now(),
    );
  }

  /// 用户点"我醒了" —— 记录当前时间为起床时间，保存记录
  Future<void> wakeUp({
    int? quality,        // 可选：睡眠质量 1-5
    String? notes,       // 可选：备注
  }) async {
    if (state.sleepTime == null) return;

    final wakeTime = DateTime.now();
    state = state.copyWith(phase: TrackingPhase.analyzing, wakeTime: wakeTime);

    try {
      final user = _ref.read(currentUserProvider)!;
      final duration = wakeTime.difference(state.sleepTime!).inMinutes;

      // 根据时长简单估算各阶段（用户没有传感器，给个参考值）
      final record = SleepRecord(
        id: _uuid.v4(),
        userId: user.id,
        date: wakeTime,
        bedtime: state.sleepTime!,
        wakeTime: wakeTime,
        durationMinutes: duration,
        sleepQuality: quality,
        deepSleepMinutes: (duration * 0.20).round(),
        lightSleepMinutes: (duration * 0.53).round(),
        remSleepMinutes: (duration * 0.22).round(),
        awakeMinutes: (duration * 0.05).round(),
        notes: notes,
      );

      final saved = await _ref.read(supabaseServiceProvider).createSleepRecord(record);
      _ref.read(sleepRecordsProvider.notifier).refresh();

      state = state.copyWith(
        phase: TrackingPhase.complete,
        completedRecord: saved,
      );
    } catch (e) {
      state = state.copyWith(
        phase: TrackingPhase.sleeping, // 回到睡眠状态，让用户重试
        errorMessage: '保存失败：$e',
      );
    }
  }

  /// 重置（回到初始状态）
  void reset() {
    state = const TrackingState();
  }
}

final trackingProvider =
    StateNotifierProvider<TrackingNotifier, TrackingState>((ref) {
  return TrackingNotifier(ref);
});
