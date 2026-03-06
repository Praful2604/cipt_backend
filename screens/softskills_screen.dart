import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SoftSkillsScreen extends StatelessWidget {
  const SoftSkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Soft Skills Interview')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Choose your soft skill to practice',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            _SkillCard(
              icon: Icons.visibility,
              title: 'Eye Contact',
              onTap: () => context.go('/timeslot'),
            ),
            _SkillCard(
              icon: Icons.face,
              title: 'Emotion',
              onTap: () => context.go('/timeslot'),
            ),
            _SkillCard(
              icon: Icons.accessibility_new,
              title: 'Body Posture',
              onTap: () => context.go('/timeslot'),
            ),
            _SkillCard(
              icon: Icons.record_voice_over,
              title: 'Sound / Speech',
              onTap: () => context.go('/timeslot'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SkillCard({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }
}
