/// Grab-bag of small helpers that don't fit elsewhere.

/// Returns `null` when the provided string is empty/blank; otherwise returns
/// the trimmed string.
String? nullIfEmpty(String? value) {
  final trimmed = value?.trim() ?? '';
  return trimmed.isEmpty ? null : trimmed;
}

/// Safely executes [action] and returns its result, or `null` on error.
T? tryOrNull<T>(T Function() action) {
  try {
    return action();
  } catch (_) {
    return null;
  }
}

/// Safely executes an async [action] and returns its result, or `null` on error.
Future<T?> tryAsyncOrNull<T>(Future<T> Function() action) async {
  try {
    return await action();
  } catch (_) {
    return null;
  }
}

/// Converts a full name into initials (e.g., "Ada Lovelace" -> "AL").
String initialsFromName(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
  final initials = parts.take(2).map((p) => p[0].toUpperCase()).join();
  return initials.isEmpty ? '?' : initials;
}

/// Truncates text to [maxLength], adding "..." when trimmed.
String ellipsize(String text, {int maxLength = 120}) {
  if (text.length <= maxLength) return text;
  return '${text.substring(0, maxLength)}...';
}
