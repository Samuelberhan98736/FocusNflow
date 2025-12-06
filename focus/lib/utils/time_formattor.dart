/// Lightweight time and date formatting helpers (no intl dependency).

const _monthAbbreviations = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String formatCountdown(int seconds) {
  if (seconds < 0) seconds = 0;
  final duration = Duration(seconds: seconds);
  return durationToMmSs(duration);
}

String durationToMmSs(Duration duration) {
  final minutes = duration.inMinutes.remainder(60);
  final secs = duration.inSeconds.remainder(60);
  return '${_twoDigits(minutes)}:${_twoDigits(secs)}';
}

String formatShortDate(DateTime date) {
  final month = _monthAbbreviations[date.month - 1];
  return '$month ${date.day}, ${date.year}';
}

String formatTimeOfDay(DateTime date) {
  final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
  final minute = _twoDigits(date.minute);
  final suffix = date.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $suffix';
}

String formatDateTime(DateTime date) {
  return '${formatShortDate(date)} · ${formatTimeOfDay(date)}';
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');
