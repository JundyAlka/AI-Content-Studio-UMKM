// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnalyticsData _$AnalyticsDataFromJson(Map<String, dynamic> json) =>
    _AnalyticsData(
      totalReach: (json['totalReach'] as num).toInt(),
      totalEngagement: (json['totalEngagement'] as num).toInt(),
      engagementRate: (json['engagementRate'] as num).toDouble(),
      dailyMetrics: (json['dailyMetrics'] as List<dynamic>)
          .map((e) => EngagementMetric.fromJson(e as Map<String, dynamic>))
          .toList(),
      platformDistribution: (json['platformDistribution'] as List<dynamic>)
          .map((e) => PlatformDistribution.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AnalyticsDataToJson(_AnalyticsData instance) =>
    <String, dynamic>{
      'totalReach': instance.totalReach,
      'totalEngagement': instance.totalEngagement,
      'engagementRate': instance.engagementRate,
      'dailyMetrics': instance.dailyMetrics,
      'platformDistribution': instance.platformDistribution,
    };

_EngagementMetric _$EngagementMetricFromJson(Map<String, dynamic> json) =>
    _EngagementMetric(
      date: DateTime.parse(json['date'] as String),
      views: (json['views'] as num).toInt(),
      interactions: (json['interactions'] as num).toInt(),
    );

Map<String, dynamic> _$EngagementMetricToJson(_EngagementMetric instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'views': instance.views,
      'interactions': instance.interactions,
    };

_PlatformDistribution _$PlatformDistributionFromJson(
        Map<String, dynamic> json) =>
    _PlatformDistribution(
      platform: json['platform'] as String,
      percentage: (json['percentage'] as num).toDouble(),
      colorValue: (json['colorValue'] as num).toInt(),
    );

Map<String, dynamic> _$PlatformDistributionToJson(
        _PlatformDistribution instance) =>
    <String, dynamic>{
      'platform': instance.platform,
      'percentage': instance.percentage,
      'colorValue': instance.colorValue,
    };
