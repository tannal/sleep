import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class HeartRateWave extends StatelessWidget {
  final List<double> dataPoints;
  final Color color;
  const HeartRateWave({super.key, required this.dataPoints, this.color = AppColors.error});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 50,
    child: CustomPaint(
      painter: _WavePainter(dataPoints: dataPoints, color: color),
      size: Size.infinite,
    ),
  );
}

class _WavePainter extends CustomPainter {
  final List<double> dataPoints;
  final Color color;
  _WavePainter({required this.dataPoints, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.length < 2) return;
    final linePaint = Paint()..color = color..strokeWidth = 1.5
      ..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final fillPaint = Paint()
      ..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [color.withOpacity(0.3), color.withOpacity(0.0)])
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;
    final dx = size.width / (dataPoints.length - 1);
    final line = Path(), fill = Path();
    fill.moveTo(0, size.height);
    for (int i = 0; i < dataPoints.length; i++) {
      final x = i * dx, y = size.height * (1 - dataPoints[i]);
      if (i == 0) { line.moveTo(x, y); fill.lineTo(x, y); }
      else {
        final px = (i-1)*dx, py = size.height*(1-dataPoints[i-1]), cpx = (px+x)/2;
        line.cubicTo(cpx, py, cpx, y, x, y);
        fill.cubicTo(cpx, py, cpx, y, x, y);
      }
    }
    fill.lineTo(size.width, size.height); fill.close();
    canvas.drawPath(fill, fillPaint);
    canvas.drawPath(line, linePaint);
  }

  @override
  bool shouldRepaint(_WavePainter old) => old.dataPoints != dataPoints;
}
