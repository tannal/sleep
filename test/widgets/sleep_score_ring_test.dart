// test/widgets/sleep_score_ring_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleep_tracker/widgets/all_widgets.dart';
import 'package:sleep_tracker/utils/app_theme.dart';

void main() {
  group('SleepScoreRing', () {
    testWidgets('renders with correct score', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: Center(
              child: SleepScoreRing(score: 82),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Score should animate to final value
      expect(find.textContaining('82'), findsOneWidget);
      expect(find.textContaining('良好'), findsOneWidget);
    });

    testWidgets('shows 优秀 for score >= 85', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SleepScoreRing(score: 90),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('优秀'), findsOneWidget);
    });

    testWidgets('shows 需改善 for score < 55', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SleepScoreRing(score: 40),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('需改善'), findsOneWidget);
    });
  });

  group('SleepStageBar', () {
    testWidgets('renders without error', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SleepStageBar(
              deepMinutes: 90,
              lightMinutes: 200,
              remMinutes: 110,
              awakeMinutes: 20,
            ),
          ),
        ),
      );
      expect(find.byType(SleepStageBar), findsOneWidget);
    });

    testWidgets('handles zero total gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SleepStageBar(
              deepMinutes: 0,
              lightMinutes: 0,
              remMinutes: 0,
              awakeMinutes: 0,
            ),
          ),
        ),
      );
      // Should not throw
      expect(find.byType(SleepStageBar), findsOneWidget);
    });
  });

  group('StatCard', () {
    testWidgets('displays label, value, and unit', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatCard(
              icon: Icons.favorite,
              label: '平均心率',
              value: '54',
              unit: 'bpm',
              color: Colors.red,
            ),
          ),
        ),
      );

      expect(find.text('54'), findsOneWidget);
      expect(find.text('bpm'), findsOneWidget);
      expect(find.text('平均心率'), findsOneWidget);
    });
  });
}
