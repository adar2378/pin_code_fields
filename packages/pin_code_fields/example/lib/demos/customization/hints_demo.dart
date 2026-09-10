import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// Hints Demo - Hint characters and widgets
class HintsDemo extends StatelessWidget {
  const HintsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Hints & Placeholders')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Empty Cell Hints',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Show placeholders in empty cells',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 32),

          // Hint character
          _HintSection(
            title: 'Hint Character',
            description: 'Simple dash or bullet placeholder',
            child: MaterialPinField(
              length: 6,
              hintCharacter: '—',
              theme: MaterialPinTheme(
                shape: MaterialPinShape.outlined,
                cellSize: const Size(44, 52),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                hintStyle: TextStyle(
                  color: colorScheme.outline,
                  fontSize: 16,
                ),
              ),
              onCompleted: (_) {},
            ),
          ),
          const SizedBox(height: 32),

          // Numeric hint
          _HintSection(
            title: 'Numeric Hints',
            description: 'Numbers showing position',
            child: MaterialPinField(
              length: 4,
              theme: MaterialPinTheme(
                shape: MaterialPinShape.outlined,
                cellSize: const Size(56, 64),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                hintCharacter: '0',
                hintStyle: TextStyle(
                  color: colorScheme.outline.withValues(alpha: 0.5),
                  fontSize: 20,
                ),
              ),
              onCompleted: (_) {},
            ),
          ),
          const SizedBox(height: 32),

          // Hint widget - dots
          _HintSection(
            title: 'Hint Widget (Dots)',
            description: 'Custom widget as placeholder',
            child: MaterialPinField(
              length: 4,
              hintWidget: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              theme: const MaterialPinTheme(
                shape: MaterialPinShape.circle,
                cellSize: Size(56, 56),
              ),
              onCompleted: (_) {},
            ),
          ),
          const SizedBox(height: 32),

          // Hint widget - icons
          _HintSection(
            title: 'Hint Widget (Icons)',
            description: 'Icon placeholders',
            child: MaterialPinField(
              length: 4,
              hintWidget: Icon(
                Icons.circle_outlined,
                size: 16,
                color: colorScheme.outline.withValues(alpha: 0.5),
              ),
              theme: const MaterialPinTheme(
                shape: MaterialPinShape.outlined,
                cellSize: Size(56, 64),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              onCompleted: (_) {},
            ),
          ),
        ],
      ),
    );
  }
}

class _HintSection extends StatelessWidget {
  const _HintSection({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }
}
