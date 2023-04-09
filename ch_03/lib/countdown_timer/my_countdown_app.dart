import 'dart:async';
import 'package:flutter/material.dart';

class CountdownApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CountdownTimer _timer = CountdownTimer();

  @override
  void dispose() {
    _timer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            StreamBuilder(
                // initialData: ,
                stream: _timer.stream,
                builder: (context, snapshot) {
                  return Text(
                    '${snapshot.data}',
                    style: TextStyle(fontSize: 70),
                  );
                }),
            const SizedBox(height: 50),
            FilledButton(
              onPressed: () {
                debugPrint('Check');
                _timer.start(10);
                debugPrint(_timer._isActive.toString());
                debugPrint(_timer._count.toString());
              },
              // onPressed: () {},
              child: Text('Start countdown'),
            ),
            const SizedBox(height: 30),
            FilledButton(
              onPressed: () => _timer.pause(),
              // onPressed: () {},
              child: Text('Pause'),
            ),
            const SizedBox(height: 30),
            FilledButton(
              onPressed: () => _timer.resume(),
              // onPressed: () {},
              child: Text('Resume'),
            ),
            const SizedBox(height: 30),
            // FilledButton(
            //   // onPressed: () => _timer.cancel(),
            //   onPressed: () {},
            //   child: Text('Cancel'),
            // ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class CountdownTimer {
  final StreamController<int> _controller = StreamController();
  bool _isActive = true;
  int _count = 0;

  Stream<int> get stream => _controller.stream;

  late final Timer _engine;

  CountdownTimer() {
    _engine = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isActive) {
        if (_count > 0) {
          _count--;
          _controller.sink.add(_count);
        } else {
          _isActive = false;
        }
      }
    });
  }

  void start(int countFrom) {
    _count = countFrom;
    _isActive = true;
  }

  void pause() {
    _isActive = false;
  }

  void resume() {
    _isActive = true;
  }

  void dispose() {
    _controller.close();
    _engine.cancel();
  }
}
