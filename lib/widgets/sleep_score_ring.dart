import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class SleepScoreRing extends StatefulWidget {
  final int score;
  final double size;
  const SleepScoreRing({super.key, required this.score, this.size = 100});

  @override
  State<SleepScoreRing> createState() => _SleepScoreRingState();
}

class _SleepScoreRingState extends State<SleepScoreRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _anim = Tween<double>(begin: 0, end: widget.score / 100)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  Color get _color {
    if (widget.score >= 85) return AppColors.success;
    if (widget.score >= 70) return AppColors.accent;
    if (widget.score >= 55) return AppColors.warning;
    return AppColors.error;
  }

  String get _label {
    if (widget.score >= 85) return '优秀';
    if (widget.score >= 70) return '良好';
    if (widget.score >= 55) return '一般';
    return '偏低';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => SizedBox(
        width: widget.size, height: widget.size,
        child: CustomPaint(
          painter: _RingPainter(progress: _anim.value, color: _color,
              trackColor: AppColors.surfaceElevated, strokeWidth: 8),
          child: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('${(widget.score * _anim.value).round()}',
                  style: TextStyle(fontSize: widget.size * 0.26,
                      fontWeight: FontWeight.w700, color: _color, fontFamily: 'Sora')),
              Text(_label, style: TextStyle(fontSize: widget.size * 0.1,
                  color: AppColors.textSecondary, fontFamily: 'Sora')),
            ]),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color, trackColor;
  final double strokeWidth;
  _RingPainter({required this.progress, required this.color,
      required this.trackColor, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = (size.width - strokeWidth) / 2;
    canvas.drawCircle(c, r, Paint()
      ..color = trackColor..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth..strokeCap = StrokeCap.round);
    if (progress <= 0) return;
    canvas.drawArc(Rect.fromCircle(center: c, radius: r),
      -pi / 2, 2 * pi * progress, false,
      Paint()
        ..shader = SweepGradient(startAngle: -pi / 2,
            endAngle: -pi / 2 + 2 * pi * progress,
            colors: [color.withOpacity(0.6), color])
            .createShader(Rect.fromCircle(center: c, radius: r))
        ..style = PaintingStyle.stroke..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color;
}
