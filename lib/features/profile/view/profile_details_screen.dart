// Directory: lib/features/profile/view

import 'package:echohub/features/profile/viewmodel/profile_details_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/user.dart';
import '../../../widgets/echo_card.dart';

class ProfileDetailsScreen extends ConsumerWidget {
  final User user;

  const ProfileDetailsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileDetailsViewModelProvider(user.id));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${state.error}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.read(profileDetailsViewModelProvider(user.id).notifier).fetchUserDetails(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EchoCard(
                      title: user.name,
                      subtitle: user.email,
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),
                    Text('Posts: ${state.postCount}'),
                    Text('Comments: ${state.commentCount}'),
                  ],
                ),
    );
  }
}