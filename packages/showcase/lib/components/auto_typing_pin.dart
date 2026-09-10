import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// Auto-typing PIN field that cycles through typing digits and clearing.
class AutoTypingPin extends StatefulWidget {
  const AutoTypingPin({
    super.key,
    this.length = 6,
    this.theme,
    this.typingInterval = const Duration(milliseconds: 300),
    this.pauseAfterComplete = const Duration(seconds: 2),
    this.pauseAfterClear = const Duration(seconds: 1),
  });

  final int length;
  final MaterialPinTheme? theme;
  final Duration typingInterval;
  final Duration pauseAfterComplete;
  final Duration pauseAfterClear;

  @override
  State<AutoTypingPin> createState() => _AutoTypingPinState();
}

class _AutoTypingPinState extends State<AutoTypingPin> {
  final _controller = PinInputController();
  Timer? _timer;
  int _currentIndex = 0;
  bool _isClearing = false;
  static const _digits = '123456789';

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startTyping() {
    _timer?.cancel();
    _currentIndex = 0;
    _isClearing = false;
    _scheduleNext();
  }

  void _scheduleNext() {
    _timer = Timer(widget.typingInterval, _typeNext);
  }

  void _typeNext() {
    if (!mounted) return;

    if (_isClearing) {
      _controller.clear();
      _isClearing = false;
      _currentIndex = 0;
      _timer = Timer(widget.pauseAfterClear, () {
        if (mounted) _scheduleNext();
      });
      return;
    }

    if (_currentIndex < widget.length) {
      final nextDigit = _digits[_currentIndex % _digits.length];
      _controller.setText(_controller.text + nextDigit);
      _currentIndex++;

      if (_currentIndex >= widget.length) {
        // Completed — pause then clear
        _isClearing = true;
        _timer = Timer(widget.pauseAfterComplete, () {
          if (mounted) _typeNext();
        });
      } else {
        _scheduleNext();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: MaterialPinField(
        length: widget.length,
        pinController: _controller,
        theme: widget.theme ?? const MaterialPinTheme(),
        enableHapticFeedback: false,
      ),
    );
  }
}
