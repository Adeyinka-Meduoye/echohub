// Directory: lib

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'navigation/app_router.dart';
import 'core/services/theme_service.dart';

void main() {
  runApp(const ProviderScope(child: EchoHubApp()));
}

class EchoHubApp extends ConsumerWidget {
  const EchoHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return themeMode.when(
      data: (mode) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'EchoHub',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        darkTheme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        themeMode: mode,
        routerConfig: router,
      ),
      loading: () => const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stack) => MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Error loading theme: $error')),
        ),
      ),
    );
  }
}