import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/diet_plan_screen.dart';
import 'screens/workout_screen.dart';
import 'screens/chemo_tracking_screen.dart'; 
import 'screens/mental_health_screen.dart';
import 'screens/register_screen.dart';
import 'config/theme.dart';




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Canfinity',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/diet-plan': (context) => const DietPlanScreen(),
        '/workout': (context) => const WorkoutScreen(),
        '/chemo-reminder': (context) => const ChemoTrackingScreen(),
        '/mental-health': (context) => const MentalHealthScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}
