import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class GifGlassAvatar extends StatefulWidget {
  final String gifAsset; // путь к gif в assets
  final double size;

  const GifGlassAvatar({
    super.key,
    required this.gifAsset,
    this.size = 140,
  });

  @override
  State<GifGlassAvatar> createState() => _GifGlassAvatarState();
}

class _GifGlassAvatarState extends State<GifGlassAvatar> {
  Color? _avgColor;

  @override
  void initState() {
    super.initState();
    _loadAverageColor();
  }

  // Считает средний цвет первого кадра GIF (сэмплируем через шаг sampleStep)
  Future<void> _loadAverageColor() async {
    try {
      final color = await _computeAverageColorFromAsset(
        widget.gifAsset,
        sampleStep: 4,
      );
      if (!mounted) return;
      setState(() => _avgColor = color);
    } catch (_) {
      // игнорируем ошибки, оставляем дефолт
    }
  }

  Future<Color> _computeAverageColorFromAsset(
    String assetPath, {
    int sampleStep = 4,
  }) async {
    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List();

    // Берем первый кадр гифки
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    final bd = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (bd == null) return const Color(0xFF888888);

    final w = image.width;
    final h = image.height;
    int r = 0, g = 0, b = 0, count = 0;

    for (int y = 0; y < h; y += sampleStep) {
      for (int x = 0; x < w; x += sampleStep) {
        final i = (y * w + x) * 4;
        final rr = bd.getUint8(i);
        final gg = bd.getUint8(i + 1);
        final bb = bd.getUint8(i + 2);
        final aa = bd.getUint8(i + 3);
        if (aa < 24) continue; // пропускаем почти прозрачные пиксели
        r += rr;
        g += gg;
        b += bb;
        count++;
      }
    }

    if (count == 0) return const Color(0xFF888888);
    return Color.fromARGB(
      255,
      (r / count).round(),
      (g / count).round(),
      (b / count).round(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;

    // Базовый цвет из гифки (если не успел посчитаться — аккуратный дефолт)
    final base = _avgColor ?? const Color(0xFF888888);

    // ОДИН цвет тени = просто средний цвет с прозрачностью
    final shadowColor = base.withOpacity(0.45);

    return Stack(
      alignment: Alignment.center,
      children: [
        // ТЕНЬ ВОКРУГ КРУГА (просто средний цвет картинки)
        DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: size * 0.35,
                spreadRadius: size * 0.05,
                offset: Offset(0, size * 0.08),
              ),
            ],
          ),
          child: SizedBox(width: size, height: size),
        ),

        // Круглая GIF-аватарка
        ClipOval(
          child: Image.asset(
            widget.gifAsset,
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        ),

        // Эффект “liquid glass” поверх
        LiquidGlassLayer(
          settings: LiquidGlassSettings(
            thickness: size * 0.3,
            blur: 0,
            glassColor: Color(0x33FFFFFF),
            lightIntensity: 1.3,
            visibility: 1.0,
            chromaticAberration: .01,
            lightAngle: 0.5 * pi,
            ambientStrength: 0,
            refractiveIndex: 1.2,
            saturation: 1.5,
          ),
          child: LiquidGlass(
            shape: LiquidOval(),
            child: SizedBox(width: size, height: size),
          ),
        ),
      ],
    );
  }
}
