import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LiquidAvatar extends StatelessWidget {
  final String gifPath; // локальная gif в assets или network-gif
  final double size;

  const LiquidAvatar({
    super.key,
    required this.gifPath,
    this.size = 140,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// -----------------------------
          /// 1. КРУГЛАЯ GIF-АВАТАРКА
          /// -----------------------------
          ClipOval(
            child: Image.asset(
              gifPath,
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
          ),

          /// -----------------------------
          /// 2. КАПЛЯ (Liquid Glass)
          /// -----------------------------
          LiquidGlassLayer(
            settings: const LiquidGlassSettings(
              thickness: 20, // сила преломления
              blur: 1,       // размытие фона
              glassColor: Color(0x33FFFFFF), // легкая белая дымка
              lightIntensity: 1.3,
              // outlineIntensity: 0.8,
              saturation: 1.1,
            ),
            child: LiquidGlass(
              shape: LiquidRoundedSuperellipse(
                borderRadius: 50,
              ), // КРУГ!!!
              child: Container(
                width: size,
                height: size,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
