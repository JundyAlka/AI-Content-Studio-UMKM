import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/analytics_data.dart';

part 'analytics_service.g.dart';

@riverpod
class AnalyticsService extends _$AnalyticsService {
  @override
  FutureOr<AnalyticsData> build() async {
    // In a real app, this would fetch from Firestore or Social Media APIs
    // For now, we simulate a delay and return mock data
    await Future.delayed(const Duration(seconds: 1));
    return AnalyticsData.mock();
  }

  Future<void> refreshAnalytics() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(milliseconds: 800));
      return AnalyticsData.mock();
    });
  }
}

@riverpod
Stream<AnalyticsData> analyticsStream(Ref ref) {
  // Simulate real-time updates every 10 seconds
  return Stream.periodic(const Duration(seconds: 10), (_) {
    final base = AnalyticsData.mock();
    // Slightly randomize for "real-time" feel
    return base.copyWith(
      totalReach: base.totalReach + (5 * (1 + (DateTime.now().second % 10))),
      totalEngagement: base.totalEngagement + (DateTime.now().second % 5),
    );
  });
}
