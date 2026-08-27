import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// Invite/Referral Code - Alphanumeric code input
///
/// Features demonstrated:
/// - Alphanumeric keyboard
/// - Text capitalization
/// - Custom validator
/// - Hint characters
/// - Success discount UI
class InviteCodePage extends StatefulWidget {
  const InviteCodePage({super.key});

  @override
  State<InviteCodePage> createState() => _InviteCodePageState();
}

class _InviteCodePageState extends State<InviteCodePage> {
  final _pinController = PinInputController();

  bool _isValidating = false;
  bool _isApplied = false;
  String? _discount;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _validateCode(String code) async {
    setState(() => _isValidating = true);

    // Simulate API validation
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    // Simulate valid codes
    final validCodes = {
      'SAVE20': '20%',
      'FRIEND': '15%',
      'WELCOME': '10%',
    };

    final upperCode = code.toUpperCase();
    if (validCodes.containsKey(upperCode)) {
      setState(() {
        _isValidating = false;
        _isApplied = true;
        _discount = validCodes[upperCode];
      });
    } else {
      setState(() => _isValidating = false);
      _pinController.triggerError();

      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          _pinController.clear();
        }
      });
    }
  }

  void _removeCode() {
    setState(() {
      _isApplied = false;
      _discount = null;
    });
    _pinController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Invite Code'),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),

                // Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: _isApplied
                        ? Colors.green.withValues(alpha: 0.1)
                        : colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isApplied ? Icons.celebration : Icons.card_giftcard,
                    size: 40,
                    color: _isApplied ? Colors.green : colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  _isApplied ? 'Code Applied!' : 'Have an invite code?',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  _isApplied
                      ? 'You\'ll get $_discount off your first order'
                      : 'Enter your 6-character invite code',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Applied success card
                if (_isApplied)
                  Card(
                    color: Colors.green.withValues(alpha: 0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.discount,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$_discount Discount',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.green,
                                  ),
                                ),
                                Text(
                                  'Applied to your order',
                                  style: TextStyle(
                                    color: Colors.green.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.green),
                            onPressed: _removeCode,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  // PIN Field for code entry
                  MaterialPinField(
                    length: 6,
                    pinController: _pinController,
                    autoFocus: true,
                    enabled: !_isValidating,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    hintCharacter: '-',
                    theme: MaterialPinTheme(
                      shape: MaterialPinShape.outlined,
                      cellSize: const Size(48, 56),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      borderWidth: 1.5,
                      focusedBorderWidth: 2,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                      hintStyle: TextStyle(
                        color: colorScheme.outline,
                        fontSize: 20,
                      ),
                    ),
                    errorText: 'Invalid code. Please try again.',
                    onCompleted: _validateCode,
                  ),

                const SizedBox(height: 24),

                // Loading indicator
                if (_isValidating)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Validating code...',
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),

                const Spacer(flex: 2),

                // Skip button
                if (!_isApplied)
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Skip for now'),
                  ),

                // Continue button when applied
                if (_isApplied)
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('Continue'),
                  ),

                const SizedBox(height: 16),

                // Hint
                Text(
                  'Try: SAVE20, FRIEND, or WELCOME',
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
