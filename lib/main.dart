import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/event_setup_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/checkin_screen.dart';
import 'screens/logs_screen.dart';
import 'providers/event_provider.dart';
import 'models/event.dart';
import 'models/participant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  Hive.registerAdapter(EventModelAdapter());
  Hive.registerAdapter(ParticipantAdapter());

  final provider = EventProvider();
  await provider.init();

  runApp(
    ChangeNotifierProvider.value(
      value: provider,
      child: const EventCheckinApp(),
    ),
  );
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
      initialRoute: context.read<EventProvider>().isEventSetup ? '/dashboard' : '/',
      routes: {
        '/': (context) => const EventSetupScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/checkin': (context) => const CheckinScreen(),
        '/logs': (context) => const LogsScreen(),
      },
    );
  }
}
