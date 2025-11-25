import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:banana/gif_glass_avatar_skip2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glass Ball',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontFamily: 'SF Pro Text',
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final featuredItems = [
      (
        title: 'Non-fiction\nsummaries',
        subtitle:
            'Get detailed outlines of popular non-fiction books to help you learn faster.',
        asset: 'assets/images/Mkj9.gif',
      ),
      (
        title: 'Travel bucket\nlist',
        subtitle:
            'Keep track of places to visit and dreams to make real on your journeys.',
        asset: 'assets/images/7fWj.gif',
      ),
      (
        title: 'Daily\nreflections',
        subtitle:
            'Build a habit of mindful journaling and track your emotional state.',
        asset: 'assets/images/747m.gif',
      ),
    ];

    final chips = [
      'Lifestyle',
      'Health & Fitness',
      'Mindfulness',
      'Cooking',
      'Productivity',
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------- Featured ----------
              const Text(
                'Featured',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 360,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: featuredItems.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final item = featuredItems[index];
                    return _FeaturedCard(
                      title: item.title,
                      subtitle: item.subtitle,
                      gifAsset: item.asset,
                    );
                  },
                ),
              ),

              const SizedBox(height: 28),

              // -------- Invites ----------
              const Text(
                'Invites',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 12),
              const _InvitesCard(),

              const SizedBox(height: 28),

              // -------- Popular ----------
              const Text(
                'Popular',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (int i = 0; i < chips.length; i++)
                    _CategoryChip(
                      label: chips[i],
                      selected: i == 1, // как на скрине — второй выделен
                    ),
                ],
              ),
              const SizedBox(height: 24),
              _SimplePopularCard(
                title: 'Mood tracker',
                subtitle:
                    'Track your moods, habits, log sets, and more to keep balance.',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const _GlassBottomBar(),
    );
  }
}

// ===== Featured Card =====

class _FeaturedCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String gifAsset;

  const _FeaturedCard({
    required this.title,
    required this.subtitle,
    required this.gifAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: GifGlassAvatar(
              gifAsset: gifAsset,
              size: 200,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.1,
              color: Color(0xFF105720),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              height: 1.35,
              color: Colors.black.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

// ===== Invites Card =====

class _InvitesCard extends StatelessWidget {
  const _InvitesCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "You've got 1 Invite!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Great apps start with great people. Invite friends with taste who can help improve Wabi.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          // Маленькие круглые аватарки-шары
          SizedBox(
            width: 76,
            child: Stack(
              children: [
                Positioned(
                  left: 22,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      GifGlassAvatar(
                        gifAsset: 'assets/images/Mkj9.gif',
                        size: 42,
                      ),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            '+',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ===== Chip =====

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _CategoryChip({
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? Colors.black : Colors.white;
    final fg = selected ? Colors.white : Colors.black87;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
        border: selected
            ? null
            : Border.all(
                color: Colors.black.withOpacity(0.08),
              ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

// ===== Popular Card (простая) =====

class _SimplePopularCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SimplePopularCard({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          GifGlassAvatar(
            gifAsset: 'assets/images/Mkj9.gif',
            size: 60,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

// ===== Glass Bottom Bar =====

class _GlassBottomBar extends StatelessWidget {
  const _GlassBottomBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 4),
                Expanded(
                  child: _BottomTabButton(
                    label: 'Home',
                    selected: true,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _BottomTabButton(
                    label: 'Explore',
                    selected: false,
                  ),
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomTabButton extends StatelessWidget {
  final String label;
  final bool selected;

  const _BottomTabButton({
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? Colors.white : Colors.transparent;
    final fg = selected ? Colors.black : Colors.black.withOpacity(0.6);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: fg,
          ),
        ),
      ),
    );
  }
}
