import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// Custom Input Formatters Demo — whitespace removal & uppercase conversion.
class CustomFormattersDemo extends StatefulWidget {
  const CustomFormattersDemo({super.key});

  @override
  State<CustomFormattersDemo> createState() => _CustomFormattersDemoState();
}

class _CustomFormattersDemoState extends State<CustomFormattersDemo> {
  final _numericController = PinInputController();
  final _alphaController = PinInputController();

  @override
  void dispose() {
    _numericController.dispose();
    _alphaController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied "$text" to clipboard'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Custom Input Formatters')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Section 1: Whitespace Removal ──────────────────────
            Text(
              'Whitespace Removal',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Paste codes with spaces — the formatter strips whitespace '
              'before the length limit is applied.',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),

            Center(
              child: MaterialPinField(
                length: 6,
                pinController: _numericController,
                autoFocus: true,
                inputFormatters: [_WhitespaceRemovingFormatter()],
                theme: const MaterialPinTheme(
                  shape: MaterialPinShape.outlined,
                  cellSize: Size(44, 52),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                onCompleted: (pin) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Completed: $pin')),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            const Text('Copy a test value:',
                style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _CopyButton(code: '12 34 56', onCopy: _copyToClipboard),
                _CopyButton(code: '1 2 3 4 5 6', onCopy: _copyToClipboard),
                _CopyButton(code: '123 456', onCopy: _copyToClipboard),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: FilledButton.tonal(
                onPressed: () => _numericController.clear(),
                child: const Text('Clear'),
              ),
            ),

            const Divider(height: 48),

            // ── Section 2: Uppercase Conversion ────────────────────
            Text(
              'Uppercase Conversion',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Type lowercase letters — they are automatically uppercased.',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),

            Center(
              child: MaterialPinField(
                length: 6,
                pinController: _alphaController,
                keyboardType: TextInputType.text,
                inputFormatters: [_UppercaseFormatter()],
                theme: const MaterialPinTheme(
                  shape: MaterialPinShape.outlined,
                  cellSize: Size(44, 52),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                onCompleted: (pin) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Completed: $pin')),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: FilledButton.tonal(
                onPressed: () => _alphaController.clear(),
                child: const Text('Clear'),
              ),
            ),

            const Divider(height: 48),

            // ── Code example card ──────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Formatter Implementation',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const SelectableText(
                        'class WhitespaceRemovingFormatter\n'
                        '    extends TextInputFormatter {\n'
                        '  @override\n'
                        '  TextEditingValue formatEditUpdate(\n'
                        '    TextEditingValue oldValue,\n'
                        '    TextEditingValue newValue,\n'
                        '  ) {\n'
                        '    final stripped =\n'
                        '        newValue.text.replaceAll(\n'
                        '            RegExp(r\'\\s\'), \'\');\n'
                        '    return newValue.copyWith(\n'
                        '      text: stripped,\n'
                        '      selection: TextSelection.collapsed(\n'
                        '          offset: stripped.length),\n'
                        '    );\n'
                        '  }\n'
                        '}',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
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

// ── Formatters ─────────────────────────────────────────────────────────────

/// Strips all whitespace so pasted codes like "12 34 56" become "123456".
class _WhitespaceRemovingFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final stripped = newValue.text.replaceAll(RegExp(r'\s'), '');
    return newValue.copyWith(
      text: stripped,
      selection: TextSelection.collapsed(offset: stripped.length),
    );
  }
}

/// Converts all characters to uppercase.
class _UppercaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final upper = newValue.text.toUpperCase();
    return newValue.copyWith(
      text: upper,
      selection: TextSelection.collapsed(offset: upper.length),
    );
  }
}

// ── Helper widgets ─────────────────────────────────────────────────────────

class _CopyButton extends StatelessWidget {
  const _CopyButton({
    required this.code,
    required this.onCopy,
  });

  final String code;
  final ValueChanged<String> onCopy;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => onCopy(code),
      icon: const Icon(Icons.copy, size: 16),
      label: Text(code),
    );
  }
}
