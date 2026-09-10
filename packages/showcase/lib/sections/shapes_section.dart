import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../components/section_title.dart';
import '../layout/responsive.dart';
import '../layout/section_wrapper.dart';

/// Showcases all 4 Material PIN shapes.
class ShapesSection extends StatelessWidget {
  const ShapesSection({super.key, this.sectionKey});

  final GlobalKey? sectionKey;

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      sectionKey: sectionKey,
      child: Column(
        children: [
          const SectionTitle(
            title: 'Four Material Shapes',
            subtitle: 'Every shape you need, ready to use',
          ),
          ResponsiveGrid(
            desktopColumns: 4,
            tabletColumns: 2,
            mobileColumns: 1,
            children: const [
              _ShapeDemo(
                shape: MaterialPinShape.outlined,
                label: 'Outlined',
                code: 'MaterialPinShape.outlined',
              ),
              _ShapeDemo(
                shape: MaterialPinShape.filled,
                label: 'Filled',
                code: 'MaterialPinShape.filled',
              ),
              _ShapeDemo(
                shape: MaterialPinShape.underlined,
                label: 'Underlined',
                code: 'MaterialPinShape.underlined',
              ),
              _ShapeDemo(
                shape: MaterialPinShape.circle,
                label: 'Circle',
                code: 'MaterialPinShape.circle',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShapeDemo extends StatefulWidget {
  const _ShapeDemo({
    required this.shape,
    required this.label,
    required this.code,
  });

  final MaterialPinShape shape;
  final String label;
  final String code;

  @override
  State<_ShapeDemo> createState() => _ShapeDemoState();
}

class _ShapeDemoState extends State<_ShapeDemo> {
  final _controller = PinInputController();
  bool _hovered = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF2A2A3E) : const Color(0xFFE5E7EB),
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            MaterialPinField(
              length: 4,
              pinController: _controller,
              theme: MaterialPinTheme(
                shape: widget.shape,
                cellSize: const Size(44, 52),
                spacing: 6,
                borderRadius: widget.shape == MaterialPinShape.circle
                    ? BorderRadius.circular(100)
                    : BorderRadius.circular(8),
              ),
              enableHapticFeedback: false,
            ),
            const SizedBox(height: 16),
            Text(
              widget.label,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E1E2E)
                    : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                widget.code,
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'monospace',
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
