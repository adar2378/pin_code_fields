import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import '../components/section_title.dart';
import '../layout/responsive.dart';
import '../layout/section_wrapper.dart';

/// Getting started / installation section for each package.
class InstallSection extends StatelessWidget {
  const InstallSection({super.key, this.sectionKey});

  final GlobalKey? sectionKey;

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      sectionKey: sectionKey,
      enableFadeIn: false,
      child: Column(
        children: [
          const SectionTitle(
            title: 'Get Started in 30 Seconds',
            subtitle: 'Add to your project and start building',
          ),
          ResponsiveGrid(
            desktopColumns: 2,
            tabletColumns: 2,
            mobileColumns: 1,
            children: const [
              _PackageInstall(
                packageName: 'pin_code_fields',
                description: 'Headless core + Material Design',
                color: Color(0xFF6366F1),
                steps: [
                  _InstallStep(
                    title: '1. Add to pubspec.yaml',
                    code:
                        'dependencies:\n  pin_code_fields: ^10.0.0\n  material_ui: ^1.0.0',
                  ),
                  _InstallStep(
                    title: '2. Import',
                    code:
                        "import 'package:pin_code_fields/pin_code_fields.dart';",
                  ),
                  _InstallStep(
                    title: '3. Use',
                    code:
                        'MaterialPinField(\n'
                        '  length: 6,\n'
                        '  onCompleted: (pin) => print(pin),\n'
                        ')',
                  ),
                ],
              ),
              _PackageInstall(
                packageName: 'pin_code_fields_liquid_glass',
                description: 'iOS 26 Liquid Glass aesthetic',
                color: Color(0xFFEC4899),
                steps: [
                  _InstallStep(
                    title: '1. Add to pubspec.yaml',
                    code:
                        'dependencies:\n  pin_code_fields_liquid_glass: ^1.0.0',
                  ),
                  _InstallStep(
                    title: '2. Import',
                    code:
                        "import 'package:pin_code_fields_liquid_glass/pin_code_fields_liquid_glass.dart';",
                  ),
                  _InstallStep(
                    title: '3. Use',
                    code:
                        'LiquidGlassPinField(\n'
                        '  length: 6,\n'
                        '  theme: LiquidGlassPinTheme.blended(\n'
                        '    blur: 10,\n'
                        '    borderRadius: 12,\n'
                        '  ),\n'
                        ')',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InstallStep {
  const _InstallStep({required this.title, required this.code});
  final String title;
  final String code;
}

class _PackageInstall extends StatelessWidget {
  const _PackageInstall({
    required this.packageName,
    required this.description,
    required this.color,
    required this.steps,
  });

  final String packageName;
  final String description;
  final Color color;
  final List<_InstallStep> steps;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Package header
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  packageName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : const Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          // Steps
          for (final step in steps) ...[
            Text(
              step.title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 8),
            _CopyableCodeBlock(code: step.code, isDark: isDark),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

class _CopyableCodeBlock extends StatefulWidget {
  const _CopyableCodeBlock({required this.code, required this.isDark});

  final String code;
  final bool isDark;

  @override
  State<_CopyableCodeBlock> createState() => _CopyableCodeBlockState();
}

class _CopyableCodeBlockState extends State<_CopyableCodeBlock> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    if (!mounted) return;
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.isDark
            ? const Color(0xFF1E1E2E)
            : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          SelectableText(
            widget.code,
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'monospace',
              color: widget.isDark ? Colors.white : const Color(0xFF1A1A2E),
              height: 1.5,
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: _copy,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: widget.isDark
                        ? const Color(0xFF2A2A3E)
                        : const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    _copied ? Icons.check : Icons.copy,
                    size: 14,
                    color: _copied
                        ? const Color(0xFF10B981)
                        : (widget.isDark
                              ? Colors.white54
                              : const Color(0xFF9CA3AF)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
