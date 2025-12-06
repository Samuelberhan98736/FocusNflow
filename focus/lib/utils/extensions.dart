import 'package:flutter/widgets.dart';

import 'time_formattor.dart';

extension StringExtensions on String {
  /// Capitalizes the first character.
  String get capitalized =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  /// Returns initials from the string when used as a name.
  String get initials {
    final parts = trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    final chars = parts.take(2).map((p) => p[0].toUpperCase()).join();
    return chars.isEmpty ? '?' : chars;
  }
}

extension DurationExtensions on Duration {
  /// Formats the duration as mm:ss (e.g., 05:30).
  String get mmSs => durationToMmSs(this);
}

extension DateTimeExtensions on DateTime {
  String get shortDate => formatShortDate(this);
  String get timeOfDay => formatTimeOfDay(this);
  String get friendlyDateTime => formatDateTime(this);
}

extension ContextExtensions on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  EdgeInsets get padding => mediaQuery.padding;
}
