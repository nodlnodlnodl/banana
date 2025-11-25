import 'dart:math';
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

  

  @override
  Widget build(BuildContext context) {
    final shadowColor = Colors.black.withOpacity(0.22); // основная тень
    final ambientColor = Colors.black.withOpacity(0.08); // окружающий рассеянный ореол
    final rimLight = Colors.white.withOpacity(0.55);     // светлый кант сверху

    return Stack(
      alignment: Alignment.center,
      children: [
        // ТЕНЬ ВОКРУГ КРУГА
        DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: size * 0.05,
                spreadRadius: size * 0.00,
                offset: Offset(0, size * 0.04),
              ),
              BoxShadow(
                color: ambientColor,
                blurRadius: size * 0.1,
                spreadRadius: size * 0.05,
                offset: Offset(0, size * 0.04),
              ),
              BoxShadow(
                color: rimLight,
                blurRadius: size * 0.22,
                spreadRadius: -size * 0.06,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          // Важно: задать размер иначе тень не появится
          child: SizedBox(width: size, height: size),
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
