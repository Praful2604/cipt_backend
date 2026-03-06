import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DomainsScreen extends StatelessWidget {
  const DomainsScreen({super.key});

  static const domains = [
    {'id': '1_Python', 'label': 'Python'},
    {'id': '2_Data Structures', 'label': 'Data Structures'},
    {'id': '3_DBMS', 'label': 'DBMS'},
    {'id': '4_OS', 'label': 'Operating System'},
    {'id': '5_CN', 'label': 'Computer Networks'},
  ];

  @override
  Widget build(BuildContext context) {
    final duration = Uri.base.queryParameters['duration'] ?? '10';

    return Scaffold(
      appBar: AppBar(title: const Text('Select Domain')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (duration.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'Assessment Duration: $duration minutes',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            Text(
              'Choose your technical domain for the assessment',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ...domains.map((d) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const Icon(Icons.folder),
                title: Text(d['label'] as String),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () => context.go('/video?domain=${d['id']}&duration=$duration'),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
