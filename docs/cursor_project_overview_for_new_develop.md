# Project overview for new developer
_Exported on 10/2/2025 at 14:23:08 EDT from Cursor (1.7.28)_

---

**User**

I am new developer on this project, review the entire project and explain what it does.

---

**Cursor**

I'll review this Flutter project for you. Let me start by examining the key files to understand what this application does.

# BlackSheep Project Overview

Welcome to **BlackSheep** (package name: `sheepfold`)! This is a Flutter mobile application designed to connect mentees with mentors in their local community.

## What It Does

BlackSheep is a **community mentorship platform** that matches people looking for guidance (mentees) with community group leaders (mentors) based on geographic proximity. Think of it as a bridge connecting individuals to local community resources.

## Tech Stack

- **Framework**: Flutter (Dart 3.8.1)
- **Backend**: Firebase
  - Firebase Authentication (user auth)
  - Firebase Realtime Database (data storage)
- **Key Dependencies**:
  - `video_player` - For splash screen and promotional videos
  - `location` - For geolocation-based mentor matching
  - `flutter_email_sender` - For email notifications
- **Platforms**: iOS, Android, Web, Linux, Windows, macOS (cross-platform)

## Application Flow

### 1. **Splash Screen**
- Displays a 6-second video (`video1.mp4`) with the BlackSheep background
- Auto-navigates to the Home Screen

### 2. **Home Screen**
- Two main options: **REGISTER** or **LOGIN**
- Uses custom fonts (Genty and Now) for branding

### 3. **Registration Flow**

**Initial Registration Screen:**
- Users choose their role:
  - **"I AM LOOKING TO CONNECT WITH PEOPLE IN MY COMMUNITY"** (Mentee)
  - **"I AM THE LEADER OF A COMMUNITY GROUP"** (Mentor)

**For Mentees:**
- Collects: first name, last name, age, gender
- Requires current location (latitude/longitude) for proximity matching
- Multi-step registration process (Screen 2 → 3 → 4)

**For Mentors:**
- Extended registration flow (Screen 2 → 3 → 4 → 5 → 6)
- Additional information to describe community group/services

### 4. **Login**
- Email/password authentication via Firebase Auth
- Retrieves user data from Firebase Realtime Database
- Routes to different screens based on user type (mentor vs mentee)

### 5. **Main Experience**

**For Mentees:**
- Initially shows connection options: "In app text" or "Phone"
- Plays a promotional video (`video2.mp4`)
- When connecting:
  - Mentee writes an initial message (min 10 characters)
  - System finds the **geographically closest mentor** using the Haversine formula
  - Creates a chat connection
  - Shows waiting screen with video (`video3.mp4`)
- Once matched, displays a single chat conversation with their mentor

**For Mentors:**
- Shows a list of all mentees connected to them (chat previews)
- Can view and respond to multiple chat conversations
- Sidebar navigation with logout option

### 6. **Chat System**
- Real-time messaging stored in Firebase Realtime Database
- Chat bubbles differentiate between current user and other party
- Messages include timestamps and sender identification
- Manual refresh functionality
- Message sending with real-time updates

## Key Features

1. **Location-Based Matching**: Automatically pairs mentees with the nearest available mentor using GPS coordinates
2. **Role-Based UI**: Different interfaces for mentors (list of chats) vs mentees (single chat)
3. **Real-time Messaging**: Firebase Realtime Database enables live chat
4. **Video Integration**: Enhances user experience during onboarding and waiting periods
5. **Authentication**: Secure Firebase Auth with email/password

## Data Structure

**User Model** (`lib/models/user.dart`):
```dart
- id
- firstName
- lastName
- email
- address
```

**Database stores**:
- User type (mentor/mentee)
- Location (latitude/longitude)
- Chat connections
- Messages with timestamps

## Color Scheme
- Primary: `#32a2c0` (teal/cyan)
- Accent: `#fbee5e` (yellow)
- Secondary: `#a06181` (mauve/pink)
- Dark: `#062d69` (navy blue)

## Project Structure
```
lib/
├── main.dart                  # App entry point
├── firebase_options.dart      # Firebase configuration
├── models/
│   └── user.dart             # User data model
├── screens/
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   ├── login/
│   ├── register/             # Multi-step registration
│   └── chat/                 # Chat interfaces
└── widgets/
    ├── buttons/              # Reusable button components
    └── layouts/headers/      # Custom header widgets
```

