// lib/widgets/testimonials.dart
import 'package:flutter/material.dart';

class Testimonials extends StatefulWidget {
  const Testimonials({super.key});

  @override
  State<Testimonials> createState() => _TestimonialsState();
}

class _TestimonialsState extends State<Testimonials> {
  final _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;

  final List<TestimonialData> _testimonials = const [
    TestimonialData(
      name: "Sarah Johnson",
      role: "Small Business Owner",
      content: "This app has transformed how I track my business expenses. The analytics features have helped me identify areas where I can cut costs.",
      rating: 5,
    ),
    TestimonialData(
      name: "Michael Chen",
      role: "Freelancer",
      content: "The categorization and filtering make it easy to track different projects. I've saved hours on expense reporting.",
      rating: 5,
    ),
    TestimonialData(
      name: "Emma Davis",
      role: "Student",
      content: "Perfect for managing my student budget. The interface is intuitive and the charts help me visualize my spending habits.",
      rating: 4,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24,
                vertical: isSmallScreen ? 16 : 24,
              ),
              child: Column(
                children: [
                  Text(
                    'What Our Users Say',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Join thousands of satisfied users managing their expenses',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: isSmallScreen ? 380 : 320,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _testimonials.length,
                onPageChanged: (int page) => setState(() => _currentPage = page),
                itemBuilder: (context, index) {
                  return AnimatedPadding(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      vertical: _currentPage == index ? 0 : 32,
                      horizontal: isSmallScreen ? 8 : 16,
                    ),
                    child: _TestimonialCard(
                      testimonial: _testimonials[index],
                      isSmallScreen: isSmallScreen,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageIndicator(),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildPageIndicator() {
    return List<Widget>.generate(
      _testimonials.length,
      (index) => Container(
        width: 8.0,
        height: 8.0,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _currentPage == index
              ? Theme.of(context).primaryColor
              : Colors.grey.shade300,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class _TestimonialCard extends StatelessWidget {
  final TestimonialData testimonial;
  final bool isSmallScreen;

  const _TestimonialCard({
    required this.testimonial,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.format_quote,
                size: isSmallScreen ? 32 : 40,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                testimonial.content,
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.5,
                  fontSize: isSmallScreen ? 14 : 16,
                ),
              ),
              const SizedBox(height: 16),
              _buildRating(),
              const SizedBox(height: 16),
              CircleAvatar(
                radius: isSmallScreen ? 24 : 30,
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Text(
                  testimonial.name[0],
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallScreen ? 16 : 20,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                testimonial.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 14 : 16,
                ),
              ),
              Text(
                testimonial.role,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: isSmallScreen ? 12 : 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Icon(
          index < testimonial.rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: isSmallScreen ? 20 : 24,
        );
      }),
    );
  }
}

class TestimonialData {
  final String name;
  final String role;
  final String content;
  final int rating;

  const TestimonialData({
    required this.name,
    required this.role,
    required this.content,
    required this.rating,
  });
}