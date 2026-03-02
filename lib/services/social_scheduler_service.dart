import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/content_item.dart';

abstract class SocialSchedulerService {
  Future<void> schedulePost(ContentItem item, DateTime time);
}

class StubSocialSchedulerService implements SocialSchedulerService {
  @override
  Future<void> schedulePost(ContentItem item, DateTime time) async {
    // Stub: Save schedule to Firestore 'schedules' collection
    // and potentially trigger a Cloud Function or Cron Job.
    await Future.delayed(const Duration(seconds: 1));
    print('Scheduled ${item.title} for $time');
  }
}

final socialSchedulerServiceProvider = Provider<SocialSchedulerService>((ref) {
  return StubSocialSchedulerService();
});
