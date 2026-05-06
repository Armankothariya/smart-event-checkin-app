import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, provider, child) {
        if (!provider.isEventSetup) {
          return const Scaffold(
            body: Center(child: Text("No event setup yet.")),
          );
        }

        int totalParticipants = provider.currentEvent!.maxCapacity;
        int checkedIn = provider.checkedInCount;
        int remaining = provider.remainingCapacity;
        
        double crowdRatio = totalParticipants > 0 ? (checkedIn / totalParticipants) : 0;
        String crowdLevel = 'Safe';
        Color crowdColor = Colors.green;
        
        if (crowdRatio >= 0.9) {
          crowdLevel = 'Full';
          crowdColor = Colors.red;
        } else if (crowdRatio >= 0.5) {
          crowdLevel = 'Moderate';
          crowdColor = Colors.orange;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(provider.currentEvent!.name),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text('Crowd Level', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: crowdColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            crowdLevel,
                            style: TextStyle(color: crowdColor, fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildStatCard('Checked In', checkedIn.toString(), Colors.blue),
                      _buildStatCard('Remaining', remaining.toString(), Colors.purple),
                      _buildStatCard('Capacity', totalParticipants.toString(), Colors.grey),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/checkin');
                      },
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('Check-in'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/logs');
                      },
                      icon: const Icon(Icons.list),
                      label: const Text('Logs'),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      elevation: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, color: Colors.black54)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
