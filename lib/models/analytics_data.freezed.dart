// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnalyticsData {
  int get totalReach;
  int get totalEngagement;
  double get engagementRate;
  List<EngagementMetric> get dailyMetrics;
  List<PlatformDistribution> get platformDistribution;

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AnalyticsDataCopyWith<AnalyticsData> get copyWith =>
      _$AnalyticsDataCopyWithImpl<AnalyticsData>(
          this as AnalyticsData, _$identity);

  /// Serializes this AnalyticsData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AnalyticsData &&
            (identical(other.totalReach, totalReach) ||
                other.totalReach == totalReach) &&
            (identical(other.totalEngagement, totalEngagement) ||
                other.totalEngagement == totalEngagement) &&
            (identical(other.engagementRate, engagementRate) ||
                other.engagementRate == engagementRate) &&
            const DeepCollectionEquality()
                .equals(other.dailyMetrics, dailyMetrics) &&
            const DeepCollectionEquality()
                .equals(other.platformDistribution, platformDistribution));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalReach,
      totalEngagement,
      engagementRate,
      const DeepCollectionEquality().hash(dailyMetrics),
      const DeepCollectionEquality().hash(platformDistribution));

  @override
  String toString() {
    return 'AnalyticsData(totalReach: $totalReach, totalEngagement: $totalEngagement, engagementRate: $engagementRate, dailyMetrics: $dailyMetrics, platformDistribution: $platformDistribution)';
  }
}

/// @nodoc
abstract mixin class $AnalyticsDataCopyWith<$Res> {
  factory $AnalyticsDataCopyWith(
          AnalyticsData value, $Res Function(AnalyticsData) _then) =
      _$AnalyticsDataCopyWithImpl;
  @useResult
  $Res call(
      {int totalReach,
      int totalEngagement,
      double engagementRate,
      List<EngagementMetric> dailyMetrics,
      List<PlatformDistribution> platformDistribution});
}

/// @nodoc
class _$AnalyticsDataCopyWithImpl<$Res>
    implements $AnalyticsDataCopyWith<$Res> {
  _$AnalyticsDataCopyWithImpl(this._self, this._then);

  final AnalyticsData _self;
  final $Res Function(AnalyticsData) _then;

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalReach = null,
    Object? totalEngagement = null,
    Object? engagementRate = null,
    Object? dailyMetrics = null,
    Object? platformDistribution = null,
  }) {
    return _then(_self.copyWith(
      totalReach: null == totalReach
          ? _self.totalReach
          : totalReach // ignore: cast_nullable_to_non_nullable
              as int,
      totalEngagement: null == totalEngagement
          ? _self.totalEngagement
          : totalEngagement // ignore: cast_nullable_to_non_nullable
              as int,
      engagementRate: null == engagementRate
          ? _self.engagementRate
          : engagementRate // ignore: cast_nullable_to_non_nullable
              as double,
      dailyMetrics: null == dailyMetrics
          ? _self.dailyMetrics
          : dailyMetrics // ignore: cast_nullable_to_non_nullable
              as List<EngagementMetric>,
      platformDistribution: null == platformDistribution
          ? _self.platformDistribution
          : platformDistribution // ignore: cast_nullable_to_non_nullable
              as List<PlatformDistribution>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _AnalyticsData implements AnalyticsData {
  const _AnalyticsData(
      {required this.totalReach,
      required this.totalEngagement,
      required this.engagementRate,
      required final List<EngagementMetric> dailyMetrics,
      required final List<PlatformDistribution> platformDistribution})
      : _dailyMetrics = dailyMetrics,
        _platformDistribution = platformDistribution;
  factory _AnalyticsData.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsDataFromJson(json);

  @override
  final int totalReach;
  @override
  final int totalEngagement;
  @override
  final double engagementRate;
  final List<EngagementMetric> _dailyMetrics;
  @override
  List<EngagementMetric> get dailyMetrics {
    if (_dailyMetrics is EqualUnmodifiableListView) return _dailyMetrics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailyMetrics);
  }

  final List<PlatformDistribution> _platformDistribution;
  @override
  List<PlatformDistribution> get platformDistribution {
    if (_platformDistribution is EqualUnmodifiableListView)
      return _platformDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_platformDistribution);
  }

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AnalyticsDataCopyWith<_AnalyticsData> get copyWith =>
      __$AnalyticsDataCopyWithImpl<_AnalyticsData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AnalyticsDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AnalyticsData &&
            (identical(other.totalReach, totalReach) ||
                other.totalReach == totalReach) &&
            (identical(other.totalEngagement, totalEngagement) ||
                other.totalEngagement == totalEngagement) &&
            (identical(other.engagementRate, engagementRate) ||
                other.engagementRate == engagementRate) &&
            const DeepCollectionEquality()
                .equals(other._dailyMetrics, _dailyMetrics) &&
            const DeepCollectionEquality()
                .equals(other._platformDistribution, _platformDistribution));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalReach,
      totalEngagement,
      engagementRate,
      const DeepCollectionEquality().hash(_dailyMetrics),
      const DeepCollectionEquality().hash(_platformDistribution));

  @override
  String toString() {
    return 'AnalyticsData(totalReach: $totalReach, totalEngagement: $totalEngagement, engagementRate: $engagementRate, dailyMetrics: $dailyMetrics, platformDistribution: $platformDistribution)';
  }
}

