import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_keys.dart';

class AIService {
  static const String _huggingFaceApiUrl =
      'https://api-inference.huggingface.co/models';
  static final String _apiKey = ApiKeys.huggingFaceApiKey;

  // For Diet Plan - using GPT-Neo which is more stable and free
  static Future<String> generateDietPlan({
    required String gender,
    required String age,
    required String cancerType,
    required String dietPreference,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_huggingFaceApiUrl/EleutherAI/gpt-neo-125M'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'inputs': '''Create a diet plan for cancer patient:
            Gender: $gender
            Age: $age
            Cancer Type: $cancerType
            Diet: $dietPreference

            Provide meal plan with:
            1. Breakfast
            2. Lunch
            3. Dinner
            4. Snacks
            5. Foods to avoid''',
          'parameters': {
            'max_length': 500,
            'temperature': 0.7,
            'num_return_sequences': 1,
          }
        }),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('API Response: $data');

        if (data is List && data.isNotEmpty) {
          String generatedText = data[0]['generated_text'] ?? '';
          if (generatedText.isEmpty) {
            return getFallbackDietPlan(cancerType, dietPreference);
          }
          return formatDietPlan(
              gender, age, cancerType, dietPreference, generatedText);
        }
      }
      return getFallbackDietPlan(cancerType, dietPreference);
    } catch (e) {
      print('Exception caught: $e');
      return getFallbackDietPlan(cancerType, dietPreference);
    }
  }

  // Add this helper method to format the response
  static String formatDietPlan(
    String gender,
    String age,
    String cancerType,
    String dietPreference,
    String generatedText,
  ) {
    return '''
Personalized Diet Plan

Patient Information:
- Gender: $gender
- Age: $age
- Cancer Type: $cancerType
- Diet Preference: $dietPreference

Recommendations:
$generatedText

Important Notes:
- Consult with your healthcare provider before starting this diet plan
- Stay hydrated by drinking plenty of water
- Eat small, frequent meals throughout the day
- Listen to your body and adjust portions as needed
''';
  }

  // For Mental Health Chat
  static Future<String> getMentalHealthResponse(String userMessage) async {
    try {
      // Using a more specific cancer support prompt
      String prompt =
          '''You are an experienced cancer support counselor with deep knowledge of oncology and mental health. 
      Provide a compassionate, informative response to this patient message: "$userMessage"
      
      Focus on:
      1. Specific cancer-related advice and coping strategies
      2. Medical accuracy and evidence-based information
      3. Emotional support with practical guidance
      4. Professional resources when needed
      5. Clear, actionable steps
      
      If the message mentions specific cancer types, provide relevant information for that cancer type.
      Always maintain a supportive and hopeful tone while being realistic.''';

      final response = await http.post(
        Uri.parse('$_huggingFaceApiUrl/google/flan-t5-large'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'inputs': prompt,
          'parameters': {
            'max_length': 500,
            'temperature': 0.7,
            'top_p': 0.9,
            'do_sample': true,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String aiResponse = data[0]['generated_text'] ?? '';

        if (aiResponse.isEmpty || aiResponse.length < 20) {
          return getEnhancedFallbackResponse(userMessage);
        }

        return aiResponse;
      } else {
        return getEnhancedFallbackResponse(userMessage);
      }
    } catch (e) {
      print('Error generating response: $e');
      return getEnhancedFallbackResponse(userMessage);
    }
  }

  static String getEnhancedFallbackResponse(String userMessage) {
    final message = userMessage.toLowerCase();

    // Prostate Cancer specific responses
    if (message.contains('prostate')) {
      return '''Here are some specific tips for prostate cancer management:

1. Treatment Support:
   - Regular PSA monitoring
   - Hormone therapy management
   - Side effect management strategies
   - Exercise recommendations

2. Lifestyle Adjustments:
   - Pelvic floor exercises
   - Dietary modifications
   - Stress management techniques
   - Physical activity guidelines

3. Available Resources:
   - Support groups specifically for prostate cancer
   - Specialist referrals
   - Educational materials
   - Clinical trial information

Would you like more specific information about any of these areas?''';
    }

    // Treatment anxiety responses
    if (message.contains('anxious') ||
        message.contains('worried') ||
        message.contains('scared')) {
      return '''I understand your anxiety about cancer treatment. Here's what might help:

1. Immediate Coping Strategies:
   - Deep breathing exercises
   - Progressive muscle relaxation
   - Mindfulness techniques
   - Guided imagery

2. Professional Support:
   - Oncology counselors
   - Support groups
   - Cancer care navigators
   - Mental health specialists

3. Practical Steps:
   - Write down your questions for doctors
   - Bring a support person to appointments
   - Keep a treatment journal
   - Create a daily routine

Would you like to explore any of these options in more detail?''';
    }

    // Side effects management
    if (message.contains('side effect') ||
        message.contains('pain') ||
        message.contains('nausea')) {
      return '''Let's address your concerns about side effects:

1. Common Management Strategies:
   - Medication timing optimization
   - Dietary adjustments
   - Rest and activity balance
   - Symptom tracking

2. When to Contact Healthcare Team:
   - Severe pain or discomfort
   - Unusual symptoms
   - Fever or infection signs
   - Significant changes in health

3. Support Resources:
   - Side effect management guides
   - Nutrition support
   - Pain management specialists
   - Complementary therapies

What specific side effects would you like to discuss?''';
    }

    // Default response with actionable steps
    return '''I'm here to support your cancer journey. Let's focus on what would help most:

1. Emotional Support:
   - Professional counseling
   - Peer support groups
   - Stress management techniques
   - Family support resources

2. Practical Assistance:
   - Treatment navigation
   - Daily management strategies
   - Lifestyle adjustments
   - Resource connections

3. Educational Resources:
   - Reliable information sources
   - Treatment options
   - Recovery guidelines
   - Support services

What specific aspect would you like to explore first?''';
  }

  static String getFallbackDietPlan(String cancerType, String dietPreference) {
    final bool isVegetarian = dietPreference == 'Vegetarian';

    return '''
Personalized Diet Plan (Standard Guidelines)

Breakfast Options:
1. High-Fiber Start
   - Oatmeal with berries and ground flaxseeds
   - Almond milk or green tea
   - Banana or apple

2. Protein-Rich Beginning
   - ${isVegetarian ? 'Tofu scramble with spinach' : 'Scrambled eggs with spinach'}
   - Whole grain toast with avocado
   - Fresh orange

3. Quick Energy
   - Greek yogurt with honey
   - Mixed nuts and seeds
   - Fresh fruit medley

Lunch Options:
1. Power Bowl
   - ${isVegetarian ? 'Quinoa with chickpeas' : 'Brown rice with grilled chicken'}
   - Steamed broccoli and carrots
   - Olive oil dressing

2. Healthy Wrap
   - ${isVegetarian ? 'Hummus and vegetable wrap' : 'Turkey and avocado wrap'}
   - Mixed green salad
   - Fresh vegetable soup

3. Nutrient-Dense Plate
   - ${isVegetarian ? 'Lentil curry' : 'Baked fish'}
   - Brown rice
   - Steamed vegetables

Dinner Options:
1. Light & Nutritious
   - ${isVegetarian ? 'Vegetable stir-fry with tofu' : 'Grilled fish with herbs'}
   - Quinoa or brown rice
   - Steamed asparagus

2. Comfort Meal
   - ${isVegetarian ? 'Black bean soup' : 'Lean chicken soup'}
   - Whole grain bread
   - Roasted vegetables

3. Easy Digest
   - ${isVegetarian ? 'Vegetable curry' : 'Poached chicken'}
   - Sweet potato mash
   - Steamed green beans

Healthy Snacks:
- Fresh fruits (apples, pears, berries)
- Raw nuts and seeds (almonds, walnuts, pumpkin seeds)
- Yogurt with honey
- Whole grain crackers with hummus
- Vegetable sticks with dip

Foods to Avoid:
- Processed and packaged foods
- Sugary drinks and excessive sweets
- Fried and fatty foods
- Alcohol
- Raw or undercooked foods
- Excessive caffeine

Special Considerations for $cancerType:
- Eat small, frequent meals to maintain energy
- Choose easily digestible foods
- Stay well hydrated with water and herbal teas
- Monitor food tolerance and adjust as needed

Important Notes:
1. Consult your healthcare provider before starting this diet
2. Adjust portions based on your appetite and tolerance
3. Keep a food diary to track any sensitivities
4. Stay hydrated with 8-10 glasses of water daily
5. Take small, frequent meals rather than large ones

Remember: This is a general guide. Your specific needs may vary based on your treatment plan and overall health status.
''';
  }
}
