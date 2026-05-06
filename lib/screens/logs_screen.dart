import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import 'package:intl/intl.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-In Logs'),
      ),
      body: Consumer<EventProvider>(
        builder: (context, provider, child) {
          final allLogs = provider.participants.reversed.toList(); // Newest first
          final filteredLogs = allLogs.where((p) {
            final lowerQuery = _searchQuery.toLowerCase();
            return p.id.toLowerCase().contains(lowerQuery) || 
                   p.name.toLowerCase().contains(lowerQuery);
          }).toList();

          return Column(
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
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: filteredLogs.isEmpty
                    ? const Center(
                        child: Text(
                          'No participants found.',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredLogs.length,
                        itemBuilder: (context, index) {
                          final log = filteredLogs[index];
                          final timeString = DateFormat('hh:mm a').format(log.checkInTime);
                          
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.green[100],
                              child: const Icon(Icons.check, color: Colors.green),
                            ),
                            title: Text('${log.name} (${log.id})'),
                            subtitle: Text('Time: $timeString'),
                            trailing: const Text('Checked In'),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