/// @nodoc
abstract mixin class _$AnalyticsDataCopyWith<$Res>
    implements $AnalyticsDataCopyWith<$Res> {
  factory _$AnalyticsDataCopyWith(
          _AnalyticsData value, $Res Function(_AnalyticsData) _then) =
      __$AnalyticsDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int totalReach,
      int totalEngagement,
      double engagementRate,
      List<EngagementMetric> dailyMetrics,
      List<PlatformDistribution> platformDistribution});
}

/// @nodoc
class __$AnalyticsDataCopyWithImpl<$Res>
    implements _$AnalyticsDataCopyWith<$Res> {
  __$AnalyticsDataCopyWithImpl(this._self, this._then);

  final _AnalyticsData _self;
  final $Res Function(_AnalyticsData) _then;

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? totalReach = null,
    Object? totalEngagement = null,
    Object? engagementRate = null,
    Object? dailyMetrics = null,
    Object? platformDistribution = null,
  }) {
    return _then(_AnalyticsData(
      totalReach: null == totalReach
          ? _self.totalReach
          : totalReach // ignore: cast_nullable_to_non_nullable
              as int,
      totalEngagement: null == totalEngagement
          ? _self.totalEngagement
          : totalEngagement // ignore: cast_nullable_to_non_nullable
              as int,
      engagementRate: null == engagementRate
          ? _self.engagementRate
          : engagementRate // ignore: cast_nullable_to_non_nullable
              as double,
      dailyMetrics: null == dailyMetrics
          ? _self._dailyMetrics
          : dailyMetrics // ignore: cast_nullable_to_non_nullable
              as List<EngagementMetric>,
      platformDistribution: null == platformDistribution
          ? _self._platformDistribution
          : platformDistribution // ignore: cast_nullable_to_non_nullable
              as List<PlatformDistribution>,
    ));
  }
}

/// @nodoc
mixin _$EngagementMetric {
  DateTime get date;
  int get views;
  int get interactions;

  /// Create a copy of EngagementMetric
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EngagementMetricCopyWith<EngagementMetric> get copyWith =>
      _$EngagementMetricCopyWithImpl<EngagementMetric>(
          this as EngagementMetric, _$identity);

  /// Serializes this EngagementMetric to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EngagementMetric &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.views, views) || other.views == views) &&
            (identical(other.interactions, interactions) ||
                other.interactions == interactions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, views, interactions);

  @override
  String toString() {
    return 'EngagementMetric(date: $date, views: $views, interactions: $interactions)';
  }
}

/// @nodoc
abstract mixin class $EngagementMetricCopyWith<$Res> {
  factory $EngagementMetricCopyWith(
          EngagementMetric value, $Res Function(EngagementMetric) _then) =
      _$EngagementMetricCopyWithImpl;
  @useResult
  $Res call({DateTime date, int views, int interactions});
}

/// @nodoc
class _$EngagementMetricCopyWithImpl<$Res>
    implements $EngagementMetricCopyWith<$Res> {
  _$EngagementMetricCopyWithImpl(this._self, this._then);

  final EngagementMetric _self;
  final $Res Function(EngagementMetric) _then;

  /// Create a copy of EngagementMetric
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? views = null,
    Object? interactions = null,
  }) {
    return _then(_self.copyWith(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      views: null == views
          ? _self.views
          : views // ignore: cast_nullable_to_non_nullable
              as int,
      interactions: null == interactions
          ? _self.interactions
          : interactions // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _EngagementMetric implements EngagementMetric {
  const _EngagementMetric(
      {required this.date, required this.views, required this.interactions});
  factory _EngagementMetric.fromJson(Map<String, dynamic> json) =>
      _$EngagementMetricFromJson(json);

  @override
  final DateTime date;
  @override
  final int views;
  @override
  final int interactions;

  /// Create a copy of EngagementMetric
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EngagementMetricCopyWith<_EngagementMetric> get copyWith =>
      __$EngagementMetricCopyWithImpl<_EngagementMetric>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$EngagementMetricToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EngagementMetric &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.views, views) || other.views == views) &&
            (identical(other.interactions, interactions) ||
                other.interactions == interactions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, views, interactions);

  @override
  String toString() {
    return 'EngagementMetric(date: $date, views: $views, interactions: $interactions)';
  }
}

