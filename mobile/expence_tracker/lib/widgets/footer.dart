// lib/widgets/footer.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    // Using a SingleChildScrollView to prevent overflow on smaller screens
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        color: Theme.of(context).colorScheme.surface,
        // Ensuring the container takes minimum full width of the screen
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _FooterColumn(
                  title: 'Company',
                  items: ['About', 'Contact'],
                  onItemTap: _launchUrl,
                ),
                const SizedBox(width: 48),
                _FooterColumn(
                  title: 'Connect',
                  items: ['Twitter', 'LinkedIn'],
                  onItemTap: _launchSocialMedia,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              '© ${DateTime.now().year} Expense Tracker',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  void _launchUrl(String page) async {
    final url = Uri.parse('https://example.com/$page'.toLowerCase());
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _launchSocialMedia(String platform) async {
    final urls = {
      'Twitter': 'https://twitter.com/expensetracker',
      'LinkedIn': 'https://linkedin.com/company/expensetracker',
    };
    final url = Uri.parse(urls[platform]!);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<String> items;
  final Function(String) onItemTap;

  const _FooterColumn({
    required this.title,
    required this.items,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: TextButton(
            onPressed: () => onItemTap(item),
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(vertical: 4),
            ),
            child: Text(item),
          ),
        )),
      ],
    );
  }
}