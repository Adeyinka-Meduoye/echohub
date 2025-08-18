// Directory: lib/features/gallery/view

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/models/photo.dart';

class PhotoDetailsScreen extends StatelessWidget {
  final Photo? photo;

  const PhotoDetailsScreen({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: photo == null
          ? const Center(child: Text('No photo available'))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  photo!.title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                CachedNetworkImage(
                  imageUrl: photo!.url,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ],
            ),
    );
  }
}