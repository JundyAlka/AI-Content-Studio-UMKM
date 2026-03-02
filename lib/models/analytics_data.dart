import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_data.freezed.dart';
part 'analytics_data.g.dart';

@freezed
abstract class AnalyticsData with _$AnalyticsData {
  const factory AnalyticsData({
    required int totalReach,
    required int totalEngagement,
    required double engagementRate,
    required List<EngagementMetric> dailyMetrics,
    required List<PlatformDistribution> platformDistribution,
  }) = _AnalyticsData;

  factory AnalyticsData.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsDataFromJson(json);

  factory AnalyticsData.mock() => AnalyticsData(
        totalReach: 12540,
        totalEngagement: 842,
        engagementRate: 6.7,
        dailyMetrics: [
          EngagementMetric(
              date: DateTime.now().subtract(const Duration(days: 6)),
              views: 1200,
              interactions: 80),
          EngagementMetric(
              date: DateTime.now().subtract(const Duration(days: 5)),
              views: 1500,
              interactions: 110),
          EngagementMetric(
              date: DateTime.now().subtract(const Duration(days: 4)),
              views: 1100,
              interactions: 75),
          EngagementMetric(
              date: DateTime.now().subtract(const Duration(days: 3)),
              views: 2400,
              interactions: 190),
          EngagementMetric(
              date: DateTime.now().subtract(const Duration(days: 2)),
              views: 1800,
              interactions: 140),
          EngagementMetric(
              date: DateTime.now().subtract(const Duration(days: 1)),
              views: 2100,
              interactions: 165),
          EngagementMetric(date: DateTime.now(), views: 2440, interactions: 82),
        ],
        platformDistribution: [
          const PlatformDistribution(
              platform: 'Instagram', percentage: 0.55, colorValue: 0xFFE1306C),
          const PlatformDistribution(
              platform: 'WhatsApp', percentage: 0.30, colorValue: 0xFF25D366),
          const PlatformDistribution(
              platform: 'TikTok', percentage: 0.15, colorValue: 0xFF000000),
        ],
      );
}

@freezed
abstract class EngagementMetric with _$EngagementMetric {
  const factory EngagementMetric({
    required DateTime date,
    required int views,
    required int interactions,
  }) = _EngagementMetric;

  factory EngagementMetric.fromJson(Map<String, dynamic> json) =>
      _$EngagementMetricFromJson(json);
}

@freezed
abstract class PlatformDistribution with _$PlatformDistribution {
  const factory PlatformDistribution({
    required String platform,
    required double percentage,
    required int colorValue,
  }) = _PlatformDistribution;

  factory PlatformDistribution.fromJson(Map<String, dynamic> json) =>
      _$PlatformDistributionFromJson(json);
}
