import 'package:flutter/material.dart';
import '../../widgets/footer.dart';

class FeaturesScreen extends StatelessWidget {
  const FeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Features'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 600;
          final crossAxisCount = isSmallScreen ? 1 : 2;

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: isSmallScreen ? 32 : 48,
                  ),
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Column(
                    children: [
                      Text(
                        'Powerful Features for Better Financial Management',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: isSmallScreen ? null : 600,
                        child: Text(
                          'Everything you need to track and manage your expenses effectively',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: isSmallScreen ? 1.2 : 1.5,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 24,
                    ),
                    itemCount: _features.length,
                    itemBuilder: (context, index) => _FeatureCard(
                      icon: _features[index].icon,
                      title: _features[index].title,
                      description: _features[index].description,
                    ),
                  ),
                ),
                const Footer(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallCard = constraints.maxWidth < 300;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(isSmallCard ? 16 : 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: isSmallCard ? 36 : 48,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

final _features = [
  _FeatureData(
    icon: Icons.category,
    title: 'Smart Categorization',
    description: 'Organize expenses with customizable categories for better tracking',
  ),
  _FeatureData(
    icon: Icons.analytics,
    title: 'Detailed Analytics',
    description: 'Get insights into your spending patterns with visual reports',
  ),
  _FeatureData(
    icon: Icons.history,
    title: 'Expense History',
    description: 'Access your complete expense history with advanced filtering',
  ),
  _FeatureData(
    icon: Icons.cloud_sync,
    title: 'Cloud Sync',
    description: 'Securely sync your data across all your devices',
  ),
];

class _FeatureData {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureData({
    required this.icon,
    required this.title,
    required this.description,
  });
}