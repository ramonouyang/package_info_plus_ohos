import 'package:flutter/services.dart';
import 'package:package_info_plus_platform_interface/package_info_data.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';

/// HarmonyOS NEXT implementation of [PackageInfoPlatform].
///
/// This plugin provides access to app package information on HarmonyOS NEXT,
/// including app name, package name, version, and build number.
class PackageInfoPlusOhos extends PackageInfoPlatform {
  /// Method channel for communication with the native layer.
  static const MethodChannel _channel =
      MethodChannel('dev.fluttercommunity.plus/package_info');

  /// Registers this class as the default instance of [PackageInfoPlatform].
  static void registerWith() {
    PackageInfoPlatform.instance = PackageInfoPlusOhos();
  }

  @override
  Future<PackageInfoData> getAll({String? baseUrl}) async {
    final Map<dynamic, dynamic>? map =
        await _channel.invokeMapMethod<dynamic, dynamic>('getAll');

    return PackageInfoData(
      appName: map?['appName'] ?? '',
      packageName: map?['packageName'] ?? '',
      version: map?['version'] ?? '',
      buildNumber: map?['buildNumber'] ?? '',
      buildSignature: map?['buildSignature'] ?? '',
      installerStore: map?['installerStore'] as String?,
    );
  }
}
