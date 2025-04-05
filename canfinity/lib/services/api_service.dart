import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000'; // Update if needed

  static Future<void> addChemoSession({
    required int sessionNumber,
    required DateTime date,
    required String duration,
    required String notes,
  }) async {
    final url = Uri.parse('$baseUrl/add_chemo_session');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'sessionNumber': sessionNumber,
        'date': date.toIso8601String().split('T')[0],
        'duration': duration,
        'notes': notes,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add chemo session');
    }
  }

  static Future<void> addMedicineReminder({
    required String medicineName,
    required String time,
    required String dosage,
    required String notes,
    required bool isActive,
  }) async {
    final url = Uri.parse('$baseUrl/add_medicine_reminder');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'medicineName': medicineName,
        'time': time,
        'dosage': dosage,
        'notes': notes,
        'isActive': isActive,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add medicine reminder');
    }
  }
  static Future<List<Map<String, dynamic>>> getChemoSessions() async {
    final url = Uri.parse('$baseUrl/get_chemo_sessions');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch chemo sessions');
    }
  }

  static Future<List<Map<String, dynamic>>> getMedicineReminders() async {
    final url = Uri.parse('$baseUrl/get_medicine_reminders');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch medicine reminders');
    }
  }
}
