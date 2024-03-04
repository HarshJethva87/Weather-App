import 'package:flutter/material.dart';

class HourlyForeCastWidget extends StatelessWidget {
  final String time;
  final String temperature;
  final IconData icon;

  const HourlyForeCastWidget(
      {super.key,
      required this.time,
      required this.temperature,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 8.0,
            ),
            Icon(
              icon,
              size: 40,
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              temperature,
              style: const TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
