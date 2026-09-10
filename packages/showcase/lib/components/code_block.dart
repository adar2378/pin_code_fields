import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import '../utils/syntax_highlight.dart';

/// Dark-themed code block with syntax highlighting and copy button.
class CodeBlock extends StatefulWidget {
  const CodeBlock({super.key, required this.code, this.maxHeight});

  final String code;
  final double? maxHeight;

  @override
  State<CodeBlock> createState() => _CodeBlockState();
}

class _CodeBlockState extends State<CodeBlock> {
  bool _copied = false;
  final _highlighter = DartSyntaxHighlighter();

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    if (!mounted) return;
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final highlighted = _highlighter.highlight(widget.code.trimRight());

    Widget codeContent = SelectableText.rich(
      highlighted,
      style: const TextStyle(
        fontFamily: 'monospace',
        fontSize: 13,
        height: 1.6,
      ),
    );

    if (widget.maxHeight != null) {
      codeContent = ConstrainedBox(
        constraints: BoxConstraints(maxHeight: widget.maxHeight!),
        child: SingleChildScrollView(child: codeContent),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A3E)),
      ),
      child: Stack(
        children: [
          Padding(padding: const EdgeInsets.all(20), child: codeContent),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              onPressed: _copyToClipboard,
              icon: Icon(
                _copied ? Icons.check : Icons.copy,
                size: 18,
                color: _copied
                    ? const Color(0xFF10B981)
                    : const Color(0xFF6B7280),
              ),
              tooltip: _copied ? 'Copied!' : 'Copy code',
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFF2A2A3E).withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
