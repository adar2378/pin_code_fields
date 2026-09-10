import 'dart:async';

import 'package:material_ui/material_ui.dart';

/// A widget that shakes its child when triggered.
///
/// The shake animation is triggered via a [Stream] or by calling
/// [ErrorShakeState.shake].
class ErrorShake extends StatefulWidget {
  const ErrorShake({
    super.key,
    required this.child,
    this.trigger,
    this.duration = const Duration(milliseconds: 500),
    this.enabled = true,
  });

  /// The child widget to shake.
  final Widget child;

  /// Stream that triggers the shake animation when it emits.
  final Stream<void>? trigger;

  /// Duration of the shake animation.
  final Duration duration;

  /// Whether shake animation is enabled.
  final bool enabled;

  @override
  State<ErrorShake> createState() => ErrorShakeState();
}

class ErrorShakeState extends State<ErrorShake>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  StreamSubscription<void>? _subscription;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.1, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ));
    _controller.addStatusListener(_onAnimationStatus);
    _subscribeToTrigger();
  }

  void _subscribeToTrigger() {
    _subscription?.cancel();
    _subscription = widget.trigger?.listen((_) => shake());
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _controller.reverse();
    }
  }

  @override
  void didUpdateWidget(ErrorShake oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger != oldWidget.trigger) {
      _subscribeToTrigger();
    }
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _controller.dispose();
    super.dispose();
  }

  /// Triggers the shake animation.
  void shake() {
    if (widget.enabled && mounted) {
      _controller.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}
