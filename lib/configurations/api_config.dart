import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      // Use API_WEB_URL when running on the web
      return dotenv.env['API_WEB_URL'] ?? 'http://localhost:5106';
    } else {
      // Use API_BASE_URL for other platforms
      return dotenv.env['API_BASE_URL'] ?? 'http://192.168.0.167:5106';
    }
  }
}