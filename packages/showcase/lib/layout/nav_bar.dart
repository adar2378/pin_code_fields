import 'dart:ui';

import 'package:material_ui/material_ui.dart';

import 'responsive.dart';

/// Navigation items for scroll spy.
class NavItem {
  const NavItem({required this.label, required this.key});
  final String label;
  final GlobalKey key;
}

/// Sticky frosted-glass navigation bar with scroll spy.
class ShowcaseNavBar extends StatelessWidget {
  const ShowcaseNavBar({
    super.key,
    required this.items,
    required this.activeIndex,
    required this.onItemTap,
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.onGitHubTap,
    required this.scrollController,
  });

  final List<NavItem> items;
  final int activeIndex;
  final ValueChanged<int> onItemTap;
  final bool isDarkMode;
  final VoidCallback onThemeToggle;
  final VoidCallback onGitHubTap;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final bp = getBreakpoint(context);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: isDarkMode
                ? const Color(0xFF0F0F1A).withValues(alpha: 0.8)
                : Colors.white.withValues(alpha: 0.85),
            border: Border(
              bottom: BorderSide(
                color: isDarkMode
                    ? const Color(0xFF2A2A3E)
                    : const Color(0xFFE5E7EB),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                // Wordmark
                Text(
                  'pin_code_fields',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDarkMode ? Colors.white : const Color(0xFF1A1A2E),
                    letterSpacing: -0.5,
                  ),
                ),
                const Spacer(),

                if (bp != Breakpoint.mobile) ...[
                  // Desktop/tablet: inline links
                  for (var i = 0; i < items.length; i++) ...[
                    _NavLink(
                      label: items[i].label,
                      isActive: i == activeIndex,
                      onTap: () => onItemTap(i),
                      isDark: isDarkMode,
                    ),
                  ],
                  const SizedBox(width: 8),
                ],

                // Theme toggle
                IconButton(
                  onPressed: onThemeToggle,
                  icon: Icon(
                    isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    size: 20,
                  ),
                  tooltip: isDarkMode ? 'Light mode' : 'Dark mode',
                ),

                // GitHub
                IconButton(
                  onPressed: onGitHubTap,
                  icon: const _GitHubIcon(),
                  tooltip: 'GitHub',
                ),

                if (bp == Breakpoint.mobile)
                  Builder(
                    builder: (ctx) => IconButton(
                      onPressed: () {
                        Scaffold.of(ctx).openEndDrawer();
                      },
                      icon: const Icon(Icons.menu, size: 20),
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

class _NavLink extends StatefulWidget {
  const _NavLink({
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.isDark,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final bool isDark;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.isActive
        ? Theme.of(context).colorScheme.primary
        : (_hovered
              ? (widget.isDark ? Colors.white70 : const Color(0xFF6B7280))
              : (widget.isDark ? Colors.white54 : const Color(0xFF9CA3AF)));

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w500,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

/// Drawer for mobile nav.
class ShowcaseDrawer extends StatelessWidget {
  const ShowcaseDrawer({
    super.key,
    required this.items,
    required this.activeIndex,
    required this.onItemTap,
    required this.isDarkMode,
  });

  final List<NavItem> items;
  final int activeIndex;
  final ValueChanged<int> onItemTap;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: isDarkMode ? const Color(0xFF1A1A2E) : Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'pin_code_fields',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? Colors.white : const Color(0xFF1A1A2E),
                ),
              ),
            ),
            const Divider(height: 1),
            for (var i = 0; i < items.length; i++)
              ListTile(
                title: Text(items[i].label),
                selected: i == activeIndex,
                selectedColor: Theme.of(context).colorScheme.primary,
                onTap: () {
                  Navigator.of(context).pop();
                  onItemTap(i);
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// Simple GitHub icon drawn with CustomPaint.
class _GitHubIcon extends StatelessWidget {
  const _GitHubIcon();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Icon(
      Icons.code,
      size: 20,
      color: isDark ? Colors.white70 : const Color(0xFF6B7280),
    );
  }
}
