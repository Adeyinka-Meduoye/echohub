// Directory: lib/features/profile/viewmodel

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/user.dart';
import '../../../core/repositories/user_repository.dart';

class ProfileState {
  final List<User> users;
  final bool isLoading;
  final String? error;

  ProfileState({
    this.users = const [],
    this.isLoading = false,
    this.error,
  });

  ProfileState copyWith({
    List<User>? users,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class ProfileViewModel extends StateNotifier<ProfileState> {
  final UserRepository _userRepository;

  ProfileViewModel(this._userRepository) : super(ProfileState()) {
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final users = await _userRepository.fetchUsers();
      state = state.copyWith(users: users, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final profileViewModelProvider = StateNotifierProvider<ProfileViewModel, ProfileState>((ref) {
  final userRepo = ref.watch(userRepositoryProvider);
  return ProfileViewModel(userRepo);
});