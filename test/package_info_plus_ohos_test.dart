import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';
import 'package:package_info_plus_ohos/package_info_plus_ohos.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel =
      MethodChannel('dev.fluttercommunity.plus/package_info');

  final List<MethodCall> log = <MethodCall>[];

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      log.add(methodCall);
      switch (methodCall.method) {
        case 'getAll':
          return <String, dynamic>{
            'appName': 'MediPulse',
            'packageName': 'com.medipulse.medipulse',
            'version': '1.0.1',
            'buildNumber': '2',
            'buildSignature': '',
            'installerStore': null,
          };
        default:
          return null;
      }
    });
  });

  tearDown(() {
    log.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('PackageInfoPlusOhos', () {
    test('registerWith sets the platform instance', () {
      PackageInfoPlusOhos.registerWith();
      expect(PackageInfoPlatform.instance, isA<PackageInfoPlusOhos>());
    });

    test('getAll returns correct package info', () async {
      final plugin = PackageInfoPlusOhos();
      final result = await plugin.getAll();

      expect(result.appName, 'MediPulse');
      expect(result.packageName, 'com.medipulse.medipulse');
      expect(result.version, '1.0.1');
      expect(result.buildNumber, '2');
      expect(result.buildSignature, '');
      expect(result.installerStore, isNull);
    });

    test('getAll invokes correct method channel', () async {
      final plugin = PackageInfoPlusOhos();
      await plugin.getAll();

      expect(log, hasLength(1));
      expect(log.first.method, 'getAll');
    });

    test('getAll handles null values gracefully', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        return <String, dynamic>{
          'appName': null,
          'packageName': null,
          'version': null,
          'buildNumber': null,
        };
      });

      final plugin = PackageInfoPlusOhos();
      final result = await plugin.getAll();

      expect(result.appName, '');
      expect(result.packageName, '');
      expect(result.version, '');
      expect(result.buildNumber, '');
    });

    test('getAll handles installerStore value', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        return <String, dynamic>{
          'appName': 'Test',
          'packageName': 'com.test',
          'version': '1.0.0',
          'buildNumber': '1',
          'installerStore': 'com.huawei.appmarket',
        };
      });

      final plugin = PackageInfoPlusOhos();
      final result = await plugin.getAll();

      expect(result.installerStore, 'com.huawei.appmarket');
    });
  });
}
