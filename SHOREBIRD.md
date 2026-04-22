# Shorebird

Shorebird cho phép push **patch** (code update) trực tiếp đến thiết bị người dùng mà không cần release mới trên store — tương tự CodePush.

- App ID: `7a875652-4306-4f4c-9870-1354d01072ba`
- Tự động update khi khởi động app (`auto_update: true` mặc định)

---

## Quy trình

```
Release (store)  →  Patch (Shorebird)  →  App tự update khi mở
```

- **Release**: tạo bản gốc, upload lên store như bình thường
- **Patch**: fix bug / update UI nhỏ → push thẳng đến user, không cần review store

---

## Tạo Release mới

Dùng khi tăng version (`pubspec.yaml`), thêm native code, hoặc thay đổi dependencies.

```bash
# Android
shorebird release android --flutter-version=3.32.8

# iOS
shorebird release ios --flutter-version=3.32.8
```

- Build và upload artifact lên Shorebird server
- File AAB output: `build/app/outputs/bundle/release/app-release.aab`
- Sau đó upload AAB lên Play Store thủ công (hoặc dùng `fastlane android play_store`)

---

## Push Patch

Dùng khi fix bug / thay đổi Dart code mà không cần release mới trên store.

```bash
# Android
shorebird patch android --release-version=1.0.2+20

# iOS
shorebird patch ios --release-version=1.0.2+20
```

- `--release-version` phải khớp với version đã release (`versionName+versionCode` trong pubspec)
- Patch sẽ được tải về và áp dụng khi user mở lại app

---

## Xem danh sách Releases

```bash
shorebird releases list
```

---

## Lưu ý

- Patch **không thể** thay đổi native code (Kotlin/Swift/plugin), chỉ thay đổi Dart code
- Phải dùng đúng `--flutter-version` với version đã dùng khi release
- Nếu `settings.gradle` dùng `PREFER_SETTINGS`, Gradle sẽ không resolve được engine của Shorebird → phải để `PREFER_PROJECT`
