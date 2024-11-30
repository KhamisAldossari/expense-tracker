import 'package:flutter/material.dart';
import '../../widgets/testimonials.dart';
import '../../widgets/footer.dart';

class TestimonialsScreen extends StatelessWidget {
  const TestimonialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('What Our Users Say'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Column(
                children: [
                  Text(
                    'User Success Stories',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Discover how our expense tracker has helped users manage their finances better',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Testimonials(),
            const SizedBox(height: 40),
            Center(
              child: FilledButton.icon(
                onPressed: () {}, // Add registration flow
                icon: const Icon(Icons.person_add),
                label: const Text('Join Our Community'),
              ),
            ),
            const SizedBox(height: 40),
            const Footer(),
          ],
        ),
      ),
    );
  }
}