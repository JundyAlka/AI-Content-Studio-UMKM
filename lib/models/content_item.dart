enum ContentType { text, image, mixed }
enum ContentPlatform { instagramFeed, instagramStory, tiktok, facebook, whatsapp, unknown }

class ContentItem {
  final String id;
  final String title;
  final String body; // Caption or Text
  final String? imageUrl;
  final ContentType type;
  final ContentPlatform platform;
  final DateTime createdAt;
  final bool isScheduled;
  final DateTime? scheduledTime;

  ContentItem({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    required this.type,
    required this.platform,
    required this.createdAt,
    this.isScheduled = false,
    this.scheduledTime,
  });

  factory ContentItem.demo(String i) {
    // Restaurant99 Theme Mock Data
    // Extract number from string like "demo-1" or just "1"
    int index = 0;
    final RegExp digitRegex = RegExp(r'\d+');
    final match = digitRegex.firstMatch(i);
    if (match != null) {
      index = int.parse(match.group(0)!);
    }
    
    // Define specific demo items for Restaurant99
    switch (index % 5) { // Recycle every 5 items
      case 0:
        return ContentItem(
          id: 'id-$i',
          title: 'Promo Spesial Ayam Geprek!',
          body: 'Nikmati pedasnya Ayam Geprek Restaurant99 dengan diskon 20% khusus hari ini! 🔥🍗 #AyamGeprek #PedasNikmat #Restaurant99',
          type: ContentType.image,
          platform: ContentPlatform.instagramFeed,
          createdAt: DateTime.now().subtract(Duration(hours: 2)),
          imageUrl: 'assets/images/ayam_geprek.png', 
        );
      case 1:
        return ContentItem(
          id: 'id-$i',
          title: 'Nasi Goreng Spesial + Telur',
          body: 'Sarapan kenyang dengan Nasi Goreng Spesial kami. Topping melimpah, rasa autentik! 🍳🍚',
          type: ContentType.image,
          platform: ContentPlatform.instagramStory,
          createdAt: DateTime.now().subtract(Duration(days: 1)),
          imageUrl: 'assets/images/nasi_goreng.png',
        );
      case 2:
        return ContentItem(
          id: 'id-$i',
          title: 'Es Teler Segar 🥑🥥',
          body: 'Cuaca panas? Segarkan harimu dengan Es Teler khas Restaurant99. Manis, dingin, dan bikin nagih!',
          type: ContentType.image,
          platform: ContentPlatform.tiktok,
          createdAt: DateTime.now().subtract(Duration(days: 2)),
          imageUrl: 'assets/images/es_teler.png',
        );
      case 3:
        return ContentItem(
          id: 'id-$i',
          title: 'Jadwal Buka Puasa Bersama',
          body: 'Booking tempat untuk Bukber sekarang sebelum penuh! Paket mulai 50rb/pax.',
          type: ContentType.image,
          platform: ContentPlatform.whatsapp,
          createdAt: DateTime.now().subtract(Duration(days: 3)),
          imageUrl: 'assets/images/thumb_food_special.png', // Paket Lengkap / Feast
        );
       case 4:
        return ContentItem(
          id: 'id-$i',
          title: 'Review: Kopi Gula Aren',
          body: '"Rasanya pas, tidak terlalu manis. Cocok buat nemenin kerja!" - Kak Andi',
          type: ContentType.image,
          platform: ContentPlatform.instagramStory,
          createdAt: DateTime.now().subtract(Duration(days: 4)),
          imageUrl: 'assets/images/mock_es_kopi.png', // Unique Coffee Image
        );
      default:
         return ContentItem(
          id: 'id-$i',
          title: 'Menu Baru Coming Soon',
          body: 'Tunggu kejutan menu baru dari kami minggu depan!',
          type: ContentType.text,
          platform: ContentPlatform.instagramFeed,
          createdAt: DateTime.now().subtract(Duration(days: 5)),
          imageUrl: null,
        );
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'imageUrl': imageUrl,
      'type': type.name,
      'platform': platform.name,
      'createdAt': createdAt.toIso8601String(),
      'isScheduled': isScheduled,
      'scheduledTime': scheduledTime?.toIso8601String(),
    };
  }

  factory ContentItem.fromMap(Map<String, dynamic> map, String docId) {
    return ContentItem(
      id: docId,
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      imageUrl: map['imageUrl'],
      type: ContentType.values.firstWhere((e) => e.name == map['type'], orElse: () => ContentType.text),
      platform: ContentPlatform.values.firstWhere((e) => e.name == map['platform'], orElse: () => ContentPlatform.unknown),
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      isScheduled: map['isScheduled'] ?? false,
      scheduledTime: map['scheduledTime'] != null ? DateTime.tryParse(map['scheduledTime']) : null,
    );
  }
}
