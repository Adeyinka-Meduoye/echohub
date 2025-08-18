// Directory: lib/features/quests/view

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../widgets/echo_card.dart';
import '../viewmodel/quest_viewmodel.dart';

class QuestScreen extends ConsumerWidget {
  const QuestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(questViewModelProvider);

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
                      onPressed: () => ref.read(questViewModelProvider.notifier).fetchQuests(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : state.quests.isEmpty
                ? const Center(child: Text('No quests found.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: state.quests.length,
                    itemBuilder: (context, index) {
                      final quest = state.quests[index];
                      return EchoCard(
                        title: quest.title,
                        subtitle: quest.completed ? 'Completed' : 'In Progress',
                        onTap: () {
                          ref.read(questViewModelProvider.notifier).toggleQuestCompletion(quest.id, !quest.completed);
                        },
                      ).animate().fadeIn(delay: Duration(milliseconds: 100 * index));
                    },
                  );
  }
}