import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../components/section_title.dart';
import '../layout/responsive.dart';
import '../layout/section_wrapper.dart';

/// Interactive playground with live preview and code generation.
class PlaygroundSection extends StatefulWidget {
  const PlaygroundSection({super.key, this.sectionKey});

  final GlobalKey? sectionKey;

  @override
  State<PlaygroundSection> createState() => _PlaygroundSectionState();
}

class _PlaygroundSectionState extends State<PlaygroundSection> {
  final _controller = PinInputController();

  // Settings
  int _length = 4;
  MaterialPinShape _shape = MaterialPinShape.outlined;
  double _cellWidth = 56;
  double _cellHeight = 64;
  double _spacing = 8;
  double _borderRadius = 12;
  bool _obscureText = false;
  bool _showCursor = true;
  MaterialPinAnimation _entryAnimation = MaterialPinAnimation.scale;

  // Colors
  Color _borderColor = const Color(0xFF6B7280);
  Color _focusedBorderColor = const Color(0xFF6366F1);
  Color _fillColor = Colors.transparent;
  Color _errorColor = const Color(0xFFEF4444);

  bool _copied = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _generateCode() {
    final shapeStr = 'MaterialPinShape.${_shape.name}';
    final animStr = 'MaterialPinAnimation.${_entryAnimation.name}';
    final buf = StringBuffer();
    buf.writeln('MaterialPinField(');
    buf.writeln('  length: $_length,');
    buf.writeln('  theme: MaterialPinTheme(');
    buf.writeln('    shape: $shapeStr,');
    buf.writeln(
      '    cellSize: Size(${_cellWidth.toStringAsFixed(0)}, ${_cellHeight.toStringAsFixed(0)}),',
    );
    buf.writeln('    spacing: ${_spacing.toStringAsFixed(0)},');
    buf.writeln(
      '    borderRadius: BorderRadius.circular(${_borderRadius.toStringAsFixed(0)}),',
    );
    buf.writeln('    entryAnimation: $animStr,');
    if (_obscureText) buf.writeln('    obscureText: true,');
    if (!_showCursor) buf.writeln('    showCursor: false,');
    buf.writeln('  ),');
    buf.writeln('  onCompleted: (pin) => print(pin),');
    buf.writeln(')');
    return buf.toString();
  }

