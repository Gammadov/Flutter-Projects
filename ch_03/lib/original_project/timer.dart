import 'dart:async';
import './timermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountDownTimer {
  double _arc = 1;
  bool _isActive = true;
  Timer? timer;
  late Duration _time;
  late Duration _fullTime;
  int work = 30;
  int shortBreak = 5;
  int longBreak = 20;

  String returnTime(Duration t) {
    String minutes = (t.inMinutes < 10)
        ? '0' + t.inMinutes.toString()
        : t.inMinutes.toString();
    int numSeconds = t.inSeconds - (t.inMinutes * 60);
    String seconds =
        (numSeconds < 10) ? '0' + numSeconds.toString() : numSeconds.toString();
    String formattedTime = minutes + ":" + seconds;
    return formattedTime;
  }

  Stream<TimerModel> stream() async* {
    yield* Stream.periodic(Duration(seconds: 1), (int a) {
      String time;
      if (this._isActive) {
        _time = _time - Duration(seconds: 1);
        _arc = _time.inSeconds / _fullTime.inSeconds;
        if (_time.inSeconds <= 0) {
          _isActive = false;
        }
      }
      time = returnTime(_time);
      return TimerModel(time, _arc);
    });
  }

  Future readSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    work = prefs.getInt('workTime') == null ? 30 : prefs.getInt('workTime')!;
    shortBreak =
        prefs.getInt('shortBreak') == null ? 30 : prefs.getInt('shortBreak')!;
    longBreak =
        prefs.getInt('longBreak') == null ? 30 : prefs.getInt('longBreak')!;
  }

  void stopTimer() {
    this._isActive = false;
  }

  void startTimer() {
    if (_time.inSeconds > 0) {
      this._isActive = true;
    }
  }

  void startWork() async {
    await readSettings();
    _arc = 1;
    _time = Duration(minutes: this.work, seconds: 0);
    _fullTime = _time;
  }

  void startBreak(bool isShort) {
    _arc = 1;
    _time = Duration(minutes: (isShort) ? shortBreak : longBreak, seconds: 0);
    _fullTime = _time;
  }
}
