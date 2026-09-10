import 'package:material_ui/material_ui.dart';

import '../theme/material_pin_theme.dart';

/// Builds an entry animation transition for PIN cell content.
///
/// This creates the appropriate transition based on the animation type.
/// For [MaterialPinAnimation.custom], returns the child unchanged since
/// custom animations are handled separately via [customBuilder].
Widget buildEntryAnimation({
  required Widget child,
  required Animation<double> animation,
  required MaterialPinAnimation type,
}) {
  switch (type) {
    case MaterialPinAnimation.scale:
      return ScaleTransition(scale: animation, child: child);
    case MaterialPinAnimation.fade:
      return FadeTransition(opacity: animation, child: child);
    case MaterialPinAnimation.slide:
      return SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    case MaterialPinAnimation.none:
    case MaterialPinAnimation.custom:
      // Custom is handled by customBuilder in getEntryAnimationTransitionBuilder
      return child;
  }
}

/// Returns an AnimatedSwitcher transition builder for PIN cell entry animations.
///
/// If [customBuilder] is provided and [type] is [MaterialPinAnimation.custom],
/// the custom builder will be used. Otherwise, the built-in animation for [type]
/// will be applied.
AnimatedSwitcherTransitionBuilder getEntryAnimationTransitionBuilder(
  MaterialPinAnimation type,
  Curve curve, {
  AnimatedSwitcherTransitionBuilder? customBuilder,
}) {
  // Use custom builder if provided and type is custom
  if (type == MaterialPinAnimation.custom && customBuilder != null) {
    return customBuilder;
  }

  return (Widget child, Animation<double> animation) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );
    return buildEntryAnimation(
      child: child,
      animation: curvedAnimation,
      type: type,
    );
  };
}
