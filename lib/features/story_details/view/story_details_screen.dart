// Directory: lib/features/story_details/view

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/post.dart';
import '../../../widgets/echo_card.dart';
import '../viewmodel/story_details_viewmodel.dart';

class StoryDetailsScreen extends ConsumerWidget {
  final Post post;

  const StoryDetailsScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(storyDetailsViewModelProvider(post));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${state.error}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.read(storyDetailsViewModelProvider(post).notifier).fetchComments(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EchoCard(
                      title: state.post!.title,
                      subtitle: state.post!.body,
                      onTap: () {
                        context.go('/story/${state.post!.id}/comments', extra: state.post);
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.go('/story/${state.post!.id}/comments', extra: state.post);
                      },
                      child: const Text('View Comments'),
                    ),
                  ],
                ),
    );
  }
}