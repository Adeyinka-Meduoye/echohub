// Directory: lib/features/comments/viewmodel

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/comment.dart';
import '../../../core/repositories/comment_repository.dart';

class CommentState {
  final List<Comment> comments;
  final bool isLoading;
  final String? error;

  CommentState({
    this.comments = const [],
    this.isLoading = false,
    this.error,
  });

  CommentState copyWith({
    List<Comment>? comments,
    bool? isLoading,
    String? error,
  }) {
    return CommentState(
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class CommentViewModel extends StateNotifier<CommentState> {
  final CommentRepository _commentRepository;
  final int postId;

  CommentViewModel(this._commentRepository, this.postId) : super(CommentState()) {
    fetchComments();
  }

  Future<void> fetchComments() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final comments = await _commentRepository.fetchCommentsForPost(postId);
      state = state.copyWith(comments: comments, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final commentViewModelProvider = StateNotifierProvider.family<CommentViewModel, CommentState, int>(
  (ref, postId) => CommentViewModel(ref.watch(commentRepositoryProvider), postId),
);