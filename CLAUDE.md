# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Crushly** — ứng dụng hẹn hò Flutter (dating app), backend Firebase, hỗ trợ iOS & Android. Package name: `easy_date`.

## Commands

> Dự án dùng **FVM** (Flutter Version Manager), Flutter 3.32.x. Luôn prefix bằng `fvm flutter` thay vì `flutter`.

```bash
# Lấy dependencies
fvm flutter pub get

# Chạy app (dev)
fvm flutter run --target lib/main.dart

# Code generation (Hive adapters, JSON serializable, locales)
fvm flutter pub run build_runner build --delete-conflicting-outputs

# Chạy tests
fvm flutter test

# Build iOS IPA và distribute lên Firebase App Distribution
cd .build && bash ios.sh

# iOS: sau khi thay đổi pubspec.yaml hoặc xoá Podfile.lock
cd ios && pod install
```

## Architecture

### Pattern: GetX MVC + Repository

**State management, navigation, DI:** GetX (`get: ^4.6.6`)

**Luồng data:**
```
UI Widget → GetxController → Repository → Firebase/Dio API
```

### Cấu trúc feature module

Mỗi feature trong `lib/features/` theo cấu trúc:
```
feature_name/
├── binding/          # GetX DI — đăng ký controller vào DI
├── controller/       # Business logic, extends BaseGetxController
├── repository/       # Interface + Impl, truy cập data layer
├── ui/               # Widgets & pages
└── model/            # Data models của feature
```

### Dependency Injection

- **GlobalBinding** (`lib/core/app/binding/global_binding.dart`): đăng ký toàn bộ repositories với `fenix: true` (tồn tại xuyên suốt vòng đời app)
- **Feature Binding**: mỗi feature có binding riêng, lazy-load controller khi vào route
- Home route dùng nhiều bindings: `[HomeBinding(), ProfileBinding(), UserListBinding(), UsersSuggestBinding()]`

### Navigation

- Routes định nghĩa trong `lib/routes/app_router.dart` dùng `GetPage`
- Tên route từ enum `AppRouteEnum` (`lib/routes/app_route.dart`)
- Điều hướng: `Get.toNamed(AppRouteEnum.xxx.path)` hoặc `Get.offAllNamed(...)`

### Base Classes quan trọng

**`BaseGetxController`** (`lib/core/base/base_controller/base_controller.dart`):
- `isShowLoading` / `isLoadingOverlay` — 2 loại loading state
- `cancelTokens` — tự động huỷ tất cả Dio requests khi controller bị close
- `_setOnErrorListener()` — xử lý lỗi HTTP tập trung (gọi trong `onReady()`)
- `handleException()` — bọc exception qua `ExceptionHandler`

**`BaseConnectAPI`** (`lib/core/base/base_repository/base_connect_api.dart`): HTTP client (Dio), dùng chung cho tất cả repositories.

### App Lifecycle

`App` widget (`lib/core/app/app.dart`) dùng `WidgetsBindingObserver`:
- `paused` → update user offline status trên Firebase
- `resumed` → update user online status
- `deferFirstFrame` / `allowFirstFrame` — đảm bảo Hive và theme được load trước khi hiển thị frame đầu

### Local Storage (Hive)

| Class | Dùng cho |
|-------|----------|
| `AppStorage` | Dữ liệu chung của app |
| `SettingStorage` | Theme (light/dark/system) và ngôn ngữ (vi/en) |
| `AlbumStickerStorage` | Cache sticker albums |
| `SecureStorage` | Thông tin đăng nhập nhạy cảm (flutter_secure_storage) |

### Localization

- File dịch: `lib/locales/vi_VN.json` và `lib/locales/en_US.json`
- Generated: `lib/generated/locales.g.dart`
- Dùng trong code: `AppStr.someKey.tr`
- Locale mặc định: `vi_VN`

### Notifications

- FCM (`lib/core/config_noti/fcm.dart`) — Firebase Cloud Messaging, foreground + background
- Local Notifications (`lib/core/config_noti/local_notif.dart`) — hiển thị notification khi app đang mở
- Click notification → navigate đến màn hình tương ứng

### Key Dependencies

| Package | Mục đích |
|---------|----------|
| `get` | State management, routing, DI |
| `firebase_*` | Auth, Firestore, Storage, Realtime DB, Messaging, Analytics, Crashlytics |
| `dio` | HTTP client |
| `hive` | Local key-value storage |
| `google_generative_ai` | Gemini AI (chat bot feature) |
| `flutter_card_swiper` | Card swipe UI (match feature) |
| `local_auth` | Biometric authentication |

## iOS Build Notes

Khi build iOS gặp lỗi `Unable to find module dependency: 'Flutter'`, `Podfile.lock` bị xóa, hoặc thay đổi plugin:

```bash
flutter clean
flutter pub get
cd ios && pod install
```

`Podfile` (`ios/Podfile`) có post_install hook thêm Flutter engine path vào `FRAMEWORK_SEARCH_PATHS` của tất cả pod targets — cần thiết cho các plugin dùng cấu trúc `Sources/` mới.
