class DietService {
  static Future<Map<String, dynamic>> generateDietPlan(
    String gender,
    int age,
    String cancerType,
    String dietPreference,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    bool isVegetarian = dietPreference == 'Vegetarian';

    // Age-specific portion sizes
    String portionSize = age < 50 ? 'regular' : 'smaller';

    switch (cancerType.toLowerCase()) {
      case 'breast cancer':
        return _getBreastCancerDiet(gender, age, isVegetarian);
      case 'lung cancer':
        return _getLungCancerDiet(gender, age, isVegetarian);
      case 'prostate cancer':
        return _getProstateCancerDiet(age, isVegetarian);
      case 'colorectal cancer':
        return _getColorectalCancerDiet(gender, age, isVegetarian);
      default:
        return _getGeneralCancerDiet(gender, age, isVegetarian);
    }
  }

  static Map<String, dynamic> _getBreastCancerDiet(
      String gender, int age, bool isVegetarian) {
    List<String> genderSpecificFoods = gender == 'Female'
        ? [
            'Flaxseeds (2 tablespoons daily)',
            'Soy products in moderation',
            'Calcium-rich foods',
          ]
        : [
            'Zinc-rich foods',
            'Protein-rich foods',
          ];

    List<String> ageSpecificFoods = age > 50
        ? [
            'Calcium-fortified foods',
            'Vitamin D rich foods',
            'Easy to digest proteins',
          ]
        : [
            'High-fiber whole grains',
            'Lean proteins',
            'Healthy fats',
          ];

    return {
      'foodsToEat': [
        ...genderSpecificFoods,
        ...ageSpecificFoods,
        'Cruciferous vegetables (broccoli, cauliflower)',
        'Green tea (2-3 cups daily)',
        'Berries and citrus fruits',
        if (!isVegetarian) 'Fatty fish (salmon, mackerel) 2-3 times weekly',
      ],
      'foodsToAvoid': [
        'Alcohol',
        'Processed meats',
        'High-fat dairy products',
        'Added sugars',
        'Deep fried foods',
        if (age > 60) 'Very spicy foods',
      ],
      'breakfast': isVegetarian
          ? age > 50
              ? [
                  'Warm quinoa porridge with almond milk and berries (1 cup) - 320 calories, 12g protein, 45g carbs, 8g fiber',
                  'Overnight oats with chia seeds and fruit (3/4 cup) - 280 calories, 10g protein, 42g carbs, 6g fiber',
                  'Whole grain toast with avocado (small portion)',
                  'Warm vegetable smoothie',
                ]
              : [
                  'Power oatmeal with nuts and seeds',
                  'Whole grain toast with peanut butter',
                  'Green smoothie bowl',
                ]
          : age > 50
              ? [
                  'Scrambled eggs with spinach',
                  'Small portion of grilled fish',
                  'Yogurt with honey',
                ]
              : [
                  'Egg white omelet with vegetables',
                  'Grilled chicken breast',
                  'Greek yogurt parfait',
                ],
      'lunch': isVegetarian
          ? age > 50
              ? [
                  'Soft cooked lentil soup',
                  'Steamed vegetables with quinoa',
                  'Vegetable curry with rice',
                ]
              : [
                  'Buddha bowl with tofu',
                  'Chickpea salad sandwich',
                  'Quinoa power bowl',
                ]
          : age > 50
              ? [
                  'Baked fish with soft vegetables',
                  'Tender chicken soup',
                  'Turkey meatballs with pasta',
                ]
              : [
                  'Grilled chicken salad',
                  'Tuna wrap with vegetables',
                  'Lean beef stir-fry',
                ],
      'dinner': isVegetarian
          ? age > 50
              ? [
                  'Soft cooked vegetables with tofu',
                  'Mushroom soup with bread',
                  'Vegetable khichdi',
                ]
              : [
                  'Stir-fried tofu with vegetables',
                  'Lentil curry with brown rice',
                  'Vegetable lasagna',
                ]
          : age > 50
              ? [
                  'Poached fish with vegetables',
                  'Tender chicken breast with rice',
                  'Soft cooked turkey with potatoes',
                ]
              : [
                  'Grilled fish with vegetables',
                  'Lean chicken breast with quinoa',
                  'Turkey with sweet potatoes',
                ],
      'precautions': [
        if (gender == 'Female') 'Monitor soy intake',
        if (age > 50) 'Eat smaller, more frequent meals',
        'Stay hydrated (8-10 glasses daily)',
        'Maintain healthy weight',
        if (age > 60) 'Choose soft, easily digestible foods',
      ],
      'consultationNotes': [
        'Regular consultation with oncologist',
        if (gender == 'Female') 'Monitor bone density',
        if (age > 50) 'Regular nutritional assessment',
        'Track food sensitivities',
        'Keep food diary',
      ],
      'preparationTips': [
        'Steam vegetables to retain maximum nutrients',
        'Use olive oil for cooking at medium temperatures',
        'Prepare meals in advance to ensure regular eating schedule',
        'Store cut vegetables in airtight containers',
        'Cook proteins at appropriate temperatures to ensure food safety',
        'Use herbs and spices instead of salt for flavoring',
      ],
      'supplementConsiderations': [
        'Vitamin D3: Discuss 1000-2000 IU daily supplementation',
        'Calcium: Consider 500-1000mg if dairy intake is limited',
        'B12: Essential for vegetarians/vegans (1000mcg daily)',
        'Omega-3: If not consuming fatty fish regularly',
        'Probiotics: Especially during/after antibiotics',
      ],
    };
  }

