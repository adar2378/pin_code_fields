import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// Headless Builder - Completely custom UI
class HeadlessBuilderDemo extends StatelessWidget {
  const HeadlessBuilderDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Headless Builder')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Build Your Own UI',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Use PinInput with a custom builder for full control',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 32),

          // Example 1: Circular dots
          const Text('Circular Dots',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          PinInput(
            length: 4,
            autoFocus: true,
            builder: (context, cells) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: cells.map((cell) {
                  return Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cell.isFilled
                          ? colorScheme.primary
                          : cell.isFocused
                              ? colorScheme.primaryContainer
                              : colorScheme.surfaceContainerHighest,
                      border: Border.all(
                        color: cell.isFocused
                            ? colorScheme.primary
                            : colorScheme.outline,
                        width: cell.isFocused ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: cell.isFilled
                          ? Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            )
                          : cell.isFocused
                              ? Container(
                                  width: 2,
                                  height: 24,
                                  color: colorScheme.primary,
                                )
                              : null,
                    ),
                  );
                }).toList(),
              );
            },
            onCompleted: (pin) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('PIN: $pin')),
              );
            },
          ),
          const SizedBox(height: 48),

          // Example 2: Squares with numbers
          const Text('Visible Numbers',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          PinInput(
            length: 6,
            builder: (context, cells) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: cells.map((cell) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 44,
                    height: 52,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: cell.isFilled
                          ? colorScheme.primary
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: cell.isFocused
                          ? [
                              BoxShadow(
                                color:
                                    colorScheme.primary.withValues(alpha: 0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                              )
                            ]
                          : null,
                    ),
                    child: Center(
                      child: cell.isFilled
                          ? Text(
                              cell.character!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : cell.isFocused
                              ? Icon(
                                  Icons.keyboard,
                                  color: colorScheme.onSurfaceVariant,
                                  size: 20,
                                )
                              : Text(
                                  '${cell.index + 1}',
                                  style: TextStyle(
                                    color: colorScheme.outline,
                                    fontSize: 14,
                                  ),
                                ),
                    ),
                  );
                }).toList(),
              );
            },
            onCompleted: (_) {},
          ),
          const SizedBox(height: 48),

          // Example 3: Underline only
          const Text('Minimalist Underline',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          PinInput(
            length: 5,
            builder: (context, cells) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: cells.map((cell) {
                  return Container(
                    width: 48,
                    height: 56,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: cell.isFocused
                              ? colorScheme.primary
                              : cell.isFilled
                                  ? colorScheme.onSurface
                                  : colorScheme.outline,
                          width: cell.isFocused ? 3 : 2,
                        ),
                      ),
                    ),
                    child: Center(
                      child: cell.isFilled
                          ? Text(
                              cell.character!,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface,
                              ),
                            )
                          : null,
                    ),
                  );
                }).toList(),
              );
            },
            onCompleted: (_) {},
          ),
        ],
      ),
    );
  }
}
