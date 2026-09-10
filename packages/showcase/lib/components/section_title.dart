import 'package:material_ui/material_ui.dart';

import '../layout/responsive.dart';

/// Section heading with title and subtitle.
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.align = CrossAxisAlignment.center,
  });

  final String title;
  final String? subtitle;
  final CrossAxisAlignment align;

  @override
  Widget build(BuildContext context) {
    final bp = getBreakpoint(context);
    final textTheme = Theme.of(context).textTheme;

    final titleStyle = switch (bp) {
      Breakpoint.desktop => textTheme.displayMedium,
      Breakpoint.tablet => textTheme.headlineLarge,
      Breakpoint.mobile => textTheme.headlineMedium,
    };

    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          title,
          style: titleStyle,
          textAlign: align == CrossAxisAlignment.center
              ? TextAlign.center
              : TextAlign.start,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 12),
          Text(
            subtitle!,
            style: textTheme.bodyLarge,
            textAlign: align == CrossAxisAlignment.center
                ? TextAlign.center
                : TextAlign.start,
          ),
        ],
        const SizedBox(height: 48),
      ],
    );
  }
}
