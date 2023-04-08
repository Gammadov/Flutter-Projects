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

  int _countFrom = 10;

  @override
  void dispose() {
    super.dispose();
    _timer.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            StreamBuilder(
                initialData: _countFrom,
                stream: _timer.stream,
                builder: (context, snapshot) {
                  return Text(
                    '${snapshot.data}',
                    style: TextStyle(fontSize: 70),
                  );
                }),
            SizedBox(
              height: 20,
            ),
            FilledButton(
                onPressed: () {
                  _timer.countdown(_countFrom);
                },
                child: Text('Start Count Down')),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class CountdownTimer {
  final StreamController<int> _controller = StreamController();
  bool isBusy = false;

  Stream<int> get stream => _controller.stream;

  void close() => _controller.close();

  void countdown(int countFrom) async {
    _controller.onResume;

    if (!isBusy) {
      isBusy = true;
      int innerCount = countFrom;
      // debugPrint(DateTime.now().toString());
      Timer.periodic(Duration(seconds: 1), (timer) {
        innerCount--;
        _controller.sink.add(innerCount);

        if (innerCount <= 0) {
          timer.cancel();
          // debugPrint(DateTime.now().toString());
          _controller.sink.add(countFrom);
          _controller.onPause;
          isBusy = false;
        }
      });
    }
  }
}
