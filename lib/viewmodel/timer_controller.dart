import 'dart:async';

import 'manager.dart';

class GameTimer {
  static String timerText = '00:00:00';
  static int _second = 0, _minute = 0, _hour = 0;
  static bool _timerRun = false;

  static void runTimer() {
    GameTimer.manageTimer();
  }

  static String showTimer() {
    return GameTimer.timerText;
  }

  static void manageTimer() {
    if (Manager.gameRun && !Manager.gameOver && !Manager.isPause) {
      if (!_timerRun) {
        _timerRun = true;
        _setTimer();
      }
    } else {
      _timerRun = false;
      if (Manager.gameOver) _resetTimer();
    }
  }

  static void _resetTimer() {
    _second = 0;
    _minute = 0;
    _hour = 0;
    timerText = '00:00:00';
    _timerRun = false;
  }

  static void _setTimer() {
    Duration time = Duration(seconds: 1);
    Timer.periodic(time, (t) {
      if (!_timerRun) {
        t.cancel();
      } else {
        if (_second < 59)
          _second++;
        else {
          _second = 0;
          if (_minute < 59)
            _minute++;
          else {
            _minute = 0;
            _hour++;
          }
        }
        timerText = _hour.toString().length == 1 ? '0$_hour' : '$_hour';
        timerText += ':';
        timerText += _minute.toString().length == 1 ? '0$_minute' : '$_minute';
        timerText += ':';
        timerText += _second.toString().length == 1 ? '0$_second' : '$_second';
      }
    });
  }
}
