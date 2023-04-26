import 'package:flutter/material.dart';
import 'package:productivity_timer/countdown_timer/notification_api.dart';
import 'package:timezone/data/latest_all.dart' as tz;

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

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    NotofocationApi.init();
    listenNotofocations();
    tz.initializeTimeZones();
  }

  void listenNotofocations() => NotofocationApi.onNotifications.stream.listen(
        (payloadEvent) =>
            debugPrint(payloadEvent.toString()), // here can be any actions
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification test')),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 30),
          FilledButton.icon(
              onPressed: () => NotofocationApi.showNotification(
                    title: 'Title',
                    body: 'Body message',
                    payload: 'some payload',
                  ),
              icon: const Icon(Icons.notifications),
              label: const Text('Simple Notification')),
          const SizedBox(height: 30),
          FilledButton.icon(
              onPressed: () => NotofocationApi.showScheduledNotification(
                    title: 'Deferred activity',
                    body: 'After 12 seconds',
                    payload: 'it is scheduled notification',
                    scheduleDate: DateTime.now().add(Duration(seconds: 12)),
                  ),
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
