import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/content_item.dart';

abstract class SocialShareService {
  Future<void> shareContent(ContentItem item);
  Future<void> postToInstagram(ContentItem item); // Stub for future Graph API
  Future<void> postToFacebook(ContentItem item);
}

class StubSocialShareService implements SocialShareService {
  @override
  Future<void> shareContent(ContentItem item) async {
    // In real app, use share_plus: Share.share(item.body);
    await Future.delayed(const Duration(milliseconds: 500));
    print('Opening system share sheet for: ${item.title}');
  }

  @override
  Future<void> postToInstagram(ContentItem item) async {
    // Stub: Simulate API call to Instagram Graph API
    // Endpoint: POST https://graph.facebook.com/v19.0/{ig-user-id}/media
    // Params: image_url, caption, access_token
    await Future.delayed(const Duration(seconds: 2));
    print('Posted to Instagram: ${item.id}');
  }

  @override
  Future<void> postToFacebook(ContentItem item) async {
    await Future.delayed(const Duration(seconds: 2));
    print('Posted to Facebook: ${item.id}');
  }
}

final socialShareServiceProvider = Provider<SocialShareService>((ref) {
  return StubSocialShareService();
});
