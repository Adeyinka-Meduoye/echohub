// Directory: lib/features/story_feed/view

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/echo_card.dart';
import '../viewmodel/post_viewmodel.dart';

class StoryFeedScreen extends ConsumerWidget {
  const StoryFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(postViewModelProvider);

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
                      onPressed: () => ref.read(postViewModelProvider.notifier).fetchPosts(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : state.posts.isEmpty
                ? const Center(child: Text('No stories found.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: state.posts.length,
                    itemBuilder: (context, index) {
                      final post = state.posts[index];
                      return EchoCard(
                        title: post.title,
                        subtitle: post.body,
                        onTap: () {
                          context.go('/story/${post.id}', extra: post);
                        },
                      ).animate().fadeIn(delay: Duration(milliseconds: 100 * index));
                    },
                  );
  }
}