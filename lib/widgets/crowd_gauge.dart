import 'package:flutter/material.dart';
import 'dart:math' as math;

class CrowdGauge extends StatelessWidget {
  final double ratio;
  final String level;
  final Color color;

  const CrowdGauge({
    super.key,
    required this.ratio,
    required this.level,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: CircularProgressIndicator(
            value: ratio,
            strokeWidth: 12,
            backgroundColor: Colors.white.withOpacity(0.1),
            color: color,
            strokeCap: StrokeCap.round,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${(ratio * 100).toInt()}%',
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            Text(
              level,
              style: TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}
