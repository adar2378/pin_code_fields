import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// Basic Usage - Simplest example
class BasicDemo extends StatefulWidget {
  const BasicDemo({super.key});

  @override
  State<BasicDemo> createState() => _BasicDemoState();
}

class _BasicDemoState extends State<BasicDemo> {
  String _enteredPin = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basic Usage')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text(
                'Enter PIN',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'The simplest MaterialPinField example',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),

              // The simplest usage!
              MaterialPinField(
                length: 6,
                onChanged: (value) => setState(() => _enteredPin = value),
                onCompleted: (pin) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Completed: $pin')),
                  );
                },
              ),

              const SizedBox(height: 24),
              Text('Entered: $_enteredPin'),
              const SizedBox(height: 48),

              // Code snippet
              _CodeSnippet(
                code: '''
MaterialPinField(
  length: 6,
  onChanged: (value) => print(value),
  onCompleted: (pin) => print('Completed: \$pin'),
)''',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CodeSnippet extends StatelessWidget {
  const _CodeSnippet({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        code,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
