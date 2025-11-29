import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerService extends ChangeNotifier {
  // Pomodoro default times (in minutes)
  int focusMinutes = 25;
  int breakMinutes = 5;

  // Timer state
  int remainingSeconds = 0;
  bool isRunning = false;
  bool isFocusTime = true;

  Timer? _timer;

  // Start the timer
  void startTimer() {
    if (isRunning) return;

    remainingSeconds = (isFocusTime ? focusMinutes : breakMinutes) * 60;
    isRunning = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        remainingSeconds--;
        notifyListeners();
      } else {
        timer.cancel();
        isRunning = false;
        switchMode();
      }
    });

    notifyListeners();
  }

  // Pause the timer
  void pauseTimer() {
    if (!isRunning) return;

    _timer?.cancel();
    isRunning = false;
    notifyListeners();
  }

  // Resume a paused timer
  void resumeTimer() {
    if (isRunning || remainingSeconds <= 0) return;

    isRunning = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        remainingSeconds--;
        notifyListeners();
      } else {
        timer.cancel();
        isRunning = false;
        switchMode();
      }
    });

    notifyListeners();
  }

  // Reset timer
  void resetTimer() {
    _timer?.cancel();
    isRunning = false;
    remainingSeconds = 0;
    notifyListeners();
  }

  // Switch between focus → break → focus
  void switchMode() {
    isFocusTime = !isFocusTime;
    remainingSeconds = (isFocusTime ? focusMinutes : breakMinutes) * 60;
    notifyListeners();
  }

  // Update user-selected durations
  void updateDurations({required int focus, required int rest}) {
    focusMinutes = focus;
    breakMinutes = rest;
    notifyListeners();
  }

  // Dispose
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
