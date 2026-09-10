import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// Comprehensive Playground - Interactively customize all options
class PlaygroundPage extends StatefulWidget {
  const PlaygroundPage({super.key});

  @override
  State<PlaygroundPage> createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends State<PlaygroundPage> {
  final _pinController = PinInputController();

  // Basic settings
  int _length = 4;
  MaterialPinShape _shape = MaterialPinShape.outlined;
  double _cellWidth = 56;
  double _cellHeight = 64;
  double _spacing = 8;
  double _borderRadius = 12;

  // Border settings
  double _borderWidth = 1.5;
  double _focusedBorderWidth = 2.0;

  // Behavior
  bool _obscureText = false;
  bool _blinkWhenObscuring = true;
  bool _showCursor = true;
  bool _animateCursor = true;
  bool _enableHaptic = true;
  bool _autoFocus = false;

  // Animation
  MaterialPinAnimation _entryAnimation = MaterialPinAnimation.scale;

  // Colors
  Color _borderColor = Colors.grey;
  Color _focusedBorderColor = Colors.blue;
  Color _filledBorderColor = Colors.blueGrey;
  Color _fillColor = Colors.transparent;
  Color _focusedFillColor = Colors.blue;
  Color _errorColor = Colors.red;

  // Cursor
  Alignment _cursorAlignment = Alignment.center;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Playground'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _pinController.clear();
            },
            tooltip: 'Clear',
          ),
          IconButton(
            icon: const Icon(Icons.error_outline),
            onPressed: () {
              _pinController.triggerError();
            },
            tooltip: 'Trigger Error',
          ),
        ],
      ),
      body: Column(
        children: [
          // Preview area
          Container(
            padding: const EdgeInsets.all(32),
            color: colorScheme.surfaceContainerLowest,
            child: Center(
              child: MaterialPinField(
                length: _length,
                pinController: _pinController,
                autoFocus: _autoFocus,
                obscureText: _obscureText,
                blinkWhenObscuring: _blinkWhenObscuring,
                enableHapticFeedback: _enableHaptic,
                theme: MaterialPinTheme(
                  shape: _shape,
                  cellSize: Size(_cellWidth, _cellHeight),
                  spacing: _spacing,
                  borderRadius:
                      BorderRadius.all(Radius.circular(_borderRadius)),
                  borderWidth: _borderWidth,
                  focusedBorderWidth: _focusedBorderWidth,
                  borderColor: _borderColor,
                  focusedBorderColor: _focusedBorderColor,
                  filledBorderColor: _filledBorderColor,
                  fillColor: _fillColor,
                  focusedFillColor: _focusedFillColor.withValues(alpha: 0.1),
                  errorColor: _errorColor,
                  errorBorderColor: _errorColor,
                  showCursor: _showCursor,
                  animateCursor: _animateCursor,
                  cursorAlignment: _cursorAlignment,
                  entryAnimation: _entryAnimation,
                ),
                onCompleted: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Completed: $value'),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),
          ),

          // Settings
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Basic
                _SectionHeader('Basic'),
                _SliderSetting(
                  label: 'Length',
                  value: _length.toDouble(),
                  min: 3,
                  max: 8,
                  divisions: 5,
                  onChanged: (v) => setState(() => _length = v.round()),
                  displayValue: _length.toString(),
                ),
                _DropdownSetting<MaterialPinShape>(
                  label: 'Shape',
                  value: _shape,
                  items: MaterialPinShape.values,
                  onChanged: (v) => setState(() => _shape = v!),
                  itemLabel: (v) => v.name,
                ),
                _SliderSetting(
                  label: 'Cell Width',
                  value: _cellWidth,
                  min: 40,
                  max: 80,
                  onChanged: (v) => setState(() => _cellWidth = v),
                ),
                _SliderSetting(
                  label: 'Cell Height',
                  value: _cellHeight,
                  min: 40,
                  max: 80,
                  onChanged: (v) => setState(() => _cellHeight = v),
                ),
                _SliderSetting(
                  label: 'Spacing',
                  value: _spacing,
                  min: 0,
                  max: 24,
                  onChanged: (v) => setState(() => _spacing = v),
                ),
                _SliderSetting(
                  label: 'Border Radius',
                  value: _borderRadius,
                  min: 0,
                  max: 32,
                  onChanged: (v) => setState(() => _borderRadius = v),
                ),

                // Borders
                _SectionHeader('Borders'),
                _SliderSetting(
                  label: 'Border Width',
                  value: _borderWidth,
                  min: 0.5,
                  max: 4,
                  onChanged: (v) => setState(() => _borderWidth = v),
                ),
                _SliderSetting(
                  label: 'Focused Border Width',
                  value: _focusedBorderWidth,
                  min: 0.5,
                  max: 4,
                  onChanged: (v) => setState(() => _focusedBorderWidth = v),
                ),

                // Colors
                _SectionHeader('Colors'),
                _ColorSetting(
                  label: 'Border',
                  value: _borderColor,
                  onChanged: (v) => setState(() => _borderColor = v),
                ),
                _ColorSetting(
                  label: 'Focused Border',
                  value: _focusedBorderColor,
                  onChanged: (v) => setState(() => _focusedBorderColor = v),
                ),
                _ColorSetting(
                  label: 'Filled Border',
                  value: _filledBorderColor,
                  onChanged: (v) => setState(() => _filledBorderColor = v),
                ),
                _ColorSetting(
                  label: 'Fill',
                  value: _fillColor,
                  onChanged: (v) => setState(() => _fillColor = v),
                ),
                _ColorSetting(
                  label: 'Focused Fill',
                  value: _focusedFillColor,
                  onChanged: (v) => setState(() => _focusedFillColor = v),
                ),
                _ColorSetting(
                  label: 'Error',
                  value: _errorColor,
                  onChanged: (v) => setState(() => _errorColor = v),
                ),

                // Behavior
                _SectionHeader('Behavior'),
                _SwitchSetting(
                  label: 'Obscure Text',
                  value: _obscureText,
                  onChanged: (v) => setState(() => _obscureText = v),
                ),
                _SwitchSetting(
                  label: 'Blink When Obscuring',
                  value: _blinkWhenObscuring,
                  onChanged: (v) => setState(() => _blinkWhenObscuring = v),
                  enabled: _obscureText,
                ),
                _SwitchSetting(
                  label: 'Show Cursor',
                  value: _showCursor,
                  onChanged: (v) => setState(() => _showCursor = v),
                ),
                _SwitchSetting(
                  label: 'Animate Cursor',
                  value: _animateCursor,
                  onChanged: (v) => setState(() => _animateCursor = v),
                  enabled: _showCursor,
                ),
                _SwitchSetting(
                  label: 'Haptic Feedback',
                  value: _enableHaptic,
                  onChanged: (v) => setState(() => _enableHaptic = v),
                ),
                _SwitchSetting(
                  label: 'Auto Focus',
                  value: _autoFocus,
                  onChanged: (v) => setState(() => _autoFocus = v),
                ),

                // Cursor Alignment
                _SectionHeader('Cursor Alignment'),
                _DropdownSetting<Alignment>(
                  label: 'Alignment',
                  value: _cursorAlignment,
                  items: const [
                    Alignment.topCenter,
                    Alignment.center,
                    Alignment.bottomCenter,
                  ],
                  onChanged: (v) => setState(() => _cursorAlignment = v!),
                  itemLabel: (v) {
                    if (v == Alignment.topCenter) return 'Top';
                    if (v == Alignment.center) return 'Center';
                    if (v == Alignment.bottomCenter) return 'Bottom';
                    return v.toString();
                  },
                ),

                // Animation
                _SectionHeader('Animation'),
                _DropdownSetting<MaterialPinAnimation>(
                  label: 'Entry Animation',
                  value: _entryAnimation,
                  items: [
                    MaterialPinAnimation.scale,
                    MaterialPinAnimation.fade,
                    MaterialPinAnimation.slide,
                    MaterialPinAnimation.none,
                  ],
                  onChanged: (v) => setState(() => _entryAnimation = v!),
                  itemLabel: (v) => v.name,
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _SliderSetting extends StatelessWidget {
  const _SliderSetting({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.divisions,
    this.displayValue,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;
  final String? displayValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(label, style: const TextStyle(fontSize: 13)),
        ),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 40,
          child: Text(
            displayValue ?? value.toStringAsFixed(1),
            style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
          ),
        ),
      ],
    );
  }
}

class _SwitchSetting extends StatelessWidget {
  const _SwitchSetting({
    required this.label,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: enabled ? null : Theme.of(context).disabledColor,
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: enabled ? onChanged : null,
        ),
      ],
    );
  }
}

class _DropdownSetting<T> extends StatelessWidget {
  const _DropdownSetting({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.itemLabel,
  });

  final String label;
  final T value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String Function(T) itemLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(label, style: const TextStyle(fontSize: 13)),
        ),
        Expanded(
          child: DropdownButton<T>(
            value: value,
            isExpanded: true,
            items: items
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(itemLabel(e)),
                    ))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _ColorSetting extends StatelessWidget {
  const _ColorSetting({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final Color value;
  final ValueChanged<Color> onChanged;

  static const _colors = [
    Colors.transparent,
    Colors.grey,
    Colors.blueGrey,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.red,
    Colors.orange,
    Colors.amber,
    Colors.green,
    Colors.teal,
    Colors.cyan,
    Colors.black,
    Colors.white,
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(label, style: const TextStyle(fontSize: 13)),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _colors.map((color) {
                final isSelected = value == color;
                return GestureDetector(
                  onTap: () => onChanged(color),
                  child: Container(
                    width: 28,
                    height: 28,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      color: color,
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: color == Colors.transparent
                        ? const Icon(Icons.block, size: 16, color: Colors.grey)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
