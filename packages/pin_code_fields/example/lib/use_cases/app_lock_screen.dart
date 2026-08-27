import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// App Lock Screen - Full-screen PIN lock
///
/// Features demonstrated:
/// - Full-screen immersive UI
/// - Custom obscuring widget (dots)
/// - Subtle animations
/// - Emergency option
/// - Haptic feedback on each digit
class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  final _pinController = PinInputController();

  static const _correctPin = '1234';

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _onPinComplete(String pin) {
    if (pin == _correctPin) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unlocked!'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      _pinController.triggerError();
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _pinController.clear();
        }
      });
    }
  }

  void _showEmergencyOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Emergency Call'),
              subtitle: const Text('Call emergency services'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Emergency call feature'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.medical_services),
              title: const Text('Medical Information'),
              subtitle: const Text('View emergency medical info'),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top bar with close button (for demo purposes)
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  tooltip: 'Exit demo',
                ),
              ),
            ),

            const Spacer(),

            // Lock icon with animation
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (context, value, child) => Transform.scale(
                scale: value,
                child: child,
              ),
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_outline,
                  size: 44,
                  color: colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Title
            Text(
              'Enter Passcode',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1,
                  ),
            ),
            const SizedBox(height: 48),

            // PIN Field - Custom dot style
            MaterialPinField(
              length: 4,
              pinController: _pinController,
              autoFocus: true,
              obscureText: true,
              blinkWhenObscuring: false, // Always obscure for lock screen
              hapticFeedbackType: HapticFeedbackType.light,
              // Custom dot widget for obscuring
              obscuringWidget: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              theme: MaterialPinTheme(
                shape: MaterialPinShape.circle,
                cellSize: const Size(20, 20),
                spacing: 24,
                borderWidth: 2,
                focusedBorderWidth: 2,
                borderColor: colorScheme.outline.withValues(alpha: 0.5),
                focusedBorderColor: colorScheme.primary,
                fillColor: Colors.transparent,
                focusedFillColor: Colors.transparent,
                filledFillColor: Colors.transparent,
                errorBorderColor: colorScheme.error,
                showCursor: false, // No cursor for lock screen
                animationDuration: const Duration(milliseconds: 150),
              ),
              onCompleted: _onPinComplete,
            ),

            const Spacer(),

            // Emergency button
            TextButton.icon(
              onPressed: _showEmergencyOptions,
              icon: Icon(
                Icons.emergency_outlined,
                color: colorScheme.error,
              ),
              label: Text(
                'Emergency',
                style: TextStyle(color: colorScheme.error),
              ),
            ),
            const SizedBox(height: 24),

            // Hint for demo
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'PIN: 1234',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
