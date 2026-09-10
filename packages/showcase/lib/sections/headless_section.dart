import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../components/demo_card.dart';
import '../components/section_title.dart';
import '../layout/section_wrapper.dart';

/// Headless builder section with 3 creative demos.
class HeadlessSection extends StatefulWidget {
  const HeadlessSection({super.key, this.sectionKey});

  final GlobalKey? sectionKey;

  @override
  State<HeadlessSection> createState() => _HeadlessSectionState();
}

class _HeadlessSectionState extends State<HeadlessSection> {
  final _ctrl1 = PinInputController();
  final _ctrl2 = PinInputController();
  final _ctrl3 = PinInputController();

  @override
  void dispose() {
    _ctrl1.dispose();
    _ctrl2.dispose();
    _ctrl3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      sectionKey: widget.sectionKey,
      child: Column(
        children: [
          const SectionTitle(
            title: 'Build Any Design',
            subtitle: 'PinInput gives you data. You give it pixels.',
          ),
          DemoCard(
            title: 'Bouncing Focus',
            demo: _BouncingFocusDemo(controller: _ctrl1),
            code: '''PinInput(
  length: 4,
  builder: (context, cells) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: cells.map((cell) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: 64, height: 72,
          margin: EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            gradient: cell.isFilled
                ? LinearGradient(colors: [primary, secondary])
                : null,
            color: cell.isFilled ? null : surfaceColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(cell.character ?? ''),
          ),
        );
      }).toList(),
    );
  },
)''',
          ),
          const SizedBox(height: 32),
          DemoCard(
            title: 'Glow Wave',
            demo: _GlowWaveDemo(controller: _ctrl2),
            code: '''PinInput(
  length: 6,
  builder: (context, cells) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: cells.map((cell) {
        final progress = cell.index / (cells.length - 1);
        final color = Color.lerp(indigo, pink, progress)!;
        return Container(
          width: 48, height: 56,
          decoration: BoxDecoration(
            color: cell.isFilled ? color : surfaceColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: cell.isFilled ? [
              BoxShadow(color: color.withOpacity(0.4),
                blurRadius: 12, spreadRadius: 2),
            ] : null,
          ),
          child: Center(
            child: Text(cell.character ?? ''),
          ),
        );
      }).toList(),
    );
  },
)''',
          ),
          const SizedBox(height: 32),
          DemoCard(
            title: 'Morphing Cells',
            demo: _MorphingDemo(controller: _ctrl3),
            code: '''PinInput(
  length: 5,
  builder: (context, cells) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: cells.map((cell) {
        return TweenAnimationBuilder<double>(
          tween: Tween(
            begin: cell.isFilled ? 0.0 : 1.0,
            end: cell.isFilled ? 1.0 : 0.0),
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            final borderRadius = 12 + 16 * value;
            return Container(
              width: 56 + 8 * value,
              height: 56 + 8 * value,
              decoration: BoxDecoration(
                gradient: cell.isFilled
                  ? LinearGradient(colors: [emerald, teal])
                  : null,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            );
          },
        );
      }).toList(),
    );
  },
)''',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// BOUNCING FOCUS
// ============================================================

class _BouncingFocusDemo extends StatelessWidget {
  const _BouncingFocusDemo({required this.controller});

  final PinInputController controller;

  @override
  Widget build(BuildContext context) {
    return PinInput(
      length: 4,
      pinController: controller,
      builder: (context, cells) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: cells.map((cell) => _BouncingCell(cell: cell)).toList(),
        );
      },
      onCompleted: (_) {},
    );
  }
}

class _BouncingCell extends StatefulWidget {
  const _BouncingCell({required this.cell});
  final PinCellData cell;

  @override
  State<_BouncingCell> createState() => _BouncingCellState();
}

class _BouncingCellState extends State<_BouncingCell>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _bounceAnim = Tween<double>(
      begin: 0,
      end: -8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(_BouncingCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cell.isFocused && !oldWidget.cell.isFocused) {
      _controller.repeat(reverse: true);
    } else if (!widget.cell.isFocused && oldWidget.cell.isFocused) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, widget.cell.isFocused ? _bounceAnim.value : 0),
          child: Transform.scale(
            scale: widget.cell.isFocused ? _scaleAnim.value : 1.0,
            child: child,
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 64,
        height: 72,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          gradient: widget.cell.isFilled
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [colorScheme.primary, colorScheme.secondary],
                )
              : null,
          color: widget.cell.isFilled ? null : const Color(0xFF1E1E2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.cell.isFocused
                ? colorScheme.primary
                : const Color(0xFF3A3A4E),
            width: 2,
          ),
          boxShadow: widget.cell.isFocused
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.4),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: widget.cell.isFilled
              ? Text(
                  widget.cell.character!,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              : widget.cell.isFocused
              ? _BlinkingCursor()
              : null,
        ),
      ),
    );
  }
}

