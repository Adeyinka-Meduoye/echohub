// Directory: lib/features/gallery/view

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/echo_card.dart';
import '../viewmodel/gallery_viewmodel.dart';

class GalleryScreen extends ConsumerWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(galleryViewModelProvider);

    return state.isLoading
        ? const Center(child: CircularProgressIndicator())
        : state.error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.read(galleryViewModelProvider.notifier).fetchAlbums(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : state.albums.isEmpty
                ? const Center(child: Text('No albums found.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: state.albums.length,
                    itemBuilder: (context, index) {
                      final album = state.albums[index];
                      return EchoCard(
                        title: album.title,
                        onTap: () {
                          context.go('/photo/${album.id}', extra: album.photos.isNotEmpty ? album.photos.first : null);
                        },
                      ).animate().fadeIn(delay: Duration(milliseconds: 100 * index));
                    },
                  );
  }
}