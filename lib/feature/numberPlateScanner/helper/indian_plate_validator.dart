/// Strict validation, two-row assembly, and uncertain-candidate recovery for
/// Indian vehicle registration numbers.
class IndianPlateValidator {
  IndianPlateValidator._();

  /// Valid RTO state / union-territory prefixes (includes legacy codes still
  /// seen on the road such as OR, UA, DN, DH and the newer TG).
  static const Set<String> _stateCodes = {
    'AN', 'AP', 'AR', 'AS', 'BR', 'CG', 'CH', 'DD', 'DH', 'DL', 'DN', 'GA',
    'GJ', 'HP', 'HR', 'JH', 'JK', 'KA', 'KL', 'LA', 'LD', 'MH', 'ML', 'MN',
    'MP', 'MZ', 'NL', 'OD', 'OR', 'PB', 'PY', 'RJ', 'SK', 'TG', 'TN', 'TR',
    'TS', 'UA', 'UK', 'UP', 'WB',
  };

  /// STATE(2 letters) + RTO(1-2 digits) + SERIES(1-3 letters) + NUMBER(4 digits)
  /// e.g. HR26DK1234, DL01AB1234, DL8CAC4194 (RTO "8C" + series "AC").
  static final RegExp _standardPlate =
      RegExp(r'^([A-Z]{2})(\d{1,2})([A-Z]{1,3})(\d{4})$');

  /// Bharat series: YY BH NNNN X(X), e.g. 22BH6517A.
  static final RegExp _bharatPlate = RegExp(r'^\d{2}BH\d{4}[A-Z]{1,2}$');

  /// Near-plate pattern used only to surface uncertain candidates for manual
  /// verification when strict validation cannot confirm all characters.
  static final RegExp _nearPlatePattern =
      RegExp(r'^([A-Z0-9]{2}\d{1,2}[A-Z0-9]{1,4}\d{3,4}|\d{2}BH\d{3,4}[A-Z0-9]{1,2})$');

  static final RegExp _noiseWords = RegExp(
    r'\b(IND|INDIA|BHARAT|SARKAR|GOVT)\b',
    caseSensitive: false,
  );

  /// Upper-cases and strips spaces, hyphens and any other non-alphanumerics.
  static String normalize(String raw) =>
      raw.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');

  /// Strips common HSRP noise words while keeping spaces/newlines intact.
  static String stripNoise(String raw) =>
      raw.toUpperCase().replaceAll(_noiseWords, ' ').trim();

  /// Returns the normalised plate if [raw] is a complete valid Indian
  /// registration number, otherwise `null`.
  static String? validate(String raw) {
    final normalized = normalize(raw);

    final standardMatch = _standardPlate.firstMatch(normalized);
    if (standardMatch != null && _stateCodes.contains(standardMatch.group(1))) {
      return normalized;
    }
    if (_bharatPlate.hasMatch(normalized)) {
      return normalized;
    }
    return null;
  }

  /// Attempts conservative position-aware OCR confusion repair (`O/0`, `I/1`,
  /// `B/8`, `S/5`, `Z/2`) when a plate string is almost valid. Returns the
  /// repaired valid plate or `null` if it remains ambiguous.
  static String? repairAndValidate(String raw) {
    final direct = validate(raw);
    if (direct != null) return direct;

    final s = normalize(raw);
    if (s.length < 8 || s.length > 11) return null;

    // Try standard plate repair: 2 letters + 1-2 digits + 1-3 letters + 4 digits.
    final state = _toLetters(s.substring(0, 2));
    if (_stateCodes.contains(state)) {
      final tailDigits = _toDigits(s.substring(s.length - 4));
      if (RegExp(r'^\d{4}$').hasMatch(tailDigits)) {
        final mid = s.substring(2, s.length - 4);
        for (final rtoLen in [2, 1]) {
          if (mid.length <= rtoLen) continue;
          final rto = _toDigits(mid.substring(0, rtoLen));
          final series = _toLetters(mid.substring(rtoLen));
          if (RegExp(r'^\d{1,2}$').hasMatch(rto) &&
              RegExp(r'^[A-Z]{1,3}$').hasMatch(series)) {
            final candidate = '$state$rto$series$tailDigits';
            if (validate(candidate) != null) return candidate;
          }
        }
      }
    }

    // Try BH series repair: YY + BH + 4 digits + 1-2 letters.
    if (s.length >= 9 && s.length <= 10) {
      final yy = _toDigits(s.substring(0, 2));
      final bh = s.substring(2, 4).replaceAll('8', 'B').replaceAll('0', 'O');
      if (RegExp(r'^\d{2}$').hasMatch(yy) && bh == 'BH') {
        final digits = _toDigits(s.substring(4, 8));
        final suffix = _toLetters(s.substring(8));
        if (RegExp(r'^\d{4}$').hasMatch(digits) &&
            RegExp(r'^[A-Z]{1,2}$').hasMatch(suffix)) {
          final candidate = '$yy$bh$digits$suffix';
          if (validate(candidate) != null) return candidate;
        }
      }
    }

    return null;
  }

  /// Extracts the best uncertain/partial alphanumeric candidate from noisy OCR
  /// text so the UI can offer manual verification instead of silently ignoring
  /// a detected plate.
  static String? extractBestUncertainCandidate(String raw) {
    final cleaned = stripNoise(raw);
    if (cleaned.isEmpty) return null;

    final repaired = repairAndValidate(cleaned);
    if (repaired != null) return repaired;

    final tokens = cleaned
        .split(RegExp(r'[\r\n\s\-]+'))
        .map(normalize)
        .where((t) => t.isNotEmpty)
        .toList();

    final candidates = <String>{
      normalize(cleaned),
      ...tokens,
    };
    if (tokens.length >= 2) {
      candidates.add(tokens.join(''));
      for (int i = 0; i < tokens.length - 1; i++) {
        candidates.add('${tokens[i]}${tokens[i + 1]}');
      }
    }

    String? best;
    int bestScore = -1;
    for (final c in candidates) {
      if (c.length < 6 || c.length > 12) continue;
      if (!c.contains(RegExp(r'\d')) || !c.contains(RegExp(r'[A-Z]'))) {
        continue;
      }
      int score = c.length;
      if (_nearPlatePattern.hasMatch(c)) score += 15;
      if (c.length >= 2 && _stateCodes.contains(_toLetters(c.substring(0, 2)))) {
        score += 10;
      }
      if (c.length >= 4 &&
          RegExp(r'^\d{4}$').hasMatch(_toDigits(c.substring(c.length - 4)))) {
        score += 8;
      }
      if (score > bestScore) {
        bestScore = score;
        best = c;
      }
    }
    return bestScore >= 14 ? best : null;
  }

  static bool looksLikePlateCandidate(String raw) {
    final normalized = normalize(raw);
    if (normalized.length < 4) return false;
    final hasDigit = normalized.contains(RegExp(r'\d'));
    final hasLetter = normalized.contains(RegExp(r'[A-Z]'));
    return hasDigit && hasLetter;
  }

  static String _toDigits(String input) => input
      .replaceAll('O', '0')
      .replaceAll('Q', '0')
      .replaceAll('D', '0')
      .replaceAll('I', '1')
      .replaceAll('L', '1')
      .replaceAll('Z', '2')
      .replaceAll('S', '5')
      .replaceAll('G', '6')
      .replaceAll('B', '8');

  static String _toLetters(String input) => input
      .replaceAll('0', 'O')
      .replaceAll('1', 'I')
      .replaceAll('2', 'Z')
      .replaceAll('5', 'S')
      .replaceAll('6', 'G')
      .replaceAll('8', 'B');
}