class _BlinkingCursor extends StatefulWidget {
  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 2,
        height: 32,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }
}

// ============================================================
// GLOW WAVE
// ============================================================

class _GlowWaveDemo extends StatelessWidget {
  const _GlowWaveDemo({required this.controller});
  final PinInputController controller;

  @override
  Widget build(BuildContext context) {
    return PinInput(
      length: 6,
      pinController: controller,
      builder: (context, cells) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: cells
              .map(
                (cell) => _GlowWaveCell(cell: cell, totalCells: cells.length),
              )
              .toList(),
        );
      },
      onCompleted: (_) {},
    );
  }
}

class _GlowWaveCell extends StatefulWidget {
  const _GlowWaveCell({required this.cell, required this.totalCells});
  final PinCellData cell;
  final int totalCells;

  @override
  State<_GlowWaveCell> createState() => _GlowWaveCellState();
}

class _GlowWaveCellState extends State<_GlowWaveCell>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _glowAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(_GlowWaveCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cell.wasJustEntered) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progress = widget.cell.index / (widget.totalCells - 1);
    final cellColor = Color.lerp(
      const Color(0xFF6366F1),
      const Color(0xFFEC4899),
      progress,
    )!;

    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (context, child) {
        final glowIntensity = _glowAnim.value;
        return Container(
          width: 48,
          height: 56,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: widget.cell.isFilled
                ? cellColor
                : colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.cell.isFocused
                  ? cellColor
                  : colorScheme.outlineVariant,
              width: widget.cell.isFocused ? 2 : 1,
            ),
            boxShadow: widget.cell.isFilled
                ? [
                    BoxShadow(
                      color: cellColor.withValues(
                        alpha: 0.3 + 0.4 * glowIntensity,
                      ),
                      blurRadius: 8 + 12 * glowIntensity,
                      spreadRadius: 1 + 3 * glowIntensity,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: widget.cell.isFilled
                ? TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.5, end: 1.0),
                    duration: const Duration(milliseconds: 150),
                    builder: (context, value, _) {
                      return Transform.scale(
                        scale: value,
                        child: Text(
                          widget.cell.character!,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  )
                : null,
          ),
        );
      },
    );
  }
}

// ============================================================
// MORPHING CELLS
// ============================================================

class _MorphingDemo extends StatelessWidget {
  const _MorphingDemo({required this.controller});
  final PinInputController controller;

  @override
  Widget build(BuildContext context) {
    return PinInput(
      length: 5,
      pinController: controller,
      builder: (context, cells) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: cells.map((cell) => _MorphingCell(cell: cell)).toList(),
        );
      },
      onCompleted: (_) {},
    );
  }
}

class _MorphingCell extends StatelessWidget {
  const _MorphingCell({required this.cell});
  final PinCellData cell;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: cell.isFilled ? 0.0 : 1.0,
        end: cell.isFilled ? 1.0 : 0.0,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      builder: (context, value, _) {
        final size = 56 + 8 * value;
        final borderRadius = 12 + 16 * value;
        return Container(
          width: size,
          height: size,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            gradient: cell.isFilled
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                  )
                : null,
            color: cell.isFilled ? null : colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: cell.isFocused
                  ? const Color(0xFF10B981)
                  : cell.isFilled
                  ? Colors.transparent
                  : colorScheme.outlineVariant,
              width: 2,
            ),
            boxShadow: cell.isFilled
                ? [
                    BoxShadow(
                      color: const Color(0xFF10B981).withValues(alpha: 0.4),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: cell.isFilled
                ? Transform.scale(
                    scale: 0.8 + 0.2 * value,
                    child: Text(
                      cell.character!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                : cell.isFocused
                ? const Icon(Icons.edit, color: Color(0xFF10B981), size: 20)
                : Text(
                    '${cell.index + 1}',
                    style: TextStyle(
                      color: colorScheme.outline,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
