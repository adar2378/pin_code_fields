import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// Obscure Text Demo - Password mode with blink effect
class ObscureTextDemo extends StatefulWidget {
  const ObscureTextDemo({super.key});

  @override
  State<ObscureTextDemo> createState() => _ObscureTextDemoState();
}

class _ObscureTextDemoState extends State<ObscureTextDemo> {
  bool _blinkEnabled = true;
  Duration _blinkDuration = const Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Obscure Text')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Password Mode',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Hide entered characters with optional blink effect',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 32),

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
                    length: 4,
                    autoFocus: true,
                    obscureText: true,
                    blinkWhenObscuring: _blinkEnabled,
                    blinkDuration: _blinkDuration,
                    theme: const MaterialPinTheme(
                      shape: MaterialPinShape.outlined,
                      cellSize: Size(56, 64),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      obscuringCharacter: '●',
                    ),
                    onCompleted: (_) {},
                  ),
                  const SizedBox(height: 16),

                  // Blink toggle
                  SwitchListTile(
                    title: const Text('Blink before obscure'),
                    subtitle: const Text('Briefly show character then hide'),
                    value: _blinkEnabled,
                    onChanged: (v) => setState(() => _blinkEnabled = v),
                  ),

                  // Blink duration
                  if (_blinkEnabled) ...[
                    const SizedBox(height: 8),
                    Text('Blink Duration: ${_blinkDuration.inMilliseconds}ms'),
                    Slider(
                      value: _blinkDuration.inMilliseconds.toDouble(),
                      min: 200,
                      max: 1000,
                      divisions: 8,
                      label: '${_blinkDuration.inMilliseconds}ms',
                      onChanged: (v) => setState(
                        () =>
                            _blinkDuration = Duration(milliseconds: v.round()),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Custom obscuring widget
          const Text('Custom Obscuring Widget',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          MaterialPinField(
            length: 4,
            obscureText: true,
            blinkWhenObscuring: true,
            obscuringWidget: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            theme: const MaterialPinTheme(
              shape: MaterialPinShape.outlined,
              cellSize: Size(56, 64),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            onCompleted: (_) {},
          ),
          const SizedBox(height: 32),

          // Different obscuring characters
          const Text('Obscuring Characters',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _ObscuringCharacterExample(
            character: '●',
            label: 'Bullet (default)',
          ),
          const SizedBox(height: 16),
          _ObscuringCharacterExample(
            character: '•',
            label: 'Small dot',
          ),
          const SizedBox(height: 16),
          _ObscuringCharacterExample(
            character: '★',
            label: 'Star',
          ),
          const SizedBox(height: 16),
          _ObscuringCharacterExample(
            character: '■',
            label: 'Square',
          ),
        ],
      ),
    );
  }
}

class _ObscuringCharacterExample extends StatelessWidget {
  const _ObscuringCharacterExample({
    required this.character,
    required this.label,
  });

  final String character;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MaterialPinField(
            length: 4,
            obscureText: true,
            blinkWhenObscuring: false,
            initialValue: '1234',
            theme: MaterialPinTheme(
              shape: MaterialPinShape.outlined,
              cellSize: const Size(44, 52),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              obscuringCharacter: character,
            ),
            onCompleted: (_) {},
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
