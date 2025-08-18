// Directory: lib/features/home/view

import 'package:flutter/material.dart';
import '../../../widgets/echo_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: const Text(
                'Welcome to EchoHub',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  'asset/images/echohubhm.png',
                  width: 300,
                  height: 350,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 200, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                EchoCard(
                  title: 'What is EchoHub?',
                  subtitle: 'Connect, share, and explore stories, photos, and quests in a vibrant community hub.',
                  onTap: () {},
                ),
                const SizedBox(height: 5),
                EchoCard(
                  title: 'Get Started',
                  subtitle: 'Explore our features using the navigation bar below.',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
