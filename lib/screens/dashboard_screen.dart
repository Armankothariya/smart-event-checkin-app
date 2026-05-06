import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/crowd_gauge.dart';
import '../utils/constants.dart';

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

        final ratio = provider.crowdRatio;
        Color crowdColor = AppColors.accent;
        String crowdLevel = 'Optimal';

        if (ratio >= 0.9) {
          crowdColor = Colors.redAccent;
          crowdLevel = 'Critical';
        } else if (ratio >= 0.7) {
          crowdColor = Colors.orangeAccent;
          crowdLevel = 'High';
        } else if (ratio >= 0.4) {
          crowdColor = Colors.yellowAccent;
          crowdLevel = 'Moderate';
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(provider.currentEvent!.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_backup_restore),
                onPressed: () => _showResetDialog(context, provider),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                CrowdGauge(ratio: ratio, level: crowdLevel, color: crowdColor),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: 'Checked In',
                        value: provider.checkedInCount.toString(),
                        icon: Icons.people,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StatCard(
                        title: 'Remaining',
                        value: provider.remainingCapacity.toString(),
                        icon: Icons.event_seat,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _StatCard(
                  title: 'Total Capacity',
                  value: provider.currentEvent!.maxCapacity.toString(),
                  icon: Icons.info_outline,
                  color: AppColors.textSecondary,
                  isWide: true,
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        label: 'Check-In',
                        icon: Icons.qr_code_scanner,
                        onPressed: () => Navigator.pushNamed(context, '/checkin'),
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _ActionButton(
                        label: 'View Logs',
                        icon: Icons.list_alt,
                        onPressed: () => Navigator.pushNamed(context, '/logs'),
                        color: AppColors.cardBg,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showResetDialog(BuildContext context, EventProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Event?'),
        content: const Text('This will clear all participant logs and event settings. This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              provider.clearAllData();
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
            },
            child: const Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isWide;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Container(
        width: isWide ? double.infinity : null,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    );
  }
}
