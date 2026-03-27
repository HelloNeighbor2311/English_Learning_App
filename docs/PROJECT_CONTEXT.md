# English Learning App - Project Context & Setup

**Date**: March 27, 2026  
**Project**: English Learning App (Flutter)  
**Status**: Foundation & Authentication Setup Complete

---

## I. Project Overview

### Objectives

- Build an intelligent English learning app on Flutter platform
- Integrate AI technologies (Scanner for object detection, AI Chatbot)
- Gamification system (XP, Levels, Streaks, Achievements)
- Support 4 core skills: Listening, Reading, Speaking, Writing
- Offline-first learning with cloud sync

### Target Users

- Students, office workers, English learners
- Support for Beginner, Intermediate, Advanced levels

### Platform & Constraints

- **Primary**: Android (minimum 6.0+)
- **Language Support**: English ↔ Vietnamese only
- **MVP Phase**: Mobile app (no web version yet)
- **AI Scanner**: ~80-100 common object classes, 15-20 FPS target

---

## II. Tech Stack

### Backend & Cloud Services

- **Firebase**:
  - Authentication (Email/Password, Google Sign-in)
  - Firestore (NoSQL database)
  - Storage (via Supabase)
- **Supabase**:
  - Storage buckets (audio, images, user files)
  - PostgreSQL (for complex queries if needed)

### Frontend Framework

- **Flutter 3.10+**: Cross-platform UI development
- **Dart**: Programming language
- **State Management**: (to be determined - might use Provider/Riverpod/Bloc)

### Key Dependencies

```yaml
firebase_core: ^3.15.2
cloud_firestore: ^5.6.11
firebase_auth: ^5.1.3
google_sign_in: ^6.2.1
supabase_flutter: ^2.5.0
```

### Android Build Tools

- Google Services Gradle plugin (Firebase config)
- Firebase BoM for dependency management
- Min SDK: Android 6.0+

---

## III. Folder Structure

```
lib/
├── app/                          # App-level setup
├── bootstrap/                    # Bootstrap initialization
│   └── firebase_bootstrap.dart   # Firebase init
├── core/                         # Global technical layers
│   ├── constants/
│   ├── errors/
│   ├── network/
│   ├── services/
│   │   ├── authentication_service.dart    # Auth logic
│   │   ├── firestore_service.dart        # Firestore operations
│   │   └── supabase_service.dart         # Supabase storage
│   ├── storage/
│   ├── theme/
│   └── utils/
├── shared/                       # Reusable assets
│   ├── widgets/
│   ├── models/
│   ├── extensions/
│   └── enums/
└── features/                     # Business modules
    ├── authentication/
    │   ├── modules/
    │   │   ├── sign_in/
    │   │   ├── sign_up/
    │   │   ├── forgot_password/
    │   │   └── session/
    │   └── (presentation/domain/data folders)
    ├── home/
    │   ├── modules/
    │   │   ├── banner/
    │   │   ├── search/
    │   │   ├── topic_dictionary/
    │   │   ├── review_notification/
    │   │   └── featured_words/
    ├── listening/
    │   ├── modules/podcast/
    │   └── modules/interview/
    ├── reading/
    │   ├── modules/articles/
    │   ├── modules/fairy_tales/
    │   ├── modules/books/
    │   └── modules/shadowing/
    ├── dictionary/
    │   ├── modules/saved_words/
    │   ├── modules/flashcard/
    │   ├── modules/quiz/
    │   ├── modules/spaced_repetition/
    │   └── modules/statistics/
    ├── gamification/
    │   ├── modules/xp_level/
    │   ├── modules/achievements/
    │   └── modules/streak/
    ├── entertainment/
    │   ├── modules/guess_word/
    │   ├── modules/matching_game/
    │   └── modules/ai_mini_games/
    ├── ai_scanner/
    │   ├── modules/camera_permission/
    │   ├── modules/object_detection/
    │   └── modules/object_detail/
    ├── ai_chatbot/
    │   ├── modules/chat/
    │   ├── modules/conversation_practice/
    │   └── modules/history/
    ├── profile/
    │   ├── modules/account/
    │   ├── modules/learning_stats/
    │   ├── modules/badges/
    │   └── modules/activity_history/
    └── settings/
        ├── modules/preferences/
        ├── modules/notifications/
        └── modules/theme/
```

### Architecture Pattern

- **Clean Architecture**: Each feature has 3 layers
  - `presentation/`: Pages, Widgets, State Management
  - `domain/`: Business Logic, Entities, Repository Interfaces, Use Cases
  - `data/`: Models, Data Sources, Repository Implementations

- **Module-based**: Each major feature subdivided into functional modules for independent development

---

## IV. Current Setup Status

### ✅ Completed

1. **Project Foundation**
   - Folder structure with 39 modules across 11 features
   - 273 skeleton files (page, entity, repository, datasource, etc.)

2. **Firebase Integration**
   - Firebase Core initialized in bootstrap
   - Firestore Service (singleton) for document operations
   - Google Services Gradle plugin configured
   - Firebase BoM added to Android dependencies

3. **Authentication System**
   - AuthenticationService: Email/Password + Google Sign-in
   - SignInPage: Email login + Google button
   - SignUpPage: Registration with level selection (Beginner/Intermediate/Advanced)
   - AuthWrapper: Auto-routing based on login state
   - SHA-1 fingerprint added to Firebase: `78:1D:35:0A:4B:FE:6B:0C:A5:CF:6D:D9:DF:EF:92:79:0B:2B:CE:FA`

