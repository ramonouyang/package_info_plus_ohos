import { bundleManager } from '@kit.AbilityKit';
import { FlutterPlugin, FlutterMethodCall, FlutterMethodResult } from '@ohos/flutter';

/**
 * HarmonyOS NEXT implementation of package_info_plus plugin.
 * 
 * Provides app package information using @ohos.bundle.bundleManager API.
 * 
 * Supported fields:
 * - appName: Application display name
 * - packageName: Application bundle name
 * - version: Version name (e.g., "1.0.1")
 * - buildNumber: Version code as string (e.g., "2")
 * - buildSignature: Empty string (not supported)
 * - installerStore: null (not supported)
 * - installTime: null (not supported)
 * - updateTime: null (not supported)
 */
export default class PackageInfoPlusOhosPlugin implements FlutterPlugin {
  private static readonly CHANNEL_NAME = 'dev.fluttercommunity.plus/package_info';

  /**
   * Registers the plugin with the Flutter engine.
   */
  static registerWith(registry: any): void {
    const channel = registry.messenger(PackageInfoPlusOhosPlugin.CHANNEL_NAME);
    const instance = new PackageInfoPlusOhosPlugin();
    channel.setMethodCallHandler(instance.handleMethodCall.bind(instance));
  }

  /**
   * Handles method calls from the Dart side.
   */
  private handleMethodCall(call: FlutterMethodCall, result: FlutterMethodResult): void {
    switch (call.method) {
      case 'getAll':
        this.handleGetAll(result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  /**
   * Retrieves all package information.
   * 
   * Uses bundleManager.getBundleInfoForSelfSync() to get current app info.
   */
  private handleGetAll(result: FlutterMethodResult): void {
    try {
      const bundleInfo = bundleManager.getBundleInfoForSelfSync();
      const appInfo = bundleInfo.appInfo;

      const packageInfo: Record<string, Object | null> = {
        appName: appInfo?.label ?? '',
        packageName: bundleInfo.bundleName ?? '',
        version: bundleInfo.versionName ?? '',
        buildNumber: bundleInfo.versionCode?.toString() ?? '0',
        buildSignature: '', // Not supported on HarmonyOS NEXT
        installerStore: null, // Not supported
        installTime: null, // Not supported
        updateTime: null, // Not supported
      };

      result.success(packageInfo);
    } catch (error) {
      result.error('PACKAGE_INFO_ERROR', 'Failed to get package info', error?.toString() ?? 'Unknown error');
    }
  }
}
