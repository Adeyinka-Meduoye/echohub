// Directory: lib/core/repositories

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/album.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';

class AlbumRepository {
  final AsyncValue<CacheService> _cacheService;
  final ApiService _apiService;

  AlbumRepository(this._cacheService, this._apiService);

  Future<List<Album>> fetchAlbums() async {
    try {
      final cacheService = _cacheService.value;
      final cachedData = cacheService?.getCachedData('albums');
      if (cachedData != null) {
        return cachedData.map((json) => Album.fromJson(json)).toList();
      }

      final data = await _apiService.get('https://jsonplaceholder.typicode.com/albums');
      final albums = data.map((json) => Album.fromJson(json)).toList();
      await cacheService?.cacheData('albums', data);
      return albums;
    } catch (e) {
      throw Exception('Failed to fetch albums: $e');
    }
  }
}

final albumRepositoryProvider = Provider<AlbumRepository>((ref) {
  final cacheService = ref.watch(cacheServiceProvider);
  final apiService = ref.watch(apiServiceProvider);
  return AlbumRepository(cacheService, apiService);
});