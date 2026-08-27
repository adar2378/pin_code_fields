import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// Creative Cell Animations - Showcase headless architecture flexibility
///
/// Demonstrates:
/// - Per-cell animations based on state
/// - Animated focus indicators
/// - Entry animations when characters are typed
/// - Custom animated cursors
/// - Wave/ripple effects
class CreativeCellAnimationsDemo extends StatefulWidget {
  const CreativeCellAnimationsDemo({super.key});

  @override
  State<CreativeCellAnimationsDemo> createState() =>
      _CreativeCellAnimationsDemoState();
}

class _CreativeCellAnimationsDemoState
    extends State<CreativeCellAnimationsDemo> {
  final _controller1 = PinInputController();
  final _controller2 = PinInputController();
  final _controller3 = PinInputController();
  final _controller4 = PinInputController();

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creative Animations'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader(
            context,
            'Bouncing Focus',
            'Focused cell bounces to attract attention',
          ),
          const SizedBox(height: 16),
          _BouncingFocusExample(controller: _controller1),
          const SizedBox(height: 48),
          _buildSectionHeader(
            context,
            'Glow Wave',
            'Glow ripples through cells on input',
          ),
          const SizedBox(height: 16),
          _GlowWaveExample(controller: _controller2),
          const SizedBox(height: 48),
          _buildSectionHeader(
            context,
            'Flip Entry',
            'Characters flip in with 3D effect',
          ),
          const SizedBox(height: 16),
          _FlipEntryExample(controller: _controller3),
          const SizedBox(height: 48),
          _buildSectionHeader(
            context,
            'Morphing Cells',
            'Cells morph shape when filled',
          ),
          const SizedBox(height: 16),
          _MorphingCellsExample(controller: _controller4),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// BOUNCING FOCUS EXAMPLE
// =============================================================================

class _BouncingFocusExample extends StatelessWidget {
  const _BouncingFocusExample({required this.controller});

  final PinInputController controller;

  @override
  Widget build(BuildContext context) {
    return PinInput(
      length: 4,
      pinController: controller,
      builder: (context, cells) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: cells.map((cell) {
            return _BouncingCell(cell: cell);
          }).toList(),
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
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _bounceAnimation = Tween<double>(begin: 0, end: -8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
          offset: Offset(0, widget.cell.isFocused ? _bounceAnimation.value : 0),
          child: Transform.scale(
            scale: widget.cell.isFocused ? _scaleAnimation.value : 1.0,
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
                  colors: [
                    colorScheme.primary,
                    colorScheme.secondary,
                  ],
                )
              : null,
          color: widget.cell.isFilled ? null : colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.cell.isFocused
                ? colorScheme.primary
                : Colors.transparent,
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
                  ? _AnimatedCursor()
                  : null,
        ),
      ),
    );
  }
}

class _AnimatedCursor extends StatefulWidget {
  @override
  State<_AnimatedCursor> createState() => _AnimatedCursorState();
}

class _AnimatedCursorState extends State<_AnimatedCursor>
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

// =============================================================================
// GLOW WAVE EXAMPLE
// =============================================================================

class _GlowWaveExample extends StatelessWidget {
  const _GlowWaveExample({required this.controller});

  final PinInputController controller;

  @override
  Widget build(BuildContext context) {
    return PinInput(
      length: 6,
      pinController: controller,
      builder: (context, cells) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: cells.map((cell) {
            return _GlowWaveCell(cell: cell, totalCells: cells.length);
          }).toList(),
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
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _glowAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
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
      animation: _glowAnimation,
      builder: (context, child) {
        final glowIntensity = _glowAnimation.value;
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
                          alpha: 0.3 + 0.4 * glowIntensity),
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
                    builder: (context, value, child) {
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

// =============================================================================
// FLIP ENTRY EXAMPLE
// =============================================================================

class _FlipEntryExample extends StatelessWidget {
  const _FlipEntryExample({required this.controller});

  final PinInputController controller;

  @override
  Widget build(BuildContext context) {
    return PinInput(
      length: 4,
      pinController: controller,
      builder: (context, cells) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: cells.map((cell) {
            return _FlipCell(cell: cell);
          }).toList(),
        );
      },
      onCompleted: (_) {},
    );
  }
}

class _FlipCell extends StatefulWidget {
  const _FlipCell({required this.cell});

  final PinCellData cell;

  @override
  State<_FlipCell> createState() => _FlipCellState();
}

class _FlipCellState extends State<_FlipCell>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;
  String? _displayChar;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _displayChar = widget.cell.character;
  }

  @override
  void didUpdateWidget(_FlipCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cell.wasJustEntered) {
      _displayChar = null;
      _controller.forward(from: 0).then((_) {
        if (mounted) {
          setState(() => _displayChar = widget.cell.character);
        }
      });
    } else if (widget.cell.character != oldWidget.cell.character) {
      _displayChar = widget.cell.character;
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
      animation: _flipAnimation,
      builder: (context, child) {
        final angle = _flipAnimation.value * 3.14159;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          child: child,
        );
      },
      child: Container(
        width: 64,
        height: 72,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          gradient: widget.cell.isFilled
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E1E2E), Color(0xFF2D2D44)],
                )
              : null,
          color:
              widget.cell.isFilled ? null : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.cell.isFocused
                ? const Color(0xFF6366F1)
                : widget.cell.isFilled
                    ? const Color(0xFF6366F1).withValues(alpha: 0.5)
                    : colorScheme.outlineVariant,
            width: 2,
          ),
          boxShadow: widget.cell.isFilled
              ? [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: _displayChar != null
              ? Text(
                  _displayChar!,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              : widget.cell.isFocused
                  ? Container(
                      width: 2,
                      height: 28,
                      color: const Color(0xFF6366F1),
                    )
                  : null,
        ),
      ),
    );
  }
}

// =============================================================================
// MORPHING CELLS EXAMPLE
// =============================================================================

class _MorphingCellsExample extends StatelessWidget {
  const _MorphingCellsExample({required this.controller});

  final PinInputController controller;

  @override
  Widget build(BuildContext context) {
    return PinInput(
      length: 5,
      pinController: controller,
      builder: (context, cells) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: cells.map((cell) {
            return _MorphingCell(cell: cell);
          }).toList(),
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
      builder: (context, value, child) {
        final size = 56 + 8 * value;
        final borderRadius = 12 + 16 * value; // Square to circle

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
                    ? const Icon(
                        Icons.edit,
                        color: Color(0xFF10B981),
                        size: 20,
                      )
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
