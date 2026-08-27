import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// Form Validation - Using PIN fields with Form validation
class FormValidationDemo extends StatefulWidget {
  const FormValidationDemo({super.key});

  @override
  State<FormValidationDemo> createState() => _FormValidationDemoState();
}

class _FormValidationDemoState extends State<FormValidationDemo> {
  final _pinController = PinInputController();
  String? _submittedValue;
  String? _validationError;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  String? _validatePin(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a PIN';
    }
    if (value.length < 4) {
      return 'PIN must be 4 digits';
    }
    if (value == '0000') {
      return 'PIN cannot be 0000';
    }
    return null;
  }

  void _handleSubmit() {
    final error = _validatePin(_pinController.text);
    setState(() {
      _validationError = error;
    });

    if (error == null) {
      setState(() {
        _submittedValue = _pinController.text;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Form submitted with PIN: $_submittedValue'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      _pinController.triggerError();
    }
  }

  void _handleReset() {
    _pinController.clear();
    setState(() {
      _submittedValue = null;
      _validationError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Form Validation')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Form Validation',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Validate PIN input with custom rules',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 32),

            // Validation rules
            Card(
              color: colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Validation Rules',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('• Must be exactly 4 digits'),
                    const Text('• Cannot be "0000"'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // PIN Field with error text
            Text(
              'Using errorText',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'MaterialPinField with built-in error display',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),

            Center(
              child: MaterialPinField(
                length: 4,
                pinController: _pinController,
                theme: MaterialPinTheme(
                  shape: MaterialPinShape.outlined,
                  cellSize: const Size(56, 64),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  focusedBorderColor: colorScheme.primary,
                  errorBorderColor: colorScheme.error,
                ),
                errorText: _validationError,
                onChanged: (_) {
                  // Clear error when user types
                  if (_validationError != null) {
                    setState(() => _validationError = null);
                  }
                },
                onCompleted: (_) => _handleSubmit(),
              ),
            ),
            const SizedBox(height: 32),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: _handleReset,
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 16),
                FilledButton(
                  onPressed: _handleSubmit,
                  child: const Text('Validate'),
                ),
              ],
            ),

            if (_submittedValue != null) ...[
              const SizedBox(height: 32),
              Card(
                color: colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Valid PIN: $_submittedValue',
                        style: TextStyle(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 48),

            // Code example
            Text(
              'Usage Example',
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
                '''MaterialPinField(
  length: 4,
  pinController: controller,
  errorText: validationError,
  onChanged: (_) {
    // Clear error on input
    setState(() => validationError = null);
  },
  onCompleted: (value) {
    // Validate and submit
    final error = validatePin(value);
    if (error != null) {
      controller.triggerError();
      setState(() => validationError = error);
    } else {
      submitForm(value);
    }
  },
)''',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Note about PinInputFormField
            Card(
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
                          'Advanced: PinInputFormField',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'For full Flutter Form integration with validator and onSaved, '
                      'use PinInputFormField with a custom builder:',
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '''PinInputFormField(
  length: 4,
  pinBuilder: (context, cells) =>
    MaterialPinRow(cells: cells, theme: theme),
  validator: (value) => ...,
  onSaved: (value) => ...,
)''',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                        ),
                      ),
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
