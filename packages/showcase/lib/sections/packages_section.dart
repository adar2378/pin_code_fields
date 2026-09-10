import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../components/feature_chip.dart';
import '../components/section_title.dart';
import '../layout/responsive.dart';
import '../layout/section_wrapper.dart';

/// Packages overview section showing ecosystem cards.
class PackagesSection extends StatelessWidget {
  const PackagesSection({super.key, this.sectionKey});

  final GlobalKey? sectionKey;

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      sectionKey: sectionKey,
      child: Column(
        children: [
          const SectionTitle(
            title: 'The Ecosystem',
            subtitle: 'A family of packages for every design system',
          ),
          ResponsiveGrid(
            desktopColumns: 3,
            tabletColumns: 3,
            mobileColumns: 1,
            children: const [
              _PackageCard(
                icon: Icons.grid_view_rounded,
                title: 'pin_code_fields',
                description: 'Headless core + Material Design',
                version: 'v9.0.0',
                color: Color(0xFF6366F1),
                showLiveDemo: true,
              ),
              _PackageCard(
                icon: Icons.blur_on,
                title: 'liquid_glass',
                description: 'iOS 26 Liquid Glass aesthetic',
                version: 'v0.1.0',
                color: Color(0xFFEC4899),
                isGlass: true,
              ),
              _PackageCard(
                icon: Icons.auto_awesome,
                title: 'Coming Soon',
                description: 'More design systems on the way',
                version: '',
                color: Color(0xFF10B981),
                isComingSoon: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PackageCard extends StatefulWidget {
  const _PackageCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.version,
    required this.color,
    this.showLiveDemo = false,
    this.isGlass = false,
    this.isComingSoon = false,
  });

  final IconData icon;
  final String title;
  final String description;
  final String version;
  final Color color;
  final bool showLiveDemo;
  final bool isGlass;
  final bool isComingSoon;

  @override
  State<_PackageCard> createState() => _PackageCardState();
}

class _PackageCardState extends State<_PackageCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered
                ? widget.color.withValues(alpha: 0.5)
                : (isDark ? const Color(0xFF2A2A3E) : const Color(0xFFE5E7EB)),
          ),
          boxShadow: [
            BoxShadow(
              color: _hovered
                  ? widget.color.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: _hovered ? 20 : 10,
              spreadRadius: _hovered ? 2 : 0,
            ),
          ],
        ),
        transform: _hovered
            ? Matrix4.diagonal3Values(1.02, 1.02, 1.0)
            : Matrix4.identity(),
        transformAlignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: widget.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(widget.icon, color: widget.color, size: 24),
                ),
                const Spacer(),
                if (widget.version.isNotEmpty)
                  FeatureChip(label: widget.version, color: widget.color),
              ],
            ),
            const SizedBox(height: 20),
            Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              widget.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),

            // Live mini-demo or placeholder
            if (widget.showLiveDemo) _buildMaterialDemo(context),
            if (widget.isGlass) _buildGlassPlaceholder(context),
            if (widget.isComingSoon) _buildComingSoon(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialDemo(BuildContext context) {
    return SizedBox(
      height: 48,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: IgnorePointer(
          child: MaterialPinField(
            length: 4,
            initialValue: '12',
            theme: MaterialPinTheme(
              shape: MaterialPinShape.outlined,
              cellSize: const Size(36, 42),
              borderColor: widget.color.withValues(alpha: 0.4),
              focusedBorderColor: widget.color,
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            enableHapticFeedback: false,
          ),
        ),
      ),
    );
  }

  Widget _buildGlassPlaceholder(BuildContext context) {
    // Since liquid glass requires Impeller (not available on web),
    // show a visual representation
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            widget.color.withValues(alpha: 0.15),
            widget.color.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(color: widget.color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          4,
          (i) => Container(
            width: 36,
            height: 42,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: widget.color.withValues(alpha: i < 2 ? 0.2 : 0.08),
              border: Border.all(color: widget.color.withValues(alpha: 0.3)),
            ),
            child: Center(
              child: i < 2
                  ? Text(
                      '${i + 1}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildComingSoon(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.color.withValues(alpha: 0.2),
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome,
              size: 16,
              color: widget.color.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 8),
            Text(
              'Stay tuned',
              style: TextStyle(
                color: widget.color.withValues(alpha: 0.5),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