4. **Supabase Storage**
   - Supabase Service (singleton) for file operations
   - Storage buckets created (vocabularies, audio, etc.)
   - Initialize in main.dart

5. **Firestore Rules (Security)**
   - User-based access control: Each user can only access their own data
   - Rules structure supports hierarchical collections

6. **Dependencies**
   - flutter_pub: All packages fetched successfully
   - No compilation errors

### ⚠️ Pending Firebase Configuration

- Enable Google Sign-in provider in Firebase Console (Settings → Authentication → Sign-in method)
- Enable Email/Password provider
- Verify Firestore user-based rules are published

---

## V. Authentication Flow

```
App Start
    ↓
Firebase Init → Supabase Init
    ↓
AuthWrapper (Stream listener)
    ↓
    ├─ User logged in? → Home Page
    └─ Not logged in? → Sign In Page
                ↓
         (Sign In / Sign Up)
         ┌─ Email + Password
         └─ Google Account
                ↓
         Save to Firestore → Stream updates
                ↓
         Redirect to Home
```

### Sign Up Flow

1. User enters email, password, chooses level
2. Create account in Firebase Auth
3. Save profile to Firestore (`/users/{uid}`)
4. AI generates starter vocabulary (TODO)

### Sign In Flow

1. Email/Password or Google Sign-in
2. Firebase Auth returns user
3. AuthWrapper listens and routes to Home

---

## VI. Services Overview

### AuthenticationService

```dart
// Key methods:
- signUpWithEmail(email, password)
- signInWithEmail(email, password)
- signInWithGoogle()
- signOut()
- resetPassword(email)
- authStateChanges (Stream)
```

### FirestoreService

```dart
// Key methods:
- setDocument(collectionPath, documentId, data)
- addDocument(collectionPath, data)
- watchCollection(collectionPath) → Stream
```

### SupabaseService

```dart
// Key methods:
- uploadFile(bucket, filePath, fileData)
- getPublicUrl(bucket, filePath)
- deleteFile(bucket, filePath)
```

---

## VII. Firebase Console Configuration Checklist

- [ ] Enable Google Sign-in in Authentication → Sign-in method
- [ ] Enable Email/Password in Authentication → Sign-in method
- [ ] Publish Firestore Rules (user-based access)
- [ ] Verify Android app config with SHA-1 fingerprint
- [ ] (Optional) Create Firestore indices for complex queries later

---

## VIII. How to Run

### Prerequisites

- Flutter 3.10+
- Android SDK (6.0+) or emulator
- Java JDK (for keytool, already detected)
- Firebase project set up

### Build & Run

```bash
cd d:\PTUD\english_learning_app

# Install dependencies
flutter pub get

# Run on emulator/device
flutter run

# Or specific device
flutter run -d <device-id>
```

### First Test

1. App shows **Sign In Page**
2. Options:
   - Sign Up: Create new account with level
   - Sign In: Use existing email
   - Google Sign-in: Authenticate via Google
3. Success → **Home Page** with user email displayed
4. Logout: Tap icon in top-right

---

## IX. Next Steps (Priority Order)

### Short-term (Critical)

1. **Enable Firebase Providers** (if not done)
   - Google Sign-in activation
   - Email/Password activation

2. **Test Authentication Flow**
   - Run app, register new user
   - Verify Firestore document creation under `/users/{uid}`
   - Test logout/login

3. **Implement User Profile Creation**
   - Save level, avatar, creation date to Firestore
   - Generate initial vocabulary set based on level

4. **Setup Local Storage (SQLite)**
   - Offline vocabulary cache
   - Learning history sync

### Medium-term (MVP Features)

5. Implement Home module (banner, search, topic dictionary)
6. Implement Dictionary module (saved words, flashcard, quiz)
7. Implement Gamification (XP/Level, achievements, streaks)
8. Implement Entertainment games (guess word, matching)

### Long-term (Advanced Features)

9. AI Scanner (YOLO integration for object detection)
10. AI Chatbot (GPT/Gemini integration)
11. Listening module (podcasts, interviews, shadowing)
12. Reading module (articles, books, fairy tales)
13. Spaced repetition algorithm for vocabulary review

---

## X. Key Decisions & Notes

### Architecture Choices

- **Singleton Services**: Authentication, Firestore, Supabase (easy access, shared state)
- **Stream-based Auth**: AuthWrapper listens to FirebaseAuth.authStateChanges() for reactive routing
- **User-based Firestore Rules**: Security-first approach; each user owns their data

### Design Patterns

- **Clean Architecture**: Separation of concerns (presentation/domain/data)
- **Feature-based Modules**: Scale horizontally; add features independently
- **Skeleton-first**: Files created empty; content added afterward

### Security Considerations

- Firestore Rules enforce user-based access
- Google-services.json with credentials (add to .gitignore)
- Supabase anon key for storage (public; use policies for storage if needed)

### Testing & Verification

- No unit tests yet (skeleton phase)
- Manual testing via Flutter app
- Firebase Console for data verification

---

## XI. Contact & Questions

For detailed setup steps, refer to:

- `/docs/firestore_setup.md` - Firestore rules & initialization
- `/docs/firebase_connect_done.md` - Firebase integration guide
- Code comments in services for API details

---

**Last Updated**: March 27, 2026  
**Maintainer**: Development Team
