// Directory: lib/core/repositories

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/comment.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';

class CommentRepository {
  final AsyncValue<CacheService> _cacheService;
  final ApiService _apiService;

  CommentRepository(this._cacheService, this._apiService);

  Future<List<Comment>> fetchComments() async {
    try {
      final cacheService = _cacheService.value;
      final cachedData = cacheService?.getCachedData('comments');
      if (cachedData != null) {
        return cachedData.map((json) => Comment.fromJson(json)).toList();
      }

      final data = await _apiService.get('https://jsonplaceholder.typicode.com/comments');
      final comments = data.map((json) => Comment.fromJson(json)).toList();
      await cacheService?.cacheData('comments', data);
      return comments;
    } catch (e) {
      throw Exception('Failed to fetch comments: $e');
    }
  }

  Future<List<Comment>> fetchCommentsForPost(int postId) async {
    try {
      final cacheService = _cacheService.value;
      final cacheKey = 'comments_$postId';
      final cachedData = cacheService?.getCachedData(cacheKey);
      if (cachedData != null) {
        return cachedData.map((json) => Comment.fromJson(json)).toList();
      }

      final data = await _apiService.get('https://jsonplaceholder.typicode.com/comments?postId=$postId');
      final comments = data.map((json) => Comment.fromJson(json)).toList();
      await cacheService?.cacheData(cacheKey, data);
      return comments;
    } catch (e) {
      throw Exception('Failed to fetch comments for post: $e');
    }
  }
}

final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  final cacheService = ref.watch(cacheServiceProvider);
  final apiService = ref.watch(apiServiceProvider);
  return CommentRepository(cacheService, apiService);
});