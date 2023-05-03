import 'package:flutter/material.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';

class TestAlarm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter alarm clock package test',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: AlarmPage(),
    );
  }
}

class AlarmPage extends StatefulWidget {
  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  TextEditingController minuteController = TextEditingController();
  TextEditingController _seconds = TextEditingController();

  @override
  void initState() {
    _seconds.text = '0';
    super.initState();
  }

  @override
  void dispose() {
    _seconds.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter alarm clock package test'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _seconds,
              style: const TextStyle(fontSize: 24),
              decoration: const InputDecoration(
                labelText: 'Seconds',
                labelStyle: TextStyle(fontSize: 17),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                FilledButton(
                  onPressed: () {
                    final seconds = int.tryParse(_seconds.text) ?? 0;

                    FlutterAlarmClock.createTimer(seconds);
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 15),
                            Text(
                              seconds == 0 ? 'Zero time' : 'Timer is set',
                              style: TextStyle(fontSize: 17),
                            ),
                            const SizedBox(height: 15),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Create timer',
                  ),
                ),
                const SizedBox(width: 16),
                FilledButton.tonal(
                  onPressed: () {
                    FlutterAlarmClock.showTimers();
                  },
                  child: Text("Show Timers"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
