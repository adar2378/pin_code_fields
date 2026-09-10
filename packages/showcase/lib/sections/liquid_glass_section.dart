import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields_liquid_glass/pin_code_fields_liquid_glass.dart';

import '../components/code_block.dart';
import '../components/section_title.dart';
import '../layout/responsive.dart';
import '../layout/section_wrapper.dart';

/// Liquid Glass section with live LiquidGlassPinField demos.
class LiquidGlassSection extends StatelessWidget {
  const LiquidGlassSection({super.key, this.sectionKey});

  final GlobalKey? sectionKey;

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      sectionKey: sectionKey,
      enableFadeIn: false,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF0A0A14)
          : const Color(0xFFF0F0FF),
      child: Column(
        children: [
          const SectionTitle(
            title: 'Liquid Glass',
            subtitle: 'iOS 26 aesthetic for Flutter',
          ),
          const SizedBox(height: 40),
          ResponsiveGrid(
            desktopColumns: 3,
            tabletColumns: 3,
            mobileColumns: 1,
            children: const [
              _GlassStyleCard(
                title: 'Separate',
                description: 'Individual glass cells with spacing',
                style: _GlassStyle.separate,
              ),
              _GlassStyleCard(
                title: 'Unified',
                description: 'One glass container with dividers',
                style: _GlassStyle.unified,
              ),
              _GlassStyleCard(
                title: 'Blended',
                description: 'Cells blend together — iOS 26 style',
                style: _GlassStyle.blended,
              ),
            ],
          ),
          const SizedBox(height: 40),
          const CodeBlock(
            code:
                '''import 'package:pin_code_fields_liquid_glass/pin_code_fields_liquid_glass.dart';

LiquidGlassPinField(
  length: 6,
  theme: LiquidGlassPinTheme.blended(
    blur: 10,
    glassColor: Colors.white.withOpacity(0.2),
    borderRadius: 12,
  ),
  onCompleted: (pin) => print('PIN: \$pin'),
)''',
          ),
        ],
      ),
    );
  }
}

enum _GlassStyle { separate, unified, blended }

class _GlassStyleCard extends StatefulWidget {
  const _GlassStyleCard({
    required this.title,
    required this.description,
    required this.style,
  });

  final String title;
  final String description;
  final _GlassStyle style;

  @override
  State<_GlassStyleCard> createState() => _GlassStyleCardState();
}

class _GlassStyleCardState extends State<_GlassStyleCard> {
  final _controller = PinInputController();
  bool _hovered = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  LiquidGlassPinTheme get _theme {
    switch (widget.style) {
      case _GlassStyle.separate:
        return LiquidGlassPinTheme.separate(
          blur: 10,
          borderRadius: 12,
          cellSize: const Size(44, 56),
        );
      case _GlassStyle.unified:
        return LiquidGlassPinTheme.unified(
          blur: 10,
          containerBorderRadius: 16,
          cellSize: const Size(44, 56),
        );
      case _GlassStyle.blended:
        return LiquidGlassPinTheme.blended(
          blur: 10,
          borderRadius: 12,
          cellSize: const Size(44, 56),
        );
    }
  }

  List<Color> get _gradientColors {
    switch (widget.style) {
      case _GlassStyle.separate:
        return const [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFA78BFA)];
      case _GlassStyle.unified:
        return const [Color(0xFFEC4899), Color(0xFFF472B6), Color(0xFFFDA4AF)];
      case _GlassStyle.blended:
        return const [Color(0xFF06B6D4), Color(0xFF8B5CF6), Color(0xFFEC4899)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: _gradientColors[0].withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            // Vibrant gradient background
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _gradientColors,
                  ),
                ),
              ),
            ),
            // Decorative circles for visual interest
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: -10,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // pin_code_fields_liquid_glass still uses SDK
                  // flutter/material, so bridge the material_ui theme to it.
                  // ignore: deprecated_member_use
                  MaterialUiCompatibilityBridge(
                    child: LiquidGlassPinField(
                      length: 4,
                      pinController: _controller,
                      theme: _theme,
                      enableHapticFeedback: false,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.title,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.description,
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