## Development Notes

- The app uses Firebase Realtime Database (not Firestore)
- Location permissions are required for mentee registration
- Email sending functionality is integrated but appears to be for testing/notifications
- Custom fonts (Genty, Now) give the app its unique branding
- Background image (`blacksheep_background_full.png`) used consistently throughout

## Next Steps for Development

You might want to explore:
1. How mentor registration differs from mentee registration
2. The matching algorithm implementation
3. Push notification setup for new messages
4. Email notification workflows
5. How to handle multiple mentees per mentor

Feel free to ask if you need clarification on any specific part of the codebase!

```dart
- id
- firstName
- lastName
- email
- address
```

```plaintext
lib/
├── main.dart                  # App entry point
├── firebase_options.dart      # Firebase configuration
├── models/
│   └── user.dart             # User data model
├── screens/
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   ├── login/
│   ├── register/             # Multi-step registration
│   └── chat/                 # Chat interfaces
└── widgets/
    ├── buttons/              # Reusable button components
    └── layouts/headers/      # Custom header widgets
```

---

**User**

build a plan to add push notifications for the chat system when a user receives a new message, on ios and android i want the notifcation to display on the user device even when the applicaion is closed.

---

**Cursor**

# Plan: Add Push Notifications for Chat System

I'll create a comprehensive plan to implement push notifications for the BlackSheep chat system using Firebase Cloud Messaging (FCM).

## Overview

We'll implement a system where:
- When a user sends a message, the recipient receives a push notification
- Notifications work on iOS and Android, even when the app is closed
- Notifications show the sender's name and message preview

## Implementation Plan

### **Phase 1: Dependencies & Configuration**

#### 1.1 Add Required Packages
```bash
flutter pub add firebase_messaging
flutter pub add flutter_local_notifications
```

**Packages needed:**
- `firebase_messaging` - For FCM integration
- `flutter_local_notifications` - For displaying notifications when app is in foreground

#### 1.2 iOS Configuration
**Files to modify:**
- `ios/Runner/AppDelegate.swift` - Add notification permissions
- `ios/Runner/Info.plist` - Add background modes
- Register app with Apple Push Notification service (APNs)
- Upload APNs authentication key to Firebase Console

**Steps:**
1. Enable Push Notifications capability in Xcode
2. Enable Background Modes > Remote notifications
3. Add to `Info.plist`:
```xml
<key>UIBackgroundModes</key>
<array>
  <key>remote-notification</key>
</array>
```

#### 1.3 Android Configuration
**Files to modify:**
- `android/app/src/main/AndroidManifest.xml` - Add notification permissions and metadata

**Steps:**
1. Add notification permissions
2. Configure notification icon
3. Set default notification channel

---

### **Phase 2: FCM Token Management**

#### 2.1 Create Notification Service (`lib/services/notification_service.dart`)
- Initialize FCM
- Request notification permissions
- Get FCM token
- Handle token refresh
- Store token in Firebase Realtime Database

#### 2.2 Update User Database Schema
**New fields in `/users/{uid}`:**
```json
{
  "fcmToken": "device_fcm_token_here",
  "fcmTokenUpdated": 1234567890
}
```

#### 2.3 Token Registration Flow
- On login: Get FCM token and save to user's database record
- On token refresh: Update database
- On logout: Remove token from database

---

### **Phase 3: Message Notification Handlers**

#### 3.1 Create Message Notification Handler (`lib/services/message_notification_handler.dart`)
Handle three notification states:
- **Foreground**: App is open - show local notification
- **Background**: App is minimized - FCM handles notification
- **Terminated**: App is closed - FCM handles notification

#### 3.2 Notification Payload Structure
```json
{
  "notification": {
    "title": "New message from John",
    "body": "Hey, how are you doing?"
  },
  "data": {
    "chatId": "chat123",
    "senderId": "user456",
    "senderName": "John Doe",
    "type": "chat_message"
  }
}
```

#### 3.3 Notification Tap Handling
- When user taps notification, navigate to the specific chat
- Handle navigation for all app states (foreground/background/terminated)

---

### **Phase 4: Backend - Cloud Functions**

#### 4.1 Setup Firebase Cloud Functions
**New file:** `functions/index.js`

