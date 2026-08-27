import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// Separators Demo - Custom separators between cells
class SeparatorsDemo extends StatelessWidget {
  const SeparatorsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Separators')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Cell Separators',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Add custom widgets between cells',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 32),

          // Dash separator
          _SeparatorSection(
            title: 'Dash Separator',
            description: 'Common for credit card or phone formats',
            child: MaterialPinField(
              length: 6,
              theme: const MaterialPinTheme(
                shape: MaterialPinShape.outlined,
                cellSize: Size(44, 52),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              separatorBuilder: (context, index) {
                if (index == 2) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '—',
                      style: TextStyle(
                        color: colorScheme.outline,
                        fontSize: 20,
                      ),
                    ),
                  );
                }
                return const SizedBox(width: 8);
              },
              onCompleted: (_) {},
            ),
          ),
          const SizedBox(height: 32),

          // Dot separator
          _SeparatorSection(
            title: 'Dot Separator',
            description: 'Subtle dots between each cell',
            child: MaterialPinField(
              length: 4,
              theme: const MaterialPinTheme(
                shape: MaterialPinShape.outlined,
                cellSize: Size(56, 64),
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
              onCompleted: (_) {},
            ),
          ),
          const SizedBox(height: 32),

          // Group separator (like credit card)
          _SeparatorSection(
            title: 'Group Separator',
            description: 'Visual grouping like credit card numbers',
            child: MaterialPinField(
              length: 8,
              theme: const MaterialPinTheme(
                shape: MaterialPinShape.underlined,
                cellSize: Size(36, 48),
              ),
              separatorBuilder: (context, index) {
                if ((index + 1) % 4 == 0 && index < 7) {
                  return const SizedBox(width: 24);
                }
                return const SizedBox(width: 8);
              },
              onCompleted: (_) {},
            ),
          ),
          const SizedBox(height: 32),

          // Custom widget separator
          _SeparatorSection(
            title: 'Icon Separator',
            description: 'Icons between specific positions',
            child: MaterialPinField(
              length: 6,
              theme: const MaterialPinTheme(
                shape: MaterialPinShape.filled,
                cellSize: Size(44, 52),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              separatorBuilder: (context, index) {
                if (index == 2) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.lock,
                      size: 16,
                      color: colorScheme.outline,
                    ),
                  );
                }
                return const SizedBox(width: 8);
              },
              onCompleted: (_) {},
            ),
          ),
        ],
      ),
    );
  }
}

class _SeparatorSection extends StatelessWidget {
  const _SeparatorSection({
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
