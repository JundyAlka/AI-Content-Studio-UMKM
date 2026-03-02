import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../config/env.dart';
import '../models/user_profile.dart';

abstract class AiTextService {
  Future<List<String>> generateCaptions({
    required UserProfile userProfile,
    required String purpose,
    required String platform,
    required String productName,
    required String tone,
    required String length,
  });
}

class StubAiTextService implements AiTextService {
  @override
  Future<List<String>> generateCaptions({
    required UserProfile userProfile,
    required String purpose,
    required String platform,
    required String productName,
    required String tone,
    required String length,
  }) async {
    // Simulate API Delay
    await Future.delayed(const Duration(seconds: 2));

    // Simple Template-based generation for stub
    final captions = <String>[];
    
    // Variation 1
    captions.add(
      'Hai ${userProfile.targetAudience}! 👋\n\n'
      'Lagi cari $productName yang pas buat kamu? '
      'Kami punya solusinya! ${userProfile.businessName} hadir dengan kualitas terbaik.\n\n'
      '✨ Keunggulan: [Keunggulan Produk]\n'
      '🚀 Promo: $purpose\n\n'
      'Yuk, cek sekarang sebelum kehabisan! #$productName #$platform #UMKMIndonesia'
    );

    // Variation 2
    captions.add(
      'Spesial untuk kamu nih! 🎁\n\n'
      '$productName dari ${userProfile.businessName} emang beda. '
      'Cocok banget buat $purpose. \n\n'
      'Pesan sekarang di link bio ya! 👇'
    );

    // Variation 3 (Short)
    captions.add(
      '$purpose! $productName terbaik cuma di ${userProfile.businessName}. '
      'Jangan sampai nyesel kalau kehabisan. 🔥'
    );

    return captions;
  }
}

class GeminiAiTextService implements AiTextService {
  final String apiKey;


  GeminiAiTextService(this.apiKey);

  @override
  Future<List<String>> generateCaptions({
    required UserProfile userProfile,
    required String purpose,
    required String platform,
    required String productName,
    required String tone,
    required String length,
  }) async {
    if (apiKey.isEmpty) {
      throw Exception('Gemini API Key is missing');
    }

    final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );

    final prompt = '''
    Bertindaklah sebagai Content Creator Expert untuk UMKM.
    Buatlah 3 variasi caption untuk platform $platform.
    
    Profil Bisnis:
    - Nama: ${userProfile.businessName}
    - Tipe: ${userProfile.businessType}
    - Tone Brand: ${userProfile.brandTone}
    - Target Audiens: ${userProfile.targetAudience}
    
    Detail Konten:
    - Produk/Topik: $productName
    - Tujuan: $purpose
    - Tone Caption: $tone
    - Panjang: $length
    
    Format Output:
    Berikan HANYA 3 variasi caption yang dipisahkan dengan separator "---".
    JANGAN berikan teks pengantar apa pun. Langsung caption saja.
    Pastikan caption menarik, persuasive, dan menggunakan emoji yang pas.
    ''';

    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    if (response.text == null) {
      throw Exception('Gagal mendapatkan respon dari AI');
    }

    // Split result by separator "---"
    List<String> results = response.text!
        .split('---')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return results;
  }
}

// Provider
final aiTextServiceProvider = Provider<AiTextService>((ref) {
  // Use real service if key exists, otherwise stub
  if (Env.geminiApiKey.isNotEmpty) {
    return GeminiAiTextService(Env.geminiApiKey);
  }
  return StubAiTextService();
});
