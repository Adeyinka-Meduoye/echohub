// Directory: lib/features/profile/viewmodel

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/repositories/post_repository.dart';
import '../../../core/repositories/comment_repository.dart';

class ProfileDetailsState {
  final int postCount;
  final int commentCount;
  final bool isLoading;
  final String? error;

  ProfileDetailsState({
    this.postCount = 0,
    this.commentCount = 0,
    this.isLoading = false,
    this.error,
  });

  ProfileDetailsState copyWith({
    int? postCount,
    int? commentCount,
    bool? isLoading,
    String? error,
  }) {
    return ProfileDetailsState(
      postCount: postCount ?? this.postCount,
      commentCount: commentCount ?? this.commentCount,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class ProfileDetailsViewModel extends StateNotifier<ProfileDetailsState> {
  final PostRepository _postRepository;
  final CommentRepository _commentRepository;
  final int userId;

  ProfileDetailsViewModel(this._postRepository, this._commentRepository, this.userId) : super(ProfileDetailsState()) {
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final posts = await _postRepository.fetchPosts();
      final comments = await _commentRepository.fetchComments();
      final postCount = posts.where((post) => post.userId == userId).length;
      final commentCount = comments.where((comment) => comment.email == 'user$userId@example.com').length;
      state = state.copyWith(
        postCount: postCount,
        commentCount: commentCount,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final profileDetailsViewModelProvider = StateNotifierProvider.family<ProfileDetailsViewModel, ProfileDetailsState, int>(
  (ref, userId) {
    final postRepo = ref.watch(postRepositoryProvider);
    final commentRepo = ref.watch(commentRepositoryProvider);
    return ProfileDetailsViewModel(postRepo, commentRepo, userId);
  },
);