import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class GifGlassAvatar extends StatelessWidget {
  final String gifAsset; // путь к gif в assets
  final double size;

  const GifGlassAvatar({
    super.key,
    required this.gifAsset,
    this.size = 140,
  });

  // Строит «теневое отражение»: размытая и затемнённая копия гифки
  Widget _shadowReflection({
    required double size,
    required String asset,
    required Offset offset,
    double blur = 16,
    double darken = 0.55, // 0..1 чем больше, тем темнее
    double opacity = 0.8,
    double scale = 1.02,
  }) {
    // Матрица затемнения (уменьшаем яркость и насыщенность)
    final List<double> darkenMatrix = <double>[
      // R
      0.6, 0.0, 0.0, 0.0, -255 * darken * 0.12,
      // G
      0.6, 0.0, 0.0, 0.0, -255 * darken * 0.12,
      // B
      0.6, 0.0, 0.0, 0.0, -255 * darken * 0.12,
      // A
      0.0, 0.0, 0.0, 1.0, 0.0,
    ];

    return Transform.translate(
      offset: offset,
      child: Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: opacity,
          child: ClipOval(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
              child: ColorFiltered(
                colorFilter: ColorFilter.matrix(darkenMatrix),
                child: Image.asset(
                  asset,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // ВМЕСТО BoxShadow – реалистичная тень из размытой тёмной копии гифки
        _shadowReflection(
          size: size,
          asset: gifAsset,
          offset: Offset(0, size * 0.18), // основная нижняя тень
          blur: size * 0.20,
          darken: 0.65,
          opacity: 0.85,
          scale: 1.02,
        ),
        _shadowReflection(
          size: size,
          asset: gifAsset,
          offset: Offset(0, size * 0.06), // мягкий ореол вокруг
          blur: size * 0.12,
          darken: 0.45,
          opacity: 0.55,
          scale: 1.06,
        ),
        // тонкий светлый кант сверху имитируем лёгким «блик»-слоем
        Positioned(
          top: 0,
          child: ClipOval(
            child: Container(
              width: size,
              height: size * 0.55,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.35),
                    Colors.white.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Круглая GIF-аватарка
        ClipOval(
          child: Image.asset(
            gifAsset,
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        ),

        // Эффект “liquid glass” поверх
        LiquidGlassLayer(
          settings: const LiquidGlassSettings(
            thickness: 70,
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
