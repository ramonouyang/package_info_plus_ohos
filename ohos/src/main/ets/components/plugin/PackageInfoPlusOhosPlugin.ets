import {
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
} from '@ohos/flutter_ohos';
import bundleManager from '@ohos.bundle.bundleManager';
import hilog from '@ohos.hilog';

const TAG = 'PackageInfoPlusOhos';
const CHANNEL_NAME = 'dev.fluttercommunity.plus/package_info';

/**
 * HarmonyOS NEXT implementation of package_info_plus plugin.
 * Uses @ohos.bundle.bundleManager API (API 26).
 *
 * BundleInfo properties (API 26):
 *   name, vendor, versionCode, versionName, minCompatibleVersionCode,
 *   targetVersion, appInfo, hapModulesInfo, installTime, updateTime
 */
export default class PackageInfoPlusOhosPlugin
  implements FlutterPlugin, MethodCallHandler {
  private channel: MethodChannel | null = null;

  getUniqueClassName(): string {
    return 'PackageInfoPlusOhosPlugin';
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), CHANNEL_NAME);
    this.channel.setMethodCallHandler(this);
    hilog.info(0x0001, TAG, 'Attached to engine');
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null);
      this.channel = null;
    }
    hilog.info(0x0001, TAG, 'Detached from engine');
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

  private handleGetAll(result: MethodResult): void {
    try {
      const bundleInfo: bundleManager.BundleInfo =
        bundleManager.getBundleInfoForSelfSync(
          bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION
        );
      const appInfo = bundleInfo.appInfo;

      const packageInfo: Record<string, Object | null> = {
        appName: appInfo?.label ?? '',
        packageName: bundleInfo.name ?? '',
        version: bundleInfo.versionName ?? '',
        buildNumber: bundleInfo.versionCode?.toString() ?? '0',
        buildSignature: '',
        installerStore: null,
        installTime: bundleInfo.installTime ?? null,
        updateTime: bundleInfo.updateTime ?? null,
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
