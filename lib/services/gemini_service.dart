import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/env.dart';

class GeminiService {
  final String _apiKey = Env.geminiApiKey;
  final String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent';

  Future<String> enhancePrompt({
    required String originalPrompt,
    required String purpose,
    required String mood,
    String? businessName,
    String? businessType,
    String? businessDescription,
  }) async {
    final systemInstruction = """
    You are an elite AI Art Director and Prompt Engineer for Stable Diffusion XL.
    Your goal is to transform a simple user request into a PROMPT for a highly aesthetic, professional image.

    **User Request**: "$originalPrompt"
    **Context**:
    - **Business Goal**: $purpose
    - **Business Name**: ${businessName ?? 'Generic Brand'}
    - **Business Type**: ${businessType ?? 'General'}
    - **Description**: ${businessDescription ?? ''}
    - **Target Mood**: $mood

    **Critical Instructions**:
    1.  **VISUALS FIRST**: Describe the *visual elements*, *background*, *lighting*, *textures*, and *composition*.
    2.  **BRAND ALIGNMENT**: Ensure the image connects with the business type ($businessType). If it's a restaurant, make it appetizing. If fashion, make it stylish.
    3.  **NO TEXT**: Do NOT ask for text to be written on the image. AI cannot write text well. Instead, describe a *clean layout* or *negative space* where text could be added later.
    4.  **QUALITY BOOSTERS**: Always include keywords like: "masterpiece, best quality, 8k, ultra-detailed, professional photography, cinematic lighting, sharp focus, hdr".
    5.  **STYLE ADAPTATION**:
        - If mood is 'Minimalis': Focus on clean lines, solid colors, negative space, soft shadows.
        - If mood is 'Playful': Use vibrant colors, soft shapes, high saturation, digital art style.
        - If mood is 'Elegan': Use dark tones, gold accents, dramatic lighting, luxury textures, marble, silk.
    6.  **OUTPUT**: Return ONLY the final English prompt string.
    """;

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": systemInstruction}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          final text = data['candidates'][0]['content']['parts'][0]['text'];
          return text.trim();
        }
      }
      print('Gemini Error: ${response.statusCode} - ${response.body}');
      return "$purpose. $originalPrompt. $mood style."; // Fallback
    } catch (e) {
      print('Gemini Exception: $e');
      return "$purpose. $originalPrompt. $mood style."; // Fallback
    }
  }
}

final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService();
});
