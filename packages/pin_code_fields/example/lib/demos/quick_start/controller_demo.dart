import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// Controller Usage - Programmatic control
class ControllerDemo extends StatefulWidget {
  const ControllerDemo({super.key});

  @override
  State<ControllerDemo> createState() => _ControllerDemoState();
}

class _ControllerDemoState extends State<ControllerDemo> {
  final _pinController = PinInputController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Controller Usage')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'PinInputController',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Programmatic control over the PIN field',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 32),

            MaterialPinField(
              length: 4,
              pinController: _pinController,
              autoFocus: true,
              theme: const MaterialPinTheme(
                shape: MaterialPinShape.outlined,
                cellSize: Size(56, 64),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              errorText: 'Error triggered via controller',
            ),
            const SizedBox(height: 24),

            // Current state display
            ListenableBuilder(
              listenable: _pinController,
              builder: (context, _) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Current State',
                            style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 8),
                        _StateRow('text', '"${_pinController.text}"'),
                        _StateRow('hasError', '${_pinController.hasError}'),
                        _StateRow('hasFocus', '${_pinController.hasFocus}'),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Control buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                FilledButton.tonal(
                  onPressed: () => _pinController.setText('1234'),
                  child: const Text('Set "1234"'),
                ),
                FilledButton.tonal(
                  onPressed: () => _pinController.clear(),
                  child: const Text('Clear'),
                ),
                FilledButton.tonal(
                  onPressed: () => _pinController.triggerError(),
                  child: const Text('Trigger Error'),
                ),
                FilledButton.tonal(
                  onPressed: () => _pinController.clearError(),
                  child: const Text('Clear Error'),
                ),
                FilledButton.tonal(
                  onPressed: () => _pinController.requestFocus(),
                  child: const Text('Focus'),
                ),
                FilledButton.tonal(
                  onPressed: () => _pinController.unfocus(),
                  child: const Text('Unfocus'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StateRow extends StatelessWidget {
  const _StateRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
