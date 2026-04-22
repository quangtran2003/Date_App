# Fastlane

Dùng Fastlane để build và phân phối app tự động.

## Yêu cầu

- Ruby + Bundler đã cài
- `FIREBASE_TOKEN` đã set trong environment (dùng `firebase login:ci` để lấy token)
- Android: `android/assets/keys/service_account.json` hợp lệ (Google Play API)
- iOS: Apple Developer account đã đăng nhập

---

## Android

### Upload lên Play Store (production)

```bash
cd android && fastlane play_store
```

- Build Flutter AAB (`--release`)
- Upload lên Play Store track `production`
- Dùng `service_account.json` để xác thực

### Phân phối lên Firebase App Distribution

```bash
cd android && fastlane firebase
```

- Build Flutter APK (`--release`)
- Upload lên Firebase App Distribution, group `tester`

---

## iOS

### Upload lên TestFlight

```bash
cd ios && fastlane testflight
```

- Build Flutter IPA (`--release`)
- Upload lên TestFlight (bỏ qua chờ processing)

### Phân phối lên Firebase App Distribution

```bash
cd ios && fastlane firebase
```

- Build Flutter IPA (`--export-method ad-hoc`)
- Upload lên Firebase App Distribution, group `tester`

---

## Lưu ý

- Version lấy tự động từ `pubspec.yaml` (ví dụ: `1.0.2+20` → `versionName=1.0.2`, `versionCode=20`)
- Để chạy từ root project, thêm `cd android` hoặc `cd ios` trước lệnh
