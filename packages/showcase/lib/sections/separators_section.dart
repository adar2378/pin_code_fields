import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../components/section_title.dart';
import '../layout/responsive.dart';
import '../layout/section_wrapper.dart';

/// Showcases separator styles between PIN cells.
class SeparatorsSection extends StatelessWidget {
  const SeparatorsSection({super.key, this.sectionKey});

  final GlobalKey? sectionKey;

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      sectionKey: sectionKey,
      child: Column(
        children: [
          const SectionTitle(
            title: 'Cell Separators',
            subtitle: 'Add custom widgets between cells',
          ),
          ResponsiveGrid(
            desktopColumns: 2,
            tabletColumns: 2,
            mobileColumns: 1,
            children: const [
              _SeparatorDemo(
                title: 'Dash',
                description: 'Credit card / phone number format',
                type: _SepType.dash,
              ),
              _SeparatorDemo(
                title: 'Dot',
                description: 'Subtle dots between each cell',
                type: _SepType.dot,
              ),
              _SeparatorDemo(
                title: 'Group',
                description: 'Visual grouping like card numbers',
                type: _SepType.group,
              ),
              _SeparatorDemo(
                title: 'Icon',
                description: 'Icons between specific positions',
                type: _SepType.icon,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum _SepType { dash, dot, group, icon }

class _SeparatorDemo extends StatefulWidget {
  const _SeparatorDemo({
    required this.title,
    required this.description,
    required this.type,
  });

  final String title;
  final String description;
  final _SepType type;

  @override
  State<_SeparatorDemo> createState() => _SeparatorDemoState();
}

class _SeparatorDemoState extends State<_SeparatorDemo> {
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
    final colorScheme = Theme.of(context).colorScheme;

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
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            _buildField(colorScheme),
            const SizedBox(height: 16),
            Text(
              widget.title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              widget.description,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white54 : const Color(0xFF9CA3AF),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(ColorScheme colorScheme) {
    switch (widget.type) {
      case _SepType.dash:
        return MaterialPinField(
          length: 6,
          pinController: _controller,
          theme: const MaterialPinTheme(
            shape: MaterialPinShape.outlined,
            cellSize: Size(40, 48),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          separatorBuilder: (context, index) {
            if (index == 2) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  '—',
                  style: TextStyle(color: colorScheme.outline, fontSize: 20),
                ),
              );
            }
            return const SizedBox(width: 6);
          },
          enableHapticFeedback: false,
        );
      case _SepType.dot:
        return MaterialPinField(
          length: 4,
          pinController: _controller,
          theme: const MaterialPinTheme(
            shape: MaterialPinShape.outlined,
            cellSize: Size(48, 56),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          separatorBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: colorScheme.outline.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
          enableHapticFeedback: false,
        );
      case _SepType.group:
        return MaterialPinField(
          length: 8,
          pinController: _controller,
          theme: const MaterialPinTheme(
            shape: MaterialPinShape.underlined,
            cellSize: Size(32, 44),
          ),
          separatorBuilder: (context, index) {
            if ((index + 1) % 4 == 0 && index < 7) {
              return const SizedBox(width: 20);
            }
            return const SizedBox(width: 6);
          },
          enableHapticFeedback: false,
        );
      case _SepType.icon:
        return MaterialPinField(
          length: 6,
          pinController: _controller,
          theme: const MaterialPinTheme(
            shape: MaterialPinShape.filled,
            cellSize: Size(40, 48),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          separatorBuilder: (context, index) {
            if (index == 2) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Icon(Icons.lock, size: 16, color: colorScheme.outline),
              );
            }
            return const SizedBox(width: 6);
          },
          enableHapticFeedback: false,
        );
    }
  }
}
