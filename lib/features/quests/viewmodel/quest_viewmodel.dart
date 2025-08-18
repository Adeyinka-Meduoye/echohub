// Directory: lib/features/quests/viewmodel

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/quest.dart';
import '../../../core/repositories/quest_repository.dart';

class QuestState {
  final List<Quest> quests;
  final bool isLoading;
  final String? error;

  QuestState({
    this.quests = const [],
    this.isLoading = false,
    this.error,
  });

  QuestState copyWith({
    List<Quest>? quests,
    bool? isLoading,
    String? error,
  }) {
    return QuestState(
      quests: quests ?? this.quests,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class QuestViewModel extends StateNotifier<QuestState> {
  final QuestRepository _questRepository;

  QuestViewModel(this._questRepository) : super(QuestState()) {
    fetchQuests();
  }

  Future<void> fetchQuests() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final quests = await _questRepository.fetchQuests();
      state = state.copyWith(quests: quests, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> toggleQuestCompletion(int questId, bool completed) async {
    try {
      await _questRepository.updateQuestCompletion(questId, completed);
      state = state.copyWith(
        quests: state.quests.map((quest) {
          if (quest.id == questId) {
            return Quest(
              id: quest.id,
              userId: quest.userId,
              title: quest.title,
              completed: completed,
            );
          }
          return quest;
        }).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final questViewModelProvider = StateNotifierProvider<QuestViewModel, QuestState>((ref) {
  final questRepo = ref.watch(questRepositoryProvider);
  return QuestViewModel(questRepo);
});