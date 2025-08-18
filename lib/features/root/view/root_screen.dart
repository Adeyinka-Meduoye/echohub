// Directory: lib/features/root/view

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/theme_service.dart';

class RootScreen extends ConsumerStatefulWidget {
  final Widget child;

  const RootScreen({super.key, required this.child});

  @override
  ConsumerState<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends ConsumerState<RootScreen> {
  int _selectedIndex = 0;

  static const List<String> _routes = [
    '/',
    '/story_feed',
    '/gallery',
    '/quests',
    '/profiles',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    context.go(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final currentPath = GoRouterState.of(context).uri.toString();

    // Update selected index based on current route
    _selectedIndex = _routes.indexWhere((route) {
      if (route == '/') return currentPath == '/';
      return currentPath == route || currentPath.startsWith('$route/');
    });
    if (_selectedIndex == -1) {
      _selectedIndex = 0; // Default to Home
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('EchoHub'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Color(0xFFFFFFFF),
        actions: [
          IconButton(
            icon: Icon(themeMode.asData?.value == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () async {
              await ref.read(themeServiceProvider).toggleTheme();
              ref.invalidate(themeModeProvider);
            },
          ),
        ],
      ),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'Stories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Quests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profiles',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedIconTheme: const IconThemeData(size: 35),
        unselectedIconTheme: const IconThemeData(size: 24),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        onTap: _onItemTapped,
      ),
    );
  }
}