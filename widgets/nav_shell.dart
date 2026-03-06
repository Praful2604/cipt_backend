import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavShell extends StatelessWidget {
  final Widget child;

  const NavShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _getSelectedIndex(context),
        onDestinationSelected: (i) => _onTap(context, i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.school), label: 'Skills'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Soft Skills'),
          NavigationDestination(icon: Icon(Icons.folder), label: 'Domain'),
          NavigationDestination(icon: Icon(Icons.schedule), label: 'Time Slot'),
          NavigationDestination(icon: Icon(Icons.rule), label: 'Guidelines'),
          NavigationDestination(icon: Icon(Icons.assessment), label: 'Report'),
        ],
      ),
    );
  }

  int _getSelectedIndex(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    if (loc.startsWith('/skills')) return 0;
    if (loc.startsWith('/softskills')) return 1;
    if (loc.startsWith('/select-domain')) return 2;
    if (loc.startsWith('/timeslot')) return 3;
    if (loc.startsWith('/guidelines')) return 4;
    if (loc.startsWith('/final-report')) return 5;
    return 0;
  }

  void _onTap(BuildContext context, int i) {
    switch (i) {
      case 0:
        context.go('/skills');
        break;
      case 1:
        context.go('/softskills');
        break;
      case 2:
        context.go('/select-domain');
        break;
      case 3:
        context.go('/timeslot');
        break;
      case 4:
        context.go('/guidelines');
        break;
      case 5:
        context.go('/final-report');
        break;
    }
  }
}
