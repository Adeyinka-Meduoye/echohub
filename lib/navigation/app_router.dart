// Directory: lib/navigation

import 'package:go_router/go_router.dart';
import '../features/root/view/root_screen.dart';
import '../features/home/view/home_screen.dart';
import '../features/story_feed/view/story_feed_screen.dart';
import '../features/story_details/view/story_details_screen.dart';
import '../features/comments/view/comment_screen.dart';
import '../features/gallery/view/gallery_screen.dart';
import '../features/gallery/view/photo_details_screen.dart';
import '../features/quests/view/quest_screen.dart';
import '../features/profile/view/profile_screen.dart';
import '../features/profile/view/profile_details_screen.dart';
import '../core/models/post.dart';
import '../core/models/photo.dart';
import '../core/models/user.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const RootScreen(child: HomeScreen()),
    ),
    GoRoute(
      path: '/story_feed',
      builder: (context, state) => const RootScreen(child: StoryFeedScreen()),
    ),
    GoRoute(
      path: '/story/:id',
      builder: (context, state) {
        final post = state.extra as Post?;
        return RootScreen(child: StoryDetailsScreen(post: post!));
      },
      routes: [
        GoRoute(
          path: 'comments',
          builder: (context, state) {
            final post = state.extra as Post?;
            return RootScreen(child: CommentScreen(postId: post!.id));
          },
        ),
      ],
    ),
    GoRoute(
      path: '/gallery',
      builder: (context, state) => const RootScreen(child: GalleryScreen()),
    ),
    GoRoute(
      path: '/photo/:id',
      builder: (context, state) {
        final photo = state.extra as Photo?;
        return RootScreen(child: PhotoDetailsScreen(photo: photo));
      },
    ),
    GoRoute(
      path: '/quests',
      builder: (context, state) => const RootScreen(child: QuestScreen()),
    ),
    GoRoute(
      path: '/profiles',
      builder: (context, state) => const RootScreen(child: ProfileScreen()),
    ),
    GoRoute(
      path: '/profile/:id',
      builder: (context, state) {
        final user = state.extra as User?;
        return RootScreen(child: ProfileDetailsScreen(user: user!));
      },
    ),
  ],
);