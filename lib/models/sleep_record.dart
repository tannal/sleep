// lib/models/sleep_record.dart
class SleepRecord {
  final String id;
  final String userId;
  final DateTime date;
  final DateTime bedtime;
  final DateTime wakeTime;
  final int? durationMinutes;
  final int? sleepQuality;
  final int deepSleepMinutes;
  final int lightSleepMinutes;
  final int remSleepMinutes;
  final int awakeMinutes;
  final int? avgHeartRate;
  final int? minHeartRate;
  final double? avgSpo2;
  final int snoringMinutes;
  final String? notes;
  final int? moodBeforeSleep;
  final int? moodAfterWake;
  final List<String>? tags;
  final DateTime? createdAt;

  const SleepRecord({
    required this.id,
    required this.userId,
    required this.date,
    required this.bedtime,
    required this.wakeTime,
    this.durationMinutes,
    this.sleepQuality,
    this.deepSleepMinutes = 0,
    this.lightSleepMinutes = 0,
    this.remSleepMinutes = 0,
    this.awakeMinutes = 0,
    this.avgHeartRate,
    this.minHeartRate,
    this.avgSpo2,
    this.snoringMinutes = 0,
    this.notes,
    this.moodBeforeSleep,
    this.moodAfterWake,
    this.tags,
    this.createdAt,
  });

