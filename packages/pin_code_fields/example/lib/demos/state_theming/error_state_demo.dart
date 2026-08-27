import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// Error State Demo - Error handling and display
class ErrorStateDemo extends StatefulWidget {
  const ErrorStateDemo({super.key});

  @override
  State<ErrorStateDemo> createState() => _ErrorStateDemoState();
}

class _ErrorStateDemoState extends State<ErrorStateDemo> {
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
      appBar: AppBar(title: const Text('Error Handling')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Error State & Shake',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter wrong PIN (not 1234) to see error',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 32),

            // PIN Field with error styling
            MaterialPinField(
              length: 4,
              pinController: _pinController,
              autoFocus: true,
              theme: MaterialPinTheme(
                shape: MaterialPinShape.outlined,
                cellSize: const Size(56, 64),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                // Error state theming
                errorColor: colorScheme.error,
                errorFillColor:
                    colorScheme.errorContainer.withValues(alpha: 0.3),
                errorBorderColor: colorScheme.error,
                errorBorderWidth: 2,
                errorTextStyle: TextStyle(
                  color: colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Custom error builder
              errorBuilder: (errorText) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, color: colorScheme.error, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    errorText ?? 'Error',
                    style: TextStyle(color: colorScheme.error),
                  ),
                ],
              ),
              errorText: 'Incorrect PIN. Try 1234.',
              onCompleted: (pin) {
                if (pin == '1234') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Correct PIN!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  _pinController.triggerError();
                }
              },
            ),
            const SizedBox(height: 32),

            // Control buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                FilledButton.tonal(
                  onPressed: () => _pinController.triggerError(),
                  child: const Text('Trigger Error'),
                ),
                FilledButton.tonal(
                  onPressed: () => _pinController.clearError(),
                  child: const Text('Clear Error'),
                ),
                FilledButton.tonal(
                  onPressed: () => _pinController.clear(),
                  child: const Text('Clear All'),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Features list
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Error Features',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _FeatureItem(
                      icon: Icons.vibration,
                      title: 'Shake Animation',
                      description: 'Cells shake on error',
                    ),
                    _FeatureItem(
                      icon: Icons.palette,
                      title: 'Custom Colors',
                      description: 'Error fill, border, text colors',
                    ),
                    _FeatureItem(
                      icon: Icons.widgets,
                      title: 'Error Builder',
                      description: 'Custom error widget below field',
                    ),
                    _FeatureItem(
                      icon: Icons.auto_fix_high,
                      title: 'Auto Clear',
                      description: 'Error clears when typing',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
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