#### 4.2 Create "onMessageCreate" Trigger
Trigger function when new message is added to `/chats/{chatId}/messages/`

**Function logic:**
1. Detect new message creation
2. Identify recipient (mentee or mentor)
3. Fetch recipient's FCM token from database
4. Get sender's name
5. Send push notification via FCM Admin SDK

#### 4.3 Deploy Cloud Functions
```bash
firebase init functions
firebase deploy --only functions
```

---

### **Phase 5: Code Integration**

#### 5.1 Update Main App (`lib/main.dart`)
- Initialize notification service on app startup
- Setup background message handler
- Request permissions

#### 5.2 Update Login Screens
- **`lib/screens/login/login_screen.dart`**: Save FCM token after successful login
- Handle token registration for both mentor and mentee

#### 5.3 Update Registration Screens
- Save FCM token after registration completes

#### 5.4 Update Chat Screens
- **`lib/screens/chat/single_chat_screen.dart`**: No changes needed (Cloud Function handles notifications)
- Optional: Show notification delivery status

#### 5.5 Add Logout Token Cleanup
- Remove FCM token from database on logout
- Update both mentor and mentee chat list screens

---

### **Phase 6: Testing Strategy**

#### 6.1 Test Cases
1. **Foreground notification**: Send message while recipient has app open
2. **Background notification**: Send message while recipient has app minimized
3. **Terminated notification**: Send message while recipient's app is closed
4. **Notification tap**: Verify navigation to correct chat
5. **Token refresh**: Test token updates correctly
6. **Cross-platform**: Test on both iOS and Android devices
7. **Multiple devices**: One user logged in on multiple devices

#### 6.2 Testing Tools
- Firebase Console > Cloud Messaging (manual test messages)
- Postman (test FCM API directly)
- Physical devices (iOS/Android)

---

### **Phase 7: Optimization & Polish**

#### 7.1 Notification Features
- Message preview truncation (max 100 characters)
- Badge count on app icon
- Notification sound customization
- Grouped notifications (if multiple messages)

#### 7.2 User Preferences
- Optional: Add settings screen for notification preferences
- Toggle notifications on/off
- Quiet hours

#### 7.3 Error Handling
- Handle token retrieval failures
- Retry logic for token registration
- Log notification delivery failures

---

## File Structure (New Files)

```
lib/
├── services/
│   ├── notification_service.dart          # NEW - FCM initialization & token management
│   └── message_notification_handler.dart  # NEW - Handle incoming notifications
├── utils/
│   └── notification_navigation.dart       # NEW - Navigate from notifications
└── main.dart                              # MODIFIED - Initialize notifications

functions/                                  # NEW FOLDER
├── package.json
├── index.js                               # Cloud Function for sending notifications
└── .gitignore

ios/Runner/
├── AppDelegate.swift                      # MODIFIED - iOS notification setup
└── Info.plist                             # MODIFIED - Background modes

android/app/src/main/
├── AndroidManifest.xml                    # MODIFIED - Notification permissions
└── res/drawable/
    └── notification_icon.png              # NEW - Notification icon
```

---

## Estimated Timeline

- **Phase 1 (Configuration)**: 2-3 hours
- **Phase 2 (Token Management)**: 3-4 hours  
- **Phase 3 (Handlers)**: 4-5 hours
- **Phase 4 (Cloud Functions)**: 4-6 hours
- **Phase 5 (Integration)**: 3-4 hours
- **Phase 6 (Testing)**: 4-6 hours
- **Phase 7 (Polish)**: 2-3 hours

**Total: ~25-35 hours**

---

## Prerequisites

1. Firebase project already configured ✅ (already done)
2. Firebase Blaze plan (required for Cloud Functions)
3. Apple Developer account (for APNs certificates)
4. Physical iOS and Android devices for testing

---

## Security Considerations

1. Never expose FCM server keys in client code
2. Validate message sender in Cloud Functions
3. Rate limit notifications to prevent spam
4. Sanitize notification content (remove sensitive data)
5. Use Firebase Security Rules to protect FCM tokens

---

## Next Steps

Would you like me to:
1. **Start implementing Phase 1** (add dependencies and configuration)?
2. **Create the notification service files** first?
3. **Set up the Cloud Functions** structure?
4. **Show you the detailed code** for any specific phase?

