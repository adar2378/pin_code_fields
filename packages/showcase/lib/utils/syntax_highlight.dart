import 'package:material_ui/material_ui.dart';

/// Simple regex-based Dart syntax highlighting for code blocks.
class DartSyntaxHighlighter {
  DartSyntaxHighlighter({
    this.keywordColor = const Color(0xFF569CD6),
    this.stringColor = const Color(0xFFCE9178),
    this.commentColor = const Color(0xFF6A9955),
    this.numberColor = const Color(0xFFB5CEA8),
    this.annotationColor = const Color(0xFFDCDCAA),
    this.classColor = const Color(0xFF4EC9B0),
    this.punctuationColor = const Color(0xFFD4D4D4),
    this.defaultColor = const Color(0xFFD4D4D4),
    this.propertyColor = const Color(0xFF9CDCFE),
  });

  final Color keywordColor;
  final Color stringColor;
  final Color commentColor;
  final Color numberColor;
  final Color annotationColor;
  final Color classColor;
  final Color punctuationColor;
  final Color defaultColor;
  final Color propertyColor;

  static const _keywords = {
    'abstract',
    'as',
    'assert',
    'async',
    'await',
    'break',
    'case',
    'catch',
    'class',
    'const',
    'continue',
    'covariant',
    'default',
    'deferred',
    'do',
    'dynamic',
    'else',
    'enum',
    'export',
    'extends',
    'extension',
    'external',
    'factory',
    'false',
    'final',
    'finally',
    'for',
    'Function',
    'get',
    'hide',
    'if',
    'implements',
    'import',
    'in',
    'interface',
    'is',
    'late',
    'library',
    'mixin',
    'new',
    'null',
    'on',
    'operator',
    'part',
    'required',
    'rethrow',
    'return',
    'sealed',
    'set',
    'show',
    'static',
    'super',
    'switch',
    'sync',
    'this',
    'throw',
    'true',
    'try',
    'typedef',
    'var',
    'void',
    'when',
    'while',
    'with',
    'yield',
    'override',
    'int',
    'double',
    'String',
    'bool',
    'List',
    'Map',
    'Set',
    'Future',
    'Stream',
  };

  // Regex patterns ordered by priority
  static final _patterns = [
    // Comments (single-line)
    RegExp(r'//.*$', multiLine: true),
    // Multi-line strings
    RegExp(r"'''[\s\S]*?'''"),
    RegExp(r'"""[\s\S]*?"""'),
    // Strings (single and double quoted)
    RegExp(r"'(?:[^'\\]|\\.)*'"),
    RegExp(r'"(?:[^"\\]|\\.)*"'),
    // Annotations
    RegExp(r'@\w+'),
    // Numbers
    RegExp(r'\b\d+\.?\d*\b'),
    // Keywords (word boundary)
    RegExp(r'\b(?:' + _keywords.join('|') + r')\b'),
    // Class-like identifiers (PascalCase)
    RegExp(r'\b[A-Z][a-zA-Z0-9]*\b'),
    // Named parameters
    RegExp(r'\b\w+(?=\s*:)'),
  ];

  TextSpan highlight(String code) {
    final spans = <TextSpan>[];
    final matches = <_Match>[];

    // Collect all matches
    for (var i = 0; i < _patterns.length; i++) {
      for (final match in _patterns[i].allMatches(code)) {
        matches.add(_Match(match.start, match.end, i));
      }
    }

    // Sort by start position, then by priority (lower index = higher priority)
    matches.sort((a, b) {
      final cmp = a.start.compareTo(b.start);
      return cmp != 0 ? cmp : a.patternIndex.compareTo(b.patternIndex);
    });

    // Remove overlapping matches (keep higher priority)
    final filtered = <_Match>[];
    var lastEnd = 0;
    for (final m in matches) {
      if (m.start >= lastEnd) {
        filtered.add(m);
        lastEnd = m.end;
      }
    }

    // Build spans
    var pos = 0;
    for (final m in filtered) {
      // Add plain text before this match
      if (m.start > pos) {
        spans.add(
          TextSpan(
            text: code.substring(pos, m.start),
            style: TextStyle(color: defaultColor),
          ),
        );
      }

      // Add colored match
      final text = code.substring(m.start, m.end);
      final color = _colorForPattern(m.patternIndex);
      spans.add(
        TextSpan(
          text: text,
          style: TextStyle(color: color),
        ),
      );

      pos = m.end;
    }

    // Add remaining text
    if (pos < code.length) {
      spans.add(
        TextSpan(
          text: code.substring(pos),
          style: TextStyle(color: defaultColor),
        ),
      );
    }

    return TextSpan(children: spans);
  }

  Color _colorForPattern(int index) {
    return switch (index) {
      0 => commentColor, // Comments
      1 || 2 => stringColor, // Multi-line strings
      3 || 4 => stringColor, // Strings
      5 => annotationColor, // Annotations
      6 => numberColor, // Numbers
      7 => keywordColor, // Keywords
      8 => classColor, // PascalCase (class names)
      9 => propertyColor, // Named parameters
      _ => defaultColor,
    };
  }
}

class _Match {
  const _Match(this.start, this.end, this.patternIndex);
  final int start;
  final int end;
  final int patternIndex;
}
