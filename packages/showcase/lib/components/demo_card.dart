import 'package:material_ui/material_ui.dart';

import '../layout/responsive.dart';
import 'code_block.dart';

/// Live demo + code side-by-side card.
class DemoCard extends StatefulWidget {
  const DemoCard({
    super.key,
    required this.demo,
    required this.code,
    this.title,
  });

  final Widget demo;
  final String code;
  final String? title;

  @override
  State<DemoCard> createState() => _DemoCardState();
}

class _DemoCardState extends State<DemoCard> {
  bool _showCode = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bp = getBreakpoint(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = bp == Breakpoint.mobile;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF2A2A3E) : const Color(0xFFE5E7EB),
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.title != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Text(
                    widget.title!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              if (isMobile) ...[
                // Mobile: stacked layout
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(child: widget.demo),
                ),
                // Show code toggle
                InkWell(
                  onTap: () => setState(() => _showCode = !_showCode),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: isDark
                              ? const Color(0xFF2A2A3E)
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _showCode ? Icons.code_off : Icons.code,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _showCode ? 'Hide Code' : 'Show Code',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_showCode)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: CodeBlock(code: widget.code, maxHeight: 300),
                  ),
              ] else ...[
                // Desktop/tablet: side by side
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 55, child: Center(child: widget.demo)),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 45,
                        child: CodeBlock(code: widget.code, maxHeight: 300),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