  static Map<String, dynamic> _getLungCancerDiet(
      String gender, int age, bool isVegetarian) {
    return {
      'foodsToEat': [
        'Orange and yellow fruits/vegetables',
        'Leafy greens',
        if (!isVegetarian) 'Lean proteins',
        'Whole grains',
        'Nuts and seeds',
      ],
      'foodsToAvoid': [
        'Processed foods',
        'Smoked or cured meats',
        'Excessive salt',
        'Alcohol',
        'Sugary drinks',
      ],
      'breakfast': isVegetarian
          ? [
              'Smoothie bowl with berries and seeds',
              'Whole grain porridge with nuts',
              'Tofu scramble with vegetables',
            ]
          : [
              'Poached eggs on whole grain toast',
              'Protein smoothie with fruits',
              'Turkey bacon with sweet potatoes',
            ],
      'lunch': isVegetarian
          ? [
              'Vegetable soup with legumes',
              'Quinoa salad with chickpeas',
              'Hummus wrap with vegetables',
            ]
          : [
              'Grilled chicken with roasted vegetables',
              'Fish tacos with cabbage slaw',
              'Turkey and quinoa bowl',
            ],
      'dinner': isVegetarian
          ? [
              'Lentil curry with brown rice',
              'Baked tempeh with vegetables',
              'Black bean and sweet potato bowl',
            ]
          : [
              'Baked fish with quinoa',
              'Lean turkey meatloaf with vegetables',
              'Chicken stir-fry with brown rice',
            ],
      'precautions': [
        'Avoid smoking and second-hand smoke',
        'Eat smaller, frequent meals',
        'Stay well-hydrated',
        'Monitor weight changes',
      ],
      'consultationNotes': [
        'Regular check-ups with pulmonologist',
        'Monitor breathing during meals',
        'Discuss supplements with doctor',
        'Consider working with a respiratory therapist',
      ],
      'preparationTips': [
        'Steam vegetables to retain maximum nutrients',
        'Use olive oil for cooking at medium temperatures',
        'Prepare meals in advance to ensure regular eating schedule',
        'Store cut vegetables in airtight containers',
        'Cook proteins at appropriate temperatures to ensure food safety',
        'Use herbs and spices instead of salt for flavoring',
      ],
    };
  }

