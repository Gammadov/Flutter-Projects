import 'package:flutter/material.dart';

void main() => runApp(const HelloWorldApp());

class HelloWorldApp extends StatelessWidget {
  const HelloWorldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Hello World",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Hello World Travel App"),
          backgroundColor: Colors.deepPurple,
        ),
        body: Builder(
          builder: (context) => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Hello World Travel',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800]),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        'Discover the World',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                          decoration: const BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Colors.blue,
                                blurRadius: 10,
                                spreadRadius: 2)
                          ]),
                          child: Image.network(
                            'https://images.freeimages.com/images/large-previews/eaa/the-beach-1464354.jpg',
                            height: 350,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: ElevatedButton(
                        child: const Text('Contact Us'),
                        // onPressed: () => debugPrint('Contact us'),
                        onPressed: () => contactUs(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void contactUs(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Contact Us'),
          content: const Text('Mail us at hello@world.com'),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }
}
