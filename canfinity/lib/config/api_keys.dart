import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKeys {
  static final huggingFaceApiKey = dotenv.env['HUGGINGFACE_API_KEY'] ?? ''; // Replace with your token
} 