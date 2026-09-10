import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../components/auto_typing_pin.dart';
import '../components/feature_chip.dart';
import '../components/gradient_text.dart';
import '../layout/responsive.dart';
import '../theme/app_theme.dart';

/// Hero section with animated gradient background and auto-typing PIN.
class HeroSection extends StatefulWidget {
  const HeroSection({
    super.key,
    required this.onExplore,
    required this.onPubDev,
  });

  final VoidCallback onExplore;
  final VoidCallback onPubDev;

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bp = getBreakpoint(context);
    final screenHeight = MediaQuery.sizeOf(context).height;

    return SizedBox(
      height: screenHeight,
      child: Stack(
        children: [
          // Animated gradient background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bgController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _HeroBgPainter(
                    animation: _bgController.value,
                    isDark: Theme.of(context).brightness == Brightness.dark,
                  ),
                );
              },
            ),
          ),

          // Floating orbs
          ..._buildOrbs(screenHeight),

          // Content
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: bp == Breakpoint.mobile ? 24 : 64,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  GradientText(
                    'pin_code_fields',
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF818CF8),
                        Color(0xFFC084FC),
                        Color(0xFFFB7185),
                      ],
                    ),
                    style: TextStyle(
                      fontSize: switch (bp) {
                        Breakpoint.desktop => 72,
                        Breakpoint.tablet => 56,
                        Breakpoint.mobile => 40,
                      },
                      fontWeight: FontWeight.w800,
                      letterSpacing: -2,
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Subtitle
                  Text(
                    'The Flutter PIN input ecosystem',
                    style: TextStyle(
                      fontSize: bp == Breakpoint.mobile ? 18 : 22,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Version badges
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: const [
                      FeatureChip(label: 'v9.0.0', color: Color(0xFF10B981)),
                      FeatureChip(
                        label: 'Headless Core',
                        color: Color(0xFF6366F1),
                      ),
                      FeatureChip(
                        label: 'Material Design',
                        color: Color(0xFF8B5CF6),
                      ),
                      FeatureChip(
                        label: 'Liquid Glass',
                        color: Color(0xFFEC4899),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),

                  // Auto-typing PIN
                  SizedBox(
                    width: 400,
                    child: AutoTypingPin(
                      length: 6,
                      theme: MaterialPinTheme(
                        shape: MaterialPinShape.outlined,
                        cellSize: Size(
                          bp == Breakpoint.mobile ? 44 : 56,
                          bp == Breakpoint.mobile ? 52 : 64,
                        ),
                        borderColor: const Color(0xFF4A4A5E),
                        focusedBorderColor: const Color(0xFF818CF8),
                        fillColor: Colors.white.withValues(alpha: 0.05),
                        focusedFillColor: const Color(
                          0xFF6366F1,
                        ).withValues(alpha: 0.1),
                        textStyle: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        cursorColor: const Color(0xFF818CF8),
                        entryAnimation: MaterialPinAnimation.scale,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // CTA buttons
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      _CtaButton(
                        label: 'Explore',
                        onTap: widget.onExplore,
                        isPrimary: true,
                      ),
                      _CtaButton(
                        label: 'pub.dev',
                        onTap: widget.onPubDev,
                        isPrimary: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildOrbs(double screenHeight) {
    return [
      _FloatingOrb(
        controller: _bgController,
        left: -60,
        top: screenHeight * 0.2,
        size: 200,
        color: BrandColors.indigo.withValues(alpha: 0.15),
        speed: 0.7,
      ),
      _FloatingOrb(
        controller: _bgController,
        right: -40,
        top: screenHeight * 0.1,
        size: 160,
        color: BrandColors.purple.withValues(alpha: 0.12),
        speed: 0.5,
      ),
      _FloatingOrb(
        controller: _bgController,
        left: 100,
        bottom: screenHeight * 0.15,
        size: 120,
        color: BrandColors.pink.withValues(alpha: 0.1),
        speed: 0.9,
      ),
    ];
  }
}

class _FloatingOrb extends StatelessWidget {
  const _FloatingOrb({
    required this.controller,
    this.left,
    this.right,
    this.top,
    this.bottom,
    required this.size,
    required this.color,
    required this.speed,
  });

  final AnimationController controller;
  final double? left, right, top, bottom;
  final double size;
  final Color color;
  final double speed;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final offset = math.sin(controller.value * 2 * math.pi * speed) * 20;
        return Positioned(
          left: left != null ? left! + offset : null,
          right: right != null ? right! - offset : null,
          top: top != null ? top! + offset * 0.5 : null,
          bottom: bottom != null ? bottom! - offset * 0.5 : null,
          child: child!,
        );
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
        ),
      ),
    );
  }
}

class _HeroBgPainter extends CustomPainter {
  _HeroBgPainter({required this.animation, required this.isDark});

  final double animation;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Dark gradient background
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [
              const Color(0xFF0F0F1A),
              const Color(0xFF1E1B4B),
              const Color(0xFF0F0F1A),
            ]
          : [
              const Color(0xFFF0F0FF),
              const Color(0xFFE8E0FF),
              const Color(0xFFF8F0FF),
            ],
    );

    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
  }

  @override
  bool shouldRepaint(_HeroBgPainter oldDelegate) =>
      oldDelegate.animation != animation || oldDelegate.isDark != isDark;
}

class _CtaButton extends StatefulWidget {
  const _CtaButton({
    required this.label,
    required this.onTap,
    required this.isPrimary,
  });

  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  State<_CtaButton> createState() => _CtaButtonState();
}

class _CtaButtonState extends State<_CtaButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          decoration: BoxDecoration(
            gradient: widget.isPrimary
                ? const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  )
                : null,
            color: widget.isPrimary
                ? null
                : Colors.white.withValues(alpha: _hovered ? 0.15 : 0.1),
            borderRadius: BorderRadius.circular(12),
            border: widget.isPrimary
                ? null
                : Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          transform: _hovered
              ? Matrix4.diagonal3Values(1.03, 1.03, 1.0)
              : Matrix4.identity(),
          transformAlignment: Alignment.center,
          child: Text(
            widget.label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
