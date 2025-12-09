import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/timer_service.dart';
import '../../widgets/timer_display.dart';

class SharedTimerScreen extends StatelessWidget {
  const SharedTimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shared Timer')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<TimerService>(
            builder: (_, timer, __) => TimerDisplay(
              remainingSeconds: timer.remainingSeconds,
              isFocusTime: timer.isFocusTime,
              isRunning: timer.isRunning,
              onStart: timer.startTimer,
              onPause: timer.pauseTimer,
              onResume: timer.resumeTimer,
              onReset: timer.resetTimer,
              onSkip: timer.switchMode,
            ),
          ),
        ),
      ),
    );
  }
}
