# package_info_plus_ohos

[![pub package](https://img.shields.io/pub/v/package_info_plus_ohos.svg)](https://pub.dev/packages/package_info_plus_ohos)
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

HarmonyOS NEXT implementation of Flutter's [package_info_plus](https://pub.dev/packages/package_info_plus) plugin.

## Features

- ✅ Query application name
- ✅ Query package name (bundle name)
- ✅ Query version name
- ✅ Query version code (build number)
- ⚠️ Build signature (not supported, returns empty string)
- ⚠️ Installer store (not supported, returns null)
- ⚠️ Install/update time (not supported, returns null)

## Requirements

- HarmonyOS NEXT (API 12+)
- Flutter for HarmonyOS (3.24.0+)
- DevEco Studio 5.0+

## Installation

```yaml
dependencies:
  package_info_plus: ^10.0.0
  package_info_plus_ohos:
    git:
      url: https://github.com/ramonouyang/package_info_plus_ohos.git
      ref: main
```

## Usage

The plugin implements `PackageInfoPlatform`, so it works transparently with the `package_info_plus` API:

```dart
import 'package:package_info_plus/package_info_plus.dart';

// Get package information
PackageInfo packageInfo = await PackageInfo.fromPlatform();

String appName = packageInfo.appName;
String packageName = packageInfo.packageName;
String version = packageInfo.version;
String buildNumber = packageInfo.buildNumber;
```

## Architecture

```
package_info_plus_ohos/
├── lib/
│   └── package_info_plus_ohos.dart              # Dart implementation
├── ohos/
│   └── src/main/ets/components/plugin/
│       └── PackageInfoPlusOhosPlugin.ets         # ArkTS native layer
└── example/
    └── lib/main.dart                             # Example app
```

### HarmonyOS API Mapping

| Field | HarmonyOS API | Notes |
|-------|---------------|-------|
| appName | `BundleInfo.appInfo.label` | Application display name |
| packageName | `BundleInfo.bundleName` | Application bundle name |
| version | `BundleInfo.versionName` | Version string (e.g., "1.0.1") |
| buildNumber | `BundleInfo.versionCode` | Integer converted to string |
| buildSignature | — | Not supported, returns empty string |
| installerStore | — | Not supported, returns null |
| installTime | — | Not supported, returns null |
| updateTime | — | Not supported, returns null |

## Platform-Specific Notes

### Unsupported Fields

The following fields are not supported on HarmonyOS NEXT and will return default values:

- **buildSignature**: Returns empty string. HarmonyOS does not expose app signature information through public APIs.
- **installerStore**: Returns null. HarmonyOS does not provide installer information through public APIs.
- **installTime / updateTime**: Returns null. These timestamps are not available through public APIs.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.
