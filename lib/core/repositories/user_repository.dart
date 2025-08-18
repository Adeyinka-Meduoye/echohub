// Directory: lib/core/repositories

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';

class UserRepository {
  final AsyncValue<CacheService> _cacheService;
  final ApiService _apiService;

  UserRepository(this._cacheService, this._apiService);

  Future<List<User>> fetchUsers() async {
    try {
      final cacheService = _cacheService.value;
      final cachedData = cacheService?.getCachedData('users');
      if (cachedData != null) {
        return cachedData.map((json) => User.fromJson(json)).toList();
      }

      final data = await _apiService.get('https://jsonplaceholder.typicode.com/users');
      final users = data.map((json) => User.fromJson(json)).toList();
      await cacheService?.cacheData('users', data);
      return users;
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final cacheService = ref.watch(cacheServiceProvider);
  final apiService = ref.watch(apiServiceProvider);
  return UserRepository(cacheService, apiService);
});