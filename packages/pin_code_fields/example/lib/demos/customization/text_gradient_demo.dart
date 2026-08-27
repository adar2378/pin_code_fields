import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// Text Gradient - Apply gradient effects to PIN text
class TextGradientDemo extends StatelessWidget {
  const TextGradientDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Text Gradient')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Gradient Text Effects',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Apply beautiful gradients to your PIN text',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 32),

          // Rainbow gradient
          _GradientSection(
            title: 'Rainbow Gradient',
            child: MaterialPinField(
              length: 4,
              theme: const MaterialPinTheme(
                shape: MaterialPinShape.outlined,
                cellSize: Size(56, 64),
                textGradient: LinearGradient(
                  colors: [
                    Colors.red,
                    Colors.orange,
                    Colors.yellow,
                    Colors.green,
                    Colors.blue,
                    Colors.purple,
                  ],
                ),
              ),
              onCompleted: (_) {},
            ),
          ),
          const SizedBox(height: 32),

          // Primary gradient
          _GradientSection(
            title: 'Primary Gradient',
            child: MaterialPinField(
              length: 4,
              theme: MaterialPinTheme(
                shape: MaterialPinShape.filled,
                cellSize: const Size(56, 64),
                fillColor: colorScheme.primaryContainer.withValues(alpha: 0.3),
                textGradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.tertiary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              onCompleted: (_) {},
            ),
          ),
          const SizedBox(height: 32),

          // Gold gradient
          _GradientSection(
            title: 'Gold Gradient',
            child: MaterialPinField(
              length: 4,
              theme: MaterialPinTheme(
                shape: MaterialPinShape.outlined,
                cellSize: const Size(56, 64),
                borderColor: Colors.amber.shade300,
                focusedBorderColor: Colors.amber.shade600,
                textGradient: const LinearGradient(
                  colors: [
                    Color(0xFFD4AF37),
                    Color(0xFFF5E7A3),
                    Color(0xFFD4AF37),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
              onCompleted: (_) {},
            ),
          ),
          const SizedBox(height: 32),

          // Vertical gradient
          _GradientSection(
            title: 'Vertical Gradient',
            child: MaterialPinField(
              length: 4,
              theme: const MaterialPinTheme(
                shape: MaterialPinShape.underlined,
                cellSize: Size(56, 64),
                textGradient: LinearGradient(
                  colors: [Colors.cyan, Colors.blue],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              onCompleted: (_) {},
            ),
          ),
          const SizedBox(height: 32),

          // Note about gradients
          Card(
            color: colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline,
                          size: 20, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Note',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gradients are disabled in error and disabled states '
                    'to maintain readability and visual feedback.',
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientSection extends StatelessWidget {
  const _GradientSection({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }
}
