import 'package:flutter/material.dart';

import '../utils/time_formattor.dart';
import 'custom_buttom.dart';

/// Displays a simple focus/break timer with controls.
class TimerDisplay extends StatelessWidget {
  const TimerDisplay({
    super.key,
    required this.remainingSeconds,
    required this.isFocusTime,
    required this.isRunning,
    this.onStart,
    this.onPause,
    this.onResume,
    this.onReset,
    this.onSkip,
  });

  final int remainingSeconds;
  final bool isFocusTime;
  final bool isRunning;
  final VoidCallback? onStart;
  final VoidCallback? onPause;
  final VoidCallback? onResume;
  final VoidCallback? onReset;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final title = isFocusTime ? 'Focus Time' : 'Break Time';
    final timeText = formatCountdown(remainingSeconds);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          timeText,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: onReset,
              icon: const Icon(Icons.refresh),
              tooltip: 'Reset',
            ),
            const SizedBox(width: 8),
            if (!isRunning)
              CustomButton(
                label: remainingSeconds > 0 ? 'Resume' : 'Start',
                onPressed: remainingSeconds > 0 ? onResume ?? onStart : onStart,
                expand: false,
              )
            else
              CustomButton(
                label: 'Pause',
                onPressed: onPause,
                expand: false,
              ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: onSkip,
              icon: const Icon(Icons.skip_next),
              tooltip: 'Skip',
            ),
          ],
        ),
      ],
    );
  }
}
