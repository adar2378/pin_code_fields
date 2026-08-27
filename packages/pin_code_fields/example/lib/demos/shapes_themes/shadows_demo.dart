import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// Shadows Demo - Box shadows and elevation
class ShadowsDemo extends StatelessWidget {
  const ShadowsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Shadows & Elevation')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Box Shadows',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add depth with shadows on different states',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 32),

          // Subtle shadow
          _ShadowSection(
            title: 'Subtle Shadow',
            description: 'Soft shadow for a lifted appearance',
            child: MaterialPinField(
              length: 4,
              theme: MaterialPinTheme(
                shape: MaterialPinShape.outlined,
                cellSize: const Size(56, 64),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                fillColor: colorScheme.surface,
                boxShadows: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              onCompleted: (_) {},
            ),
          ),
          const SizedBox(height: 32),

          // Focused shadow
          _ShadowSection(
            title: 'Focus Glow Effect',
            description: 'Shadow only on focused cell',
            child: MaterialPinField(
              length: 4,
              theme: MaterialPinTheme(
                shape: MaterialPinShape.outlined,
                cellSize: const Size(56, 64),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                fillColor: colorScheme.surface,
                focusedBorderColor: colorScheme.primary,
                focusedBoxShadows: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              onCompleted: (_) {},
            ),
          ),
          const SizedBox(height: 32),

          // Error shadow
          _ShadowSection(
            title: 'Error Glow',
            description: 'Red glow on error state (try "1111")',
            child: _ErrorShadowDemo(),
          ),
          const SizedBox(height: 32),

          // Elevation style
          _ShadowSection(
            title: 'Material Elevation',
            description: 'Card-like elevation effect',
            child: MaterialPinField(
              length: 4,
              theme: MaterialPinTheme(
                shape: MaterialPinShape.filled,
                cellSize: const Size(56, 64),
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                fillColor: colorScheme.surface,
                elevation: 2,
                focusedElevation: 8,
                focusedFillColor: colorScheme.surface,
              ),
              onCompleted: (_) {},
            ),
          ),
          const SizedBox(height: 32),

          // Neumorphism style
          _ShadowSection(
            title: 'Neumorphism Style',
            description: 'Soft UI with inset shadows',
            child: MaterialPinField(
              length: 4,
              theme: MaterialPinTheme(
                shape: MaterialPinShape.filled,
                cellSize: const Size(56, 64),
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                fillColor: colorScheme.surfaceContainerHighest,
                boxShadows: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.8),
                    blurRadius: 10,
                    offset: const Offset(-5, -5),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(5, 5),
                  ),
                ],
                focusedBoxShadows: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ],
              ),
              onCompleted: (_) {},
            ),
          ),
          const SizedBox(height: 32),

          // Code example
          Text(
            'Usage',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '''MaterialPinTheme(
  // Default shadow for all cells
  boxShadows: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ],
  // Shadow only for focused cell
  focusedBoxShadows: [
    BoxShadow(
      color: Colors.blue.withOpacity(0.3),
      blurRadius: 12,
      spreadRadius: 2,
    ),
  ],
  // Shadow for error state
  errorBoxShadows: [
    BoxShadow(
      color: Colors.red.withOpacity(0.3),
      blurRadius: 12,
    ),
  ],
)''',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShadowSection extends StatelessWidget {
  const _ShadowSection({
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
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }
}

class _ErrorShadowDemo extends StatefulWidget {
  @override
  State<_ErrorShadowDemo> createState() => _ErrorShadowDemoState();
}

class _ErrorShadowDemoState extends State<_ErrorShadowDemo> {
  final _controller = PinInputController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return MaterialPinField(
      length: 4,
      pinController: _controller,
      theme: MaterialPinTheme(
        shape: MaterialPinShape.outlined,
        cellSize: const Size(56, 64),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        fillColor: colorScheme.surface,
        errorBorderColor: colorScheme.error,
        errorBoxShadows: [
          BoxShadow(
            color: colorScheme.error.withValues(alpha: 0.4),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      onCompleted: (value) {
        if (value == '1111') {
          _controller.triggerError();
        }
      },
    );
  }
}
