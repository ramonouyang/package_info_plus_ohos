# package_info_plus_ohos 设计文档

## 1. 概述

`package_info_plus_ohos` 是 Flutter 插件 `package_info_plus` 的 HarmonyOS NEXT 平台实现。该插件提供应用包信息查询 API，包括应用名称、包名、版本号、构建号等。

## 2. 功能范围

### 2.1 支持的功能

| 功能 | 说明 | 优先级 |
|------|------|--------|
| 应用名称 | `appName` | P0 |
| 包名 | `packageName` | P0 |
| 版本号 | `version` (如 "1.0.1") | P0 |
| 构建号 | `buildNumber` (如 "2") | P0 |
| 构建签名 | `buildSignature` | P1 |
| 安装来源 | `installerStore` | P2 |
| 安装时间 | `installTime` | P2 |
| 更新时间 | `updateTime` | P2 |

### 2.2 不支持的功能

- 无（所有功能均可通过 HarmonyOS API 实现）

## 3. 架构设计

### 3.1 分层架构

```
┌─────────────────────────────────────┐
│  Flutter App (Dart)                 │
│  package_info_plus                  │
└──────────────┬──────────────────────┘
               │ MethodChannel
               │ "dev.fluttercommunity.plus/package_info"
               ▼
┌─────────────────────────────────────┐
│  Dart Plugin Layer                  │
│  PackageInfoPlusOhos                │
│  - implements PackageInfoPlatform   │
│  - getAll() → Map<String, dynamic>  │
└──────────────┬──────────────────────┘
               │ MethodChannel
               ▼
┌─────────────────────────────────────┐
│  ArkTS Native Layer                 │
│  PackageInfoPlusOhosPlugin.ets      │
│  - handleGetAll()                   │
│  - @ohos.bundle.bundleManager       │
└─────────────────────────────────────┘
```

### 3.2 目录结构

```
package_info_plus_ohos/
├── lib/
│   └── package_info_plus_ohos.dart           # Dart 实现
├── ohos/
│   ├── index.ets                              # 插件入口
│   ├── src/main/ets/components/plugin/
│   │   └── PackageInfoPlusOhosPlugin.ets     # ArkTS 原生层
│   └── src/main/module.json5                  # 模块配置
├── test/
│   └── package_info_plus_ohos_test.dart       # 单元测试
├── example/
│   └── lib/main.dart                          # 示例应用
├── pubspec.yaml                               # 包配置
├── README.md                                  # 文档
└── LICENSE                                    # 开源协议
```

## 4. API 映射

### 4.1 MethodChannel 接口

**Channel 名称**: `dev.fluttercommunity.plus/package_info`

**方法**: `getAll`

**请求**: 无参数

**响应**: `Map<String, dynamic>`
```dart
{
  'appName': String,        // 应用名称
  'packageName': String,    // 包名
  'version': String,        // 版本号
  'buildNumber': String,    // 构建号
  'buildSignature': String, // 构建签名（可选）
  'installerStore': String?, // 安装来源（可选）
  'installTime': String?,   // 安装时间戳（毫秒，可选）
  'updateTime': String?,    // 更新时间戳（毫秒，可选）
}
```

### 4.2 HarmonyOS API 映射

| 字段 | HarmonyOS API | 说明 |
|------|---------------|------|
| appName | `BundleInfo.appInfo.label` | 应用显示名称 |
| packageName | `BundleInfo.bundleName` | 应用包名 |
| version | `BundleInfo.versionName` | 版本名称 |
| buildNumber | `BundleInfo.versionCode` | 版本号（整数转字符串） |
| buildSignature | `BundleInfo.appInfo.signature` | 应用签名（可选） |
| installerStore | 暂不支持 | 需要额外权限 |
| installTime | 暂不支持 | 需要额外权限 |
| updateTime | 暂不支持 | 需要额外权限 |

### 4.3 HarmonyOS API 调用

```typescript
import { bundleManager } from '@kit.AbilityKit';

// 获取当前应用包信息
const bundleInfo = bundleManager.getBundleInfoForSelfSync();
const appInfo = bundleInfo.appInfo;

const result = {
  appName: appInfo.label,
  packageName: bundleInfo.bundleName,
  version: bundleInfo.versionName,
  buildNumber: bundleInfo.versionCode.toString(),
  buildSignature: '', // 需要额外 API
  installerStore: null,
  installTime: null,
  updateTime: null,
};
```

## 5. 权限要求

- 无需额外权限
- `getBundleInfoForSelfSync()` 是系统 API，无需声明权限

## 6. 错误处理

### 6.1 异常场景

| 场景 | 处理方式 |
|------|----------|
| 获取包信息失败 | 返回空字符串或 null |
| 字段不存在 | 使用默认值（空字符串或 null） |

### 6.2 错误码

无需自定义错误码，直接抛出异常由 Flutter 层处理。

## 7. 测试策略

### 7.1 单元测试

- 测试 `getAll()` 方法返回值格式
- 测试字段类型正确性
- 测试空值处理

### 7.2 集成测试

- 在示例应用中验证实际返回值
- 验证与 `package_info_plus` API 兼容性

## 8. 发布计划

### 8.1 版本规划

- **v0.1.0**: 基础功能（appName, packageName, version, buildNumber）
- **v0.2.0**: 扩展功能（buildSignature, installerStore, installTime, updateTime）
- **v1.0.0**: 稳定版本，发布到 pub.dev

### 8.2 开源准备

- [x] 代码结构符合 Flutter 插件规范
- [x] README.md 包含使用说明
- [x] LICENSE 文件（MIT 或 Apache-2.0）
- [x] example 应用
- [x] 单元测试覆盖
- [ ] pub.dev 发布（待验证）

## 9. 参考资源

- [package_info_plus 源码](https://github.com/fluttercommunity/plus_plugins/tree/main/packages/package_info_plus)
- [HarmonyOS bundleManager API](https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/js-apis-bundlemanager-V5)
- [Flutter 插件开发指南](https://docs.flutter.dev/development/platform-integration/plugin-api)
