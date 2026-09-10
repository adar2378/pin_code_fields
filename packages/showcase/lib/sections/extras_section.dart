import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../components/section_title.dart';
import '../layout/responsive.dart';
import '../layout/section_wrapper.dart';

/// Showcases shadows/neumorphism, text gradients, and custom animations.
class ExtrasSection extends StatelessWidget {
  const ExtrasSection({super.key, this.sectionKey});

  final GlobalKey? sectionKey;

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      sectionKey: sectionKey,
      child: Column(
        children: [
          const SectionTitle(
            title: 'More Features',
            subtitle: 'Shadows, gradients, custom animations & more',
          ),
          ResponsiveGrid(
            desktopColumns: 3,
            tabletColumns: 2,
            mobileColumns: 1,
            children: const [
              _NeumorphismDemo(),
              _FocusGlowDemo(),
              _ElevationDemo(),
              _RainbowGradientDemo(),
              _GoldGradientDemo(),
              _CustomAnimationDemo(),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// NEUMORPHISM
// ============================================================

class _NeumorphismDemo extends StatefulWidget {
  const _NeumorphismDemo();

  @override
  State<_NeumorphismDemo> createState() => _NeumorphismDemoState();
}

class _NeumorphismDemoState extends State<_NeumorphismDemo> {
  final _controller = PinInputController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1A1A2E) : const Color(0xFFE8E8F0);

    return _DemoCard(
      title: 'Neumorphism',
      description: 'Soft UI with dual shadows',
      backgroundColor: bgColor,
      child: MaterialPinField(
        length: 4,
        pinController: _controller,
        theme: MaterialPinTheme(
          shape: MaterialPinShape.filled,
          cellSize: const Size(48, 56),
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          fillColor: bgColor,
          borderColor: Colors.transparent,
          boxShadows: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.4)
                  : Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(4, 4),
            ),
            BoxShadow(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.white.withValues(alpha: 0.8),
              blurRadius: 10,
              offset: const Offset(-4, -4),
            ),
          ],
          focusedBoxShadows: [
            BoxShadow(
              color: const Color(
                0xFF6366F1,
              ).withValues(alpha: isDark ? 0.3 : 0.2),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        enableHapticFeedback: false,
      ),
    );
  }
}

// ============================================================
// FOCUS GLOW
// ============================================================

class _FocusGlowDemo extends StatefulWidget {
  const _FocusGlowDemo();

  @override
  State<_FocusGlowDemo> createState() => _FocusGlowDemoState();
}

class _FocusGlowDemoState extends State<_FocusGlowDemo> {
  final _controller = PinInputController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return _DemoCard(
      title: 'Focus Glow',
      description: 'Glowing shadow on active cell',
      child: MaterialPinField(
        length: 4,
        pinController: _controller,
        theme: MaterialPinTheme(
          shape: MaterialPinShape.outlined,
          cellSize: const Size(48, 56),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          focusedBorderColor: colorScheme.primary,
          focusedBoxShadows: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.4),
              blurRadius: 14,
              spreadRadius: 2,
            ),
          ],
        ),
        enableHapticFeedback: false,
      ),
    );
  }
}

// ============================================================
// ELEVATION
// ============================================================

class _ElevationDemo extends StatefulWidget {
  const _ElevationDemo();

  @override
  State<_ElevationDemo> createState() => _ElevationDemoState();
}

class _ElevationDemoState extends State<_ElevationDemo> {
  final _controller = PinInputController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      title: 'Material Elevation',
      description: 'Card-like lift on focus',
      child: MaterialPinField(
        length: 4,
        pinController: _controller,
        theme: MaterialPinTheme(
          shape: MaterialPinShape.filled,
          cellSize: const Size(48, 56),
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          fillColor: Theme.of(context).colorScheme.surface,
          elevation: 2,
          focusedElevation: 8,
          focusedFillColor: Theme.of(context).colorScheme.surface,
        ),
        enableHapticFeedback: false,
      ),
    );
  }
}

// ============================================================
// RAINBOW GRADIENT
// ============================================================

class _RainbowGradientDemo extends StatefulWidget {
  const _RainbowGradientDemo();

  @override
  State<_RainbowGradientDemo> createState() => _RainbowGradientDemoState();
}

class _RainbowGradientDemoState extends State<_RainbowGradientDemo> {
  final _controller = PinInputController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      title: 'Rainbow Text',
      description: 'Gradient applied to PIN digits',
      child: MaterialPinField(
        length: 4,
        pinController: _controller,
        theme: const MaterialPinTheme(
          shape: MaterialPinShape.outlined,
          cellSize: Size(48, 56),
          borderRadius: BorderRadius.all(Radius.circular(12)),
          textGradient: LinearGradient(
            colors: [
              Colors.red,
              Colors.orange,
              Colors.green,
              Colors.blue,
              Colors.purple,
            ],
          ),
        ),
        enableHapticFeedback: false,
      ),
    );
  }
}

// ============================================================
// GOLD GRADIENT
// ============================================================

class _GoldGradientDemo extends StatefulWidget {
  const _GoldGradientDemo();

  @override
  State<_GoldGradientDemo> createState() => _GoldGradientDemoState();
}

class _GoldGradientDemoState extends State<_GoldGradientDemo> {
  final _controller = PinInputController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      title: 'Gold Text',
      description: 'Premium gold gradient effect',
      child: MaterialPinField(
        length: 4,
        pinController: _controller,
        theme: MaterialPinTheme(
          shape: MaterialPinShape.outlined,
          cellSize: const Size(48, 56),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderColor: Colors.amber.shade300,
          focusedBorderColor: Colors.amber.shade600,
          textGradient: const LinearGradient(
            colors: [Color(0xFFD4AF37), Color(0xFFF5E7A3), Color(0xFFD4AF37)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        enableHapticFeedback: false,
      ),
    );
  }
}

// ============================================================
// CUSTOM ANIMATION
// ============================================================

class _CustomAnimationDemo extends StatefulWidget {
  const _CustomAnimationDemo();

  @override
  State<_CustomAnimationDemo> createState() => _CustomAnimationDemoState();
}

class _CustomAnimationDemoState extends State<_CustomAnimationDemo> {
  final _controller = PinInputController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      title: 'Custom Animation',
      description: 'Rotation + fade entry effect',
      child: MaterialPinField(
        length: 4,
        pinController: _controller,
        theme: MaterialPinTheme(
          shape: MaterialPinShape.outlined,
          cellSize: const Size(48, 56),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          entryAnimation: MaterialPinAnimation.custom,
          customEntryAnimationBuilder: (child, animation) {
            return RotationTransition(
              turns: Tween<double>(begin: 0.5, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
              ),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          animationDuration: const Duration(milliseconds: 400),
        ),
        enableHapticFeedback: false,
      ),
    );
  }
}

// ============================================================
// SHARED DEMO CARD
// ============================================================

class _DemoCard extends StatefulWidget {
  const _DemoCard({
    required this.title,
    required this.description,
    required this.child,
    this.backgroundColor,
  });

  final String title;
  final String description;
  final Widget child;
  final Color? backgroundColor;

  @override
  State<_DemoCard> createState() => _DemoCardState();
}

class _DemoCardState extends State<_DemoCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color:
              widget.backgroundColor ??
              (isDark ? const Color(0xFF1A1A2E) : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF2A2A3E) : const Color(0xFFE5E7EB),
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            widget.child,
            const SizedBox(height: 16),
            Text(
              widget.title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              widget.description,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white54 : const Color(0xFF9CA3AF),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
