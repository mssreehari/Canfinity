import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/theme.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  String? age;
  List<Exercise> exercises = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('Workout Plan', style: TextStyle(color: AppTheme.primary)),
        backgroundColor: AppTheme.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Age Input Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter Your Age',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.text,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Age',
                      labelStyle: TextStyle(color: AppTheme.subtext),
                      filled: true,
                      fillColor: AppTheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: AppTheme.primary.withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppTheme.primary),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: AppTheme.primary.withOpacity(0.3)),
                      ),
                    ),
                    style: TextStyle(color: AppTheme.text),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        age = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: age == null || age!.isEmpty
                        ? null
                        : () {
                            setState(() {
                              isLoading = true;
                              exercises =
                                  WorkoutService.getExercises(int.parse(age!));
                              isLoading = false;
                            });
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: AppTheme.secondary,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBackgroundColor:
                          AppTheme.primary.withOpacity(0.3),
                      disabledForegroundColor:
                          AppTheme.secondary.withOpacity(0.5),
                    ),
                    child: Text(
                      isLoading ? 'Generating...' : 'Generate Workout Plan',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            if (exercises.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                'Your Personalized Workout Plan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return ExerciseCard(exercise: exercise);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ExerciseCard extends StatefulWidget {
  final Exercise exercise;

  const ExerciseCard({
    super.key,
    required this.exercise,
  });

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  void _launchVideo() async {
    final Uri url = Uri.parse(widget.exercise.videoUrl);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch video';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Could not open video. Please check your internet connection.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        title: Text(
          widget.exercise.name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.text,
          ),
        ),
        subtitle: Text(
          getDifficultyText(widget.exercise.difficulty),
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.accent,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.exercise.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.subtext,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Duration: ${widget.exercise.duration}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.accent,
                  ),
                ),
                const SizedBox(height: 12),
                if (widget.exercise.cancerTypeModifications.isNotEmpty) ...[
                  Text(
                    'Cancer-Specific Modifications:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...widget.exercise.cancerTypeModifications.entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '• ${entry.key}: ${entry.value}',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.subtext,
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _launchVideo,
                  icon: const Icon(Icons.play_circle_outline, size: 20),
                  label: const Text('Watch Tutorial'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getDifficultyText(ExerciseDifficulty difficulty) {
    switch (difficulty) {
      case ExerciseDifficulty.beginner:
        return '🟢 Beginner';
      case ExerciseDifficulty.intermediate:
        return '🟡 Intermediate';
      case ExerciseDifficulty.advanced:
        return '🔴 Advanced';
    }
  }
}

// First, let's add an enum for difficulty levels
enum ExerciseDifficulty { beginner, intermediate, advanced }

// Update the Exercise class to include difficulty and cancer type modifications
class Exercise {
  final String name;
  final String description;
  final String duration;
  final String videoUrl;
  final ExerciseDifficulty difficulty;
  final Map<String, String> cancerTypeModifications;

  Exercise({
    required this.name,
    required this.description,
    required this.duration,
    required this.videoUrl,
    required this.difficulty,
    required this.cancerTypeModifications,
  });
}

class WorkoutService {
  static List<Exercise> getExercises(int age) {
    if (age <= 12) {
      return [
        Exercise(
          name: 'Fun Walking Games',
          description:
              'Walking exercises mixed with simple games to keep it entertaining.',
          duration: '10 minutes',
          videoUrl:
              'https://www.youtube.com/watch?v=ymigWt5TOV8', // Kids walking exercise
          difficulty: ExerciseDifficulty.beginner,
          cancerTypeModifications: {
            'Leukemia': 'Take frequent breaks and monitor energy levels',
            'Brain Tumor': 'Avoid sudden movements, focus on steady walking',
            'Bone Cancer':
                'Use support when needed, avoid high-impact movements',
          },
        ),
        Exercise(
          name: 'Animal Movements',
          description:
              'Mimicking animal movements like bear crawls and bunny hops.',
          duration: '8 minutes',
          videoUrl:
              'https://www.youtube.com/watch?v=DfiN7pG0D0k', // Animal walks for kids
          difficulty: ExerciseDifficulty.beginner,
          cancerTypeModifications: {
            'Leukemia': 'Choose slower animals to mimic, take breaks as needed',
            'Lymphoma': 'Focus on upper body movements if leg fatigue occurs',
            'Bone Cancer':
                'Modify movements to avoid pressure on affected areas',
          },
        ),
        Exercise(
          name: 'Balloon Games',
          description:
              'Light exercises using balloons to improve coordination.',
          duration: '10 minutes',
          videoUrl:
              'https://www.youtube.com/watch?v=JE5G8qH6t0Q', // Balloon exercises
          difficulty: ExerciseDifficulty.beginner,
          cancerTypeModifications: {},
        ),
        Exercise(
          name: 'Dance Movement',
          description: 'Simple dance moves to familiar children\'s songs.',
          duration: '8 minutes',
          videoUrl:
              'https://www.youtube.com/watch?v=BQ9q4U2P3ig', // Kids dance moves
          difficulty: ExerciseDifficulty.beginner,
          cancerTypeModifications: {},
        ),
        Exercise(
          name: 'Stretching Games',
          description: 'Playful stretching exercises with storytelling.',
          duration: '7 minutes',
          videoUrl:
              'https://www.youtube.com/watch?v=EppJw89K8N8', // Kids stretching
          difficulty: ExerciseDifficulty.beginner,
          cancerTypeModifications: {},
        ),
      ];
    } else if (age <= 19) {
      return [
        Exercise(
          name: 'Modified High Knees',
          description: 'Gentle knee lifts while standing or seated.',
          duration: '5 minutes',
          videoUrl:
              'https://www.youtube.com/watch?v=uZq6ZDu0rOQ', // Low impact exercises
          difficulty: ExerciseDifficulty.intermediate,
          cancerTypeModifications: {
            'Hodgkin Lymphoma': 'Perform seated if experiencing fatigue',
            'Bone Cancer':
                'Reduce range of motion, focus on controlled movements',
            'Brain Tumor': 'Keep movements slow and controlled',
          },
        ),
        Exercise(
          name: 'Resistance Band Training',
          description: 'Upper body strengthening with light resistance bands.',
          duration: '12 minutes',
          videoUrl:
              'https://www.youtube.com/watch?v=yIQxqfdJ5X4', // Resistance band workout
          difficulty: ExerciseDifficulty.intermediate,
          cancerTypeModifications: {
            'Leukemia': 'Use lighter resistance, focus on form',
            'Lymphoma': 'Take breaks between sets, monitor breathing',
            'Bone Cancer': 'Avoid exercises that stress affected bones',
          },
        ),
        Exercise(
          name: 'Balance Exercises',
          description: 'Simple balance exercises to maintain stability.',
          duration: '10 minutes',
          videoUrl: 'https://www.youtube.com/watch?v=z-tUHuNPStw',
          difficulty: ExerciseDifficulty.beginner,
          cancerTypeModifications: {},
        ),
        Exercise(
          name: 'Seated Strength',
          description: 'Light strength training exercises while seated.',
          duration: '12 minutes',
          videoUrl: 'https://www.youtube.com/watch?v=4Uzk6f2GnO8',
          difficulty: ExerciseDifficulty.beginner,
          cancerTypeModifications: {},
        ),
        Exercise(
          name: 'Mindful Movement',
          description: 'Combining breathing exercises with gentle movement.',
          duration: '10 minutes',
          videoUrl: 'https://www.youtube.com/watch?v=EYQsRBNYdPk',
          difficulty: ExerciseDifficulty.beginner,
          cancerTypeModifications: {},
        ),
      ];
    } else if (age <= 35) {
      return [
        Exercise(
          name: 'Modified Yoga Flow',
          description: 'Gentle yoga sequences adapted for cancer patients.',
          duration: '15 minutes',
          videoUrl:
              'https://www.youtube.com/watch?v=4vTJHUDB5ak', // Gentle yoga
          difficulty: ExerciseDifficulty.intermediate,
          cancerTypeModifications: {
            'Breast Cancer': 'Modify chest-opening poses',
            'Lung Cancer': 'Focus on gentle breathing',
            'Colorectal Cancer': 'Avoid deep twists',
          },
        ),
        Exercise(
          name: 'Low-Impact Cardio',
          description: 'Gentle cardio movements to maintain stamina.',
          duration: '12 minutes',
          videoUrl:
              'https://youtu.be/HP_P-A3crw4?si=SCqGUj5TdvUX5z17', // Low impact cardio
          difficulty: ExerciseDifficulty.intermediate,
          cancerTypeModifications: {
            'Breast Cancer': 'Avoid arm circles',
            'Lung Cancer': 'Reduce intensity, focus on breathing',
            'Bone Cancer': 'Stay low-impact, avoid jumps',
          },
        ),
        Exercise(
          name: 'Core Stability',
          description: 'Gentle core exercises to maintain strength.',
          duration: '10 minutes',
          videoUrl: 'https://www.youtube.com/watch?v=K-CrEi0ymMg',
          difficulty: ExerciseDifficulty.beginner,
          cancerTypeModifications: {},
        ),
        Exercise(
          name: 'Resistance Band Work',
          description: 'Light resistance training using bands.',
          duration: '15 minutes',
          videoUrl: 'https://www.youtube.com/watch?v=1DYH5ud3zHo',
          difficulty: ExerciseDifficulty.intermediate,
          cancerTypeModifications: {},
        ),
        Exercise(
          name: 'Balance Training',
          description: 'Exercises to improve balance and stability.',
          duration: '12 minutes',
          videoUrl: 'https://www.youtube.com/watch?v=z-tUHuNPStw',
          difficulty: ExerciseDifficulty.beginner,
          cancerTypeModifications: {},
        ),
      ];
    } else if (age <= 48) {
      return [
        Exercise(
          name: 'Chair-Based Yoga',
          description: 'Yoga poses modified to be done with chair support.',
          duration: '15 minutes',
          videoUrl: 'https://www.youtube.com/watch?v=KEjiXtb2hRg', // Chair yoga
          difficulty: ExerciseDifficulty.beginner,
          cancerTypeModifications: {
            'Breast Cancer': 'Modify arm movements',
            'Lung Cancer': 'Focus on gentle breathing',
            'Bone Cancer': 'Use chair support as needed',
          },
        ),
        Exercise(
          name: 'Gentle Stretching',
          description: 'Full-body stretching routine for flexibility.',
          duration: '12 minutes',
          videoUrl:
              'https://www.youtube.com/watch?v=Ki8EXSex-2U', // Gentle stretching
          difficulty: ExerciseDifficulty.beginner,
          cancerTypeModifications: {
            'Breast Cancer': 'Modify chest stretches',
            'Lung Cancer': 'Keep movements gentle',
            'Bone Cancer': 'Avoid stretching affected areas',
          },
        ),
        Exercise(
          name: 'Standing Balance',
          description: 'Balance exercises with support options.',
          duration: '10 minutes',
          videoUrl: 'https://www.youtube.com/watch?v=z-tUHuNPStw',
          difficulty: ExerciseDifficulty.beginner,
          cancerTypeModifications: {},
        ),
        Exercise(
          name: 'Seated Strength',
          description: 'Upper body exercises while seated.',
          duration: '15 minutes',
          videoUrl: 'https://www.youtube.com/watch?v=4Uzk6f2GnO8',
          difficulty: ExerciseDifficulty.beginner,
          cancerTypeModifications: {},
        ),
        Exercise(
          name: 'Breathing Exercises',
          description: 'Deep breathing techniques for relaxation.',
          duration: '8 minutes',
          videoUrl: 'https://www.youtube.com/watch?v=EYQsRBNYdPk',
          difficulty: ExerciseDifficulty.beginner,
          cancerTypeModifications: {},
        ),
      ];
    } else {
      return [
        Exercise(
          name: 'Chair Tai Chi',
          description: 'Gentle flowing movements adapted for seated practice.',
          duration: '15 minutes',
          videoUrl:
              'https://www.youtube.com/watch?v=coQHjTOgF7M', // Seated tai chi
          difficulty: ExerciseDifficulty.beginner,
          cancerTypeModifications: {
            'Lung Cancer': 'Focus on breathing coordination',
            'Bone Cancer': 'Reduce range of motion as needed',
            'Brain Cancer': 'Keep movements slow and controlled',
          },
        ),
        Exercise(
          name: 'Relaxation Breathing',
          description: 'Focused breathing exercises for stress relief.',
          duration: '10 minutes',
          videoUrl:
              'https://www.youtube.com/watch?v=8VwufJrUhic', // Breathing exercises
          difficulty: ExerciseDifficulty.beginner,
          cancerTypeModifications: {
            'Lung Cancer': 'Follow at own pace',
            'Brain Cancer': 'Keep sessions short',
            'Breast Cancer': 'Avoid strain on chest',
          },
        ),
        Exercise(
          name: 'Seated Stretching',
          description: 'Safe stretching exercises from a seated position.',
          duration: '15 minutes',
          videoUrl: 'https://www.youtube.com/watch?v=Ki8EXSex-2U',
          difficulty: ExerciseDifficulty.beginner,
          cancerTypeModifications: {},
        ),
        Exercise(
          name: 'Hand & Arm Mobility',
          description: 'Gentle exercises for upper body mobility.',
          duration: '10 minutes',
          videoUrl: 'https://www.youtube.com/watch?v=1DYH5ud3zHo',
          difficulty: ExerciseDifficulty.beginner,
          cancerTypeModifications: {},
        ),
        Exercise(
          name: 'Mindful Movement',
          description: 'Very gentle movement combined with meditation.',
          duration: '12 minutes',
          videoUrl: 'https://www.youtube.com/watch?v=keYtPQ1COHQ',
          difficulty: ExerciseDifficulty.beginner,
          cancerTypeModifications: {},
        ),
      ];
    }
  }
}
