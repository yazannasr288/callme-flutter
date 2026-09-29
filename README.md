# CallMe — Flutter Voice & Video Calling App

CallMe is a Flutter mobile application for discovering registered users and starting real-time voice or video calls through ZEGO UI Kit.

The project includes a Flutter client, a PHP backend integration for user registration and user listing, Firebase initialization, and ZEGO calling/signaling integration.

## Screenshots

<p align="center">
  <img src="screenshots/login-screen.png" width="300">
  <img src="screenshots/home-screen.png" width="300">
</p>

## Features

- User registration/sign-in using username and ID
- Persistent login state with Shared Preferences
- User directory loaded from the PHP backend
- One-tap voice calls
- One-tap video calls
- ZEGO UI Kit integration for calling and signaling
- Firebase initialization and Firebase Messaging dependency
- Arabic user interface
- Simple Flutter UI for authentication and user discovery

## Tech Stack

| Technology | Purpose |
| --- | --- |
| Flutter / Dart | Mobile application |
| ZEGO UI Kit | Voice and video calling |
| ZEGO Signaling Plugin | Call signaling and invitations |
| Firebase Core | Firebase initialization |
| Firebase Messaging | Push-messaging dependency included in the project |
| Shared Preferences | Local login-state persistence |
| HTTP | Communication with the PHP backend |

## Project Structure

```text
lib/
├── main.dart
├── login.dart
├── homepage.dart
├── callservices.dart
├── constant.dart
└── firebase_options.dart

assets/
└── call.png

screenshots/
├── login-screen.png
└── home-screen.png

android/
ios/
test/
```

## How It Works

1. The user enters a username and ID on the login screen.
2. The app stores the entered user information locally using Shared Preferences.
3. The app sends the user information to the PHP backend through `signup.php`.
4. The home screen retrieves the available users through `getuser.php`.
5. The user can start a voice or video call using ZEGO.
6. Logging out clears the local session and unregisters the ZEGO calling service.

## Backend Integration

The current Flutter code communicates with these PHP endpoints:

```text
POST /signup.php
GET  /getuser.php
```

### signup.php

The login screen sends:

```text
username
id
```

The original client handles these backend responses:

```text
success
exists
```

### getuser.php

The endpoint is expected to return a JSON array containing users with fields used by the app:

```text
user_name
user_num
```

> **Current status:** The original hosted backend used during development is no longer active. The application therefore requires a replacement or reactivated PHP backend for server-backed login and user-list functionality.

## ZEGO Configuration

ZEGO initialization is handled in `lib/callservices.dart` using values from `lib/constant.dart`.

Before running the calling features, provide valid ZEGO credentials locally:

```dart
class Constant {
  static String appSign = "YOUR_ZEGO_APP_SIGN";
  static int appId = YOUR_ZEGO_APP_ID;
}
```

**Do not commit a real ZEGO App Sign to a public repository.**

## Firebase

Firebase is initialized from:

```text
lib/firebase_options.dart
```

The project also includes `firebase.json` and the Firebase Messaging dependency.

Firebase configuration is application-specific, so a fresh setup may require configuring the corresponding Firebase Android/iOS applications.

## Getting Started

### 1. Install dependencies

```bash
flutter pub get
```

### 2. Configure services

Before running the complete application:

- Set valid ZEGO App ID and App Sign in your local configuration.
- Provide an active PHP backend implementing the expected endpoints.
- Configure Firebase for the target platform when required.

### 3. Run the application

```bash
flutter run
```

## Project Status

The Flutter client, UI, ZEGO integration, and backend integration are included for portfolio and demonstration purposes.

The original PHP hosting used during development is no longer active, so the server-dependent parts of the application require a replacement backend. Voice and video calling also require valid ZEGO credentials.

## License

This project is released under the MIT License. See [LICENSE](LICENSE).
