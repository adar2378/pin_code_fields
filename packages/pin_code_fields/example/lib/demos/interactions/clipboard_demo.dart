import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// Clipboard Demo - Clipboard detection and paste
class ClipboardDemo extends StatefulWidget {
  const ClipboardDemo({super.key});

  @override
  State<ClipboardDemo> createState() => _ClipboardDemoState();
}

class _ClipboardDemoState extends State<ClipboardDemo> {
  final _pinController = PinInputController();
  String? _detectedCode;

  @override
  void dispose() {
    _pinController.dispose();
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

  void _pasteCode() {
    if (_detectedCode != null) {
      _pinController.setText(_detectedCode!);
      setState(() => _detectedCode = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Clipboard Detection')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Clipboard Detection',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Automatically detect PIN codes in clipboard',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 32),

            // PIN Field
            MaterialPinField(
              length: 6,
              pinController: _pinController,
              autoFocus: true,
              theme: const MaterialPinTheme(
                shape: MaterialPinShape.outlined,
                cellSize: Size(44, 52),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              onClipboardFound: (code) {
                setState(() => _detectedCode = code);
              },
              clipboardValidator: (text, length) {
                // Accept 6-digit codes only
                return text.length == length &&
                    RegExp(r'^[0-9]+$').hasMatch(text);
              },
              onCompleted: (pin) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Completed: $pin')),
                );
              },
            ),
            const SizedBox(height: 16),

            // Detected code prompt
            if (_detectedCode != null)
              Card(
                color: colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.content_paste, color: colorScheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Code found in clipboard',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              _detectedCode!,
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FilledButton(
                        onPressed: _pasteCode,
                        child: const Text('Paste'),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 32),

            // Test codes to copy
            const Text('Try These Codes',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _CopyButton(code: '123456', onCopy: _copyToClipboard),
                _CopyButton(code: '000000', onCopy: _copyToClipboard),
                _CopyButton(code: '987654', onCopy: _copyToClipboard),
              ],
            ),

            const SizedBox(height: 24),

            // Instructions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('How It Works',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      '1. Copy a 6-digit code to clipboard\n'
                      '2. Tap the PIN field to focus it\n'
                      '3. The code is detected and shown\n'
                      '4. Tap "Paste" to auto-fill',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Clear button
            FilledButton.tonal(
              onPressed: () {
                _pinController.clear();
                setState(() => _detectedCode = null);
              },
              child: const Text('Clear'),
            ),
          ],
        ),
      ),
    );
  }
}

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
