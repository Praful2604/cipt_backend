import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TimeSlotScreen extends StatelessWidget {
  const TimeSlotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const durations = [
      {'label': '10 Minutes', 'value': 10},
      {'label': '15 Minutes', 'value': 15},
      {'label': '20 Minutes', 'value': 20},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Select Time Slot')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Choose how long you want for the assessment',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            ...durations.map((d) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const Icon(Icons.schedule),
                title: Text(d['label'] as String),
                subtitle: const Text('Quick assessment'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () => context.go('/select-domain?duration=${d['value']}'),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
