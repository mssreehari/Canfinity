import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../services/diet_service.dart';

class DietPlanScreen extends StatefulWidget {
  const DietPlanScreen({super.key});

  @override
  State<DietPlanScreen> createState() => _DietPlanScreenState();
}

class _DietPlanScreenState extends State<DietPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ageController = TextEditingController();
  String _gender = 'Male';
  String _cancerType = 'Breast Cancer';
  String _dietPreference = 'Non-Vegetarian';
  String _dietPlan = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          'Diet Plan Generator',
          style: TextStyle(color: AppTheme.primary),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Your Personalized Diet Plan',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 20),

                // Gender Dropdown
                Text(
                  'Gender',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.text,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: AppTheme.primary.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(8),
                    color: AppTheme.surface,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _gender,
                      dropdownColor: AppTheme.surface,
                      style: TextStyle(color: AppTheme.text, fontSize: 16),
                      icon:
                          Icon(Icons.arrow_drop_down, color: AppTheme.primary),
                      onChanged: (String? newValue) {
                        setState(() {
                          _gender = newValue!;
                        });
                      },
                      items: ['Male', 'Female', 'Other']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Age Field
                Text(
                  'Age',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.text,
                  ),
                ),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppTheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: AppTheme.primary.withOpacity(0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppTheme.primary),
                    ),
                    hintText: 'Enter your age',
                    hintStyle: TextStyle(color: AppTheme.subtext),
                  ),
                  style: TextStyle(color: AppTheme.text),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Cancer Type Dropdown
                Text(
                  'Cancer Type',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.text,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: AppTheme.primary.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(8),
                    color: AppTheme.surface,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _cancerType,
                      dropdownColor: AppTheme.surface,
                      style: TextStyle(color: AppTheme.text, fontSize: 16),
                      icon:
                          Icon(Icons.arrow_drop_down, color: AppTheme.primary),
                      onChanged: (String? newValue) {
                        setState(() {
                          _cancerType = newValue!;
                        });
                      },
                      items: [
                        'Breast Cancer',
                        'Lung Cancer',
                        'Prostate Cancer',
                        'Colorectal Cancer',
                        'Other'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Diet Preference Dropdown
                Text(
                  'Diet Preference',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.text,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: AppTheme.primary.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(8),
                    color: AppTheme.surface,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _dietPreference,
                      dropdownColor: AppTheme.surface,
                      style: TextStyle(color: AppTheme.text, fontSize: 16),
                      icon:
                          Icon(Icons.arrow_drop_down, color: AppTheme.primary),
                      onChanged: (String? newValue) {
                        setState(() {
                          _dietPreference = newValue!;
                        });
                      },
                      items: [
                        'Vegetarian',
                        'Non-Vegetarian',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Generate Button
                Center(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _generateDietPlan,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Generate Diet Plan',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
                const SizedBox(height: 32),

                // Generated Diet Plan
                if (_dietPlan.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      border:
                          Border.all(color: AppTheme.primary.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Personalized Diet Plan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _dietPlan,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.text,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _generateDietPlan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final age = int.parse(_ageController.text);
      final dietPlan = await DietService.generateDietPlan(
        _gender,
        age,
        _cancerType,
        _dietPreference,
      );

      // Format the diet plan into a readable string
      final formattedPlan = '''
Foods to Eat:
${(dietPlan['foodsToEat'] as List).map((e) => '• $e').join('\n')}

Foods to Avoid:
${(dietPlan['foodsToAvoid'] as List).map((e) => '• $e').join('\n')}

Breakfast Options:
${(dietPlan['breakfast'] as List).map((e) => '• $e').join('\n')}

Lunch Options:
${(dietPlan['lunch'] as List).map((e) => '• $e').join('\n')}

Dinner Options:
${(dietPlan['dinner'] as List).map((e) => '• $e').join('\n')}

Precautions:
${(dietPlan['precautions'] as List).map((e) => '• $e').join('\n')}

Important Notes:
${(dietPlan['consultationNotes'] as List).map((e) => '• $e').join('\n')}
''';

      setState(() {
        _dietPlan = formattedPlan;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
