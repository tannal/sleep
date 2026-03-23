// lib/providers/tracking_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/sleep_record.dart';
import '../providers/auth_provider.dart';
import '../providers/sleep_provider.dart';

// SharedPreferences 存储的 key
const _kSleepTime  = 'tracking_sleep_time';   // 入睡时间戳（毫秒）
const _kSessionId  = 'tracking_session_id';   // 本次会话 UUID
const _kPhase      = 'tracking_phase';        // 当前阶段字符串

enum TrackingPhase { idle, sleeping, analyzing, complete }

class TrackingState {
  final TrackingPhase phase;
  final DateTime? sleepTime;
  final DateTime? wakeTime;
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
  }) =>
      TrackingState(
        phase: phase ?? this.phase,
        sleepTime: sleepTime ?? this.sleepTime,
        wakeTime: wakeTime ?? this.wakeTime,
        completedRecord: completedRecord ?? this.completedRecord,
        errorMessage: errorMessage,
      );

  Duration get elapsed {
    if (sleepTime == null) return Duration.zero;
    return (wakeTime ?? DateTime.now()).difference(sleepTime!);
  }

  String get elapsedText {
    final d = elapsed;
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    if (h > 0) return '$h 小时 $m 分钟';
    return '$m 分钟';
  }

  bool get isSleeping => phase == TrackingPhase.sleeping;
  bool get isIdle     => phase == TrackingPhase.idle;
  bool get isComplete => phase == TrackingPhase.complete;
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class TrackingNotifier extends StateNotifier<TrackingState> {
  TrackingNotifier(this._ref) : super(const TrackingState()) {
    _restore(); // App 启动时恢复持久化状态
  }

  final Ref _ref;
  final _uuid = const Uuid();

  // ── 恢复持久化状态 ──────────────────────────────────────────────────────────

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final phase  = prefs.getString(_kPhase);
    final millis = prefs.getInt(_kSleepTime);

    // 只恢复"睡眠中"状态，其他状态无需恢复
    if (phase == 'sleeping' && millis != null) {
      state = TrackingState(
        phase: TrackingPhase.sleeping,
        sleepTime: DateTime.fromMillisecondsSinceEpoch(millis),
      );
    }
  }

  // ── 持久化当前状态 ─────────────────────────────────────────────────────────

  Future<void> _persist(TrackingPhase phase, {DateTime? sleepTime, String? sessionId}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kPhase, phase.name);
    if (sleepTime != null) {
      await prefs.setInt(_kSleepTime, sleepTime.millisecondsSinceEpoch);
    }
    if (sessionId != null) {
      await prefs.setString(_kSessionId, sessionId);
    }
  }

  Future<void> _clearPersisted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kPhase);
    await prefs.remove(_kSleepTime);
    await prefs.remove(_kSessionId);
  }

  // ── 公开方法 ───────────────────────────────────────────────────────────────

  /// 点"我要睡了"
  Future<void> startSleep() async {
    final now = DateTime.now();
    final sessionId = _uuid.v4();

    state = TrackingState(
      phase: TrackingPhase.sleeping,
      sleepTime: now,
    );

    // 持久化：写入磁盘，重启后恢复
    await _persist(TrackingPhase.sleeping, sleepTime: now, sessionId: sessionId);
  }

  /// 点"我醒了"
  Future<void> wakeUp({int? quality, String? notes}) async {
    if (state.sleepTime == null) return;

    final sleepTime = state.sleepTime!;
    final wakeTime  = DateTime.now();

    state = state.copyWith(phase: TrackingPhase.analyzing, wakeTime: wakeTime);

    try {
      final user     = _ref.read(currentUserProvider)!;
      final duration = wakeTime.difference(sleepTime).inMinutes;

      // 从磁盘读取 sessionId（重启后也能拿到）
      final prefs     = await SharedPreferences.getInstance();
      final sessionId = prefs.getString(_kSessionId) ?? _uuid.v4();

      final record = SleepRecord(
        id: sessionId,
        userId: user.id,
        date: wakeTime,
        bedtime: sleepTime,
        wakeTime: wakeTime,
        durationMinutes: duration,
        sleepQuality: quality,
        deepSleepMinutes:  (duration * 0.20).round(),
        lightSleepMinutes: (duration * 0.53).round(),
        remSleepMinutes:   (duration * 0.22).round(),
        awakeMinutes:      (duration * 0.05).round(),
        notes: notes,
      );

      final saved = await _ref.read(supabaseServiceProvider).createSleepRecord(record);
      _ref.read(sleepRecordsProvider.notifier).refresh();

      // 保存成功 → 清除持久化数据
      await _clearPersisted();

      state = state.copyWith(
        phase: TrackingPhase.complete,
        completedRecord: saved,
      );
    } catch (e) {
      // 保存失败 → 回到睡眠状态（持久化数据还在，重启仍能恢复）
      state = state.copyWith(
        phase: TrackingPhase.sleeping,
        errorMessage: '保存失败，请重试：${e.toString().split('\n').first}',
      );
    }
  }

  /// 取消并重置
  Future<void> reset() async {
    await _clearPersisted();
    state = const TrackingState();
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final trackingProvider =
    StateNotifierProvider<TrackingNotifier, TrackingState>((ref) {
  return TrackingNotifier(ref);
});
