import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_details_screen.dart';
import '../database/database_helper.dart';
import 'chemo_tracking_screen.dart';
import 'medicine_reminders_tab.dart';
import '../config/theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  int? age;
  String cancerType = '';
  String dietPreference = '';
  String cancerStage = '';
  String location = '';
  String phoneNumber = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedName = prefs.getString('name') ?? '';
    if (storedName.isNotEmpty) {
      final storedAge = prefs.getInt('age') ?? 0;
      final storedCancerType = prefs.getString('cancerType') ?? '';
      final storedDiet = prefs.getString('dietPreference') ?? '';
      final storedStage = prefs.getString('cancerStage') ?? '';
      final storedLocation = prefs.getString('location') ?? '';
      final storedPhone = prefs.getString('phoneNumber') ?? '';
      final storedEmail = prefs.getString('email') ?? '';
      final chemoSessions = await DatabaseHelper.instance.getChemoSessions();
      final medicineReminders = await DatabaseHelper.instance.getMedicineReminders();
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailsScreen(
              name: storedName,
              age: storedAge,
              cancerType: storedCancerType,
              dietPreference: storedDiet,
              cancerStage: storedStage,
              location: storedLocation,
              phoneNumber: storedPhone,
              email: storedEmail,
              chemoSessions: chemoSessions,
              medicineReminders: medicineReminders,
            ),
          ),
        );
      });
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setInt('age', age ?? 0);
    await prefs.setString('cancerType', cancerType);
    await prefs.setString('dietPreference', dietPreference);
    await prefs.setString('cancerStage', cancerStage);
    await prefs.setString('location', location);
    await prefs.setString('phoneNumber', phoneNumber);
    await prefs.setString('email', email);
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      await _saveData();
      final chemoSessions = await DatabaseHelper.instance.getChemoSessions();
      final medicineReminders = await DatabaseHelper.instance.getMedicineReminders();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registered successfully!'),
          backgroundColor: AppTheme.secondary,
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserDetailsScreen(
            name: name,
            age: age ?? 0,
            cancerType: cancerType,
            dietPreference: dietPreference,
            cancerStage: cancerStage,
            location: location,
            phoneNumber: phoneNumber,
            email: email,
            chemoSessions: chemoSessions,
            medicineReminders: medicineReminders,
          ),
        ),
      );
    }
  }

  InputDecoration themedInput(String label, IconData icon) => InputDecoration(
    labelText: label,
    labelStyle: TextStyle(color: AppTheme.subtext),
    prefixIcon: Icon(icon, color: AppTheme.primary),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppTheme.secondary, width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: AppTheme.primary.withOpacity(0.5), width: 1.5),
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.primary.withOpacity(0.3), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    // Header with icon and title
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          size: 64,
                          color: AppTheme.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        'Welcome to CancerCare',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.secondary,
                        ),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Let\'s get to know you better',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.subtext,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Form Fields with Icons
                    TextFormField(
                      initialValue: name,
                      decoration: themedInput('Your Name', Icons.person),
                      onChanged: (value) => setState(() => name = value),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: age?.toString(),
                      decoration: themedInput('Your Age', Icons.calendar_today),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => setState(() => age = int.tryParse(value)),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your age' : null,
                    ),
                    const SizedBox(height: 16),

                    // Styled Dropdown
                    DropdownButtonFormField<String>(
                      decoration: themedInput('Cancer Type', Icons.medical_information),
                      value: cancerType.isNotEmpty ? cancerType : null,
                      items: const [
                        DropdownMenuItem(value: 'Breast', child: Text('Breast')),
                        DropdownMenuItem(value: 'Lung', child: Text('Lung')),
                        DropdownMenuItem(value: 'Colon', child: Text('Colon')),
                      ],
                      onChanged: (value) => setState(() => cancerType = value ?? ''),
                      validator: (value) => value == null || value.isEmpty ? 'Please select cancer type' : null,
                      icon: const Icon(Icons.arrow_drop_down_circle, color: AppTheme.primary),
                      dropdownColor: Colors.white,
                      style: const TextStyle(color: AppTheme.text, fontSize: 16),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      initialValue: dietPreference,
                      decoration: themedInput('Diet Preference', Icons.restaurant_menu),
                      onChanged: (value) => setState(() => dietPreference = value),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: cancerStage,
                      decoration: themedInput('Cancer Stage', Icons.bar_chart),
                      onChanged: (value) => setState(() => cancerStage = value),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: location,
                      decoration: themedInput('Location', Icons.location_on),
                      onChanged: (value) => setState(() => location = value),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: phoneNumber,
                      decoration: themedInput('Phone Number', Icons.phone),
                      keyboardType: TextInputType.phone,
                      onChanged: (value) => setState(() => phoneNumber = value),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: email,
                      decoration: themedInput('Email', Icons.email),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => setState(() => email = value),
                    ),
                    const SizedBox(height: 32),

                    // Redesigned Button
                    ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
                        shadowColor: AppTheme.secondary.withOpacity(0.5),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Complete Registration',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}