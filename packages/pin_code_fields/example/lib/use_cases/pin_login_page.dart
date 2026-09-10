import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// PIN Login - Authenticate with PIN
///
/// Features demonstrated:
/// - Obscured PIN entry
/// - Maximum attempts tracking
/// - Error shake animation
/// - Biometric hint button
/// - Forgot PIN option
/// - Account lockout warning
class PinLoginPage extends StatefulWidget {
  const PinLoginPage({super.key});

  @override
  State<PinLoginPage> createState() => _PinLoginPageState();
}

class _PinLoginPageState extends State<PinLoginPage> {
  final _pinController = PinInputController();

  static const _maxAttempts = 5;
  static const _correctPin = '1234';

  int _attempts = 0;
  bool _isLocked = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _onPinComplete(String pin) {
    if (_isLocked) return;

    if (pin == _correctPin) {
      _showSuccessDialog();
    } else {
      setState(() => _attempts++);
      _pinController.triggerError();

      // Clear after error animation
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          _pinController.clear();
        }
      });

      // Check if locked
      if (_attempts >= _maxAttempts) {
        setState(() => _isLocked = true);
        _showLockedDialog();
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.lock_open, color: Colors.green, size: 64),
        title: const Text('Welcome!'),
        content: const Text('You have successfully logged in.'),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showLockedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.lock, color: Colors.red, size: 64),
        title: const Text('Account Locked'),
        content: const Text(
          'Too many incorrect attempts. '
          'Please try again later or use biometric authentication.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Go Back'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _useBiometric();
            },
            child: const Text('Use Fingerprint'),
          ),
        ],
      ),
    );
  }

  void _useBiometric() {
    // Simulate biometric success
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Biometric authentication would be triggered here'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _forgotPin() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Forgot PIN?'),
        content: const Text(
          'To reset your PIN, you\'ll need to verify your identity '
          'using your email or phone number.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Reset link sent to your email'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Reset PIN'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final remainingAttempts = _maxAttempts - _attempts;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),

                // Avatar
                CircleAvatar(
                  radius: 48,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person,
                    size: 48,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  'Welcome back!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),

                Text(
                  'Enter your PIN to continue',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 48),

                // PIN Field
                MaterialPinField(
                  length: 4,
                  pinController: _pinController,
                  autoFocus: true,
                  enabled: !_isLocked,
                  obscureText: true,
                  theme: MaterialPinTheme(
                    shape: MaterialPinShape.circle,
                    cellSize: const Size(56, 56),
                    borderWidth: 2,
                    focusedBorderWidth: 3,
                    obscuringCharacter: '●',
                    textStyle: const TextStyle(fontSize: 24),
                    fillColor: colorScheme.surfaceContainerHighest,
                    focusedFillColor: colorScheme.primaryContainer,
                    filledFillColor: colorScheme.primaryContainer,
                  ),
                  onCompleted: _onPinComplete,
                ),
                const SizedBox(height: 24),

                // Attempts warning
                if (_attempts > 0 && !_isLocked)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: remainingAttempts <= 2
                          ? colorScheme.errorContainer
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 18,
                          color: remainingAttempts <= 2
                              ? colorScheme.error
                              : colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$remainingAttempts attempts remaining',
                          style: TextStyle(
                            color: remainingAttempts <= 2
                                ? colorScheme.error
                                : colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                const Spacer(),

                // Biometric button
                OutlinedButton.icon(
                  onPressed: _isLocked ? null : _useBiometric,
                  icon: const Icon(Icons.fingerprint),
                  label: const Text('Use Fingerprint'),
                ),
                const SizedBox(height: 12),

                // Forgot PIN
                TextButton(
                  onPressed: _forgotPin,
                  child: const Text('Forgot PIN?'),
                ),

                const SizedBox(height: 24),

                // Hint
                Text(
                  'Hint: PIN is 1234',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.outline,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
