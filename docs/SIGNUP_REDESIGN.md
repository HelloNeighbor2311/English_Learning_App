# Sign Up Flow - Redesign Documentation

**Status**: ✅ Hoàn thành (27/3/2026)  
**Architecture**: Clean Architecture + SOLID Principles

---

## 📊 Kiến Trúc Redesigned

### 1. **Domain Layer** (Business Logic)

```
sign_up/domain/
├── user_entity.dart          ✅ UserEntity (uid, email, level, createdAt, emailVerified)
├── sign_up_repository.dart   ✅ Abstract repository interface
└── sign_up_use_case.dart     ✅ Business logic (validation + signup orchestration)
```

**Trách Vụ:**

- `UserEntity`: Immutable user profile object
- `SignUpRepository`: Interface định nghĩa hợp đồng
- `SignUpUseCase`: Chứa tất cả business logic:
  - Validation: email, password, confirmPassword, length >= 6
  - Gọi repository để sign up + save profile

---

### 2. **Data Layer** (External Services)

```
sign_up/data/
├── user_model.dart                ✅ UserModel extends UserEntity
├── user_remote_datasource.dart    ✅ UserRemoteDataSource interface + implementation
└── sign_up_repository_impl.dart   ✅ SignUpRepository implementation
```

**Trách Vụ:**

- `UserModel`: Chuyển đổi giữa Entity ↔ JSON (Firestore)
- `UserRemoteDataSourceImpl`: Lưu user profile vào Firestore (/users/{uid})
- `SignUpRepositoryImpl`: Orchestrate 4 bước:
  1. Gọi AuthenticationService.signUpWithEmail()
  2. Tạo UserModel từ response
  3. Gọi UserRemoteDataSource để lưu profile
  4. Gửi email verification (non-blocking)

---

### 3. **Presentation Layer** (UI)

```
sign_up/presentation/
├── sign_up_page.dart    ✅ Refactored UI (improved)
└── sign_up_state.dart   ✅ SignUpState class (loading, success, failure)
```

**Cải Thiện:**

- ✅ **State Management**: SignUpState class (status, errorMessage, successMessage)
- ✅ **Dependency Injection**: Khởi tạo dependencies trong initState()
- ✅ **UI UX**: Error/success messages, disabled inputs khi loading
- ✅ **Form Validation**: Xử lý lỗi từ use case, hiển thị chi tiết
- ✅ **Loading indicator**: Button loading state khi đang xử lý
- ✅ **Better UX**:
  - Icons cho input fields
  - Helper text cho password
  - Segmented level selector
  - Color-coded error/success messages

---

## 🔄 Sign Up Flow (Updated)

```
SignUpPage (UI)
    ↓
_handleSignUp()
    ↓
SignUpUseCase.call(email, password, confirmPassword, level)
    ├─ Validate inputs
    └─ Call repository.signUpWithEmail()
        ↓
    SignUpRepositoryImpl.signUpWithEmail()
        ├─ 1️⃣ AuthenticationService.signUpWithEmail() → Firebase Auth
        ├─ 2️⃣ Create UserModel
        ├─ 3️⃣ UserRemoteDataSource.saveUserProfile() → Firestore (/users/{uid})
        ├─ 4️⃣ AuthenticationService.sendEmailVerification() (async, non-blocking)
        └─ Return UserEntity
    ↓
SignUpState.success + Show SnackBar
    ↓
Navigate to Home (via AuthWrapper stream listener)
```

---

## ✨ Key Features

### **1. Proper Validation**

- Email không trống
- Password >= 6 ký tự
- Password match confirmation
- All validation tại use case
- Detailed error messages

### **2. User Profile Auto-Save**

- Tự động lưu vào Firestore sau khi auth success
- Cấu trúc: `/users/{uid}` với fields:
  - uid
  - email
  - level (Beginner/Intermediate/Advanced)
  - createdAt (ISO8601)
  - emailVerified (false initially)

### **3. Separation of Concerns**

- **Domain**: Business logic độc lập với framework
- **Data**: Firestore/Auth implementation details
- **Presentation**: Chỉ xử lý UI, delegate logic
- **No Direct Calls**: UI → UseCase → Repository → Services

### **4. Better Error Handling**

- `FormatException`: Validation errors (user-friendly)
- `Exception`: System errors (with context)
- Error displayed in UI container
- Error dismiss trước khi submit tiếp

### **5. Loading State Management**

- Button disabled khi loading
- Inputs disabled khi loading
- Loading indicator thay vì text
- Can't toggle level khi loading

---

## 📝 Data Models

### UserEntity (Domain)

```dart
class UserEntity {
  final String uid;
  final String email;
  final String level;  // Beginner, Intermediate, Advanced
  final DateTime createdAt;
  final bool emailVerified;
}
```

### Firestore Structure

```
/users/{uid}
├── uid: string
├── email: string
├── level: string
├── createdAt: string (ISO8601)
└── emailVerified: boolean
```

---

## 🎯 Next Steps

1. **Test Sign Up Flow**
   - Run app
   - Register new account
   - Verify user saved in Firestore (/users/{uid})
   - Verify email verification sent

2. **Enable Firebase Providers** (if not done)
   - Email/Password authentication
   - Firestore rules (already user-based)

3. **Polish**
   - Input validation regex (email format)
   - Password strength indicator
   - Terms & conditions checkbox
   - Avatar creation/selection

4. **Extend**
   - Sign in flow (same Clean Architecture)
   - User profile update
   - Level change

---

## 📚 Files Modified/Created

| File                         | Status        | Type         |
| ---------------------------- | ------------- | ------------ |
| user_entity.dart             | ✅ Created    | Domain       |
| sign_up_repository.dart      | ✅ Updated    | Domain       |
| sign_up_use_case.dart        | ✅ Created    | Domain       |
| user_model.dart              | ✅ Created    | Data         |
| user_remote_datasource.dart  | ✅ Created    | Data         |
| sign_up_repository_impl.dart | ✅ Updated    | Data         |
| sign_up_state.dart           | ✅ Updated    | Presentation |
| sign_up_page.dart            | ✅ Refactored | Presentation |

---

**Last Updated**: 27/3/2026
