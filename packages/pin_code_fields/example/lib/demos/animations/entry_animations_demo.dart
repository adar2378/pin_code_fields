import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// Entry Animations - Compare all animation types
class EntryAnimationsDemo extends StatefulWidget {
  const EntryAnimationsDemo({super.key});

  @override
  State<EntryAnimationsDemo> createState() => _EntryAnimationsDemoState();
}

class _EntryAnimationsDemoState extends State<EntryAnimationsDemo> {
  MaterialPinAnimation _selectedAnimation = MaterialPinAnimation.scale;
  final _pinController = PinInputController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entry Animations')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Character Entry Animation',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'See how characters animate when typed',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            // PIN Field
            MaterialPinField(
              length: 4,
              pinController: _pinController,
              autoFocus: true,
              theme: MaterialPinTheme(
                shape: MaterialPinShape.outlined,
                cellSize: const Size(56, 64),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                entryAnimation: _selectedAnimation,
                animationDuration: const Duration(milliseconds: 200),
              ),
              onCompleted: (_) {},
            ),
            const SizedBox(height: 24),

            // Reset button
            FilledButton.tonal(
              onPressed: () => _pinController.clear(),
              child: const Text('Clear & Try Again'),
            ),
            const SizedBox(height: 32),

            // Animation selector
            const Text('Select Animation:',
                style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),

            RadioGroup<MaterialPinAnimation>(
              groupValue: _selectedAnimation,
              onChanged: (value) {
                if (value == null) return;
                setState(() => _selectedAnimation = value);
                _pinController.clear();
              },
              child: Column(
                children: MaterialPinAnimation.values.map((anim) {
                  return RadioListTile<MaterialPinAnimation>(
                    title: Text(_animationName(anim)),
                    subtitle: Text(_animationDescription(anim)),
                    value: anim,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _animationName(MaterialPinAnimation anim) {
    return switch (anim) {
      MaterialPinAnimation.scale => 'Scale',
      MaterialPinAnimation.fade => 'Fade',
      MaterialPinAnimation.slide => 'Slide',
      MaterialPinAnimation.none => 'None',
      MaterialPinAnimation.custom => 'Custom',
    };
  }

  String _animationDescription(MaterialPinAnimation anim) {
    return switch (anim) {
      MaterialPinAnimation.scale => 'Characters pop in with scale effect',
      MaterialPinAnimation.fade => 'Characters fade in smoothly',
      MaterialPinAnimation.slide => 'Characters slide up into place',
      MaterialPinAnimation.none => 'No animation, instant appearance',
      MaterialPinAnimation.custom => 'Use customEntryAnimationBuilder',
    };
  }
}