Let me know which phase you'd like to tackle first, and I'll provide the complete implementation code!

```shellscript
flutter pub add firebase_messaging
flutter pub add flutter_local_notifications
```

```xml
<key>UIBackgroundModes</key>
<array>
  <key>remote-notification</key>
</array>
```

```json
{
  "fcmToken": "device_fcm_token_here",
  "fcmTokenUpdated": 1234567890
}
```

```json
{
  "notification": {
    "title": "New message from John",
    "body": "Hey, how are you doing?"
  },
  "data": {
    "chatId": "chat123",
    "senderId": "user456",
    "senderName": "John Doe",
    "type": "chat_message"
  }
}
```

```shellscript
firebase init functions
firebase deploy --only functions
```

```plaintext
lib/
├── services/
│   ├── notification_service.dart          # NEW - FCM initialization & token management
│   └── message_notification_handler.dart  # NEW - Handle incoming notifications
├── utils/
│   └── notification_navigation.dart       # NEW - Navigate from notifications
└── main.dart                              # MODIFIED - Initialize notifications

functions/                                  # NEW FOLDER
├── package.json
├── index.js                               # Cloud Function for sending notifications
└── .gitignore

ios/Runner/
├── AppDelegate.swift                      # MODIFIED - iOS notification setup
└── Info.plist                             # MODIFIED - Background modes

android/app/src/main/
├── AndroidManifest.xml                    # MODIFIED - Notification permissions
└── res/drawable/
    └── notification_icon.png              # NEW - Notification icon
```

---

**User**

okay, I want to approach this step by step, after each step you outlined stop and let me review for testings.

---

**Cursor**

Perfect! Let's implement this step-by-step with testing breaks. I'll create a task list and start with **Phase 1: Dependencies & Configuration**.

Now let's start with **Phase 1: Dependencies & Configuration**. I'll add the required packages and set up the basic configuration for iOS and Android.

Now I'll update the necessary files for Phase 1:

```yaml
name: sheepfold
description: "BlackSheep."
# The following line prevents the package from being accidentally published to
# pub.dev using `flutter pub publish`. This is preferred for private packages.
publish_to: "none" # Remove this line if you wish to publish to pub.dev

# The following defines the version and build number for your application.
# A version number is three numbers separated by dots, like 1.2.43
# followed by an optional build number separated by a +.
# Both the version and the builder number may be overridden in flutter
# build by specifying --build-name and --build-number, respectively.
# In Android, build-name is used as versionName while build-number used as versionCode.
# Read more about Android versioning at https://developer.android.com/studio/publish/versioning
# In iOS, build-name is used as CFBundleShortVersionString while build-number is used as CFBundleVersion.
# Read more about iOS versioning at
# https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
# In Windows, build-name is used as the major, minor, and patch parts
# of the product and file versions while build-number is used as the build suffix.
version: 1.0.0+1

environment:
  sdk: ^3.8.1

# Dependencies specify other packages that your package needs in order to work.
# To automatically upgrade your package dependencies to the latest versions
# consider running `flutter pub upgrade --major-versions`. Alternatively,
# dependencies can be manually updated by changing the version numbers below to
# the latest version available on pub.dev. To see which dependencies have newer
# versions available, run `flutter pub outdated`.
dependencies:
  flutter:
    sdk: flutter

  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.8
  firebase_core: ^4.0.0
  firebase_auth: ^6.0.1
  video_player: ^2.10.0
  firebase_database: ^12.0.0
  location: ^5.0.0
  flutter_email_sender: ^8.0.0
  firebase_messaging: ^15.1.5
  flutter_local_notifications: ^18.0.1

dev_dependencies:
  flutter_test:
    sdk: flutter

  # The "flutter_lints" package below contains a set of recommended lints to
  # encourage good coding practices. The lint set provided by the package is
  # activated in the `analysis_options.yaml` file located at the root of your
  # package. See that file for information about deactivating specific lint
  # rules and activating additional ones.
  flutter_lints: ^5.0.0

# For information on the generic Dart part of this file, see the
# following page: https://dart.dev/tools/pub/pubspec

# The following section is specific to Flutter packages.
flutter:
  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true

  # To add assets to your application, add an assets section, like this:
  assets:
    - assets/images/
    - assets/videos/

  # An image asset can refer to one or more resolution-specific "variants", see
  # https://flutter.dev/to/resolution-aware-images

  # For details regarding adding assets from package dependencies, see
  # https://flutter.dev/to/asset-from-package

  # To add custom fonts to your application, add a fonts section here,
  # in this "flutter" section. Each entry in this list should have a
  # "family" key with the font family name, and a "fonts" key with a
  # list giving the asset and other descriptors for the font. For
  # example:
  # fonts:
  #   - family: Schyler
  #     fonts:
  #       - asset: fonts/Schyler-Regular.ttf
  #       - asset: fonts/Schyler-Italic.ttf
  #         style: italic
  #   - family: Trajan Pro
  #     fonts:
  #       - asset: fonts/TrajanPro.ttf
  #       - asset: fonts/TrajanPro_Bold.ttf
  #         weight: 700
  #
  # For details regarding fonts from package dependencies,
  # see https://flutter.dev/to/font-from-package
  fonts:
    - family: Now
      fonts:
        - asset: assets/fonts/now_regular.otf
    - family: Genty
      fonts:
        - asset: assets/fonts/genty_regular.ttf

```

