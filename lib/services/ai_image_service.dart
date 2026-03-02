import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';

abstract class AiImageService {
  Future<String> generateImage({
    required UserProfile userProfile,
    required String type,
    required String purpose,
    required String prompt,
    required String mood,
  });
}

class StubAiImageService implements AiImageService {
  @override
  Future<String> generateImage({
    required UserProfile userProfile,
    required String type,
    required String purpose,
    required String prompt,
    required String mood,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 3));
    
    // Return a random placeholder image
    // In a real app, this would be the URL from DALL-E or Stable Diffusion
    return 'https://picsum.photos/seed/${DateTime.now().millisecondsSinceEpoch}/512/512';
  }
}

final aiImageServiceProvider = Provider<AiImageService>((ref) {
  return StubAiImageService();
});