/// @nodoc
abstract mixin class _$EngagementMetricCopyWith<$Res>
    implements $EngagementMetricCopyWith<$Res> {
  factory _$EngagementMetricCopyWith(
          _EngagementMetric value, $Res Function(_EngagementMetric) _then) =
      __$EngagementMetricCopyWithImpl;
  @override
  @useResult
  $Res call({DateTime date, int views, int interactions});
}

/// @nodoc
class __$EngagementMetricCopyWithImpl<$Res>
    implements _$EngagementMetricCopyWith<$Res> {
  __$EngagementMetricCopyWithImpl(this._self, this._then);

  final _EngagementMetric _self;
  final $Res Function(_EngagementMetric) _then;

  /// Create a copy of EngagementMetric
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? date = null,
    Object? views = null,
    Object? interactions = null,
  }) {
    return _then(_EngagementMetric(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      views: null == views
          ? _self.views
          : views // ignore: cast_nullable_to_non_nullable
              as int,
      interactions: null == interactions
          ? _self.interactions
          : interactions // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$PlatformDistribution {
  String get platform;
  double get percentage;
  int get colorValue;

  /// Create a copy of PlatformDistribution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PlatformDistributionCopyWith<PlatformDistribution> get copyWith =>
      _$PlatformDistributionCopyWithImpl<PlatformDistribution>(
          this as PlatformDistribution, _$identity);

  /// Serializes this PlatformDistribution to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PlatformDistribution &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage) &&
            (identical(other.colorValue, colorValue) ||
                other.colorValue == colorValue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, platform, percentage, colorValue);

  @override
  String toString() {
    return 'PlatformDistribution(platform: $platform, percentage: $percentage, colorValue: $colorValue)';
  }
}

/// @nodoc
abstract mixin class $PlatformDistributionCopyWith<$Res> {
  factory $PlatformDistributionCopyWith(PlatformDistribution value,
          $Res Function(PlatformDistribution) _then) =
      _$PlatformDistributionCopyWithImpl;
  @useResult
  $Res call({String platform, double percentage, int colorValue});
}

/// @nodoc
class _$PlatformDistributionCopyWithImpl<$Res>
    implements $PlatformDistributionCopyWith<$Res> {
  _$PlatformDistributionCopyWithImpl(this._self, this._then);

  final PlatformDistribution _self;
  final $Res Function(PlatformDistribution) _then;

  /// Create a copy of PlatformDistribution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? platform = null,
    Object? percentage = null,
    Object? colorValue = null,
  }) {
    return _then(_self.copyWith(
      platform: null == platform
          ? _self.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
      percentage: null == percentage
          ? _self.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      colorValue: null == colorValue
          ? _self.colorValue
          : colorValue // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _PlatformDistribution implements PlatformDistribution {
  const _PlatformDistribution(
      {required this.platform,
      required this.percentage,
      required this.colorValue});
  factory _PlatformDistribution.fromJson(Map<String, dynamic> json) =>
      _$PlatformDistributionFromJson(json);

  @override
  final String platform;
  @override
  final double percentage;
  @override
  final int colorValue;

  /// Create a copy of PlatformDistribution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PlatformDistributionCopyWith<_PlatformDistribution> get copyWith =>
      __$PlatformDistributionCopyWithImpl<_PlatformDistribution>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PlatformDistributionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PlatformDistribution &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage) &&
            (identical(other.colorValue, colorValue) ||
                other.colorValue == colorValue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, platform, percentage, colorValue);

  @override
  String toString() {
    return 'PlatformDistribution(platform: $platform, percentage: $percentage, colorValue: $colorValue)';
  }
}

/// @nodoc
abstract mixin class _$PlatformDistributionCopyWith<$Res>
    implements $PlatformDistributionCopyWith<$Res> {
  factory _$PlatformDistributionCopyWith(_PlatformDistribution value,
          $Res Function(_PlatformDistribution) _then) =
      __$PlatformDistributionCopyWithImpl;
  @override
  @useResult
  $Res call({String platform, double percentage, int colorValue});
}

/// @nodoc
class __$PlatformDistributionCopyWithImpl<$Res>
    implements _$PlatformDistributionCopyWith<$Res> {
  __$PlatformDistributionCopyWithImpl(this._self, this._then);

  final _PlatformDistribution _self;
  final $Res Function(_PlatformDistribution) _then;

  /// Create a copy of PlatformDistribution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? platform = null,
    Object? percentage = null,
    Object? colorValue = null,
  }) {
    return _then(_PlatformDistribution(
      platform: null == platform
          ? _self.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
      percentage: null == percentage
          ? _self.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      colorValue: null == colorValue
          ? _self.colorValue
          : colorValue // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
