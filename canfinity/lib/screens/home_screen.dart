import 'package:flutter/material.dart';
import '../widgets/feature_card.dart';
import '../config/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _handleUserIconPress(BuildContext context) async {
    // Placeholder logic for user details
    final name = null;
    final age = null;
    final cancerType = null;

    if (name == null || age == null || cancerType == null) {
      // Navigate to the registration screen if not registered
      Navigator.pushNamed(context, '/register');
    } else {
      // Show user details if already registered
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('User Details'),
          content: Text('Name: $name\nAge: $age\nCancer Type: $cancerType'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.primary,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: const Text(
                'Canfinity',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  shadows: [
                    Shadow(
                      blurRadius: 8.0,
                      color: Color.fromARGB(125, 0, 0, 0),
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/holding_hands_cancer.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Color.fromRGBO(255, 192, 203, 0.35),
                      BlendMode.overlay,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.person, color: Colors.white),
                  onPressed: () => _handleUserIconPress(context),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 40,
                        width: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.secondary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Your Care Journey',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.text,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      'Personalized support for your recovery',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.subtext,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primary.withOpacity(0.1),
                          AppTheme.background,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 0.9,
                      children: [
                        FeatureCard(
                          title: 'Diet Plan',
                          subtitle: 'Personalized\nNutrition',
                          icon: Icons.restaurant_menu,
                          color: const Color.fromRGBO(255, 182, 193, 1),
                          onTap: () => Navigator.pushNamed(context, '/diet-plan'),
                        ),
                        FeatureCard(
                          title: 'Workout Plan',
                          subtitle: 'Stay active',
                          icon: Icons.fitness_center,
                          color: AppTheme.secondary,
                          onTap: () => Navigator.pushNamed(context, '/workout'),
                        ),
                        FeatureCard(
                          title: 'Reminders',
                          subtitle: 'Track medications',
                          icon: Icons.calendar_today,
                          color: AppTheme.primary,
                          onTap: () =>
                              Navigator.pushNamed(context, '/chemo-reminder'),
                        ),
                        FeatureCard(
                          title: 'Mental Health',
                          subtitle: '24/7 support',
                          icon: Icons.favorite,
                          color: AppTheme.accent,
                          onTap: () =>
                              Navigator.pushNamed(context, '/mental-health'),
                        ),
                      ],
                    ),
                  ),
                  // Added inspirational message and support button
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "We're here for you",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.text,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Every step of the way, remember you're never alone on this journey.",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.subtext,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.secondary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.support_agent, size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                "Connect with Support",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}