// Directory: lib/features/gallery/viewmodel

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/album.dart';
import '../../../core/repositories/album_repository.dart';
import '../../../core/repositories/photo_repository.dart';

class GalleryState {
  final List<Album> albums;
  final bool isLoading;
  final String? error;

  GalleryState({
    this.albums = const [],
    this.isLoading = false,
    this.error,
  });

  GalleryState copyWith({
    List<Album>? albums,
    bool? isLoading,
    String? error,
  }) {
    return GalleryState(
      albums: albums ?? this.albums,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class GalleryViewModel extends StateNotifier<GalleryState> {
  final AlbumRepository _albumRepository;
  final PhotoRepository _photoRepository;

  GalleryViewModel(this._albumRepository, this._photoRepository) : super(GalleryState()) {
    fetchAlbums();
  }

  Future<void> fetchAlbums() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final albums = await _albumRepository.fetchAlbums();
      final albumsWithPhotos = <Album>[];
      for (var album in albums) {
        try {
          final photos = await _photoRepository.fetchPhotosForAlbum(album.id);
          albumsWithPhotos.add(Album(id: album.id, userId: album.userId, title: album.title, photos: photos));
        } catch (e) {
          // Skip albums with failed photo fetches
          continue;
        }
      }
      state = state.copyWith(
        albums: albumsWithPhotos,
        isLoading: false,
        error: albumsWithPhotos.isEmpty ? 'Failed to load albums or photos' : null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load albums: $e',
      );
    }
  }
}

final galleryViewModelProvider = StateNotifierProvider<GalleryViewModel, GalleryState>((ref) {
  final albumRepo = ref.watch(albumRepositoryProvider);
  final photoRepo = ref.watch(photoRepositoryProvider);
  return GalleryViewModel(albumRepo, photoRepo);
});