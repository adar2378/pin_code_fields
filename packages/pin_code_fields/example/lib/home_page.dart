import 'package:material_ui/material_ui.dart';

// Use Cases
import 'use_cases/otp_verification_page.dart';
import 'use_cases/pin_setup_flow.dart';
import 'use_cases/pin_login_page.dart';
import 'use_cases/payment_pin_page.dart';
import 'use_cases/invite_code_page.dart';
import 'use_cases/app_lock_screen.dart';

// Feature Demos
import 'demos/quick_start/basic_demo.dart';
import 'demos/quick_start/controller_demo.dart';
import 'demos/shapes_themes/shape_gallery_demo.dart';
import 'demos/shapes_themes/color_customization_demo.dart';
import 'demos/shapes_themes/shadows_demo.dart';
import 'demos/shapes_themes/app_wide_theming_demo.dart';
import 'demos/animations/entry_animations_demo.dart';
import 'demos/animations/custom_cursor_demo.dart';
import 'demos/animations/creative_cell_animations_demo.dart';
import 'demos/state_theming/all_states_demo.dart';
import 'demos/state_theming/error_state_demo.dart';
import 'demos/customization/headless_builder_demo.dart';
import 'demos/customization/hints_demo.dart';
import 'demos/customization/obscure_text_demo.dart';
import 'demos/customization/separators_demo.dart';
import 'demos/customization/text_gradient_demo.dart';
import 'demos/interactions/clipboard_demo.dart';
import 'demos/interactions/form_validation_demo.dart';
import 'demos/interactions/autofill_demo.dart';
import 'demos/interactions/custom_formatters_demo.dart';

// Playground
import 'playground/playground_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pin Code Fields'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.apps), text: 'Use Cases'),
              Tab(icon: Icon(Icons.widgets), text: 'Features'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _UseCasesTab(),
            _FeaturesTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PlaygroundPage()),
          ),
          icon: const Icon(Icons.tune),
          label: const Text('Playground'),
        ),
      ),
    );
  }
}

// ============================================================================
// USE CASES TAB
// ============================================================================

class _UseCasesTab extends StatelessWidget {
  const _UseCasesTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _UseCaseCard(
          icon: Icons.sms,
          title: 'OTP Verification',
          subtitle: 'Phone/email verification with resend timer',
          color: Colors.blue,
          onTap: () => _navigate(context, const OtpVerificationPage()),
        ),
        _UseCaseCard(
          icon: Icons.pin,
          title: 'PIN Setup',
          subtitle: 'Create and confirm PIN flow',
          color: Colors.green,
          onTap: () => _navigate(context, const PinSetupFlow()),
        ),
        _UseCaseCard(
          icon: Icons.lock_open,
          title: 'PIN Login',
          subtitle: 'Authenticate with PIN, max attempts',
          color: Colors.orange,
          onTap: () => _navigate(context, const PinLoginPage()),
        ),
        _UseCaseCard(
          icon: Icons.payment,
          title: 'Payment Confirmation',
          subtitle: 'Secure transaction PIN entry',
          color: Colors.purple,
          onTap: () => _navigate(context, const PaymentPinPage()),
        ),
        _UseCaseCard(
          icon: Icons.card_giftcard,
          title: 'Invite/Referral Code',
          subtitle: 'Alphanumeric code input',
          color: Colors.teal,
          onTap: () => _navigate(context, const InviteCodePage()),
        ),
        _UseCaseCard(
          icon: Icons.screen_lock_portrait,
          title: 'App Lock Screen',
          subtitle: 'Full-screen lock with PIN',
          color: Colors.red,
          onTap: () => _navigate(context, const AppLockScreen()),
        ),
      ],
    );
  }

  void _navigate(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}

class _UseCaseCard extends StatelessWidget {
  const _UseCaseCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// FEATURES TAB
// ============================================================================

class _FeaturesTab extends StatelessWidget {
  const _FeaturesTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _FeatureSection(
          title: 'Quick Start',
          items: [
            _FeatureItem(
              title: 'Basic Usage',
              page: const BasicDemo(),
            ),
            _FeatureItem(
              title: 'With Controller',
              page: const ControllerDemo(),
            ),
          ],
        ),
        _FeatureSection(
          title: 'Shapes & Themes',
          items: [
            _FeatureItem(
              title: 'Shape Gallery',
              page: const ShapeGalleryDemo(),
            ),
            _FeatureItem(
              title: 'Color Customization',
              page: const ColorCustomizationDemo(),
            ),
            _FeatureItem(
              title: 'Shadows & Elevation',
              page: const ShadowsDemo(),
            ),
            _FeatureItem(
              title: 'App-Wide Theming',
              page: const AppWideThemingDemo(),
            ),
          ],
        ),
        _FeatureSection(
          title: 'Animations',
          items: [
            _FeatureItem(
              title: 'Creative Cell Animations',
              page: const CreativeCellAnimationsDemo(),
            ),
            _FeatureItem(
              title: 'Entry Animations',
              page: const EntryAnimationsDemo(),
            ),
            _FeatureItem(
              title: 'Custom Cursor',
              page: const CustomCursorDemo(),
            ),
          ],
        ),
        _FeatureSection(
          title: 'State Theming',
          items: [
            _FeatureItem(
              title: 'All States Demo',
              page: const AllStatesDemo(),
            ),
            _FeatureItem(
              title: 'Error Handling',
              page: const ErrorStateDemo(),
            ),
          ],
        ),
        _FeatureSection(
          title: 'Customization',
          items: [
            _FeatureItem(
              title: 'Headless Builder',
              page: const HeadlessBuilderDemo(),
            ),
            _FeatureItem(
              title: 'Hints & Placeholders',
              page: const HintsDemo(),
            ),
            _FeatureItem(
              title: 'Obscure Text',
              page: const ObscureTextDemo(),
            ),
            _FeatureItem(
              title: 'Separators',
              page: const SeparatorsDemo(),
            ),
            _FeatureItem(
              title: 'Text Gradient',
              page: const TextGradientDemo(),
            ),
          ],
        ),
        _FeatureSection(
          title: 'Interactions',
          items: [
            _FeatureItem(
              title: 'Clipboard Detection',
              page: const ClipboardDemo(),
            ),
            _FeatureItem(
              title: 'Form Validation',
              page: const FormValidationDemo(),
            ),
            _FeatureItem(
              title: 'Autofill & SMS',
              page: const AutofillDemo(),
            ),
            _FeatureItem(
              title: 'Custom Input Formatters',
              page: const CustomFormattersDemo(),
            ),
          ],
        ),
      ],
    );
  }
}

class _FeatureSection extends StatelessWidget {
  const _FeatureSection({
    required this.title,
    required this.items,
  });

  final String title;
  final List<_FeatureItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        Card(
          margin: const EdgeInsets.only(bottom: 16),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: items.map((item) {
              final isLast = item == items.last;
              return Column(
                children: [
                  ListTile(
                    title: Text(item.title),
                    trailing: const Icon(Icons.chevron_right, size: 20),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => item.page),
                    ),
                  ),
                  if (!isLast) const Divider(height: 1),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _FeatureItem {
  const _FeatureItem({
    required this.title,
    required this.page,
  });

  final String title;
  final Widget page;
}
