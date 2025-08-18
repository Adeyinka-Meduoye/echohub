// Directory: lib/features/profile/view

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/echo_card.dart';
import '../viewmodel/profile_viewmodel.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileViewModelProvider);

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
                      onPressed: () => ref.read(profileViewModelProvider.notifier).fetchUsers(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : state.users.isEmpty
                ? const Center(child: Text('No profiles found.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      final user = state.users[index];
                      return EchoCard(
                        title: user.name,
                        subtitle: user.email,
                        onTap: () {
                          context.go('/profile/${user.id}', extra: user);
                        },
                      ).animate().fadeIn(delay: Duration(milliseconds: 100 * index));
                    },
                  );
  }
}