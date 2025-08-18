// Directory: lib/features/story_feed/viewmodel

import 'package:echohub/core/models/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/repositories/post_repository.dart' as repo;

class PostState {
  final List<Post> posts;
  final bool isLoading;
  final String? error;

  PostState({
    this.posts = const [],
    this.isLoading = false,
    this.error,
  });

  PostState copyWith({
    List<Post>? posts,
    bool? isLoading,
    String? error,
  }) {
    return PostState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class PostViewModel extends StateNotifier<PostState> {
  final repo.PostRepository _postRepository;

  PostViewModel(this._postRepository) : super(PostState()) {
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final posts = await _postRepository.fetchPosts();
      state = state.copyWith(posts: posts, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final postViewModelProvider = StateNotifierProvider<PostViewModel, PostState>((ref) {
  final postRepo = ref.watch(repo.postRepositoryProvider);
  return PostViewModel(postRepo);
});