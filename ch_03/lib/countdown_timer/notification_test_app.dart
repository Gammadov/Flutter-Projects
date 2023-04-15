import 'package:flutter/material.dart';

class TestNotification extends StatelessWidget {
  const TestNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Notification Test',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: NotificationScreen());
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification test')),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 30),
          FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.notifications),
              label: const Text('Simple Notification')),
          const SizedBox(height: 30),
          FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.notifications_active),
              label: const Text('Scheduled Notification')),
          const SizedBox(height: 30),
          FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.delete_forever),
              label: const Text('Remove Notifications')),
          const SizedBox(height: 30),
        ]),
      ),
    );
  }
}
