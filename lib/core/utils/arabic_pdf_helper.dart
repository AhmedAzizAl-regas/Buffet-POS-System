import 'package:intl/intl.dart';

class ArabicPdfHelper {
  // Classification of Arabic characters
  static const _rightConnectors = {
    'ا', 'أ', 'إ', 'آ', 'د', 'ذ', 'ر', 'ز', 'و', 'ؤ', 'ة', 'ى',
    '\uFEF5', '\uFEF7', '\uFEF9', '\uFEFB' // Lam-Alef ligatures
  };

  static const _dualConnectors = {
    'ب', 'ت', 'ث', 'ج', 'ح', 'خ', 'س', 'ش', 'ص', 'ض', 'ط', 'ظ',
    'ع', 'غ', 'ف', 'ق', 'ك', 'ل', 'م', 'ن', 'ه', 'ي', 'ئ'
  };

  // Shapes dictionary: [Isolated, Final, Initial, Medial]
  static const _shapes = {
    'ا': ['\uFE8D', '\uFE8E', '\uFE8D', '\uFE8E'],
    'أ': ['\uFE83', '\uFE84', '\uFE83', '\uFE84'],
    'إ': ['\uFE87', '\uFE88', '\uFE87', '\uFE88'],
    'آ': ['\uFE81', '\uFE82', '\uFE81', '\uFE82'],
    'ب': ['\uFE8F', '\uFE90', '\uFE91', '\uFE92'],
    'ت': ['\uFE95', '\uFE96', '\uFE97', '\uFE98'],
    'ث': ['\uFE99', '\uFE9A', '\uFE9B', '\uFE9C'],
    'ج': ['\uFE9D', '\uFE9E', '\uFE9F', '\uFEA0'],
    'ح': ['\uFEA1', '\uFEA2', '\uFEA3', '\uFEA4'],
    'خ': ['\uFEA5', '\uFEA6', '\uFEA7', '\uFEA8'],
    'د': ['\uFEA9', '\uFEAA', '\uFEA9', '\uFEAA'],
    'ذ': ['\uFEAB', '\uFEAC', '\uFEAB', '\uFEAC'],
    'ر': ['\uFEAD', '\uFEAE', '\uFEAD', '\uFEAE'],
    'ز': ['\uFEAF', '\uFEB0', '\uFEAF', '\uFEB0'],
    'س': ['\uFEB1', '\uFEB2', '\uFEB3', '\uFEB4'],
    'ش': ['\uFEB5', '\uFEB6', '\uFEB7', '\uFEB8'],
    'ص': ['\uFEB9', '\uFEBA', '\uFEBB', '\uFEBC'],
    'ض': ['\uFEBD', '\uFEBE', '\uFEBF', '\uFEC0'],
    'ط': ['\uFEC1', '\uFEC2', '\uFEC3', '\uFEC4'],
    'ظ': ['\uFEC5', '\uFEC6', '\uFEC7', '\uFEC8'],
    'ع': ['\uFEC9', '\uFECA', '\uFECB', '\uFECC'],
    'غ': ['\uFECD', '\uFECE', '\uFECF', '\uFED0'],
    'ف': ['\uFED1', '\uFED2', '\uFED3', '\uFED4'],
    'ق': ['\uFED5', '\uFED6', '\uFED7', '\uFED8'],
    'ك': ['\uFED9', '\uFEDA', '\uFEDB', '\uFEDC'],
    'ل': ['\uFEDD', '\uFEDE', '\uFEDF', '\uFEE0'],
    'م': ['\uFEE1', '\uFEE2', '\uFEE3', '\uFEE4'],
    'ن': ['\uFEE5', '\uFEE6', '\uFEE7', '\uFEE8'],
    'ه': ['\uFEE9', '\uFEEA', '\uFEEB', '\uFEEC'],
    'و': ['\uFEED', '\uFEEE', '\uFEED', '\uFEEE'],
    'ؤ': ['\uFE85', '\uFE86', '\uFE85', '\uFE86'],
    'ة': ['\uFE93', '\uFE94', '\uFE93', '\uFE94'],
    'ى': ['\uFEEF', '\uFEF0', '\uFEEF', '\uFEF0'],
    'ي': ['\uFEF1', '\uFEF2', '\uFEF3', '\uFEF4'],
    'ئ': ['\uFE89', '\uFE8A', '\uFE8B', '\uFE8C'],
    'ء': ['\uFE80', '\uFE80', '\uFE80', '\uFE80'],
    '\uFEF5': ['\uFEF5', '\uFEF6', '\uFEF5', '\uFEF6'], // لأ Isolated/Final
    '\uFEF7': ['\uFEF7', '\uFEF8', '\uFEF7', '\uFEF8'], // لأ Isolated/Final
    '\uFEF9': ['\uFEF9', '\uFEFA', '\uFEF9', '\uFEFA'], // لإ Isolated/Final
    '\uFEFB': ['\uFEFB', '\uFEFC', '\uFEFB', '\uFEFC'], // لا Isolated/Final
  };

