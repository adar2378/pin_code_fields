import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// Custom Cursor - Different cursor styles
class CustomCursorDemo extends StatelessWidget {
  const CustomCursorDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Custom Cursor')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Cursor Styles',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Customize how the cursor looks when focused',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 32),

          // Default line cursor
          _CursorSection(
            title: 'Default Line Cursor',
            description: 'Standard blinking vertical line',
            child: MaterialPinField(
              length: 4,
              theme: const MaterialPinTheme(
                shape: MaterialPinShape.outlined,
                cellSize: Size(56, 64),
                cursorWidth: 2,
                cursorColor: Colors.indigo,
                animateCursor: true,
              ),
              onCompleted: (_) {},
            ),
          ),
          const SizedBox(height: 32),

          // Underscore cursor
          _CursorSection(
            title: 'Underscore Cursor',
            description: 'Horizontal line at the bottom',
            child: MaterialPinField(
              length: 4,
              theme: MaterialPinTheme(
                shape: MaterialPinShape.outlined,
                cellSize: const Size(56, 64),
                cursorAlignment: Alignment.bottomCenter,
                cursorWidget: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    width: 24,
                    height: 3,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              onCompleted: (_) {},
            ),
          ),
          const SizedBox(height: 32),

          // Dot cursor
          _CursorSection(
            title: 'Dot Cursor',
            description: 'Small pulsing dot',
            child: MaterialPinField(
              length: 4,
              theme: MaterialPinTheme(
                shape: MaterialPinShape.outlined,
                cellSize: const Size(56, 64),
                cursorWidget: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              onCompleted: (_) {},
            ),
          ),
          const SizedBox(height: 32),

          // No cursor
          _CursorSection(
            title: 'No Cursor',
            description: 'Clean look without any cursor',
            child: MaterialPinField(
              length: 4,
              theme: const MaterialPinTheme(
                shape: MaterialPinShape.filled,
                cellSize: Size(56, 64),
                showCursor: false,
              ),
              onCompleted: (_) {},
            ),
          ),
        ],
      ),
    );
  }
}

class _CursorSection extends StatelessWidget {
  const _CursorSection({
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
