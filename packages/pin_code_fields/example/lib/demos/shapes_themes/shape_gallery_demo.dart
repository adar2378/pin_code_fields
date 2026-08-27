import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// Shape Gallery - All 4 shapes side-by-side
class ShapeGalleryDemo extends StatelessWidget {
  const ShapeGalleryDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shape Gallery')),
      body: SizedBox(
        width: double.infinity,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: const [
            _ShapeSection(
              title: 'Outlined',
              description: 'Classic bordered style',
              shape: MaterialPinShape.outlined,
            ),
            SizedBox(height: 32),
            _ShapeSection(
              title: 'Filled',
              description: 'Solid background without border',
              shape: MaterialPinShape.filled,
            ),
            SizedBox(height: 32),
            _ShapeSection(
              title: 'Underlined',
              description: 'Minimalist bottom border only',
              shape: MaterialPinShape.underlined,
            ),
            SizedBox(height: 32),
            _ShapeSection(
              title: 'Circle',
              description: 'Round cells for a softer look',
              shape: MaterialPinShape.circle,
            ),
          ],
        ),
      ),
    );
  }
}

class _ShapeSection extends StatelessWidget {
  const _ShapeSection({
    required this.title,
    required this.description,
    required this.shape,
  });

  final String title;
  final String description;
  final MaterialPinShape shape;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 16),
        MaterialPinField(
          length: 4,
          theme: MaterialPinTheme(
            shape: shape,
            cellSize: const Size(56, 64),
          ),
          onCompleted: (_) {},
        ),
      ],
    );
  }
}
