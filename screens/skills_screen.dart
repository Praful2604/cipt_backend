import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Your Skill Track')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select a category to begin your interview preparation',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            Card(
              child: ListTile(
                leading: const Icon(Icons.computer, size: 40),
                title: const Text('Technical Skills'),
                subtitle: const Text('Practice coding interviews, system design, and technical questions'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () => context.go('/guidelines'),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.people, size: 40),
                title: const Text('Soft Skills'),
                subtitle: const Text('Practice communication, leadership, and behavioral interview questions'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () => context.go('/softskills'),
              ),
            ),
            const Spacer(),
            Text(
              'You can switch tracks anytime. Your progress will be saved.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
