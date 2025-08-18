// Directory: lib/core/repositories

import 'dart:convert';
import 'package:echohub/core/models/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../services/cache_service.dart';

class PostRepository {
  final AsyncValue<CacheService> _cacheService;

  PostRepository(this._cacheService);

  Future<List<Post>> fetchPosts() async {
    try {
      final cacheService = _cacheService.value;
      final cachedData = cacheService?.getCachedData('posts');
      if (cachedData != null) {
        return cachedData.map((json) => Post.fromJson(json)).toList();
      }

      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final posts = data.map((json) => Post.fromJson(json)).toList();
        await cacheService?.cacheData('posts', data.cast<Map<String, dynamic>>());
        return posts;
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}

final postRepositoryProvider = Provider<PostRepository>((ref) {
  final cacheService = ref.watch(cacheServiceProvider);
  return PostRepository(cacheService);
});