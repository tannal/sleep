// test/models/sleep_record_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sleep_tracker/models/sleep_record.dart';

void main() {
  group('SleepRecord', () {
    late SleepRecord goodRecord;
    late SleepRecord poorRecord;

    setUp(() {
      final now = DateTime.now();

      goodRecord = SleepRecord(
        id: 'test-1',
        userId: 'user-1',
        date: now,
        bedtime: now.subtract(const Duration(hours: 8)),
        wakeTime: now,
        durationMinutes: 480, // 8 hours
        sleepQuality: 5,
        deepSleepMinutes: 100, // ~21%
        lightSleepMinutes: 254,
        remSleepMinutes: 110, // ~23%
        awakeMinutes: 16,
      );

      poorRecord = SleepRecord(
        id: 'test-2',
        userId: 'user-1',
        date: now,
        bedtime: now.subtract(const Duration(hours: 5)),
        wakeTime: now,
        durationMinutes: 300, // 5 hours
        sleepQuality: 1,
        deepSleepMinutes: 20, // ~7%
        lightSleepMinutes: 220,
        remSleepMinutes: 40, // ~13%
        awakeMinutes: 20,
      );
    });

    group('sleepScore', () {
      test('good record scores high (>=75)', () {
        expect(goodRecord.sleepScore, greaterThanOrEqualTo(75));
      });

      test('poor record scores low (<55)', () {
        expect(poorRecord.sleepScore, lessThan(60));
      });

      test('score is clamped between 0 and 100', () {
        expect(goodRecord.sleepScore, inInclusiveRange(0, 100));
        expect(poorRecord.sleepScore, inInclusiveRange(0, 100));
      });
    });

    group('scoreLabel', () {
      test('good record has positive label', () {
        expect(['优秀', '良好'], contains(goodRecord.scoreLabel));
      });

      test('poor record has negative label', () {
        expect(['一般', '需改善'], contains(poorRecord.scoreLabel));
      });
    });

    group('formattedDuration', () {
      test('8 hours shows correctly', () {
        expect(goodRecord.formattedDuration, equals('8h 0m'));
      });

      test('5 hours shows correctly', () {
        expect(poorRecord.formattedDuration, equals('5h 0m'));
      });
    });

    group('totalDuration', () {
      test('correct duration calculated', () {
        expect(goodRecord.totalDuration.inHours, equals(8));
        expect(poorRecord.totalDuration.inHours, equals(5));
      });
    });

    group('JSON serialization', () {
      test('round-trip serialization', () {
        final json = goodRecord.toJson();
        expect(json['id'], equals('test-1'));
        expect(json['sleep_quality'], equals(5));
        expect(json['deep_sleep_minutes'], equals(100));
      });
    });
  });

  group('SleepInsight', () {
    test('creates from json correctly', () {
      final insight = SleepInsight.fromJson({
        'id': 'insight-1',
        'user_id': 'user-1',
        'insight_type': 'recommendation',
        'title': '测试洞察',
        'content': '内容',
        'is_read': false,
        'generated_at': DateTime.now().toIso8601String(),
      });

      expect(insight.id, equals('insight-1'));
      expect(insight.insightType, equals('recommendation'));
      expect(insight.isRead, isFalse);
    });
  });
}
