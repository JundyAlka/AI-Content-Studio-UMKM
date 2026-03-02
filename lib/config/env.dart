import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  static String get stabilityApiKey => dotenv.env['STABILITY_API_KEY'] ?? '';
  static String get aiTextApiKey =>
      dotenv.env['AI_TEXT_API_KEY'] ?? 'demo_text_key';
  static String get aiImageApiKey =>
      dotenv.env['AI_IMAGE_API_KEY'] ?? 'demo_image_key';

  // Base URLs
  static String get aiTextBaseUrl =>
      dotenv.env['AI_TEXT_BASE_URL'] ?? 'https://api.openai.com/v1';
  static String get aiImageBaseUrl =>
      dotenv.env['AI_IMAGE_BASE_URL'] ??
      'https://api.openai.com/v1/images/generations';
}
