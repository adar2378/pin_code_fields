import 'package:material_ui/material_ui.dart';

/// A widget that displays a blinking cursor.
///
/// The cursor blinks by animating its opacity from 0 to 1.
class CursorBlink extends StatefulWidget {
  const CursorBlink({
    super.key,
    this.color,
    this.width,
    this.height,
    this.animate = true,
    this.duration = const Duration(milliseconds: 500),
    this.child,
  }) : assert(
          child != null || (color != null && width != null && height != null),
          'Either child must be provided, or color, width, and height must all be provided',
        );

  /// The color of the cursor (used when [child] is null).
  final Color? color;

  /// The width of the cursor (used when [child] is null).
  final double? width;

  /// The height of the cursor (used when [child] is null).
  final double? height;

  /// Whether to animate the cursor.
  final bool animate;

  /// Duration of one blink cycle.
  final Duration duration;

  /// Custom widget to use as cursor.
  ///
  /// When provided, this widget is used instead of the default line cursor.
  final Widget? child;

  @override
  State<CursorBlink> createState() => _CursorBlinkState();
}

class _CursorBlinkState extends State<CursorBlink>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.animate) {
      _controller.repeat(reverse: true);
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(CursorBlink oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate != oldWidget.animate) {
      if (widget.animate) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.value = 1.0;
      }
    }
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.animate) {
      return _buildCursor(1.0);
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => _buildCursor(_animation.value),
    );
  }

  Widget _buildCursor(double opacity) {
    final cursorWidget = widget.child ??
        Container(
          width: widget.width,
          height: widget.height,
          color: widget.color,
        );

    return Opacity(
      opacity: opacity,
      child: cursorWidget,
    );
  }
}
