// lib/widgets/footer.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FooterColumn(
                title: 'About',
                items: ['Company', 'Team', 'Contact Us'],
                onItemTap: (item) => _launchUrl(item),
              ),
              _FooterColumn(
                title: 'Support',
                items: ['FAQ', 'Help Center', 'Privacy Policy'],
                onItemTap: (item) => _launchUrl(item),
              ),
              _FooterColumn(
                title: 'Social',
                items: ['Twitter', 'LinkedIn', 'GitHub'],
                onItemTap: (item) => _launchSocialMedia(item),
              ),
            ],
          ),
          const Divider(height: 40),
          Text(
            '© ${DateTime.now().year} Expense Tracker. All rights reserved.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  void _launchUrl(String page) async {
    final url = Uri.parse('https://example.com/$page');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _launchSocialMedia(String platform) async {
    final urls = {
      'Twitter': 'https://twitter.com/expensetracker',
      'LinkedIn': 'https://linkedin.com/company/expensetracker',
      'GitHub': 'https://github.com/expensetracker',
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
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: TextButton(
            onPressed: () => onItemTap(item),
            child: Text(item),
          ),
        )),
      ],
    );
  }
}