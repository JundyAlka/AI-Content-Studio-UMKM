// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$analyticsStreamHash() => r'3de9c735d08258a946c0ee073c47546881e0cd8d';

/// See also [analyticsStream].
@ProviderFor(analyticsStream)
final analyticsStreamProvider =
    AutoDisposeStreamProvider<AnalyticsData>.internal(
  analyticsStream,
  name: r'analyticsStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$analyticsStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AnalyticsStreamRef = AutoDisposeStreamProviderRef<AnalyticsData>;
String _$analyticsServiceHash() => r'543733994fd3a38016b400048af67b853d479a94';

/// See also [AnalyticsService].
@ProviderFor(AnalyticsService)
final analyticsServiceProvider =
    AutoDisposeAsyncNotifierProvider<AnalyticsService, AnalyticsData>.internal(
  AnalyticsService.new,
  name: r'analyticsServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$analyticsServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AnalyticsService = AutoDisposeAsyncNotifier<AnalyticsData>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
