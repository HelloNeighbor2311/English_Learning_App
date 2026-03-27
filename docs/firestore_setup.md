# Firestore Setup Guide

## 1) Create Firebase project

- Go to Firebase Console and create a project.
- Add an Android app with package name: `com.example.english_learning_app`.
- Download `google-services.json` and place it at:
  - `android/app/google-services.json`

## 2) Configure FlutterFire CLI (recommended)

Run in project root:

```bash
flutterfire configure --project=<your-firebase-project-id> --platforms=android
```

This command creates platform configuration and links your app to Firebase.

## 3) Install dependencies

Run:

```bash
flutter pub get
```

## 4) Verify Firestore rules (development)

For testing only, use permissive rules temporarily:

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

Important: tighten rules before production.

## 5) Run app and test write

- Start app on Android.
- In the home screen, press `Luu du lieu test`.
- Check Firestore collection `app_logs` for a new document.

## 6) Production checklist

- Replace open Firestore rules with user-based auth rules.
- Enable Firebase Authentication before storing user-specific data.
- Add indexes for query-heavy collections when needed.
