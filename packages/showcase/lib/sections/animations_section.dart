import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../components/code_block.dart';
import '../components/section_title.dart';
import '../layout/responsive.dart';
import '../layout/section_wrapper.dart';

/// Showcases entry animations and error shake.
class AnimationsSection extends StatefulWidget {
  const AnimationsSection({super.key, this.sectionKey});

  final GlobalKey? sectionKey;

  @override
  State<AnimationsSection> createState() => _AnimationsSectionState();
}

class _AnimationsSectionState extends State<AnimationsSection> {
  final _scaleCtrl = PinInputController();
  final _fadeCtrl = PinInputController();
  final _slideCtrl = PinInputController();
  final _errorCtrl = PinInputController();

  @override
  void dispose() {
    _scaleCtrl.dispose();
    _fadeCtrl.dispose();
    _slideCtrl.dispose();
    _errorCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bp = getBreakpoint(context);
    final isMobile = bp == Breakpoint.mobile;

    return SectionWrapper(
      sectionKey: widget.sectionKey,
      child: Column(
        children: [
          const SectionTitle(
            title: 'Smooth Animations',
            subtitle: 'Delightful entry transitions and error feedback',
          ),

          // Entry animations row
          Wrap(
            spacing: 24,
            runSpacing: 32,
            alignment: WrapAlignment.center,
            children: [
              _AnimationDemo(
                label: 'Scale',
                animation: MaterialPinAnimation.scale,
                controller: _scaleCtrl,
                isMobile: isMobile,
              ),
              _AnimationDemo(
                label: 'Fade',
                animation: MaterialPinAnimation.fade,
                controller: _fadeCtrl,
                isMobile: isMobile,
              ),
              _AnimationDemo(
                label: 'Slide',
                animation: MaterialPinAnimation.slide,
                controller: _slideCtrl,
                isMobile: isMobile,
              ),
            ],
          ),
          const SizedBox(height: 48),

          // Error shake demo
          _ErrorShakeDemo(controller: _errorCtrl),
          const SizedBox(height: 32),

          // Code snippet
          const CodeBlock(
            code: '''MaterialPinField(
  length: 6,
  theme: MaterialPinTheme(
    entryAnimation: MaterialPinAnimation.scale,
    animationDuration: Duration(milliseconds: 150),
  ),
)

// Trigger error shake:
controller.triggerError();''',
          ),
        ],
      ),
    );
  }
}

class _AnimationDemo extends StatelessWidget {
  const _AnimationDemo({
    required this.label,
    required this.animation,
    required this.controller,
    required this.isMobile,
  });

  final String label;
  final MaterialPinAnimation animation;
  final PinInputController controller;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: isMobile ? double.infinity : 280,
          child: MaterialPinField(
            length: 4,
            pinController: controller,
            theme: MaterialPinTheme(
              shape: MaterialPinShape.outlined,
              cellSize: const Size(48, 56),
              entryAnimation: animation,
              borderRadius: BorderRadius.circular(10),
            ),
            enableHapticFeedback: false,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorShakeDemo extends StatelessWidget {
  const _ErrorShakeDemo({required this.controller});

  final PinInputController controller;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF2A2A3E) : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        children: [
          Text('Error Shake', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Type a PIN and trigger an error',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          MaterialPinField(
            length: 4,
            pinController: controller,
            theme: MaterialPinTheme(
              shape: MaterialPinShape.outlined,
              cellSize: const Size(52, 60),
              borderRadius: BorderRadius.circular(12),
            ),
            enableHapticFeedback: false,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => controller.triggerError(),
            icon: const Icon(Icons.error_outline, size: 18),
            label: const Text('Trigger Error'),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