```swift
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Request notification permissions
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Handle notification when app is in foreground
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler([.alert, .badge, .sound])
  }
}

```

```plaintext
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>$(DEVELOPMENT_LANGUAGE)</string>
	<key>CFBundleDisplayName</key>
	<string>Sheepfold</string>
	<key>CFBundleExecutable</key>
	<string>$(EXECUTABLE_NAME)</string>
	<key>CFBundleIdentifier</key>
	<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>sheepfold</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleShortVersionString</key>
	<string>$(FLUTTER_BUILD_NAME)</string>
	<key>CFBundleSignature</key>
	<string>????</string>
	<key>CFBundleVersion</key>
	<string>$(FLUTTER_BUILD_NUMBER)</string>
	<key>LSRequiresIPhoneOS</key>
	<true/>
	<key>NSLocationWhenInUseUsageDescription</key>
	<true/>
	<key>UILaunchStoryboardName</key>
	<string>LaunchScreen</string>
	<key>UIMainStoryboardFile</key>
	<string>Main</string>
	<key>UISupportedInterfaceOrientations</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
		<string>UIInterfaceOrientationLandscapeLeft</string>
		<string>UIInterfaceOrientationLandscapeRight</string>
	</array>
	<key>UISupportedInterfaceOrientations~ipad</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
		<string>UIInterfaceOrientationPortraitUpsideDown</string>
		<string>UIInterfaceOrientationLandscapeLeft</string>
		<string>UIInterfaceOrientationLandscapeRight</string>
	</array>
	<key>CADisableMinimumFrameDurationOnPhone</key>
	<true/>
	<key>UIApplicationSupportsIndirectInputEvents</key>
	<true/>
	<key>UIBackgroundModes</key>
	<array>
		<string>fetch</string>
		<string>remote-notification</string>
	</array>
	<key>FirebaseAppDelegateProxyEnabled</key>
	<false/>
</dict>
</plist>

```

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Permissions for push notifications -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
    <uses-permission android:name="android.permission.VIBRATE"/>
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
    
    <application
        android:label="sheepfold"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:taskAffinity=""
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <!-- Specifies an Android theme to apply to this Activity as soon as
                 the Android process has started. This theme is visible to the user
                 while the Flutter UI initializes. After that, this theme continues
                 to determine the Window background behind the Flutter UI. -->
            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@style/NormalTheme"
              />
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        <!-- Don't delete the meta-data below.
             This is used by the Flutter tool to generate GeneratedPluginRegistrant.java -->
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
    <!-- Required to query activities that can process text, see:
         https://developer.android.com/training/package-visibility and
         https://developer.android.com/reference/android/content/Intent#ACTION_PROCESS_TEXT.

         In particular, this is used by the Flutter engine in io.flutter.plugin.text.ProcessTextPlugin. -->
    <queries>
        <intent>
            <action android:name="android.intent.action.PROCESS_TEXT"/>
            <data android:mimeType="text/plain"/>
        </intent>
    </queries>
</manifest>