  static Map<String, dynamic> _getProstateCancerDiet(
      int age, bool isVegetarian) {
    return {
      'foodsToEat': [
        'Tomatoes and tomato products',
        'Cruciferous vegetables',
        'Pomegranates',
        'Green tea',
        'Fish rich in omega-3',
      ],
      'foodsToAvoid': [
        'Dairy products (limit intake)',
        'Red meat',
        'Processed meats',
        'Foods high in calcium',
        'Alcohol',
      ],
      'breakfast': isVegetarian
          ? [
              'Oatmeal with flaxseeds and berries',
              'Whole grain toast with avocado',
              'Plant-based yogurt with nuts and fruits',
            ]
          : [
              'Egg white omelet with vegetables',
              'Whole grain toast with salmon',
              'Greek yogurt with berries',
            ],
      'lunch': isVegetarian
          ? [
              'Quinoa bowl with roasted vegetables',
              'Lentil soup with whole grain bread',
              'Buddha bowl with tofu',
            ]
          : [
              'Grilled chicken salad',
              'Tuna wrap with vegetables',
              'Turkey and avocado sandwich',
            ],
      'dinner': isVegetarian
          ? [
              'Stir-fried tofu with vegetables',
              'Bean and vegetable curry',
              'Chickpea pasta with vegetables',
            ]
          : [
              'Baked fish with roasted vegetables',
              'Lean chicken breast with quinoa',
              'Turkey meatballs with zucchini noodles',
            ],
      'precautions': [
        'Limit calcium supplements',
        'Monitor vitamin D intake',
        'Control portion sizes',
      ],
      'consultationNotes': [
        'Regular PSA level monitoring',
        'Discuss soy consumption',
        'Review supplements with doctor',
      ],
      'preparationTips': [
        'Steam vegetables to retain maximum nutrients',
        'Use olive oil for cooking at medium temperatures',
        'Prepare meals in advance to ensure regular eating schedule',
        'Store cut vegetables in airtight containers',
        'Cook proteins at appropriate temperatures to ensure food safety',
        'Use herbs and spices instead of salt for flavoring',
      ],
    };
  }

  static Map<String, dynamic> _getColorectalCancerDiet(
      String gender, int age, bool isVegetarian) {
    List<String> ageSpecificFoods = age > 50
        ? [
            'Soft, well-cooked vegetables',
            'Easy-to-digest proteins',
            'Low-fiber fruits (without skin)',
          ]
        : [
            'High-fiber vegetables',
            'Whole grains',
            'Fresh fruits with skin (if tolerated)',
          ];

    return {
      'foodsToEat': [
        ...ageSpecificFoods,
        'Lean proteins',
        'Probiotic-rich foods',
        'Omega-3 rich foods',
        if (!isVegetarian) 'Fish (2-3 times weekly)',
        'Cooked vegetables',
        'Water-rich fruits',
      ],
      'foodsToAvoid': [
        'Red and processed meats',
        'Alcohol',
        'Sugary drinks and snacks',
        'Fried foods',
        'Spicy foods',
        if (age > 50) 'Raw vegetables and fruits with tough skins',
        'Processed snacks and fast food',
      ],
      'breakfast': isVegetarian
          ? age > 50
              ? [
                  'Smooth oatmeal with banana and ground flaxseeds',
                  'Well-cooked quinoa porridge with soft fruits',
                  'Vegetable smoothie with protein powder',
                ]
              : [
                  'High-fiber cereal with plant-based milk',
                  'Whole grain toast with avocado',
                  'Fruit and vegetable smoothie bowl',
                ]
          : age > 50
              ? [
                  'Scrambled eggs with well-cooked spinach',
                  'Soft poached eggs on toast',
                  'Greek yogurt with soft fruits',
                ]
              : [
                  'Egg white omelet with vegetables',
                  'Grilled fish with whole grain toast',
                  'Turkey breast with sweet potatoes',
                ],
      'lunch': isVegetarian
          ? age > 50
              ? [
                  'Well-cooked lentil soup',
                  'Soft steamed vegetables with tofu',
                  'Pureed vegetable soup with bread',
                ]
              : [
                  'Quinoa bowl with roasted vegetables',
                  'Chickpea and vegetable curry',
                  'Buddha bowl with tempeh',
                ]
          : age > 50
              ? [
                  'Baked fish with soft vegetables',
                  'Tender chicken soup',
                  'Well-cooked turkey with rice',
                ]
              : [
                  'Grilled chicken with vegetables',
                  'Baked fish with quinoa',
                  'Turkey and avocado wrap',
                ],
      'dinner': isVegetarian
          ? age > 50
              ? [
                  'Soft cooked rice with vegetable curry',
                  'Well-cooked pasta with legume sauce',
                  'Mashed potatoes with vegetable stew',
                ]
              : [
                  'Stir-fried tofu with vegetables',
                  'Lentil and vegetable curry',
                  'Bean and vegetable soup',
                ]
          : age > 50
              ? [
                  'Poached fish with mashed potatoes',
                  'Tender chicken breast with rice',
                  'Well-cooked fish with soft vegetables',
                ]
              : [
                  'Baked fish with roasted vegetables',
                  'Lean chicken with brown rice',
                  'Turkey meatballs with vegetables',
                ],
      'precautions': [
        'Stay well hydrated',
        'Eat small, frequent meals',
        'Chew food thoroughly',
        if (age > 50) 'Choose soft, well-cooked foods',
        'Monitor fiber intake',
        'Watch for any digestive discomfort',
        'Avoid very hot or very cold foods',
      ],
      'consultationNotes': [
        'Regular colonoscopy check-ups',
        'Monitor bowel movements',
        'Track food sensitivities',
        'Discuss fiber intake with doctor',
        if (age > 50) 'Regular nutritional assessment',
        'Keep food diary',
        'Report any digestive changes',
      ],
      'preparationTips': [
        'Steam vegetables to retain maximum nutrients',
        'Use olive oil for cooking at medium temperatures',
        'Prepare meals in advance to ensure regular eating schedule',
        'Store cut vegetables in airtight containers',
        'Cook proteins at appropriate temperatures to ensure food safety',
        'Use herbs and spices instead of salt for flavoring',
      ],
    };
  }

