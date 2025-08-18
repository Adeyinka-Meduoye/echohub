// Directory: lib/core/repositories

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';

class TodoRepository {
  final AsyncValue<CacheService> _cacheService;
  final ApiService _apiService;

  TodoRepository(this._cacheService, this._apiService);

  Future<List<Todo>> fetchTodos() async {
    try {
      final cacheService = _cacheService.value;
      final cachedData = cacheService?.getCachedData('todos');
      if (cachedData != null) {
        return cachedData.map((json) => Todo.fromJson(json)).toList();
      }

      final data = await _apiService.get('https://jsonplaceholder.typicode.com/todos');
      final todos = data.map((json) => Todo.fromJson(json)).toList();
      await cacheService?.cacheData('todos', data);
      return todos;
    } catch (e) {
      throw Exception('Failed to fetch todos: $e');
    }
  }

  Future<Todo> updateTodo(int id, bool completed) async {
    try {
      final cacheService = _cacheService.value;
      final data = await _apiService.put(
        'https://jsonplaceholder.typicode.com/todos/$id',
        {'completed': completed},
      );
      final updatedTodo = Todo.fromJson(data);
      final cachedData = cacheService?.getCachedData('todos') ?? [];
      final updatedData = cachedData.map((json) {
        if (json['id'] == id) {
          return {...json, 'completed': completed};
        }
        return json;
      }).toList();
      await cacheService?.cacheData('todos', updatedData);
      return updatedTodo;
    } catch (e) {
      throw Exception('Failed to update todo: $e');
    }
  }
}

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  final cacheService = ref.watch(cacheServiceProvider);
  final apiService = ref.watch(apiServiceProvider);
  return TodoRepository(cacheService, apiService);
});