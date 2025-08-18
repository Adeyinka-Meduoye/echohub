// Directory: lib/features/story_details/viewmodel

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/post.dart';
import '../../../core/models/comment.dart';
import '../../../core/repositories/comment_repository.dart';

class StoryDetailsState {
  final Post? post;
  final List<Comment> comments;
  final bool isLoading;
  final String? error;

  StoryDetailsState({
    this.post,
    this.comments = const [],
    this.isLoading = false,
    this.error,
  });

  StoryDetailsState copyWith({
    Post? post,
    List<Comment>? comments,
    bool? isLoading,
    String? error,
  }) {
    return StoryDetailsState(
      post: post ?? this.post,
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class StoryDetailsViewModel extends StateNotifier<StoryDetailsState> {
  final CommentRepository _commentRepository;
  final Post post;

  StoryDetailsViewModel(this._commentRepository, this.post) : super(StoryDetailsState(post: post)) {
    fetchComments();
  }

  Future<void> fetchComments() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final comments = await _commentRepository.fetchCommentsForPost(post.id);
      state = state.copyWith(comments: comments, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final storyDetailsViewModelProvider = StateNotifierProvider.family<StoryDetailsViewModel, StoryDetailsState, Post>(
  (ref, post) => StoryDetailsViewModel(ref.watch(commentRepositoryProvider), post),
);