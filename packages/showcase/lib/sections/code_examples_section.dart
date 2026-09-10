import 'package:material_ui/material_ui.dart';

import '../components/code_block.dart';
import '../components/section_title.dart';
import '../layout/section_wrapper.dart';
import '../utils/code_snippets.dart';

/// Tabbed code examples section.
class CodeExamplesSection extends StatefulWidget {
  const CodeExamplesSection({super.key, this.sectionKey});

  final GlobalKey? sectionKey;

  @override
  State<CodeExamplesSection> createState() => _CodeExamplesSectionState();
}

class _CodeExamplesSectionState extends State<CodeExamplesSection> {
  int _selectedTab = 0;

  static const _tabs = [
    _Tab(label: 'Quick Start', code: CodeSnippets.quickStart),
    _Tab(label: 'Controller', code: CodeSnippets.controller),
    _Tab(label: 'Headless', code: CodeSnippets.headless),
    _Tab(label: 'Liquid Glass', code: CodeSnippets.liquidGlass),
    _Tab(label: 'Form', code: CodeSnippets.formIntegration),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SectionWrapper(
      sectionKey: widget.sectionKey,
      enableFadeIn: false,
      child: Column(
        children: [
          const SectionTitle(
            title: 'Copy. Paste. Ship.',
            subtitle: 'Ready-to-use code for every use case',
          ),
          // Custom tab bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_tabs.length, (i) {
                final isActive = i == _selectedTab;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _TabButton(
                    label: _tabs[i].label,
                    isActive: isActive,
                    isDark: isDark,
                    onTap: () => setState(() => _selectedTab = i),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 24),
          // Code block
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: CodeBlock(
              key: ValueKey(_selectedTab),
              code: _tabs[_selectedTab].code,
            ),
          ),
        ],
      ),
    );
  }
}

class _Tab {
  const _Tab({required this.label, required this.code});
  final String label;
  final String code;
}

class _TabButton extends StatefulWidget {
  const _TabButton({
    required this.label,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  @override
  State<_TabButton> createState() => _TabButtonState();
}

class _TabButtonState extends State<_TabButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isActive
                ? Theme.of(context).colorScheme.primary
                : (_hovered
                      ? Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1)
                      : (widget.isDark
                            ? const Color(0xFF1A1A2E)
                            : const Color(0xFFF3F4F6))),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: widget.isActive
                  ? Theme.of(context).colorScheme.primary
                  : (widget.isDark
                        ? const Color(0xFF2A2A3E)
                        : const Color(0xFFE5E7EB)),
            ),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w500,
              color: widget.isActive
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
