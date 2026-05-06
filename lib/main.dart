import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/event_setup_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/checkin_screen.dart';
import 'screens/logs_screen.dart';

void main() {
  runApp(const EventCheckinApp());
}

class EventCheckinApp extends StatelessWidget {
  const EventCheckinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Event Check-in',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const EventSetupScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/checkin': (context) => const CheckinScreen(),
        '/logs': (context) => const LogsScreen(),
      },
    );
  }
}
