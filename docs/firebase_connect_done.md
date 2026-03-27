# Hoàn tất liên kết Firebase + Firestore

## Trạng thái hiện tại

✅ google-services.json đã đặt tại: `android/app/google-services.json`
✅ Dependencies đã cập nhật (firebase_core, cloud_firestore)
✅ Firebase Bootstrap đã cấu hình tại: `lib/bootstrap/firebase_bootstrap.dart`
✅ Firestore Service đã tạo tại: `lib/core/services/firestore_service.dart`
✅ main.dart đã tích hợp Firebase init + test UI tại: `lib/main.dart`
✅ Code analyzer không lỗi

## Bước tiếp theo: Chạy app trên Android

**1. Yêu cầu Firestore Rules (tạm thời cho dev)**

Vào Firebase Console → Your project → Firestore Database → Rules tab

Dán quy tắc tạm thời (chỉ dùng dev/test):

```txt
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

Nhấn **Publish**.

**2. Chạy app**

Option A - Android Emulator:

```bash
flutter run
```

Option B - Thiết bị thật (USB):

```bash
flutter run -d <device-id>
```

Để xem danh sách device:

```bash
flutter devices
```

**3. Test lưu dữ liệu**

- Khi app khởi chạy, sẽ hiển thị màn hình "Firestore Setup"
- Nhấn nút **Luu du lieu test**
- Nếu thành công, sẽ hiển thị: "Da luu thanh cong docId: <id>"
- Kiểm tra Firestore Console → Collection `app_logs` → sẽ có document mới

## Firestore Collections cần tạo sau

Dựa trên module requirements, bạn sẽ cần collections sau:

- `users` - hồ sơ người dùng
- `vocabularies` - từ vựng
- `flashcards` - flashcard
- `learning_stats` - thống kê học tập
- `achievements` - thành tích
- `streak_history` - lịch sủ streaks
- ... (tùy theo feature)

## Notes

- google-services.json chứa API keys, **không commit** vào Git (thêm vào .gitignore)
- Firestore rules ở trên quá mở, cần thay đổi sau khi thêm Authentication
- Nếu gặp lỗi "401 Unauthorized", kiểm tra Firestore Rules lại
