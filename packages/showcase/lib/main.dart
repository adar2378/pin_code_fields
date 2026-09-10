import 'package:material_ui/material_ui.dart';
import 'package:web/web.dart' as web;

import 'layout/nav_bar.dart';
import 'sections/animations_section.dart';
import 'sections/code_examples_section.dart';
import 'sections/extras_section.dart';
import 'sections/footer_section.dart';
import 'sections/headless_section.dart';
import 'sections/hero_section.dart';
import 'sections/install_section.dart';
import 'sections/liquid_glass_section.dart';
import 'sections/packages_section.dart';
import 'sections/playground_section.dart';
import 'sections/separators_section.dart';
import 'sections/shapes_section.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ShowcaseApp());
}

class ShowcaseApp extends StatefulWidget {
  const ShowcaseApp({super.key});

  @override
  State<ShowcaseApp> createState() => _ShowcaseAppState();
}

class _ShowcaseAppState extends State<ShowcaseApp> {
  bool _isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'pin_code_fields — The Flutter PIN input ecosystem',
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? buildDarkTheme() : buildLightTheme(),
      home: ShowcaseHome(
        isDarkMode: _isDarkMode,
        onThemeToggle: () => setState(() => _isDarkMode = !_isDarkMode),
      ),
    );
  }
}

class ShowcaseHome extends StatefulWidget {
  const ShowcaseHome({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  @override
  State<ShowcaseHome> createState() => _ShowcaseHomeState();
}

class _ShowcaseHomeState extends State<ShowcaseHome> {
  final _scrollController = ScrollController();

  // Section keys for scroll spy
  final _packagesKey = GlobalKey();
  final _shapesKey = GlobalKey();
  final _separatorsKey = GlobalKey();
  final _extrasKey = GlobalKey();
  final _animationsKey = GlobalKey();
  final _headlessKey = GlobalKey();
  final _liquidGlassKey = GlobalKey();
  final _playgroundKey = GlobalKey();
  final _codeExamplesKey = GlobalKey();
  final _installKey = GlobalKey();

  int _activeNavIndex = 0;

  late final List<NavItem> _navItems;

  @override
  void initState() {
    super.initState();
    _navItems = [
      NavItem(label: 'Packages', key: _packagesKey),
      NavItem(label: 'Shapes', key: _shapesKey),
      NavItem(label: 'Separators', key: _separatorsKey),
      NavItem(label: 'Extras', key: _extrasKey),
      NavItem(label: 'Animations', key: _animationsKey),
      NavItem(label: 'Headless', key: _headlessKey),
      NavItem(label: 'Liquid Glass', key: _liquidGlassKey),
      NavItem(label: 'Playground', key: _playgroundKey),
      NavItem(label: 'Code', key: _codeExamplesKey),
      NavItem(label: 'Install', key: _installKey),
    ];
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Scroll spy: determine which section is currently visible
    const navBarHeight = 64.0;
    final offset = _scrollController.offset + navBarHeight + 100;

    int newIndex = 0;
    for (var i = _navItems.length - 1; i >= 0; i--) {
      final key = _navItems[i].key;
      final renderObject = key.currentContext?.findRenderObject();
      if (renderObject is RenderBox && renderObject.attached) {
        final position = renderObject.localToGlobal(
          Offset.zero,
          ancestor: context.findRenderObject(),
        );
        if (position.dy <= offset) {
          newIndex = i;
          break;
        }
      }
    }

    if (newIndex != _activeNavIndex) {
      setState(() => _activeNavIndex = newIndex);
    }
  }

  void _scrollToSection(int index) {
    final key = _navItems[index].key;
    final renderObject = key.currentContext?.findRenderObject();
    if (renderObject is RenderBox && renderObject.attached) {
      final position = renderObject.localToGlobal(
        Offset.zero,
        ancestor: context.findRenderObject(),
      );
      _scrollController.animateTo(
        _scrollController.offset + position.dy - 80,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _scrollToPackages() {
    _scrollToSection(0);
  }

  void _openGitHub() {
    web.window.open('https://github.com/adar2378/pin_code_fields', '_blank');
  }

  void _openPubDev() {
    web.window.open('https://pub.dev/packages/pin_code_fields', '_blank');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: ShowcaseDrawer(
        items: _navItems,
        activeIndex: _activeNavIndex,
        onItemTap: _scrollToSection,
        isDarkMode: widget.isDarkMode,
      ),
      body: Stack(
        children: [
          // Scrollable content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: HeroSection(
                  onExplore: _scrollToPackages,
                  onPubDev: _openPubDev,
                ),
              ),
              SliverToBoxAdapter(
                child: PackagesSection(sectionKey: _packagesKey),
              ),
              SliverToBoxAdapter(child: ShapesSection(sectionKey: _shapesKey)),
              SliverToBoxAdapter(
                child: SeparatorsSection(sectionKey: _separatorsKey),
              ),
              SliverToBoxAdapter(child: ExtrasSection(sectionKey: _extrasKey)),
              SliverToBoxAdapter(
                child: AnimationsSection(sectionKey: _animationsKey),
              ),
              SliverToBoxAdapter(
                child: HeadlessSection(sectionKey: _headlessKey),
              ),
              SliverToBoxAdapter(
                child: LiquidGlassSection(sectionKey: _liquidGlassKey),
              ),
              SliverToBoxAdapter(
                child: PlaygroundSection(sectionKey: _playgroundKey),
              ),
              SliverToBoxAdapter(
                child: CodeExamplesSection(sectionKey: _codeExamplesKey),
              ),
              SliverToBoxAdapter(
                child: InstallSection(sectionKey: _installKey),
              ),
              const SliverToBoxAdapter(child: FooterSection()),
            ],
          ),

          // Sticky nav bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ShowcaseNavBar(
              items: _navItems,
              activeIndex: _activeNavIndex,
              onItemTap: _scrollToSection,
              isDarkMode: widget.isDarkMode,
              onThemeToggle: widget.onThemeToggle,
              onGitHubTap: _openGitHub,
              scrollController: _scrollController,
            ),
          ),
        ],
      ),
    );
  }
}
