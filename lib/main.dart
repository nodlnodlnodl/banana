import 'dart:math';
import 'package:banana/gif_glass_avatar_skip2.dart';
import 'package:banana/glass_gif.dart';
import 'package:banana/main2.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 251, 251, 2)),
      ),
      home: const MyHomePage(title: 'Clicker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  int _counter = 0;
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final GlobalKey _buttonKey = GlobalKey();
  Offset _originGlobal = Offset.zero;
  OverlayEntry? _overlayEntry;

  final double _speed = 600.0; // пикселей в секунду для всех малинок

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(days: 1), // длинная длительность
    )..addListener(() {
        _removeFinishedParticles();
        _overlayEntry?.markNeedsBuild();
        if (_particles.isEmpty) {
          _removeOverlay();
        }
      });
    _controller.forward(); // запускаем один раз
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateOriginGlobal());
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    _updateOriginGlobal();
    _spawnParticles();
  }

  void _updateOriginGlobal() {
    final ctxButton = _buttonKey.currentContext;
    if (ctxButton == null) return;
    final boxButton = ctxButton.findRenderObject() as RenderBox;
    final topLeft = boxButton.localToGlobal(Offset.zero);
    _originGlobal = topLeft + Offset(boxButton.size.width / 2, boxButton.size.height / 2);
  }

  void _spawnParticles() {
    final size = MediaQuery.of(context).size;
    final rnd = Random();

    // НЕ очищаем _particles, просто добавляем новые
    final creationTime = _controller.lastElapsedDuration ?? Duration.zero;

    for (int i = 0; i < 28; i++) {
      final angle = rnd.nextDouble() * 2 * pi;
      final dist = _distanceToEdge(angle, _originGlobal, size);
      final particleSize = 28 + rnd.nextDouble() * 10;
      final spinSpeed = (rnd.nextDouble() * 2 * pi) * (rnd.nextBool() ? 1 : -1);
      _particles.add(_Particle(
        angle: angle,
        maxDistance: dist,
        size: particleSize,
        spinSpeed: spinSpeed,
        start: creationTime,
      ));
    }

    _insertOrUpdateOverlay();
  }

  double _distanceToEdge(double angle, Offset origin, Size screenSize) {
    final dx = cos(angle);
    final dy = sin(angle);

    // t где луч достигнет соответствующей границы
    final candidates = <double>[];

    if (dx > 0) {
      candidates.add((screenSize.width - origin.dx) / dx);
    } else if (dx < 0) {
      candidates.add((0 - origin.dx) / dx);
    }

    if (dy > 0) {
      candidates.add((screenSize.height - origin.dy) / dy);
    } else if (dy < 0) {
      candidates.add((0 - origin.dy) / dy);
    }

    // берем минимальное положительное
    final positive = candidates.where((t) => t > 0).toList();
    return positive.isEmpty ? 0 : positive.reduce(min);
  }

  void _insertOrUpdateOverlay() {
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(builder: (context) {
        return IgnorePointer(
          ignoring: true,
          child: Stack(
            fit: StackFit.expand,
            children: [
              for (final p in _particles) _particleWidget(p),
            ],
          ),
        );
      });
      Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
    } else {
      _overlayEntry!.markNeedsBuild();
    }
  }

  void _removeFinishedParticles() {
    final now = _controller.lastElapsedDuration ?? Duration.zero;
    _particles.removeWhere((p) {
      final elapsedMs = (now - p.start).inMilliseconds;
      if (elapsedMs < 0) return false;
      final traveled = _speed * (elapsedMs / 1000.0);
      return traveled >= p.maxDistance;
    });
  }

  Widget _particleWidget(_Particle p) {
    final now = _controller.lastElapsedDuration ?? Duration.zero;
    final elapsed = now - p.start;
    if (elapsed.isNegative) return const SizedBox.shrink();

    final traveled = (_speed * (elapsed.inMilliseconds / 1000.0)).clamp(0, p.maxDistance);
    final double ratio = p.maxDistance == 0 ? 0 : traveled / p.maxDistance;

    final dx = cos(p.angle) * traveled;
    final dy = sin(p.angle) * traveled;

    final scale = 0.3 + 0.7 * Curves.easeOut.transform(ratio);
    double opacity = 1.0;
    if (ratio > 0.95) {
      opacity = (1 - (ratio - 0.95) / 0.05).clamp(0.0, 1.0);
    }

    final currentSize = p.size * scale;
    final rotation = p.spinSpeed * ratio;

    return Positioned(
      left: _originGlobal.dx + dx - currentSize / 2,
      top: _originGlobal.dy + dy - currentSize / 2,
      child: Opacity(
        opacity: opacity,
        child: Transform.rotate(
          angle: rotation,
          child: Image.asset(
            'assets/images/berryrose.png',
            width: currentSize,
            height: currentSize,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // частицы поверх AppBar через Overlay
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              key: _buttonKey,
              onTap: _incrementCounter,
              // child: GlassDrop(
              //   size: 140,
              //   // сюда можно вставлять gif / jpg / png / анимированный виджет
              //   child: Image.asset(
              //     'assets/images/white.gif', // или gif
              //     fit: BoxFit.cover,
              //   ),
              // ),
              child: GifGlassAvatar(
                gifAsset: 'assets/images/Mkj9.gif',
                size: 200,
              ),
              // child: LiquidAvatar(
              //   gifPath: 'assets/images/white.gif',
              //   size: 140,
              // ),

            ),
            const SizedBox(height: 24),
            const Text('Бананов нафармлено:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _Particle {
  final double angle;
  final double maxDistance;
  final double size;
  final double spinSpeed;
  final Duration start; // момент создания (от контроллера)
  _Particle({
    required this.angle,
    required this.maxDistance,
    required this.size,
    required this.spinSpeed,
    required this.start,
  });
}
