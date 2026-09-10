import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// Autofill Demo - SMS autofill and keyboard suggestions
class AutofillDemo extends StatelessWidget {
  const AutofillDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Autofill & SMS')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Autofill Support',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enable SMS autofill and keyboard suggestions',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 32),

          // OTP Autofill
          _AutofillSection(
            title: 'OTP / One-Time Code',
            description:
                'Best for SMS verification codes. iOS and Android will '
                'suggest codes from recent SMS messages.',
            child: MaterialPinField(
              length: 6,
              enableAutofill: true,
              autofillHints: const [AutofillHints.oneTimeCode],
              theme: MaterialPinTheme(
                shape: MaterialPinShape.outlined,
                cellSize: const Size(48, 56),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                focusedBorderColor: colorScheme.primary,
              ),
              onCompleted: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('OTP received: $value'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),

          // Password/PIN Autofill
          _AutofillSection(
            title: 'Password / PIN',
            description:
                'For PIN codes that might be saved in password managers.',
            child: MaterialPinField(
              length: 4,
              obscureText: true,
              enableAutofill: true,
              autofillHints: const [AutofillHints.password],
              theme: MaterialPinTheme(
                shape: MaterialPinShape.filled,
                cellSize: const Size(56, 64),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                focusedBorderColor: colorScheme.primary,
              ),
              onCompleted: (_) {},
            ),
          ),
          const SizedBox(height: 32),

          // No Autofill
          _AutofillSection(
            title: 'Autofill Disabled',
            description:
                'For sensitive fields where autofill should be prevented.',
            child: MaterialPinField(
              length: 4,
              enableAutofill: false,
              theme: MaterialPinTheme(
                shape: MaterialPinShape.outlined,
                cellSize: const Size(56, 64),
                borderColor: colorScheme.outline,
                focusedBorderColor: colorScheme.primary,
              ),
              onCompleted: (_) {},
            ),
          ),
          const SizedBox(height: 32),

          // Info card
          Card(
            color: colorScheme.surfaceContainerHighest,
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
                        'How it works',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    icon: Icons.phone_android,
                    title: 'iOS',
                    description:
                        'Shows "From Messages" suggestion above keyboard',
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.android,
                    title: 'Android',
                    description:
                        'Uses SMS Retriever API for automatic code detection',
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.password,
                    title: 'Password Managers',
                    description:
                        'Can suggest saved PINs when using password hint',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Common autofill hints
          Text(
            'Common Autofill Hints',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HintRow('AutofillHints.oneTimeCode', 'SMS/OTP codes'),
                _HintRow('AutofillHints.password', 'Saved passwords/PINs'),
                _HintRow('AutofillHints.newPassword', 'Creating new PIN'),
                _HintRow('AutofillHints.creditCardNumber', 'Card numbers'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AutofillSection extends StatelessWidget {
  const _AutofillSection({
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
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon,
            size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
              children: [
                TextSpan(
                  text: '$title: ',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                TextSpan(text: description),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HintRow extends StatelessWidget {
  const _HintRow(this.hint, this.description);

  final String hint;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              hint,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