  Future<void> _copyCode() async {
    await Clipboard.setData(ClipboardData(text: _generateCode()));
    if (!mounted) return;
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bp = getBreakpoint(context);
    final isMobile = bp == Breakpoint.mobile;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SectionWrapper(
      sectionKey: widget.sectionKey,
      enableFadeIn: false,
      child: Column(
        children: [
          const SectionTitle(
            title: 'Playground',
            subtitle: 'Tweak every parameter',
          ),
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF2A2A3E)
                    : const Color(0xFFE5E7EB),
              ),
            ),
            child: isMobile
                ? Column(
                    children: [
                      _buildPreview(isDark),
                      const Divider(height: 1),
                      _buildSettings(isDark),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildPreview(isDark)),
                      Container(
                        width: 1,
                        height: 500,
                        color: isDark
                            ? const Color(0xFF2A2A3E)
                            : const Color(0xFFE5E7EB),
                      ),
                      Expanded(child: _buildSettings(isDark)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const SizedBox(height: 40),
          MaterialPinField(
            length: _length,
            pinController: _controller,
            obscureText: _obscureText,
            theme: MaterialPinTheme(
              shape: _shape,
              cellSize: Size(_cellWidth, _cellHeight),
              spacing: _spacing,
              borderRadius: BorderRadius.circular(_borderRadius),
              borderColor: _borderColor,
              focusedBorderColor: _focusedBorderColor,
              fillColor: _fillColor,
              errorColor: _errorColor,
              showCursor: _showCursor,
              entryAnimation: _entryAnimation,
            ),
            enableHapticFeedback: false,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => _controller.clear(),
                icon: const Icon(Icons.refresh),
                tooltip: 'Clear',
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _controller.triggerError(),
                icon: const Icon(Icons.error_outline),
                tooltip: 'Trigger Error',
              ),
              const SizedBox(width: 16),
              FilledButton.icon(
                onPressed: _copyCode,
                icon: Icon(_copied ? Icons.check : Icons.copy, size: 18),
                label: Text(_copied ? 'Copied!' : 'Copy Code'),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSettings(bool isDark) {
    return SizedBox(
      height: 500,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _settingLabel('Length'),
          Slider(
            value: _length.toDouble(),
            min: 3,
            max: 8,
            divisions: 5,
            label: _length.toString(),
            onChanged: (v) => setState(() {
              _length = v.round();
              _controller.clear();
            }),
          ),
          _settingLabel('Shape'),
          SegmentedButton<MaterialPinShape>(
            segments: const [
              ButtonSegment(
                value: MaterialPinShape.outlined,
                label: Text('Outlined'),
              ),
              ButtonSegment(
                value: MaterialPinShape.filled,
                label: Text('Filled'),
              ),
              ButtonSegment(
                value: MaterialPinShape.underlined,
                label: Text('Underline'),
              ),
              ButtonSegment(
                value: MaterialPinShape.circle,
                label: Text('Circle'),
              ),
            ],
            selected: {_shape},
            onSelectionChanged: (v) => setState(() => _shape = v.first),
            showSelectedIcon: false,
            style: SegmentedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(height: 16),
          _settingLabel('Cell Size'),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _cellWidth,
                  min: 36,
                  max: 80,
                  label: 'W: ${_cellWidth.toStringAsFixed(0)}',
                  onChanged: (v) => setState(() => _cellWidth = v),
                ),
              ),
              Expanded(
                child: Slider(
                  value: _cellHeight,
                  min: 36,
                  max: 80,
                  label: 'H: ${_cellHeight.toStringAsFixed(0)}',
                  onChanged: (v) => setState(() => _cellHeight = v),
                ),
              ),
            ],
          ),
          _settingLabel('Spacing: ${_spacing.toStringAsFixed(0)}'),
          Slider(
            value: _spacing,
            min: 0,
            max: 24,
            onChanged: (v) => setState(() => _spacing = v),
          ),
          _settingLabel('Border Radius: ${_borderRadius.toStringAsFixed(0)}'),
          Slider(
            value: _borderRadius,
            min: 0,
            max: 32,
            onChanged: (v) => setState(() => _borderRadius = v),
          ),
          _settingLabel('Animation'),
          SegmentedButton<MaterialPinAnimation>(
            segments: const [
              ButtonSegment(
                value: MaterialPinAnimation.scale,
                label: Text('Scale'),
              ),
              ButtonSegment(
                value: MaterialPinAnimation.fade,
                label: Text('Fade'),
              ),
              ButtonSegment(
                value: MaterialPinAnimation.slide,
                label: Text('Slide'),
              ),
              ButtonSegment(
                value: MaterialPinAnimation.none,
                label: Text('None'),
              ),
            ],
            selected: {_entryAnimation},
            onSelectionChanged: (v) =>
                setState(() => _entryAnimation = v.first),
            showSelectedIcon: false,
            style: SegmentedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(height: 16),
          _settingLabel('Colors'),
          _colorRow(
            'Border',
            _borderColor,
            (c) => setState(() => _borderColor = c),
          ),
          _colorRow(
            'Focused',
            _focusedBorderColor,
            (c) => setState(() => _focusedBorderColor = c),
          ),
          _colorRow('Fill', _fillColor, (c) => setState(() => _fillColor = c)),
          _colorRow(
            'Error',
            _errorColor,
            (c) => setState(() => _errorColor = c),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Obscure Text', style: TextStyle(fontSize: 14)),
            value: _obscureText,
            onChanged: (v) => setState(() => _obscureText = v),
            dense: true,
          ),
          SwitchListTile(
            title: const Text('Show Cursor', style: TextStyle(fontSize: 14)),
            value: _showCursor,
            onChanged: (v) => setState(() => _showCursor = v),
            dense: true,
          ),
        ],
      ),
    );
  }

  Widget _settingLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _colorRow(String label, Color value, ValueChanged<Color> onChanged) {
    const colors = [
      Colors.transparent,
      Color(0xFF6B7280),
      Color(0xFF6366F1),
      Color(0xFF8B5CF6),
      Color(0xFFEC4899),
      Color(0xFFEF4444),
      Color(0xFF10B981),
      Color(0xFF3B82F6),
      Colors.black,
      Colors.white,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(label, style: const TextStyle(fontSize: 12)),
          ),
          ...colors.map((c) {
            final isSelected = value == c;
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => onChanged(c),
                child: Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color: c,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: c == Colors.transparent
                      ? const Icon(Icons.block, size: 14, color: Colors.grey)
                      : null,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