  factory SleepRecord.fromJson(Map<String, dynamic> json) {
    final tags = (json['sleep_tags'] as List?)
        ?.map((t) => t is Map ? t['tag'] as String : t as String)
        .toList();
    return SleepRecord(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      date: DateTime.parse(json['date'] as String),
      bedtime: DateTime.parse(json['bedtime'] as String),
      wakeTime: DateTime.parse(json['wake_time'] as String),
      durationMinutes: json['duration_minutes'] as int?,
      sleepQuality: json['sleep_quality'] as int?,
      deepSleepMinutes: (json['deep_sleep_minutes'] as int?) ?? 0,
      lightSleepMinutes: (json['light_sleep_minutes'] as int?) ?? 0,
      remSleepMinutes: (json['rem_sleep_minutes'] as int?) ?? 0,
      awakeMinutes: (json['awake_minutes'] as int?) ?? 0,
      avgHeartRate: json['avg_heart_rate'] as int?,
      minHeartRate: json['min_heart_rate'] as int?,
      avgSpo2: (json['avg_spo2'] as num?)?.toDouble(),
      snoringMinutes: (json['snoring_minutes'] as int?) ?? 0,
      notes: json['notes'] as String?,
      moodBeforeSleep: json['mood_before_sleep'] as int?,
      moodAfterWake: json['mood_after_wake'] as int?,
      tags: tags ?? (json['tags'] as List?)?.cast<String>(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'date': date.toIso8601String().substring(0, 10),
        'bedtime': bedtime.toIso8601String(),
        'wake_time': wakeTime.toIso8601String(),
        'sleep_quality': sleepQuality,
        'deep_sleep_minutes': deepSleepMinutes,
        'light_sleep_minutes': lightSleepMinutes,
        'rem_sleep_minutes': remSleepMinutes,
        'awake_minutes': awakeMinutes,
        'avg_heart_rate': avgHeartRate,
        'min_heart_rate': minHeartRate,
        'avg_spo2': avgSpo2,
        'snoring_minutes': snoringMinutes,
        'notes': notes,
        'mood_before_sleep': moodBeforeSleep,
        'mood_after_wake': moodAfterWake,
      };

  SleepRecord copyWith({
    String? id,
    String? userId,
    DateTime? date,
    DateTime? bedtime,
    DateTime? wakeTime,
    int? durationMinutes,
    int? sleepQuality,
    int? deepSleepMinutes,
    int? lightSleepMinutes,
    int? remSleepMinutes,
    int? awakeMinutes,
    int? avgHeartRate,
    int? minHeartRate,
    double? avgSpo2,
    int? snoringMinutes,
    String? notes,
    int? moodBeforeSleep,
    int? moodAfterWake,
    List<String>? tags,
  }) {
    return SleepRecord(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      bedtime: bedtime ?? this.bedtime,
      wakeTime: wakeTime ?? this.wakeTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      deepSleepMinutes: deepSleepMinutes ?? this.deepSleepMinutes,
      lightSleepMinutes: lightSleepMinutes ?? this.lightSleepMinutes,
      remSleepMinutes: remSleepMinutes ?? this.remSleepMinutes,
      awakeMinutes: awakeMinutes ?? this.awakeMinutes,
      avgHeartRate: avgHeartRate ?? this.avgHeartRate,
      minHeartRate: minHeartRate ?? this.minHeartRate,
      avgSpo2: avgSpo2 ?? this.avgSpo2,
      snoringMinutes: snoringMinutes ?? this.snoringMinutes,
      notes: notes ?? this.notes,
      moodBeforeSleep: moodBeforeSleep ?? this.moodBeforeSleep,
      moodAfterWake: moodAfterWake ?? this.moodAfterWake,
      tags: tags ?? this.tags,
    );
  }

  int get sleepScore {
    int score = 0;
    final total = durationMinutes ?? 0;
    final hours = total / 60.0;

    if (hours >= 7 && hours <= 9) score += 40;
    else if (hours >= 6 || hours <= 10) score += 28;
    else if (hours >= 5) score += 15;
    else score += 5;

    if (total > 0) {
      final deepPct = deepSleepMinutes / total;
      if (deepPct >= 0.15 && deepPct <= 0.25) score += 25;
      else if (deepPct >= 0.10) score += 15;
      else if (deepPct >= 0.05) score += 8;

      final remPct = remSleepMinutes / total;
      if (remPct >= 0.20 && remPct <= 0.25) score += 20;
      else if (remPct >= 0.15) score += 12;
      else if (remPct >= 0.10) score += 6;
    }

    score += (sleepQuality ?? 3) * 3;
    return score.clamp(0, 100);
  }

  String get scoreLabel {
    final s = sleepScore;
    if (s >= 85) return '优秀';
    if (s >= 70) return '良好';
    if (s >= 55) return '一般';
    return '需改善';
  }

  Duration get totalDuration => Duration(minutes: durationMinutes ?? 0);

  String get formattedDuration {
    final d = totalDuration;
    return '${d.inHours}h ${d.inMinutes.remainder(60)}m';
  }
}

class SleepStage {
  final String id;
  final String sleepRecordId;
  final String userId;
  final DateTime timestamp;
  final String stage;
  final int? heartRate;
  final double? spo2;
  final int? movementScore;

  const SleepStage({
    required this.id,
    required this.sleepRecordId,
    required this.userId,
    required this.timestamp,
    required this.stage,
    this.heartRate,
    this.spo2,
    this.movementScore,
  });

  factory SleepStage.fromJson(Map<String, dynamic> json) => SleepStage(
        id: json['id'] as String,
        sleepRecordId: json['sleep_record_id'] as String,
        userId: json['user_id'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        stage: json['stage'] as String,
        heartRate: json['heart_rate'] as int?,
        spo2: (json['spo2'] as num?)?.toDouble(),
        movementScore: json['movement_score'] as int?,
      );
}

class SleepInsight {
  final String id;
  final String userId;
  final String insightType;
  final String title;
  final String content;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime generatedAt;

  const SleepInsight({
    required this.id,
    required this.userId,
    required this.insightType,
    required this.title,
    required this.content,
    this.data,
    this.isRead = false,
    required this.generatedAt,
  });

  factory SleepInsight.fromJson(Map<String, dynamic> json) => SleepInsight(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        insightType: json['insight_type'] as String,
        title: json['title'] as String,
        content: json['content'] as String,
        data: json['data'] as Map<String, dynamic>?,
        isRead: (json['is_read'] as bool?) ?? false,
        generatedAt: DateTime.parse(json['generated_at'] as String),
      );
}

class WeeklySleepStats {
  final String userId;
  final DateTime weekStart;
  final int nightsTracked;
  final double avgHours;
  final double avgQuality;
  final double avgDeepSleepMin;
  final double avgRemMin;
  final int? avgHeartRate;
  final double? avgSpo2;

  const WeeklySleepStats({
    required this.userId,
    required this.weekStart,
    required this.nightsTracked,
    required this.avgHours,
    required this.avgQuality,
    required this.avgDeepSleepMin,
    required this.avgRemMin,
    this.avgHeartRate,
    this.avgSpo2,
  });

  factory WeeklySleepStats.fromJson(Map<String, dynamic> json) =>
      WeeklySleepStats(
        userId: json['user_id'] as String,
        weekStart: DateTime.parse(json['week_start'] as String),
        nightsTracked: (json['nights_tracked'] as num).toInt(),
        avgHours: (json['avg_hours'] as num).toDouble(),
        avgQuality: (json['avg_quality'] as num).toDouble(),
        avgDeepSleepMin: (json['avg_deep_sleep_min'] as num).toDouble(),
        avgRemMin: (json['avg_rem_min'] as num).toDouble(),
        avgHeartRate: json['avg_heart_rate'] as int?,
        avgSpo2: (json['avg_spo2'] as num?)?.toDouble(),
      );
}
