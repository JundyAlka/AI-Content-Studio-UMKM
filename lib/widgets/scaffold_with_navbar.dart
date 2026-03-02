import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget navigationShell;

  const ScaffoldWithNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNavBar'));

  @override
  Widget build(BuildContext context) {
    // Determine the current index based on the route
    // In GoRouter 7+ using StatefulShellRoute is common, but strict ShellRoute 
    // requires checking the location string which is messier.
    // However, for this task, the navigationShell (from StatefulShellRoute) is easiest if we update router.
    // Let's assume we update router to use StatefulShellRoute.
    
    // If navigationShell is NOT a StatefulShellRoute branch container, we need a different approach.
    // But let's build this expecting StatefulShellRoute for best practice.
    
    // cast if we use StatefulShellRoute
    final StatefulNavigationShell shell = navigationShell as StatefulNavigationShell;

    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (index) {
          shell.goBranch(index, initialLocation: index == shell.currentIndex);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_open_outlined),
            selectedIcon: Icon(Icons.folder),
            label: 'Library',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Jadwal',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}
