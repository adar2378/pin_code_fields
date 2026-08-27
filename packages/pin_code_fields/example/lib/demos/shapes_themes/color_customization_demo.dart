import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// Color Customization - Comprehensive state-based theming
///
/// Demonstrates ALL color properties in MaterialPinTheme:
/// - Default state (empty cells)
/// - Focused state (current input cell)
/// - Filled state (cells with characters)
/// - Following state (cells after focused)
/// - Complete state (all cells filled)
/// - Error state
/// - Disabled state
/// - Cursor color
class ColorCustomizationDemo extends StatefulWidget {
  const ColorCustomizationDemo({super.key});

  @override
  State<ColorCustomizationDemo> createState() => _ColorCustomizationDemoState();
}

class _ColorCustomizationDemoState extends State<ColorCustomizationDemo>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Controllers for different sections
  final _interactiveController = PinInputController();
  final _errorController = PinInputController();
  final _disabledController = PinInputController();

  // Interactive demo colors
  Color _borderColor = Colors.grey.shade400;
  Color _focusedBorderColor = Colors.indigo;
  Color _filledBorderColor = Colors.indigo.shade300;
  Color _fillColor = Colors.grey.shade100;
  Color _focusedFillColor = Colors.indigo.shade50;
  Color _filledFillColor = Colors.indigo.shade100;
  Color _followingBorderColor = Colors.grey.shade300;
  Color _followingFillColor = Colors.grey.shade50;
  Color _cursorColor = Colors.indigo;

  // Complete state colors
  Color _completeBorderColor = Colors.green;
  Color _completeFillColor = Colors.green.shade50;

  // Error colors
  Color _errorColor = Colors.red;
  Color _errorFillColor = Colors.red.shade50;
  Color _errorBorderColor = Colors.red;

  // Disabled colors
  Color _disabledColor = Colors.grey.shade400;
  Color _disabledFillColor = Colors.grey.shade100;
  Color _disabledBorderColor = Colors.grey.shade300;

  final _baseColors = [
    Colors.indigo,
    Colors.blue,
    Colors.teal,
    Colors.green,
    Colors.orange,
    Colors.pink,
    Colors.purple,
    Colors.red,
    Colors.grey,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _disabledController.setText('12');
  }

  @override
  void dispose() {
    _tabController.dispose();
    _interactiveController.dispose();
    _errorController.dispose();
    _disabledController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Customization'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Interactive'),
            Tab(text: 'All States'),
            Tab(text: 'Presets'),
            Tab(text: 'Reference'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInteractiveTab(),
          _buildAllStatesTab(),
          _buildPresetsTab(),
          _buildReferenceTab(),
        ],
      ),
    );
  }

  // ============================================================================
  // INTERACTIVE TAB - Live color picker
  // ============================================================================

  Widget _buildInteractiveTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Live Preview
        _SectionTitle('Live Preview'),
        _PreviewCard(
          child: MaterialPinField(
            length: 6,
            pinController: _interactiveController,
            theme: MaterialPinTheme(
              shape: MaterialPinShape.outlined,
              cellSize: const Size(48, 56),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              // Default state
              borderColor: _borderColor,
              fillColor: _fillColor,
              // Focused state
              focusedBorderColor: _focusedBorderColor,
              focusedFillColor: _focusedFillColor,
              // Filled state
              filledBorderColor: _filledBorderColor,
              filledFillColor: _filledFillColor,
              // Following cells
              followingBorderColor: _followingBorderColor,
              followingFillColor: _followingFillColor,
              // Complete state
              completeBorderColor: _completeBorderColor,
              completeFillColor: _completeFillColor,
              // Cursor
              cursorColor: _cursorColor,
            ),
            onCompleted: (_) {},
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton.icon(
            onPressed: () => _interactiveController.clear(),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Reset'),
          ),
        ),
        const SizedBox(height: 24),

        // Color Sections
        _ColorSection(
          title: 'Empty Cells',
          subtitle: 'Cells waiting for input',
          colors: [
            _ColorProperty(
              name: 'Border',
              color: _borderColor,
              onColorSelected: (c) => setState(() => _borderColor = c),
              baseColors: _baseColors,
            ),
            _ColorProperty(
              name: 'Fill',
              color: _fillColor,
              onColorSelected: (c) => setState(() => _fillColor = c),
              baseColors: _baseColors,
              useLightVariants: true,
            ),
          ],
        ),

        _ColorSection(
          title: 'Focused Cell',
          subtitle: 'Current input position',
          colors: [
            _ColorProperty(
              name: 'Border',
              color: _focusedBorderColor,
              onColorSelected: (c) => setState(() => _focusedBorderColor = c),
              baseColors: _baseColors,
            ),
            _ColorProperty(
              name: 'Fill',
              color: _focusedFillColor,
              onColorSelected: (c) => setState(() => _focusedFillColor = c),
              baseColors: _baseColors,
              useLightVariants: true,
            ),
          ],
        ),

        _ColorSection(
          title: 'Filled Cells',
          subtitle: 'Cells with characters entered',
          colors: [
            _ColorProperty(
              name: 'Border',
              color: _filledBorderColor,
              onColorSelected: (c) => setState(() => _filledBorderColor = c),
              baseColors: _baseColors,
            ),
            _ColorProperty(
              name: 'Fill',
              color: _filledFillColor,
              onColorSelected: (c) => setState(() => _filledFillColor = c),
              baseColors: _baseColors,
              useLightVariants: true,
            ),
          ],
        ),

        _ColorSection(
          title: 'Following Cells',
          subtitle: 'Cells after the focused position',
          colors: [
            _ColorProperty(
              name: 'Border',
              color: _followingBorderColor,
              onColorSelected: (c) => setState(() => _followingBorderColor = c),
              baseColors: _baseColors,
            ),
            _ColorProperty(
              name: 'Fill',
              color: _followingFillColor,
              onColorSelected: (c) => setState(() => _followingFillColor = c),
              baseColors: _baseColors,
              useLightVariants: true,
            ),
          ],
        ),

        _ColorSection(
          title: 'Complete State',
          subtitle: 'All cells filled',
          colors: [
            _ColorProperty(
              name: 'Border',
              color: _completeBorderColor,
              onColorSelected: (c) => setState(() => _completeBorderColor = c),
              baseColors: _baseColors,
            ),
            _ColorProperty(
              name: 'Fill',
              color: _completeFillColor,
              onColorSelected: (c) => setState(() => _completeFillColor = c),
              baseColors: _baseColors,
              useLightVariants: true,
            ),
          ],
        ),

        _ColorSection(
          title: 'Cursor',
          subtitle: 'Blinking cursor in focused cell',
          colors: [
            _ColorProperty(
              name: 'Color',
              color: _cursorColor,
              onColorSelected: (c) => setState(() => _cursorColor = c),
              baseColors: _baseColors,
            ),
          ],
        ),

        const SizedBox(height: 32),
      ],
    );
  }

  // ============================================================================
  // ALL STATES TAB - Show all states at once
  // ============================================================================

  Widget _buildAllStatesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SectionTitle('Default + Focused + Filled'),
        const Text(
          'Type to see states change dynamically',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 12),
        _PreviewCard(
          child: MaterialPinField(
            length: 6,
            autoFocus: true,
            theme: MaterialPinTheme(
              shape: MaterialPinShape.outlined,
              cellSize: const Size(46, 54),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              borderColor: Colors.grey.shade300,
              fillColor: Colors.grey.shade50,
              focusedBorderColor: Colors.blue,
              focusedFillColor: Colors.blue.shade50,
              filledBorderColor: Colors.blue.shade400,
              filledFillColor: Colors.blue.shade100,
              followingBorderColor: Colors.grey.shade200,
              followingFillColor: Colors.white,
              completeBorderColor: Colors.green,
              completeFillColor: Colors.green.shade50,
            ),
            onCompleted: (_) {},
          ),
        ),
        const SizedBox(height: 8),
        _StateIndicatorRow(
          indicators: [
            _StateIndicator('Empty', Colors.grey.shade300, Colors.grey.shade50),
            _StateIndicator('Focused', Colors.blue, Colors.blue.shade50),
            _StateIndicator(
                'Filled', Colors.blue.shade400, Colors.blue.shade100),
            _StateIndicator('Complete', Colors.green, Colors.green.shade50),
          ],
        ),
        const SizedBox(height: 32),
        _SectionTitle('Error State'),
        const Text(
          'Tap "Trigger Error" to see error styling',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 12),
        _PreviewCard(
          child: Column(
            children: [
              MaterialPinField(
                length: 4,
                pinController: _errorController,
                theme: MaterialPinTheme(
                  shape: MaterialPinShape.outlined,
                  cellSize: const Size(56, 64),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  errorColor: _errorColor,
                  errorFillColor: _errorFillColor,
                  errorBorderColor: _errorBorderColor,
                ),
                onCompleted: (_) {},
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () => _errorController.triggerError(),
                    child: const Text('Trigger Error'),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () {
                      _errorController.clearError();
                      _errorController.clear();
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _ColorSection(
          title: 'Customize Error Colors',
          subtitle: '',
          colors: [
            _ColorProperty(
              name: 'Error Base',
              color: _errorColor,
              onColorSelected: (c) => setState(() {
                _errorColor = c;
                _errorBorderColor = c;
                _errorFillColor = c.withValues(alpha: 0.1);
              }),
              baseColors: [
                Colors.red,
                Colors.pink,
                Colors.orange,
                Colors.deepOrange
              ],
            ),
          ],
        ),
        const SizedBox(height: 32),
        _SectionTitle('Disabled State'),
        const Text(
          'Read-only cells with muted styling',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 12),
        _PreviewCard(
          child: MaterialPinField(
            length: 4,
            pinController: _disabledController,
            enabled: false,
            theme: MaterialPinTheme(
              shape: MaterialPinShape.outlined,
              cellSize: const Size(56, 64),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              disabledColor: _disabledColor,
              disabledFillColor: _disabledFillColor,
              disabledBorderColor: _disabledBorderColor,
            ),
            onCompleted: (_) {},
          ),
        ),
        const SizedBox(height: 8),
        _ColorSection(
          title: 'Customize Disabled Colors',
          subtitle: '',
          colors: [
            _ColorProperty(
              name: 'Disabled Base',
              color: _disabledColor,
              onColorSelected: (c) => setState(() {
                _disabledColor = c;
                _disabledBorderColor = c.withValues(alpha: 0.5);
                _disabledFillColor = c.withValues(alpha: 0.1);
              }),
              baseColors: const [
                Colors.grey,
                Colors.blueGrey,
                Colors.brown,
                Colors.cyan,
              ],
            ),
          ],
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  // ============================================================================
  // PRESETS TAB - Ready-made color schemes
  // ============================================================================

  Widget _buildPresetsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SectionTitle('Ready-Made Themes'),
        const SizedBox(height: 16),

        // Ocean Blue
        _ThemePresetCard(
          name: 'Ocean Blue',
          description: 'Cool and professional',
          theme: MaterialPinTheme(
            shape: MaterialPinShape.outlined,
            cellSize: const Size(52, 60),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            borderColor: Colors.blue.shade200,
            fillColor: Colors.blue.shade50,
            focusedBorderColor: Colors.blue.shade600,
            focusedFillColor: Colors.blue.shade100,
            filledBorderColor: Colors.blue.shade400,
            filledFillColor: Colors.blue.shade50,
            completeBorderColor: Colors.blue.shade700,
            completeFillColor: Colors.blue.shade100,
            cursorColor: Colors.blue.shade600,
          ),
        ),

        // Forest Green
        _ThemePresetCard(
          name: 'Forest Green',
          description: 'Natural and calming',
          theme: MaterialPinTheme(
            shape: MaterialPinShape.outlined,
            cellSize: const Size(52, 60),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            borderColor: Colors.green.shade200,
            fillColor: Colors.green.shade50,
            focusedBorderColor: Colors.green.shade600,
            focusedFillColor: Colors.green.shade100,
            filledBorderColor: Colors.green.shade400,
            filledFillColor: Colors.green.shade50,
            completeBorderColor: Colors.teal,
            completeFillColor: Colors.teal.shade50,
            cursorColor: Colors.green.shade600,
          ),
        ),

        // Sunset Orange
        _ThemePresetCard(
          name: 'Sunset Orange',
          description: 'Warm and energetic',
          theme: MaterialPinTheme(
            shape: MaterialPinShape.filled,
            cellSize: const Size(52, 60),
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            fillColor: Colors.orange.shade50,
            focusedFillColor: Colors.orange.shade100,
            filledFillColor: Colors.orange.shade200,
            completeFillColor: Colors.deepOrange.shade100,
            cursorColor: Colors.deepOrange,
            textStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange.shade700,
            ),
          ),
        ),

        // Royal Purple
        _ThemePresetCard(
          name: 'Royal Purple',
          description: 'Elegant and luxurious',
          theme: MaterialPinTheme(
            shape: MaterialPinShape.outlined,
            cellSize: const Size(52, 60),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            borderColor: Colors.purple.shade200,
            fillColor: Colors.purple.shade50,
            focusedBorderColor: Colors.purple.shade600,
            focusedFillColor: Colors.purple.shade100,
            filledBorderColor: Colors.purple.shade400,
            filledFillColor: Colors.purple.shade50,
            completeBorderColor: Colors.deepPurple,
            completeFillColor: Colors.deepPurple.shade50,
            cursorColor: Colors.purple.shade600,
          ),
        ),

        // Monochrome
        _ThemePresetCard(
          name: 'Monochrome',
          description: 'Clean and minimal',
          theme: MaterialPinTheme(
            shape: MaterialPinShape.underlined,
            cellSize: const Size(48, 56),
            borderWidth: 2,
            focusedBorderWidth: 3,
            borderColor: Colors.grey.shade300,
            focusedBorderColor: Colors.grey.shade800,
            filledBorderColor: Colors.grey.shade600,
            completeBorderColor: Colors.black,
            cursorColor: Colors.black,
            textStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),

        // Neon Pink
        _ThemePresetCard(
          name: 'Neon Pink',
          description: 'Bold and vibrant',
          theme: MaterialPinTheme(
            shape: MaterialPinShape.outlined,
            cellSize: const Size(52, 60),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            borderWidth: 2,
            focusedBorderWidth: 3,
            borderColor: Colors.pink.shade200,
            fillColor: Colors.pink.shade50,
            focusedBorderColor: Colors.pink,
            focusedFillColor: Colors.pink.shade100,
            filledBorderColor: Colors.pink.shade400,
            filledFillColor: Colors.pink.shade50,
            completeBorderColor: Colors.pinkAccent,
            completeFillColor: Colors.pink.shade100,
            cursorColor: Colors.pink,
            textStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.pink.shade700,
            ),
          ),
        ),

        const SizedBox(height: 32),
      ],
    );
  }

  // ============================================================================
  // REFERENCE TAB - All color properties documented
  // ============================================================================

  Widget _buildReferenceTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SectionTitle('Color Properties Reference'),
        const SizedBox(height: 8),
        const Text(
          'All available color properties in MaterialPinTheme',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 24),
        _ReferenceCategory(
          title: 'Default State',
          icon: Icons.crop_square_outlined,
          properties: const [
            _PropertyDoc('fillColor', 'Background for empty cells'),
            _PropertyDoc('borderColor', 'Border for empty cells'),
          ],
        ),
        _ReferenceCategory(
          title: 'Focused State',
          icon: Icons.center_focus_strong,
          properties: const [
            _PropertyDoc('focusedFillColor', 'Background for current cell'),
            _PropertyDoc('focusedBorderColor', 'Border for current cell'),
          ],
        ),
        _ReferenceCategory(
          title: 'Filled State',
          icon: Icons.check_box,
          properties: const [
            _PropertyDoc('filledFillColor', 'Background for cells with input'),
            _PropertyDoc('filledBorderColor', 'Border for cells with input'),
          ],
        ),
        _ReferenceCategory(
          title: 'Following Cells',
          icon: Icons.arrow_forward,
          properties: const [
            _PropertyDoc('followingFillColor', 'Background after focused'),
            _PropertyDoc('followingBorderColor', 'Border after focused'),
          ],
        ),
        _ReferenceCategory(
          title: 'Complete State',
          icon: Icons.done_all,
          properties: const [
            _PropertyDoc('completeFillColor', 'Background when all filled'),
            _PropertyDoc('completeBorderColor', 'Border when all filled'),
          ],
        ),
        _ReferenceCategory(
          title: 'Error State',
          icon: Icons.error_outline,
          properties: const [
            _PropertyDoc('errorColor', 'Base color for error state'),
            _PropertyDoc('errorFillColor', 'Background on error'),
            _PropertyDoc('errorBorderColor', 'Border on error'),
          ],
        ),
        _ReferenceCategory(
          title: 'Disabled State',
          icon: Icons.block,
          properties: const [
            _PropertyDoc('disabledColor', 'Base color for disabled'),
            _PropertyDoc('disabledFillColor', 'Background when disabled'),
            _PropertyDoc('disabledBorderColor', 'Border when disabled'),
          ],
        ),
        _ReferenceCategory(
          title: 'Cursor',
          icon: Icons.text_fields,
          properties: const [
            _PropertyDoc('cursorColor', 'Color of blinking cursor'),
          ],
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

// =============================================================================
// HELPER WIDGETS
// =============================================================================

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(child: child),
      ),
    );
  }
}

