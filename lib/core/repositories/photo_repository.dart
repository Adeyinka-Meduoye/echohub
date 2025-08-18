// Directory: lib/core/repositories

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retry/retry.dart';
import '../models/photo.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';

class PhotoRepository {
  final AsyncValue<CacheService> _cacheService;
  final ApiService _apiService;

  PhotoRepository(this._cacheService, this._apiService);

  Future<List<Photo>> fetchPhotosForAlbum(int albumId) async {
    return retry(
      () async {
        try {
          final cacheService = _cacheService.value;
          final cacheKey = 'photos_$albumId';
          final cachedData = cacheService?.getCachedData(cacheKey);
          if (cachedData != null) {
            return cachedData.map((json) => Photo.fromJson(json)).toList();
          }

          final data = await _apiService.get('https://jsonplaceholder.typicode.com/photos?albumId=$albumId');
          final photos = data.map((json) => Photo.fromJson(json)).toList();
          await cacheService?.cacheData(cacheKey, data);
          return photos;
        } catch (e) {
          throw Exception('Failed to fetch photos: $e');
        }
      },
      maxAttempts: 3,
      delayFactor: const Duration(seconds: 2),
    );
  }
}

final photoRepositoryProvider = Provider<PhotoRepository>((ref) {
  final cacheService = ref.watch(cacheServiceProvider);
  final apiService = ref.watch(apiServiceProvider);
  return PhotoRepository(cacheService, apiService);
});