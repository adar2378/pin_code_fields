import 'package:material_ui/material_ui.dart';

/// Breakpoints for responsive layout.
enum Breakpoint { mobile, tablet, desktop }

/// Returns the current breakpoint based on screen width.
Breakpoint getBreakpoint(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < 600) return Breakpoint.mobile;
  if (width < 1024) return Breakpoint.tablet;
  return Breakpoint.desktop;
}

/// Responsive builder that provides the current breakpoint.
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({super.key, required this.builder});

  final Widget Function(BuildContext context, Breakpoint breakpoint) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bp = getBreakpoint(context);
        return builder(context, bp);
      },
    );
  }
}

/// Responsive grid that adapts columns to breakpoint.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.desktopColumns = 3,
    this.tabletColumns = 2,
    this.mobileColumns = 1,
    this.spacing = 24,
    this.runSpacing = 24,
  });

  final List<Widget> children;
  final int desktopColumns;
  final int tabletColumns;
  final int mobileColumns;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, bp) {
        final columns = switch (bp) {
          Breakpoint.desktop => desktopColumns,
          Breakpoint.tablet => tabletColumns,
          Breakpoint.mobile => mobileColumns,
        };

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children.map((child) {
            final totalSpacing = spacing * (columns - 1);
            return LayoutBuilder(
              builder: (context, constraints) {
                final parentWidth = constraints.maxWidth;
                final itemWidth = (parentWidth - totalSpacing) / columns;
                return SizedBox(
                  width: itemWidth.clamp(0, parentWidth),
                  child: child,
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}
