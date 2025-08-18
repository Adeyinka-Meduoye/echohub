// Directory: lib/core/repositories

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quest.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';

class QuestRepository {
  final AsyncValue<CacheService> _cacheService;
  final ApiService _apiService;

  QuestRepository(this._cacheService, this._apiService);

  Future<List<Quest>> fetchQuests() async {
    try {
      final cacheService = _cacheService.value;
      final cachedData = cacheService?.getCachedData('quests');
      if (cachedData != null) {
        return cachedData.map((json) => Quest.fromJson(json)).toList();
      }

      final data = await _apiService.get('https://jsonplaceholder.typicode.com/todos');
      final quests = data.map((json) => Quest.fromJson(json)).toList();
      await cacheService?.cacheData('quests', data);
      return quests;
    } catch (e) {
      throw Exception('Failed to fetch quests: $e');
    }
  }

  Future<void> updateQuestCompletion(int questId, bool completed) async {
    try {
      await _apiService.put(
        'https://jsonplaceholder.typicode.com/todos/$questId',
        {'completed': completed},
      );
    } catch (e) {
      throw Exception('Failed to update quest: $e');
    }
  }
}

final questRepositoryProvider = Provider<QuestRepository>((ref) {
  final cacheService = ref.watch(cacheServiceProvider);
  final apiService = ref.watch(apiServiceProvider);
  return QuestRepository(cacheService, apiService);
});