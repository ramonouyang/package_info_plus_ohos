import {
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
} from '@ohos/flutter_ohos';
import bundleManager from '@ohos.bundle.bundleManager';

const TAG = 'PackageInfoPlusOhos';
const CHANNEL_NAME = 'dev.fluttercommunity.plus/package_info';

/**
 * HarmonyOS NEXT implementation of package_info_plus plugin.
 * 
 * Provides app package information using @ohos.bundle.bundleManager API.
 */
export default class PackageInfoPlusOhosPlugin
  implements FlutterPlugin, MethodCallHandler {
  private channel: MethodChannel | null = null;

  static registerWith(registrar: FlutterPluginBinding): void {
    const instance = new PackageInfoPlusOhosPlugin();
    const channel = new MethodChannel(
      CHANNEL_NAME,
      registrar.getMessenger()
    );
    channel.setMethodCallHandler(instance);
    instance.channel = channel;
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
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
   */
  private handleGetAll(result: MethodResult): void {
    try {
      const bundleInfo = bundleManager.getBundleInfoForSelfSync();
      const appInfo = bundleInfo.appInfo;

      const packageInfo: Record<string, Object | null> = {
        appName: appInfo?.label ?? '',
        packageName: bundleInfo.bundleName ?? '',
        version: bundleInfo.versionName ?? '',
        buildNumber: bundleInfo.versionCode?.toString() ?? '0',
        buildSignature: '',
        installerStore: null,
        installTime: null,
        updateTime: null,
      };

      result.success(packageInfo);
    } catch (error) {
      result.error(
        'PACKAGE_INFO_ERROR',
        'Failed to get package info',
        error?.toString() ?? 'Unknown error'
      );
    }
  }
}
