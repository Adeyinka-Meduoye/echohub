// Directory: lib/core/services

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ThemeService {
  static const _themeKey = 'theme_mode';

  Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeKey) ?? 'light';
    return themeString == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final currentTheme = await getThemeMode();
    final newTheme = currentTheme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await prefs.setString(_themeKey, newTheme == ThemeMode.dark ? 'dark' : 'light');
  }
}

final themeServiceProvider = Provider<ThemeService>((ref) => ThemeService());

final themeModeProvider = FutureProvider<ThemeMode>((ref) async {
  final themeService = ref.watch(themeServiceProvider);
  return themeService.getThemeMode();
});