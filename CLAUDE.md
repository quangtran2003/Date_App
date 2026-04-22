# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Crushly** — ứng dụng hẹn hò Flutter (dating app), backend Firebase, hỗ trợ iOS & Android.  
Package: `vn.crusly.com` (Android) / Bundle ID: `vn.crusly.com` (iOS). App version: `pubspec.yaml`.

## Commands

Dự án dùng **FVM** Flutter `3.32.8` (xem `.fvmrc`). Luôn dùng `fvm flutter`, không dùng `flutter` trực tiếp.

```bash
# Dependencies
fvm flutter pub get

# Chạy app
fvm flutter run --target lib/main.dart

# Lint
fvm flutter analyze

# Code generation — chạy khi thêm/sửa: Hive model, JSON serializable, locales
fvm flutter pub run build_runner build --delete-conflicting-outputs

# Tests
fvm flutter test

# iOS: sau khi thay đổi pubspec.yaml hoặc xoá Podfile.lock
fvm flutter clean && fvm flutter pub get && cd ios && pod install
```

### Phân phối app (Fastlane) — xem [FASTLANE.md](FASTLANE.md)

```bash
cd android && fastlane play_store   # Build AAB → Play Store (production)
cd android && fastlane firebase     # Build APK → Firebase App Distribution
cd ios && fastlane testflight       # Build IPA → TestFlight
cd ios && fastlane firebase         # Build IPA → Firebase App Distribution
```

### Code push (Shorebird) — xem [SHOREBIRD.md](SHOREBIRD.md)

```bash
# Tạo release mới (khi tăng version hoặc thay đổi native code)
shorebird release android --flutter-version=3.32.8
shorebird release ios --flutter-version=3.32.8

# Push patch (chỉ thay đổi Dart code, không cần review store)
shorebird patch android --release-version=<versionName+versionCode>
shorebird patch ios --release-version=<versionName+versionCode>
```

## Architecture

### Pattern: GetX MVC + Repository

**State management, navigation, DI:** GetX

```
UI Widget → GetxController → Repository → Firebase / Dio API
```

### Cấu trúc feature module

Mỗi feature trong `lib/features/` theo cấu trúc:

```
feature_name/
├── binding/       # GetX DI — đăng ký controller
├── controller/    # Business logic, extends BaseGetxController
├── repository/    # Interface + Impl, truy cập data layer
├── ui/            # Widgets & pages
└── model/         # Data models (thường có @JsonSerializable hoặc HiveType)
```

**Features hiện có:** `auth/` (login, register, forgot_pass, biometric), `home/`, `splash/`, `profile/`, `profile_detail/`, `user_list/`, `users_suggest/`, `match_user/`, `profile_match/`, `chat/`, `chat_bot/`, `sticker/`, `video_call/`

### Dependency Injection

- **GlobalBinding** (`lib/core/app/binding/global_binding.dart`): đăng ký tất cả repositories với `fenix: true` — tồn tại xuyên suốt vòng đời app
- **Feature Binding**: lazy-load controller khi vào route
- Home route dùng nhiều bindings: `[HomeBinding(), ProfileBinding(), UserListBinding(), UsersSuggestBinding()]`

### Navigation

- Routes: `lib/routes/app_router.dart` (GetPage) + `lib/routes/app_route.dart` (enum `AppRouteEnum`)
- Điều hướng: `Get.toNamed(AppRouteEnum.xxx.path)` hoặc `Get.offAllNamed(...)`

### Base Classes quan trọng

**`BaseGetxController`** (`lib/core/base/base_controller/base_controller.dart`):
- `isShowLoading` / `isLoadingOverlay` — 2 loại loading state
- `cancelTokens` — tự động huỷ Dio requests khi controller close
- `_setOnErrorListener()` — xử lý lỗi HTTP tập trung (gọi trong `onReady()`)
- `handleException()` — bọc exception qua `ExceptionHandler`

Các biến thể: `BasePageSearchController` (search), `BaseRefreshController` (pull-to-refresh).

**`BaseConnectAPI`** (`lib/core/base/base_repository/base_connect_api.dart`): Dio HTTP client dùng chung.

### App Lifecycle

`App` widget (`lib/core/app/app.dart`) dùng `WidgetsBindingObserver`:
- `paused` → update user offline status trên Firestore
- `resumed` → update user online status
- `deferFirstFrame` / `allowFirstFrame` — đảm bảo Hive + theme load trước frame đầu

### Local Storage (Hive)

| Class | Dùng cho |
|-------|----------|
| `AppStorage` | Token, dữ liệu chung |
| `SettingStorage` | Theme (light/dark/system), ngôn ngữ (vi/en) |
| `AlbumStickerStorage` | Cache sticker albums |
| `SecureStorage` | Thông tin đăng nhập (flutter_secure_storage) |

### Localization

- File dịch: `lib/locales/vi_VN.json` (mặc định) và `lib/locales/en_US.json`
- Generated: `lib/generated/locales.g.dart` — chạy `build_runner` sau khi sửa JSON
- Dùng trong code: `AppStr.someKey.tr`

### Firebase

**Firestore collections** (`lib/core/const/firebase_collection.dart`):
- `users`, `chats`, `messages`, `calls`

**Notifications:**
- FCM (`lib/core/config_noti/fcm.dart`) — foreground + background
- Local Notifications (`lib/core/config_noti/local_notif.dart`) — hiển thị khi app đang mở, navigate theo loại message

### Code Push (Shorebird)

`ShorebirdUtils` (`lib/utils/shorebird_util.dart`) — tự kiểm tra update mỗi 10 phút, tự apply patch và restart app. `app_id: 7a875652-4306-4f4c-9870-1354d01072ba`.

## Android Build Notes

`android/settings.gradle` phải dùng `RepositoriesMode.PREFER_PROJECT` (không phải `PREFER_SETTINGS`) để Shorebird có thể inject repository chứa engine của họ lúc build. Nếu đổi về `PREFER_SETTINGS`, `shorebird release` sẽ fail với lỗi `Could not find io.flutter:flutter_embedding_release`.

NDK version phải là `27.0.12077973` (trong `android/app/build.gradle`) để tương thích với các plugin Firebase/Flutter hiện tại.

## iOS Build Notes

`ios/Podfile` có `post_install` hook set min iOS 13.0 cho tất cả pods và thêm Flutter engine path vào `FRAMEWORK_SEARCH_PATHS` — cần thiết cho các plugin dùng cấu trúc `Sources/` mới. Không xoá hook này.
