import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// Demo showing how to use MaterialPinThemeExtension for app-wide theming
class AppWideThemingDemo extends StatelessWidget {
  const AppWideThemingDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App-Wide Theming'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _InfoCard(
            title: 'Theme Extension',
            description:
                'This demo uses a MaterialPinThemeExtension registered in the app\'s ThemeData. '
                'MaterialPinField automatically uses the global theme when no explicit theme is provided.',
            icon: Icons.palette,
          ),
          const SizedBox(height: 24),

          _SectionTitle('Using Theme.of(context).materialPinTheme'),
          const SizedBox(height: 16),

          // Example 1: Using the global theme from ThemeData
          _ExampleCard(
            title: 'Global Theme',
            description:
                'This field automatically uses the theme from ThemeData (no explicit theme parameter)',
            child: const _PinFieldFromTheme(),
          ),

          const SizedBox(height: 24),

          _SectionTitle('Override with Explicit Theme'),
          const SizedBox(height: 16),

          // Example 2: Overriding with explicit theme
          _ExampleCard(
            title: 'Custom Theme Override',
            description: 'This field overrides the global theme',
            child: MaterialPinField(
              length: 4,
              theme: const MaterialPinTheme(
                shape: MaterialPinShape.filled,
                cellSize: Size(50, 60),
                spacing: 8,
                fillColor: Colors.amber,
                focusedFillColor: Colors.orange,
              ),
              onCompleted: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('PIN: $value')),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          _SectionTitle('Code Example'),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '// In your MaterialApp:',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  'MaterialApp(',
                  style: TextStyle(fontFamily: 'monospace'),
                ),
                Text(
                  '  theme: ThemeData(',
                  style: TextStyle(fontFamily: 'monospace'),
                ),
                Text(
                  '    extensions: const [',
                  style: TextStyle(fontFamily: 'monospace'),
                ),
                Text(
                  '      MaterialPinThemeExtension(',
                  style: TextStyle(fontFamily: 'monospace'),
                ),
                Text(
                  '        theme: MaterialPinTheme(...),',
                  style: TextStyle(fontFamily: 'monospace'),
                ),
                Text(
                  '      ),',
                  style: TextStyle(fontFamily: 'monospace'),
                ),
                Text(
                  '    ],',
                  style: TextStyle(fontFamily: 'monospace'),
                ),
                Text(
                  '  ),',
                  style: TextStyle(fontFamily: 'monospace'),
                ),
                Text(''),
                Text(
                  '// In your widget (automatic theme usage):',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  'MaterialPinField(',
                  style: TextStyle(fontFamily: 'monospace'),
                ),
                Text(
                  '  length: 6,',
                  style: TextStyle(fontFamily: 'monospace'),
                ),
                Text(
                  '  // No theme parameter - uses ThemeData automatically',
                  style: TextStyle(fontFamily: 'monospace'),
                ),
                Text(
                  ')',
                  style: TextStyle(fontFamily: 'monospace'),
                ),
                Text(''),
                Text(
                  '// Or explicitly access the theme:',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  'final pinTheme = Theme.of(context).materialPinTheme;',
                  style: TextStyle(fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PinFieldFromTheme extends StatelessWidget {
  const _PinFieldFromTheme();

  @override
  Widget build(BuildContext context) {
    // This field automatically uses the theme from ThemeData
    // because no explicit theme parameter is provided
    return MaterialPinField(
      length: 6,
      onCompleted: (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PIN: $value')),
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
