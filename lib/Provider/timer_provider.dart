import 'dart:async';
import 'package:flutter/material.dart';

class TimerProvider with ChangeNotifier {
  String? selectedCourse;
  static const int _defaultMaxSeconds = 3600;
  int maxSeconds = _defaultMaxSeconds;
  int seconds = _defaultMaxSeconds;
  Timer? timer;
  bool isPaused = false;
  bool hasStarted = false;
  VoidCallback? onTimerFinish;
  int currentImageIndex = 0;
  int currentImageLevel = 0;

  void updateCurrentImageIndex(int newIndex) {
    currentImageIndex = newIndex;
    notifyListeners();
  }

  void updateCurrentImageLevel(int newLevel) {
    currentImageLevel = newLevel;
    notifyListeners();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(microseconds: 1), (_) {
      if (!isPaused) {
        if (seconds > 0) {
          seconds--;
          hasStarted = true;
          calculateCurrentImageLevel();
        } else {
          stopTimer(reset: true);
          Future.delayed(const Duration(seconds: 1), () {
            if (onTimerFinish != null && seconds == maxSeconds) {
              onTimerFinish!();
            }
          });
        }
        notifyListeners();
      }
    });
  }

  void stopTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }
    timer?.cancel();
    hasStarted = false;
    notifyListeners();
  }

  void resetTimer() {
    seconds = maxSeconds;
    isPaused = false;
    hasStarted = false;
    notifyListeners();
  }

  void calculateCurrentImageLevel() {
    int timeIndicator = maxSeconds - seconds;
    if (timeIndicator > 0 && timeIndicator <= 3599) {
      currentImageLevel = 0;
    } else if (timeIndicator > 3599 && timeIndicator <= 7199) {
      currentImageLevel = 1;
    } else if (timeIndicator > 7199 && timeIndicator <= 10799) {
      currentImageLevel = 2;
    } else if (timeIndicator > 10799) {
      currentImageLevel = 3;
    }
  }
}
