// lib/services/sleep_tracking_service.dart
// Web-compatible version (no sensor imports)
import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/sleep_record.dart';

enum TrackingState { idle, preparing, tracking, analyzing, complete }

class SleepSession {
  final String sessionId;
  final DateTime startTime;
  DateTime? endTime;
  final List<SleepStagePoint> stagePoints = [];
  final List<HeartRatePoint> heartRatePoints = [];

  SleepSession({required this.sessionId, required this.startTime});

  int get durationMinutes =>
      (endTime ?? DateTime.now()).difference(startTime).inMinutes;

  SleepRecord buildRecord(String userId) {
    final stages = analyzeSleepStages();
    final heartRates = heartRatePoints.map((p) => p.bpm).toList();
    final avgHR = heartRates.isNotEmpty
        ? heartRates.reduce((a, b) => a + b) ~/ heartRates.length
        : null;
    final minHR = heartRates.isNotEmpty ? heartRates.reduce(min) : null;

    return SleepRecord(
      id: sessionId,
      userId: userId,
      date: endTime ?? DateTime.now(),
      bedtime: startTime,
      wakeTime: endTime ?? DateTime.now(),
      deepSleepMinutes: stages['deep'] ?? 0,
      lightSleepMinutes: stages['light'] ?? 0,
      remSleepMinutes: stages['rem'] ?? 0,
      awakeMinutes: stages['awake'] ?? 0,
      avgHeartRate: avgHR,
      minHeartRate: minHR,
    );
  }

  Map<String, int> analyzeSleepStages() {
    final total = durationMinutes;
    return {
      'deep': (total * 0.20).round(),
      'rem': (total * 0.22).round(),
      'awake': (total * 0.05).round(),
      'light': (total * 0.53).round(),
    };
  }

  List<SleepStage> buildStageRecords(String recordId, String userId) {
    return stagePoints
        .map((p) => SleepStage(
              id: '',
              sleepRecordId: recordId,
              userId: userId,
              timestamp: p.timestamp,
              stage: p.stage,
              heartRate: p.heartRate,
              movementScore: p.movementScore,
            ))
        .toList();
  }
}

class SleepStagePoint {
  final DateTime timestamp;
  final String stage;
  final int? heartRate;
  final int? movementScore;
  SleepStagePoint({
    required this.timestamp,
    required this.stage,
    this.heartRate,
    this.movementScore,
  });
}

class HeartRatePoint {
  final DateTime timestamp;
  final int bpm;
  HeartRatePoint({required this.timestamp, required this.bpm});
}

final sleepTrackingServiceProvider = Provider<SleepTrackingService>((ref) {
  final service = SleepTrackingService();
  ref.onDispose(service.dispose);
  return service;
});

class SleepTrackingService {
  void dispose() {}
}
