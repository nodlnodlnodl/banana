import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Стеклянная капля с тенью.
/// Внутрь можно передать любую картинку / gif / любой виджет.
class GlassDrop extends StatelessWidget {
  final double size;
  final Widget? child;

  /// Цвет “подложки” под картинкой (если у child есть прозрачность)
  final Color baseColor;

  const GlassDrop({
    super.key,
    required this.size,
    this.child,
    this.baseColor = const Color(0xFFF4F4F4),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          /// 1. ОБЪЁМНАЯ ТЕНЬ ПОД КАПЛЕЙ
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                // нижняя мягкая большая тень
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: size * 0.45,
                  spreadRadius: size * 0.02,
                  offset: Offset(0, size * 0.18),
                ),
                // лёгкое свечение вокруг
                BoxShadow(
                  color: Colors.white.withOpacity(0.6),
                  blurRadius: size * 0.25,
                  spreadRadius: -size * 0.02,
                  offset: Offset(0, -size * 0.02),
                ),
              ],
            ),
          ),

          /// 2. КРУГ С ГРАДИЕНТОМ + ВСТАВЛЯЕМ КАРТИНКУ
          ClipOval(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.0, -0.3),
                  radius: 1.0,
                  colors: [
                    Colors.white.withOpacity(0.95),
                    baseColor,
                  ],
                ),
              ),
              child: child, // сюда можно засунуть Image, Gif, что угодно
            ),
          ),

          /// 3. ГЛЯНЦЕВЫЙ БЛИК СВЕРХУ
          CustomPaint(
            painter: _GlassHighlightPainter(),
          ),
        ],
      ),
    );
  }
}

/// Рисуем блик в виде “полумесяца” сверху.
class _GlassHighlightPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final circleRect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Тонкая белая окантовка по краю
    final outlinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02
      ..color = Colors.white.withOpacity(0.8);
    canvas.drawOval(
      circleRect.deflate(outlinePaint.strokeWidth / 2),
      outlinePaint,
    );

    // Верхний глянцевый блик
    final highlightRect = Rect.fromLTWH(
      size.width * 0.00,
      size.height * 0.00,
      size.width,
      size.height,
    );

    final highlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Colors.white.withOpacity(0.0),
          Colors.white.withOpacity(0.0),
        ],
      ).createShader(highlightRect);

    final highlightPath = Path()..addOval(highlightRect);

    // Рисуем блик только внутри круга
    canvas.save();
    canvas.clipPath(Path()..addOval(circleRect));
    canvas.drawPath(highlightPath, highlightPaint);
    canvas.restore();

    // Дополнительное лёгкое внутреннее затемнение снизу,
    // чтобы капля казалась толще.
    final innerShadowRect = Rect.fromLTWH(
      size.width * 0.1,
      size.height * 0.5,
      size.width * 0.8,
      size.height * 0.6,
    );
    final innerShadowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black.withOpacity(0.0),
          Colors.black.withOpacity(0.12),
        ],
      ).createShader(innerShadowRect);
    final innerShadowPath = Path()..addOval(innerShadowRect);

    canvas.save();
    canvas.clipPath(Path()..addOval(circleRect));
    canvas.drawPath(innerShadowPath, innerShadowPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
