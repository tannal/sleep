// lib/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/sleep_record.dart';

class SupabaseService {
  final SupabaseClient _client;
  SupabaseService(this._client);

  // ─── Auth ─────────────────────────────────────────────────────────────────

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? username,
  }) =>
      _client.auth.signUp(
        email: email,
        password: password,
        data: username != null ? {'username': username} : null,
      );

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) =>
      _client.auth.signInWithPassword(email: email, password: password);

  Future<void> signOut() => _client.auth.signOut();

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
  User? get currentUser => _client.auth.currentUser;

  // ─── User Profile ─────────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final res = await _client
        .from('user_profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    return res;
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) =>
      _client
          .from('user_profiles')
          .update({...data, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', userId);

  // ─── Sleep Records ────────────────────────────────────────────────────────

  Future<List<SleepRecord>> getSleepRecords({
    required String userId,
    int limit = 30,
    DateTime? from,
    DateTime? to,
  }) async {
    // IMPORTANT: all filters must come BEFORE .order() and .limit()
    // to avoid PostgrestTransformBuilder type errors
    var q = _client
        .from('sleep_records')
        .select('*, sleep_tags(tag)')
        .eq('user_id', userId);

    if (from != null) {
      q = q.gte('date', from.toIso8601String().substring(0, 10));
    }
    if (to != null) {
      q = q.lte('date', to.toIso8601String().substring(0, 10));
    }

    final data = await q.order('date', ascending: false).limit(limit);

    return (data as List).map((e) {
      final tags = (e['sleep_tags'] as List?)
          ?.map((t) => t['tag'] as String)
          .toList();
      return SleepRecord.fromJson({...Map<String, dynamic>.from(e), 'tags': tags});
    }).toList();
  }

  Future<SleepRecord?> getTodaySleepRecord(String userId) async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final data = await _client
        .from('sleep_records')
        .select()
        .eq('user_id', userId)
        .eq('date', today)
        .maybeSingle();
    return data != null ? SleepRecord.fromJson(data) : null;
  }

  Future<SleepRecord> createSleepRecord(SleepRecord record) async {
    final data = await _client
        .from('sleep_records')
        .insert({
          'user_id': record.userId,
          'date': record.date.toIso8601String().substring(0, 10),
          'bedtime': record.bedtime.toIso8601String(),
          'wake_time': record.wakeTime.toIso8601String(),
          'sleep_quality': record.sleepQuality,
          'deep_sleep_minutes': record.deepSleepMinutes,
          'light_sleep_minutes': record.lightSleepMinutes,
          'rem_sleep_minutes': record.remSleepMinutes,
          'awake_minutes': record.awakeMinutes,
          'avg_heart_rate': record.avgHeartRate,
          'min_heart_rate': record.minHeartRate,
          'avg_spo2': record.avgSpo2,
          'snoring_minutes': record.snoringMinutes,
          'notes': record.notes,
          'mood_before_sleep': record.moodBeforeSleep,
          'mood_after_wake': record.moodAfterWake,
        })
        .select()
        .single();
    return SleepRecord.fromJson(data);
  }

  Future<SleepRecord> updateSleepRecord(SleepRecord record) async {
    final data = await _client
        .from('sleep_records')
        .update({
          'sleep_quality': record.sleepQuality,
          'deep_sleep_minutes': record.deepSleepMinutes,
          'light_sleep_minutes': record.lightSleepMinutes,
          'rem_sleep_minutes': record.remSleepMinutes,
          'awake_minutes': record.awakeMinutes,
          'avg_heart_rate': record.avgHeartRate,
          'avg_spo2': record.avgSpo2,
          'notes': record.notes,
          'mood_before_sleep': record.moodBeforeSleep,
          'mood_after_wake': record.moodAfterWake,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', record.id)
        .select()
        .single();
    return SleepRecord.fromJson(data);
  }

  Future<void> deleteSleepRecord(String recordId) =>
      _client.from('sleep_records').delete().eq('id', recordId);

  // ─── Sleep Stages ─────────────────────────────────────────────────────────

  Future<void> uploadSleepStages(List<SleepStage> stages) async {
    if (stages.isEmpty) return;
    await _client.from('sleep_stages').insert(
      stages.map((s) => {
        'sleep_record_id': s.sleepRecordId,
        'user_id': s.userId,
        'timestamp': s.timestamp.toIso8601String(),
        'stage': s.stage,
        'heart_rate': s.heartRate,
        'spo2': s.spo2,
        'movement_score': s.movementScore,
      }).toList(),
    );
  }

  Future<List<SleepStage>> getSleepStages(String recordId) async {
    final data = await _client
        .from('sleep_stages')
        .select()
        .eq('sleep_record_id', recordId)
        .order('timestamp');
    return (data as List).map((e) => SleepStage.fromJson(e)).toList();
  }

  // ─── Insights ─────────────────────────────────────────────────────────────

  Future<List<SleepInsight>> getInsights(String userId, {int limit = 10}) async {
    final data = await _client
        .from('sleep_insights')
        .select()
        .eq('user_id', userId)
        .order('generated_at', ascending: false)
        .limit(limit);
    return (data as List).map((e) => SleepInsight.fromJson(e)).toList();
  }

  Future<void> markInsightRead(String insightId) =>
      _client.from('sleep_insights').update({'is_read': true}).eq('id', insightId);

  // ─── Weekly Stats ─────────────────────────────────────────────────────────

  Future<List<WeeklySleepStats>> getWeeklyStats(String userId, {int weeks = 4}) async {
    final from = DateTime.now().subtract(Duration(days: weeks * 7));
    final data = await _client
        .from('weekly_sleep_stats')
        .select()
        .eq('user_id', userId)
        .gte('week_start', from.toIso8601String())
        .order('week_start', ascending: false);
    return (data as List).map((e) => WeeklySleepStats.fromJson(e)).toList();
  }

  // ─── Realtime ─────────────────────────────────────────────────────────────

  RealtimeChannel subscribeSleepRecords(
      String userId, void Function(dynamic) onUpdate) {
    return _client
        .channel('sleep_records_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'sleep_records',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) => onUpdate(payload),
        )
        .subscribe();
  }
}
