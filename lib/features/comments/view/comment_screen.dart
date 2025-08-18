// Directory: lib/features/comments/view

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../widgets/echo_card.dart';
import '../viewmodel/comment_viewmodel.dart';

class CommentScreen extends ConsumerWidget {
  final int postId;

  const CommentScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(commentViewModelProvider(postId));

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
                      onPressed: () => ref.read(commentViewModelProvider(postId).notifier).fetchComments(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : state.comments.isEmpty
                ? const Center(child: Text('No comments found.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: state.comments.length,
                    itemBuilder: (context, index) {
                      final comment = state.comments[index];
                      return EchoCard(
                        title: comment.name,
                        subtitle: comment.body,
                        onTap: () {},
                      );
                    },
                  );
  }
}