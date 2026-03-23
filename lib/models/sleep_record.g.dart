// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SleepRecordImpl _$$SleepRecordImplFromJson(Map<String, dynamic> json) =>
    _$SleepRecordImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      date: DateTime.parse(json['date'] as String),
      bedtime: DateTime.parse(json['bedtime'] as String),
      wakeTime: DateTime.parse(json['wakeTime'] as String),
      durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
      sleepQuality: (json['sleepQuality'] as num?)?.toInt(),
      deepSleepMinutes: (json['deepSleepMinutes'] as num?)?.toInt() ?? 0,
      lightSleepMinutes: (json['lightSleepMinutes'] as num?)?.toInt() ?? 0,
      remSleepMinutes: (json['remSleepMinutes'] as num?)?.toInt() ?? 0,
      awakeMinutes: (json['awakeMinutes'] as num?)?.toInt() ?? 0,
      avgHeartRate: (json['avgHeartRate'] as num?)?.toInt(),
      minHeartRate: (json['minHeartRate'] as num?)?.toInt(),
      avgSpo2: (json['avgSpo2'] as num?)?.toDouble(),
      snoringMinutes: (json['snoringMinutes'] as num?)?.toInt() ?? 0,
      roomTemperature: (json['roomTemperature'] as num?)?.toDouble(),
      roomHumidity: (json['roomHumidity'] as num?)?.toInt(),
      noiseLevel: (json['noiseLevel'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      moodBeforeSleep: (json['moodBeforeSleep'] as num?)?.toInt(),
      moodAfterWake: (json['moodAfterWake'] as num?)?.toInt(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$SleepRecordImplToJson(_$SleepRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'date': instance.date.toIso8601String(),
      'bedtime': instance.bedtime.toIso8601String(),
      'wakeTime': instance.wakeTime.toIso8601String(),
      'durationMinutes': instance.durationMinutes,
      'sleepQuality': instance.sleepQuality,
      'deepSleepMinutes': instance.deepSleepMinutes,
      'lightSleepMinutes': instance.lightSleepMinutes,
      'remSleepMinutes': instance.remSleepMinutes,
      'awakeMinutes': instance.awakeMinutes,
      'avgHeartRate': instance.avgHeartRate,
      'minHeartRate': instance.minHeartRate,
      'avgSpo2': instance.avgSpo2,
      'snoringMinutes': instance.snoringMinutes,
      'roomTemperature': instance.roomTemperature,
      'roomHumidity': instance.roomHumidity,
      'noiseLevel': instance.noiseLevel,
      'notes': instance.notes,
      'moodBeforeSleep': instance.moodBeforeSleep,
      'moodAfterWake': instance.moodAfterWake,
      'tags': instance.tags,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$SleepStageImpl _$$SleepStageImplFromJson(Map<String, dynamic> json) =>
    _$SleepStageImpl(
      id: json['id'] as String,
      sleepRecordId: json['sleepRecordId'] as String,
      userId: json['userId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      stage: json['stage'] as String,
      heartRate: (json['heartRate'] as num?)?.toInt(),
      spo2: (json['spo2'] as num?)?.toDouble(),
      movementScore: (json['movementScore'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$SleepStageImplToJson(_$SleepStageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sleepRecordId': instance.sleepRecordId,
      'userId': instance.userId,
      'timestamp': instance.timestamp.toIso8601String(),
      'stage': instance.stage,
      'heartRate': instance.heartRate,
      'spo2': instance.spo2,
      'movementScore': instance.movementScore,
    };

_$SleepInsightImpl _$$SleepInsightImplFromJson(Map<String, dynamic> json) =>
    _$SleepInsightImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      insightType: json['insightType'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      data: json['data'] as Map<String, dynamic>?,
      isRead: json['isRead'] as bool? ?? false,
      generatedAt: DateTime.parse(json['generatedAt'] as String),
    );

Map<String, dynamic> _$$SleepInsightImplToJson(_$SleepInsightImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'insightType': instance.insightType,
      'title': instance.title,
      'content': instance.content,
      'data': instance.data,
      'isRead': instance.isRead,
      'generatedAt': instance.generatedAt.toIso8601String(),
    };

_$WeeklySleepStatsImpl _$$WeeklySleepStatsImplFromJson(
        Map<String, dynamic> json) =>
    _$WeeklySleepStatsImpl(
      userId: json['userId'] as String,
      weekStart: DateTime.parse(json['weekStart'] as String),
      nightsTracked: (json['nightsTracked'] as num).toInt(),
      avgHours: (json['avgHours'] as num).toDouble(),
      avgQuality: (json['avgQuality'] as num).toDouble(),
      avgDeepSleepMin: (json['avgDeepSleepMin'] as num).toDouble(),
      avgRemMin: (json['avgRemMin'] as num).toDouble(),
      avgHeartRate: (json['avgHeartRate'] as num?)?.toInt(),
      avgSpo2: (json['avgSpo2'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$WeeklySleepStatsImplToJson(
        _$WeeklySleepStatsImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'weekStart': instance.weekStart.toIso8601String(),
      'nightsTracked': instance.nightsTracked,
      'avgHours': instance.avgHours,
      'avgQuality': instance.avgQuality,
      'avgDeepSleepMin': instance.avgDeepSleepMin,
      'avgRemMin': instance.avgRemMin,
      'avgHeartRate': instance.avgHeartRate,
      'avgSpo2': instance.avgSpo2,
    };
