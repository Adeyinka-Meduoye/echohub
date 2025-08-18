// Directory: lib/core/services

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  final SharedPreferences _prefs;

  CacheService(this._prefs);

  Future<void> cacheData(String key, List<Map<String, dynamic>> data) async {
    final jsonString = json.encode(data);
    await _prefs.setString(key, jsonString);
  }

  List<Map<String, dynamic>>? getCachedData(String key) {
    final jsonString = _prefs.getString(key);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.cast<Map<String, dynamic>>();
    }
    return null;
  }
}

final cacheServiceProvider = FutureProvider<CacheService>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return CacheService(prefs);
});