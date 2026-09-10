import 'package:material_ui/material_ui.dart';
import 'package:web/web.dart' as web;

/// Footer with links, credits.
class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  void _openUrl(String url) {
    web.window.open(url, '_blank');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF0A0A14),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // Brand
              const Text(
                'pin_code_fields ecosystem',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'v9.0.0',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 24),
              // Links
              Wrap(
                spacing: 24,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  _FooterLink(
                    label: 'GitHub',
                    onTap: () =>
                        _openUrl('https://github.com/adar2378/pin_code_fields'),
                  ),
                  _FooterLink(
                    label: 'pub.dev',
                    onTap: () =>
                        _openUrl('https://pub.dev/packages/pin_code_fields'),
                  ),
                  _FooterLink(
                    label: 'API Docs',
                    onTap: () => _openUrl(
                      'https://pub.dev/documentation/pin_code_fields/latest/',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Container(height: 1, color: Colors.white.withValues(alpha: 0.1)),
              const SizedBox(height: 24),
              Text(
                'Built with Flutter',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterLink extends StatefulWidget {
  const _FooterLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _hovered
                ? const Color(0xFF818CF8)
                : Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}
