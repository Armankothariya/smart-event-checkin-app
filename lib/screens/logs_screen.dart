import 'package:flutter/material.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  final _searchController = TextEditingController();
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Placeholder list
    final logs = [
      {'id': '101', 'name': 'Participant A', 'time': '10:05 AM', 'status': 'Checked In'},
      {'id': '102', 'name': 'Participant B', 'time': '10:12 AM', 'status': 'Checked In'},
      {'id': '103', 'name': 'Participant C', 'time': '10:25 AM', 'status': 'Checked In'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-In Logs'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search by ID or Name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // TODO: Implement search filter
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green[100],
                    child: const Icon(Icons.check, color: Colors.green),
                  ),
                  title: Text('${log['name']} (${log['id']})'),
                  subtitle: Text('Time: ${log['time']}'),
                  trailing: Text(log['status']!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
