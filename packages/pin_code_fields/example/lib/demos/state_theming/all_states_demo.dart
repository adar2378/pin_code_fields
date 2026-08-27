import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// All States Demo - Visual state machine
class AllStatesDemo extends StatelessWidget {
  const AllStatesDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('State Theming')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'PIN Field States',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Each cell state can have unique styling',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),

          // Interactive demo
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Try It',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  MaterialPinField(
                    length: 6,
                    autoFocus: true,
                    theme: MaterialPinTheme(
                      shape: MaterialPinShape.outlined,
                      cellSize: const Size(44, 52),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      // Empty state
                      fillColor: Colors.transparent,
                      borderColor: colorScheme.outline,
                      // Focused state
                      focusedFillColor:
                          colorScheme.primaryContainer.withValues(alpha: 0.3),
                      focusedBorderColor: colorScheme.primary,
                      focusedBorderWidth: 2,
                      // Filled state
                      filledFillColor: colorScheme.surfaceContainerHighest,
                      filledBorderColor: colorScheme.outline,
                      // Following state (after cursor)
                      followingFillColor: colorScheme.surfaceContainerLow,
                      followingBorderColor: colorScheme.outlineVariant,
                      // Complete state (all filled)
                      completeFillColor: Colors.green.withValues(alpha: 0.1),
                      completeBorderColor: Colors.green,
                    ),
                    onCompleted: (_) {},
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // State legend
          const Text('State Legend',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          _StateLegendItem(
            color: colorScheme.outline,
            title: 'Empty',
            description: 'Cells before the cursor',
          ),
          _StateLegendItem(
            color: colorScheme.primary,
            title: 'Focused',
            description: 'Current input position (shows cursor)',
          ),
          _StateLegendItem(
            color: colorScheme.surfaceContainerHighest,
            title: 'Filled',
            description: 'Cells with entered characters',
          ),
          _StateLegendItem(
            color: colorScheme.outlineVariant,
            title: 'Following',
            description: 'Empty cells after the cursor',
          ),
          _StateLegendItem(
            color: Colors.green,
            title: 'Complete',
            description: 'All cells when PIN is fully entered',
          ),
        ],
      ),
    );
  }
}

class _StateLegendItem extends StatelessWidget {
  const _StateLegendItem({
    required this.color,
    required this.title,
    required this.description,
  });

  final Color color;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 48,
            decoration: BoxDecoration(
              border: Border.all(color: color, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