  static String _preprocessLamAlef(String text) {
    text = text.replaceAll('لآ', '\uFEF5');
    text = text.replaceAll('لأ', '\uFEF7');
    text = text.replaceAll('لإ', '\uFEF9');
    text = text.replaceAll('لا', '\uFEFB');
    return text;
  }

  /// Shapes raw Arabic text and formats it beautifully for LTR PDF text nodes.
  static String shape(String text) {
    if (text.isEmpty) return text;

    // Preprocess Lam-Alef combinations
    text = _preprocessLamAlef(text);

    final List<String> chars = text.split('');
    final List<String> result = List.from(chars);

    for (int i = 0; i < chars.length; i++) {
      final String c = chars[i];
      if (!_shapes.containsKey(c)) continue;

      bool connectsToRight = false;
      if (i > 0) {
        final String prev = chars[i - 1];
        if (_dualConnectors.contains(prev)) {
          connectsToRight = true;
        }
      }

      bool connectsToLeft = false;
      if (i < chars.length - 1) {
        final String next = chars[i + 1];
        if (_dualConnectors.contains(c)) {
          if (_dualConnectors.contains(next) || _rightConnectors.contains(next)) {
            connectsToLeft = true;
          }
        }
      }

      final shapes = _shapes[c]!;
      if (connectsToRight && connectsToLeft) {
        result[i] = shapes[3]; // Medial
      } else if (connectsToRight) {
        result[i] = shapes[1]; // Final
      } else if (connectsToLeft) {
        result[i] = shapes[2]; // Initial
      } else {
        result[i] = shapes[0]; // Isolated
      }
    }

    return _reverseArabicWords(result.join(''));
  }

  static String _reverseArabicWords(String text) {
    final List<String> segments = [];
    String currentSegment = "";
    bool isCurrentArabic = false;

    for (int i = 0; i < text.length; i++) {
      final String c = text[i];
      final bool isArabicChar = _isArabic(c);

      if (i == 0) {
        isCurrentArabic = isArabicChar;
        currentSegment = c;
      } else {
        if (isArabicChar == isCurrentArabic) {
          currentSegment += c;
        } else {
          segments.add(_processSegment(currentSegment, isCurrentArabic));
          isCurrentArabic = isArabicChar;
          currentSegment = c;
        }
      }
    }
    if (currentSegment.isNotEmpty) {
      segments.add(_processSegment(currentSegment, isCurrentArabic));
    }

    // Mirror bracket/parenthesis pairs in non-Arabic segments so they render correctly in RTL PDF
    final List<String> mirroredSegments = segments.map((seg) {
      return seg.split('').map((ch) {
        if (ch == '(') return ')';
        if (ch == ')') return '(';
        if (ch == '[') return ']';
        if (ch == ']') return '[';
        if (ch == '{') return '}';
        if (ch == '}') return '{';
        if (ch == '<') return '>';
        if (ch == '>') return '<';
        if (ch == '«') return '»';
        if (ch == '»') return '«';
        return ch;
      }).join('');
    }).toList();

    // Since PDF prints LTR, we reverse the segment order to lay out RTL
    return mirroredSegments.reversed.join('');
  }

  static bool _isArabic(String c) {
    if (c.isEmpty) return false;
    final int code = c.codeUnitAt(0);
    return (code >= 0x0600 && code <= 0x06FF) ||
           (code >= 0xFE70 && code <= 0xFEFF);
  }

  static String _processSegment(String segment, bool isArabic) {
    if (isArabic) {
      return segment.split('').reversed.join('');
    } else {
      return segment;
    }
  }
}
