import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// PIN Setup Flow - Two-step PIN creation
///
/// Features demonstrated:
/// - Multi-step flow (create → confirm)
/// - PIN comparison validation
/// - Error handling for mismatch
/// - Success animation
/// - Clear on error
class PinSetupFlow extends StatefulWidget {
  const PinSetupFlow({super.key});

  @override
  State<PinSetupFlow> createState() => _PinSetupFlowState();
}

class _PinSetupFlowState extends State<PinSetupFlow> {
  final _createController = PinInputController();
  final _confirmController = PinInputController();
  final _pageController = PageController();

  int _currentStep = 0;
  String? _createdPin;
  bool _isSuccess = false;

  @override
  void dispose() {
    _createController.dispose();
    _confirmController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onCreateComplete(String pin) {
    _createdPin = pin;
    setState(() => _currentStep = 1);
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onConfirmComplete(String pin) {
    if (pin == _createdPin) {
      setState(() => _isSuccess = true);
      _showSuccessDialog();
    } else {
      _confirmController.triggerError();
      // Clear after a short delay so user sees the error
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          _confirmController.clear();
        }
      });
    }
  }

  void _goBack() {
    if (_currentStep == 1) {
      setState(() => _currentStep = 0);
      _confirmController.clear();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 64),
        title: const Text('PIN Created!'),
        content: const Text(
          'Your PIN has been set up successfully. '
          'You can now use it to secure your app.',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to home
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBack,
        ),
        title: const Text('Set Up PIN'),
      ),
      body: Column(
        children: [
          // Step indicator
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                _StepIndicator(
                  step: 1,
                  label: 'Create',
                  isActive: _currentStep >= 0,
                  isComplete: _currentStep > 0,
                ),
                Expanded(
                  child: Container(
                    height: 2,
                    color: _currentStep > 0
                        ? colorScheme.primary
                        : colorScheme.outlineVariant,
                  ),
                ),
                _StepIndicator(
                  step: 2,
                  label: 'Confirm',
                  isActive: _currentStep >= 1,
                  isComplete: _isSuccess,
                ),
              ],
            ),
          ),

          // Pages
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _CreatePinPage(
                  controller: _createController,
                  onComplete: _onCreateComplete,
                ),
                _ConfirmPinPage(
                  controller: _confirmController,
                  onComplete: _onConfirmComplete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({
    required this.step,
    required this.label,
    required this.isActive,
    required this.isComplete,
  });

  final int step;
  final String label;
  final bool isActive;
  final bool isComplete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isComplete
                ? colorScheme.primary
                : isActive
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceContainerHighest,
            border: Border.all(
              color: isActive ? colorScheme.primary : colorScheme.outline,
              width: 2,
            ),
          ),
          child: Center(
            child: isComplete
                ? Icon(Icons.check, size: 18, color: colorScheme.onPrimary)
                : Text(
                    '$step',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isActive
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isActive
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
        ),
      ],
    );
  }
}

class _CreatePinPage extends StatelessWidget {
  const _CreatePinPage({
    required this.controller,
    required this.onComplete,
  });

  final PinInputController controller;
  final ValueChanged<String> onComplete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Icon(
            Icons.pin_outlined,
            size: 64,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'Create your PIN',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a 4-digit PIN to secure your account',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          MaterialPinField(
            length: 4,
            pinController: controller,
            autoFocus: true,
            obscureText: true,
            blinkWhenObscuring: true,
            theme: MaterialPinTheme(
              shape: MaterialPinShape.outlined,
              cellSize: const Size(64, 72),
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              borderWidth: 2,
              focusedBorderWidth: 2.5,
              obscuringCharacter: '●',
            ),
            onCompleted: onComplete,
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

class _ConfirmPinPage extends StatelessWidget {
  const _ConfirmPinPage({
    required this.controller,
    required this.onComplete,
  });

  final PinInputController controller;
  final ValueChanged<String> onComplete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Icon(
            Icons.lock_outline,
            size: 64,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'Confirm your PIN',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Re-enter your PIN to confirm',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          MaterialPinField(
            length: 4,
            pinController: controller,
            autoFocus: true,
            obscureText: true,
            theme: MaterialPinTheme(
              shape: MaterialPinShape.outlined,
              cellSize: const Size(64, 72),
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              borderWidth: 2,
              focusedBorderWidth: 2.5,
              obscuringCharacter: '●',
            ),
            errorText: 'PINs don\'t match. Try again.',
            onCompleted: onComplete,
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
