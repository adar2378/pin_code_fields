import 'package:material_ui/material_ui.dart';

import '../../core/pin_cell_data.dart';
import '../animations/cursor_blink.dart';
import '../animations/entry_animations.dart';
import '../theme/material_pin_theme.dart';

/// Widget that renders the content inside a PIN cell.
///
/// This handles displaying the character, cursor, or empty state
/// with appropriate animations.
class MaterialCellContent extends StatelessWidget {
  const MaterialCellContent({
    super.key,
    required this.data,
    required this.theme,
    this.obscureText = false,
    this.obscuringWidget,
    this.hintCharacter,
    this.hintWidget,
    this.hintStyle,
  });

  /// The cell data containing state information.
  final PinCellData data;

  /// The resolved Material theme.
  final MaterialPinThemeData theme;

  /// Whether to obscure the text.
  final bool obscureText;

  /// Custom widget to show when obscuring text.
  final Widget? obscuringWidget;

  /// Hint character to show in empty cells.
  ///
  /// If null, falls back to [MaterialPinThemeData.hintCharacter].
  /// If [hintWidget] is provided, this is ignored.
  final String? hintCharacter;

  /// Custom widget to show in empty cells.
  ///
  /// When provided, this widget is displayed instead of [hintCharacter].
  final Widget? hintWidget;

  /// Style for hint character.
  ///
  /// If null, falls back to [MaterialPinThemeData.hintStyle].
  final TextStyle? hintStyle;

  @override
  Widget build(BuildContext context) {
    final content = _buildContent(context);

    return AnimatedSwitcher(
      duration: theme.animationDuration,
      switchInCurve: theme.animationCurve,
      switchOutCurve: theme.animationCurve,
      transitionBuilder: getEntryAnimationTransitionBuilder(
        theme.entryAnimation,
        theme.animationCurve,
        customBuilder: theme.customEntryAnimationBuilder,
      ),
      child: content,
    );
  }

  Widget _buildContent(BuildContext context) {
    // Filled cell - show character
    if (data.isFilled) {
      return _buildCharacter(context);
    }

    // Focused cell - show cursor
    if (data.isFocused && theme.showCursor && !data.isDisabled) {
      return _buildCursor(context);
    }

    // Empty cell - show hint widget, hint character, or nothing
    if (hintWidget != null) {
      return KeyedSubtree(
        key: ValueKey('hint_widget_${data.index}'),
        child: hintWidget!,
      );
    }

    final effectiveHintChar = hintCharacter ?? theme.hintCharacter;
    if (effectiveHintChar != null) {
      return _buildHint(context, effectiveHintChar);
    }

    return const SizedBox.shrink(key: ValueKey('empty'));
  }

  Widget _buildCharacter(BuildContext context) {
    // Determine if we should show obscured content
    final shouldObscure = obscureText && !data.isBlinking;

    // Use custom obscuring widget if provided
    if (shouldObscure && obscuringWidget != null) {
      Widget child = KeyedSubtree(
        key: ValueKey('obscure_widget_${data.index}'),
        child: obscuringWidget!,
      );
      // Apply opacity for disabled state
      if (data.isDisabled) {
        child = Opacity(opacity: 0.38, child: child);
      }
      // Apply error color tint if in error state
      if (data.isError) {
        child = ColorFiltered(
          colorFilter: ColorFilter.mode(
            theme.errorColor.withValues(alpha: 0.8),
            BlendMode.srcATop,
          ),
          child: child,
        );
      }
      return child;
    }

    // Use character (either actual or obscuring character)
    final displayChar =
        shouldObscure ? theme.obscuringCharacter : data.character!;

    // Apply state-specific text style (priority: disabled > error > complete > normal)
    final TextStyle? effectiveTextStyle;
    if (data.isDisabled) {
      effectiveTextStyle = theme.disabledTextStyle;
    } else if (data.isError) {
      effectiveTextStyle = theme.errorTextStyle;
    } else if (data.isComplete) {
      effectiveTextStyle = theme.completeTextStyle;
    } else {
      effectiveTextStyle = theme.textStyle;
    }

    Widget textWidget = Text(
      displayChar,
      key: ValueKey('char_${data.index}_$displayChar'),
      style: effectiveTextStyle,
    );

    // Apply gradient if provided (only when not disabled or in error)
    if (theme.textGradient != null && !data.isDisabled && !data.isError) {
      textWidget = ShaderMask(
        shaderCallback: (bounds) => theme.textGradient!.createShader(bounds),
        blendMode: BlendMode.srcIn,
        child: textWidget,
      );
    }

    return textWidget;
  }

  Widget _buildCursor(BuildContext context) {
    Widget cursor;

    // Use custom cursor widget if provided
    if (theme.cursorWidget != null) {
      cursor = CursorBlink(
        key: const ValueKey('cursor'),
        animate: theme.animateCursor,
        duration: theme.cursorBlinkDuration,
        child: theme.cursorWidget,
      );
    } else {
      // Default line cursor
      final cursorHeight =
          theme.cursorHeight ?? (theme.textStyle?.fontSize ?? 20) + 8;

      cursor = CursorBlink(
        key: const ValueKey('cursor'),
        color: theme.cursorColor,
        width: theme.cursorWidth,
        height: cursorHeight,
        animate: theme.animateCursor,
        duration: theme.cursorBlinkDuration,
      );
    }

    // Apply alignment (uses Stack's alignment for center, or explicit Align for others)
    if (theme.cursorAlignment != Alignment.center) {
      // Use SizedBox with cell size to fill the parent, allowing Align to position correctly
      return SizedBox(
        width: theme.cellSize.width,
        height: theme.cellSize.height,
        child: Align(
          alignment: theme.cursorAlignment,
          child: cursor,
        ),
      );
    }

    return cursor;
  }

  Widget _buildHint(BuildContext context, String hintChar) {
    // Widget value overrides theme value
    final effectiveHintStyle = hintStyle ??
        theme.hintStyle ??
        theme.textStyle?.copyWith(color: theme.disabledColor) ??
        TextStyle(color: theme.disabledColor);

    return Text(
      hintChar,
      key: ValueKey('hint_${data.index}'),
      style: effectiveHintStyle,
    );
  }
}
