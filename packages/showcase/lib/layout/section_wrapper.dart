import 'package:material_ui/material_ui.dart';

import 'responsive.dart';

/// Wraps a section with consistent max-width, padding, and optional scroll-fade-in.
class SectionWrapper extends StatefulWidget {
  const SectionWrapper({
    super.key,
    required this.child,
    this.sectionKey,
    this.maxWidth = 1200,
    this.padding,
    this.enableFadeIn = true,
    this.backgroundColor,
  });

  final Widget child;
  final GlobalKey? sectionKey;
  final double maxWidth;
  final EdgeInsets? padding;
  final bool enableFadeIn;
  final Color? backgroundColor;

  @override
  State<SectionWrapper> createState() => _SectionWrapperState();
}

class _SectionWrapperState extends State<SectionWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    if (!widget.enableFadeIn) {
      _fadeController.value = 1.0;
      _isVisible = true;
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(bool visible) {
    if (visible && !_isVisible) {
      _isVisible = true;
      _fadeController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bp = getBreakpoint(context);
    final defaultPadding = switch (bp) {
      Breakpoint.desktop => const EdgeInsets.symmetric(
        horizontal: 64,
        vertical: 80,
      ),
      Breakpoint.tablet => const EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 64,
      ),
      Breakpoint.mobile => const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 48,
      ),
    };

    Widget content = Container(
      key: widget.sectionKey,
      color: widget.backgroundColor,
      width: double.infinity,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: widget.maxWidth),
          child: Padding(
            padding: widget.padding ?? defaultPadding,
            child: widget.child,
          ),
        ),
      ),
    );

    if (widget.enableFadeIn) {
      content = _FadeInOnScroll(
        onVisible: _onVisibilityChanged,
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: _fadeController,
            curve: Curves.easeOut,
          ),
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0, 0.05),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _fadeController,
                    curve: Curves.easeOut,
                  ),
                ),
            child: content,
          ),
        ),
      );
    }

    return content;
  }
}

class _FadeInOnScroll extends StatefulWidget {
  const _FadeInOnScroll({required this.child, required this.onVisible});

  final Widget child;
  final ValueChanged<bool> onVisible;

  @override
  State<_FadeInOnScroll> createState() => _FadeInOnScrollState();
}

class _FadeInOnScrollState extends State<_FadeInOnScroll> {
  final _key = GlobalKey();
  bool _triggered = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _check() {
    if (_triggered) return;
    final renderObject = _key.currentContext?.findRenderObject();
    if (renderObject is RenderBox && renderObject.attached) {
      final offset = renderObject.localToGlobal(Offset.zero);
      final viewportHeight = MediaQuery.sizeOf(context).height;
      if (offset.dy < viewportHeight * 1.1) {
        _triggered = true;
        widget.onVisible(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check on every build (triggered by scroll rebuilds)
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
    return KeyedSubtree(key: _key, child: widget.child);
  }
}