```

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Permissions for push notifications -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
    <uses-permission android:name="android.permission.VIBRATE"/>
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
    
    <application
        android:label="sheepfold"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:taskAffinity=""
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <!-- Specifies an Android theme to apply to this Activity as soon as
                 the Android process has started. This theme is visible to the user
                 while the Flutter UI initializes. After that, this theme continues
                 to determine the Window background behind the Flutter UI. -->
            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@style/NormalTheme"
              />
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        <!-- Don't delete the meta-data below.
             This is used by the Flutter tool to generate GeneratedPluginRegistrant.java -->
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
        
        <!-- Firebase Cloud Messaging -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="blacksheep_chat_channel" />
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_icon"
            android:resource="@mipmap/ic_launcher" />
    </application>
    <!-- Required to query activities that can process text, see:
         https://developer.android.com/training/package-visibility and
         https://developer.android.com/reference/android/content/Intent#ACTION_PROCESS_TEXT.

         In particular, this is used by the Flutter engine in io.flutter.plugin.text.ProcessTextPlugin. -->
    <queries>
        <intent>
            <action android:name="android.intent.action.PROCESS_TEXT"/>
            <data android:mimeType="text/plain"/>
        </intent>
    </queries>
</manifest>

```

Perfect! Now let me install the new dependencies:

Great! I've completed the configuration updates for **Phase 1**. Here's what I've done:

## ✅ Phase 1: Dependencies & Configuration - COMPLETED

### Changes Made:

#### 1. **Updated `pubspec.yaml`**
- Added `firebase_messaging: ^15.1.5`
- Added `flutter_local_notifications: ^18.0.1`

#### 2. **Updated iOS Configuration**
- **`ios/Runner/AppDelegate.swift`**: Added notification delegate setup and foreground notification handler
- **`ios/Runner/Info.plist`**: Added background modes (`fetch`, `remote-notification`) and disabled Firebase proxy

#### 3. **Updated Android Configuration**
- **`android/app/src/main/AndroidManifest.xml`**: 
  - Added notification permissions (INTERNET, POST_NOTIFICATIONS, VIBRATE, RECEIVE_BOOT_COMPLETED)
  - Added FCM metadata for default notification channel and icon

---

## 🧪 Testing Instructions for Phase 1

Before we move to Phase 2, please test that everything compiles correctly:

### Step 1: Install Dependencies
```bash
cd /Users/chrisgeorge/localdev/BLACKSHEEP/blacksheep
flutter pub get
```

### Step 2: Clean and Rebuild
```bash
flutter clean
flutter pub get
```

### Step 3: Build for iOS (if testing on iOS)
```bash
flutter build ios --debug
```
Or open in Xcode and build:
```bash
open ios/Runner.xcworkspace
```

**Note for iOS**: You'll need to:
1. Open the project in Xcode
2. Enable **Push Notifications** capability (Signing & Capabilities tab)
3. Enable **Background Modes** and check "Remote notifications"

### Step 4: Build for Android (if testing on Android)
```bash
flutter build apk --debug
```

### Step 5: Run the App
```bash
flutter run
```

The app should compile and run normally. The new packages are installed but not yet active, so there should be no functional changes yet.

---

## ⚠️ Additional iOS Setup Required (Manual)

For iOS push notifications to work, you'll need to configure APNs in your Apple Developer account:

1. **Generate APNs Key**:
   - Go to Apple Developer Console → Certificates, Identifiers & Profiles → Keys
   - Create a new key with "Apple Push Notifications service (APNs)" enabled
   - Download the `.p8` file

2. **Upload to Firebase Console**:
   - Go to Firebase Console → Project Settings → Cloud Messaging
   - Under "Apple app configuration", upload your APNs key
   - Enter your Key ID and Team ID

---

## ✅ Success Criteria

Phase 1 is complete when:
- [ ] `flutter pub get` runs without errors
- [ ] App compiles for iOS and/or Android
- [ ] App runs normally with no crashes
- [ ] No new linter errors introduced

**Let me know when you've tested and we'll move on to Phase 2: FCM Token Management!** 🚀

```shellscript
cd /Users/chrisgeorge/localdev/BLACKSHEEP/blacksheep
flutter pub get
```

```shellscript
flutter clean
flutter pub get
```

```shellscript
flutter build ios --debug
```

```shellscript
open ios/Runner.xcworkspace
```

```shellscript
flutter build apk --debug
```

```shellscript
flutter run
```

