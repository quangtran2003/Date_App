# easy_date

## Config firebase
- https://codewithandrea.com/articles/flutter-flavors-for-firebase-apps/#setting-up-multiple-firebase-environments

```
flutterfire config --project easy-date-dev --out=lib/firebase/firebase_options_dev.dart --android-app-id=vn.softdreams.easy_date.dev
```

```
flutterfire config --project easy-date-prod --out=lib/firebase/firebase_options_prod.dart --android-app-id=vn.softdreams.easy_date
```

- Android: Tạo 2 thư mục dev và prod trong android/app/src (tên folder phải trùng với tên các flavor được trong app/build.gradle) và lưu 2 file google-service.json (tải từ firebase) tương ứng với từng flavor

## Build android
```
fvm flutter build apk --flavor dev --target lib/main_dev.dart
```

```
fvm flutter build apk --flavor prod --target lib/main_prod.dart
```

# RULES:
- Check network trước khi call API
- Try-Catch lỗi trong controller khi call API (xem feat login), nếu muốn tự handle lỗi cụ thể thì có thể try on catch

# Vào trang: https://temp-mail.org/vi/ để tạo email tạm