  static Map<String, dynamic> _getGeneralCancerDiet(
      String gender, int age, bool isVegetarian) {
    List<String> ageSpecificFoods = age > 50
        ? [
            'Easily digestible proteins (fish, tender chicken)',
            'Soft cooked vegetables',
            'Nutrient-dense smoothies',
            'Calcium and Vitamin D rich foods',
            'Anti-inflammatory herbs (turmeric, ginger)',
          ]
        : [
            'High-protein foods for muscle maintenance',
            'Complex carbohydrates for energy',
            'Antioxidant-rich berries',
            'Healthy fats (avocados, olive oil)',
            'Iron-rich foods',
          ];

    List<String> genderSpecificFoods = gender == 'Female'
        ? [
            'Iron-rich foods (especially during treatment)',
            'Calcium-rich foods for bone health',
            'Folate-rich vegetables',
            'Plant-based estrogens in moderation',
          ]
        : [
            'Protein-rich foods for muscle maintenance',
            'Zinc-rich foods for immune function',
            'Heart-healthy omega-3 fatty acids',
            'Selenium-rich foods',
          ];

    return {
      'foodsToEat': [
        ...ageSpecificFoods,
        ...genderSpecificFoods,
        'Rainbow of vegetables (5-7 servings daily)',
        'Fresh fruits (3-4 servings daily)',
        'Whole grains (3 servings daily)',
        if (!isVegetarian) 'Lean proteins (2-3 servings daily)',
        'Healthy fats (2-3 tablespoons daily)',
        'Probiotic-rich foods',
        'High-fiber foods (25-35g daily)',
      ],
      'foodsToAvoid': [
        'Processed foods and snacks',
        'Added sugars and artificial sweeteners',
        'Excessive salt (limit to 2300mg daily)',
        'Alcohol',
        'Deep fried foods',
        'Unpasteurized dairy products',
        'Raw or undercooked foods',
        if (age > 60) 'Very spicy or acidic foods',
      ],
      'breakfast': isVegetarian
          ? age > 50
              ? [
                  'Warm quinoa porridge with almond milk and berries (1 cup) - 320 calories, 12g protein, 45g carbs, 8g fiber',
                  'Overnight oats with chia seeds and fruit (3/4 cup) - 280 calories, 10g protein, 42g carbs, 6g fiber',
                  'Whole grain toast (2 slices) with avocado and hemp seeds',
                  'Protein-rich smoothie with spinach and plant milk (16 oz)',
                ]
              : [
                  'Power breakfast bowl with mixed grains and nuts (1.5 cups)',
                  'Tofu scramble with vegetables and whole grain toast',
                  'Steel-cut oats with protein powder and fruit (1 cup)',
                  'Green smoothie bowl with granola and seeds',
                ]
          : age > 50
              ? [
                  'Soft scrambled eggs (2) with whole grain toast',
                  'Greek yogurt parfait with soft fruits (1 cup)',
                  'Poached eggs with spinach on English muffin',
                  'Protein smoothie with collagen powder (16 oz)',
                ]
              : [
                  'Egg white omelet with vegetables and cheese',
                  'Grilled chicken breast with sweet potato hash',
                  'Salmon toast with avocado (2 slices)',
                  'High-protein pancakes with berries',
                ],
      'lunch': isVegetarian
          ? age > 50
              ? [
                  'Soft cooked lentil soup with vegetables (1.5 cups)',
                  'Quinoa bowl with steamed vegetables and tofu (1 cup)',
                  'Vegetable curry with brown rice (portion size: 1 cup)',
                  'Smooth hummus wrap with soft vegetables',
                ]
              : [
                  'Buddha bowl with mixed grains and legumes (2 cups)',
                  'Chickpea and quinoa salad with olive oil dressing',
                  'Tempeh stir-fry with brown rice (1.5 cups)',
                  'Mediterranean wrap with falafel and tahini',
                ]
          : age > 50
              ? [
                  'Baked fish with roasted vegetables (4-6 oz fish)',
                  'Chicken soup with whole grain crackers (1.5 cups)',
                  'Turkey and avocado sandwich on soft bread',
                  'Tender fish tacos with soft shells',
                ]
              : [
                  'Grilled chicken salad with quinoa (6 oz chicken)',
                  'Tuna protein bowl with mixed grains (2 cups)',
                  'Turkey wrap with vegetables and hummus',
                  'Lean beef stir-fry with brown rice (5 oz beef)',
                ],
      'dinner': isVegetarian
          ? age > 50
              ? [
                  'Soft cooked vegetable curry with rice (1 cup)',
                  'Lentil soup with whole grain bread (1.5 cups)',
                  'Baked tofu with mashed potatoes (4 oz tofu)',
                  'Vegetable pasta with protein-rich sauce',
                ]
              : [
                  'Stir-fried tempeh with vegetables (6 oz tempeh)',
                  'Black bean and sweet potato bowl (2 cups)',
                  'Chickpea curry with cauliflower rice',
                  'Vegetable lasagna with tofu ricotta',
                ]
          : age > 50
              ? [
                  'Poached fish with steamed vegetables (4-6 oz fish)',
                  'Tender chicken breast with quinoa (4 oz chicken)',
                  'Baked turkey with soft roasted vegetables',
                  'Fish stew with soft vegetables (1.5 cups)',
                ]
              : [
                  'Grilled salmon with roasted vegetables (6 oz fish)',
                  'Lean chicken stir-fry with brown rice (6 oz chicken)',
                  'Turkey meatballs with zucchini noodles (5 oz turkey)',
                  'Baked cod with quinoa pilaf (6 oz fish)',
                ],
      'precautions': [
        'Monitor portion sizes based on activity level',
        'Eat slowly and chew thoroughly',
        'Stay hydrated (8-10 glasses of water daily)',
        'Take small, frequent meals (5-6 times per day)',
        'Avoid eating close to bedtime (2-3 hours gap)',
        'Monitor weight changes weekly',
        'Keep room temperature water handy during meals',
        if (age > 50) 'Choose easily digestible foods',
        'Avoid extreme temperature foods',
        'Use herbs and spices to enhance flavor',
      ],
      'consultationNotes': [
        'Regular consultation with oncologist and nutritionist',
        'Weekly weight monitoring',
        'Keep detailed food and symptom diary',
        'Track energy levels after meals',
        'Monitor hydration status',
        'Discuss supplement needs with healthcare team',
        'Regular blood work to monitor nutritional status',
        if (gender == 'Female') 'Monitor bone density and iron levels',
        if (age > 50) 'Regular nutritional assessment',
        'Report any new food sensitivities',
      ],
      'preparationTips': [
        'Steam vegetables to retain maximum nutrients',
        'Use olive oil for cooking at medium temperatures',
        'Prepare meals in advance to ensure regular eating schedule',
        'Store cut vegetables in airtight containers',
        'Cook proteins at appropriate temperatures to ensure food safety',
        'Use herbs and spices instead of salt for flavoring',
      ],
      'supplementConsiderations': [
        'Vitamin D3: Discuss 1000-2000 IU daily supplementation',
        'Calcium: Consider 500-1000mg if dairy intake is limited',
        'B12: Essential for vegetarians/vegans (1000mcg daily)',
        'Omega-3: If not consuming fatty fish regularly',
        'Probiotics: Especially during/after antibiotics',
      ],
    };
  }
}

class DietPlan {
  final List<String> foodsToEat;
  final List<String> foodsToAvoid;
  final List<String> breakfastOptions;
  final List<String> lunchOptions;
  final List<String> dinnerOptions;
  final List<String> precautions;
  final List<String> consultationNotes;

  DietPlan({
    required this.foodsToEat,
    required this.foodsToAvoid,
    required this.breakfastOptions,
    required this.lunchOptions,
    required this.dinnerOptions,
    required this.precautions,
    required this.consultationNotes,
  });
}