class _ColorSection extends StatelessWidget {
  const _ColorSection({
    required this.title,
    required this.subtitle,
    required this.colors,
  });

  final String title;
  final String subtitle;
  final List<_ColorProperty> colors;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
            const SizedBox(height: 12),
            ...colors,
          ],
        ),
      ),
    );
  }
}

class _ColorProperty extends StatelessWidget {
  const _ColorProperty({
    required this.name,
    required this.color,
    required this.onColorSelected,
    required this.baseColors,
    this.useLightVariants = false,
  });

  final String name;
  final Color color;
  final ValueChanged<Color> onColorSelected;
  final List<MaterialColor> baseColors;
  final bool useLightVariants;

  @override
  Widget build(BuildContext context) {
    final colors = useLightVariants
        ? baseColors.map((c) => c.shade100).toList()
        : baseColors.map((c) => c.shade500).toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Expanded(
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: colors.map((c) {
                final isSelected = _colorsMatch(c, color);
                return GestureDetector(
                  onTap: () => onColorSelected(c),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: c,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: c.withValues(alpha: 0.5),
                                blurRadius: 8,
                                spreadRadius: 1,
                              )
                            ]
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  bool _colorsMatch(Color a, Color b) {
    return (a.r - b.r).abs() < 0.01 &&
        (a.g - b.g).abs() < 0.01 &&
        (a.b - b.b).abs() < 0.01;
  }
}

class _StateIndicatorRow extends StatelessWidget {
  const _StateIndicatorRow({required this.indicators});
  final List<_StateIndicator> indicators;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: indicators,
    );
  }
}

class _StateIndicator extends StatelessWidget {
  const _StateIndicator(this.label, this.borderColor, this.fillColor);
  final String label;
  final Color borderColor;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: fillColor,
            border: Border.all(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _ThemePresetCard extends StatelessWidget {
  const _ThemePresetCard({
    required this.name,
    required this.description,
    required this.theme,
  });

  final String name;
  final String description;
  final MaterialPinTheme theme;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(width: 8),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: MaterialPinField(
                length: 4,
                theme: theme,
                onCompleted: (_) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReferenceCategory extends StatelessWidget {
  const _ReferenceCategory({
    required this.title,
    required this.icon,
    required this.properties,
  });

  final String title;
  final IconData icon;
  final List<_PropertyDoc> properties;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(icon, size: 20),
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          children: properties
              .map((p) => ListTile(
                    dense: true,
                    title: Text(
                      p.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontFamily: 'monospace',
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    subtitle: Text(p.description),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class _PropertyDoc {
  const _PropertyDoc(this.name, this.description);
  final String name;
  final String description;
}
