import 'package:flutter/foundation.dart';

import '../services/timer_service.dart';

/// Bridges timer state and controls to the UI layer.
class TimerProvider extends ChangeNotifier {
  TimerProvider({TimerService? timerService})
      : _timerService = timerService ?? TimerService() {
    _timerService.addListener(_relayTimerChanges);
  }

  final TimerService _timerService;

  bool get isRunning => _timerService.isRunning;
  bool get isFocusTime => _timerService.isFocusTime;
  int get remainingSeconds => _timerService.remainingSeconds;
  int get focusMinutes => _timerService.focusMinutes;
  int get breakMinutes => _timerService.breakMinutes;

  void start() => _timerService.startTimer();
  void pause() => _timerService.pauseTimer();
  void resume() => _timerService.resumeTimer();
  void reset() => _timerService.resetTimer();
  void switchMode() => _timerService.switchMode();

  void updateDurations({required int focus, required int rest}) =>
      _timerService.updateDurations(focus: focus, rest: rest);

  void _relayTimerChanges() {
    notifyListeners();
  }

  @override
  void dispose() {
    _timerService.removeListener(_relayTimerChanges);
    _timerService.dispose();
    super.dispose();
  }
}
