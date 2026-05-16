# LABOUR PARTY — Product Requirements Document (PRD)
**Version:** 2.0 | **Platform:** Android Only | **Framework:** Flutter | **Status:** Ready for Development
**Package ID:** `com.roshan.labourparty` | **APK Target Size:** 10–20 MB

---

## ⚙️ SECTION 0 — AI CODING AGENT GUIDE & INSTRUCTIONS

> **READ THIS SECTION COMPLETELY BEFORE WRITING ANY CODE.**
> This section is a direct instruction set for any AI coding agent (Cursor, GitHub Copilot, Claude Code, etc.) implementing this project. Follow every rule here without exception.

### 0.1 — What You Are Building

You are building **Labour Party** — a fully offline, professional-grade Flutter application for Android. It is a personal operational management tool used daily to record labour work, track payments, manage drivers and tractors, count sand trips, and generate reports. There is no backend server, no API, no authentication, and no internet requirement. All data lives on-device in Hive boxes.

### 0.2 — Data Integrity Rules (CRITICAL — NO EXCEPTIONS)

**NEVER use mock data, placeholder data, dummy data, fake data, hardcoded sample data, or placeholder logic anywhere in the codebase.** Every screen, widget, BLoC, use case, and repository must operate exclusively on real Hive-stored data. Specifically:

- Dashboard statistics must be computed by querying actual Hive boxes in real time.
- All lists (work records, labours, drivers, tractors) must be read from the corresponding Hive box.
- Amount-per-labour must be computed as `totalAmount / labourCount` using real user-entered values.
- Sand trip counts must reflect actual saved records.
- Charts and reports must be built from aggregated real data. If there is no data yet, show the Empty State — **not** sample chart data.
- Do not seed the database with any initial fake records for testing or demonstration.

### 0.3 — State Completeness Rules

Every screen must handle all four states completely before being considered done:

1. **Loading State** — Show the skeleton loader defined in Section 12. Never show a blank white screen.
2. **Empty State** — Show the Lottie-animated empty state defined in Section 13. Include a contextual action button.
3. **Error State** — Show the error widget defined in Section 13 with the actual error message and a retry button that re-triggers the BLoC event.
4. **Data State** — Show the real UI with real data from Hive.

### 0.4 — Architecture Enforcement Rules

- Follow Clean Architecture strictly: `domain` layer has zero Flutter/Hive imports. `data` layer has zero UI imports. `presentation` layer has zero Hive imports.
- Every BLoC must emit states in this order: `Loading → Data | Empty | Error`.
- All Hive reads and writes happen exclusively inside `datasource/` classes.
- Use cases call repositories; repositories call datasources. No layer-skipping.
- Use `Equatable` on all BLoC states and events for proper equality checks.

### 0.5 — UI/UX Implementation Rules

- Implement **Material Design 3** as the base. Do not use deprecated Material 2 widgets.
- Use `flutter_animate` for all animations. Do not use raw `AnimationController` unless `flutter_animate` cannot handle it.
- Implement `glassmorphism_ui` glass cards exactly as described per screen. Every card with a glass specification must use `GlassmorphismCard` with blur ≥ 10.
- All forms must use real-time validation. No form should be submitted with empty required fields.
- All delete actions must show a `showDialog` confirmation before executing the Hive delete.
- Back navigation on all secondary screens must use the `WillPopScope` (or `PopScope` on Flutter 3.16+) to safely close overlays first.

### 0.6 — Assets & Resources Required

Before running the project, prepare the following asset files and place them in `assets/`:

**Lottie Animations** (download from LottieFiles.com — search exact terms):
- `assets/lottie/empty_work.json` — search "empty clipboard" or "no data"
- `assets/lottie/empty_labour.json` — search "empty people group"
- `assets/lottie/empty_driver.json` — search "no vehicle" or "empty truck"
- `assets/lottie/success.json` — search "success checkmark green"
- `assets/lottie/loading.json` — search "loading dots" or "progress loader"
- `assets/lottie/error.json` — search "error warning red"
- `assets/lottie/splash_logo.json` — search "construction worker" or "labour tools"
- `assets/lottie/no_report.json` — search "empty chart" or "no analytics"

**Images/Icons:**
- `assets/images/app_logo.png` — App logo (512×512, transparent background, designed with hard-hat + tools motif in deep blue and cyan)
- `assets/images/app_logo_dark.png` — Same logo adapted for dark backgrounds

**Fonts** (add to `pubspec.yaml` and download from Google Fonts):
- `Outfit` — Primary font (display, headers, titles)
- `Inter` — Body font (form labels, descriptions, values)

**All assets must be declared in `pubspec.yaml` under `flutter > assets` and `flutter > fonts` before use.**

### 0.7 — Package Versions (Pin These)

Always use pinned, compatible versions. Do not use `any` for version constraints. Resolve `flutter pub get` without conflicts before writing any feature code.

```yaml
dependencies:
  flutter_bloc: ^8.1.6
  equatable: ^2.0.5
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  path_provider: ^2.1.3
  flutter_animate: ^4.5.0
  lottie: ^3.1.2
  glassmorphism_ui: ^0.1.0+2
  intl: ^0.19.0
  uuid: ^4.4.2
  shared_preferences: ^2.2.3
  animations: ^2.0.11
  fl_chart: ^0.68.0
  shimmer: ^3.0.0
  cached_network_image: ^3.3.1   # Only for potential future avatar support
  google_fonts: ^6.2.1

dev_dependencies:
  hive_generator: ^2.0.1
  build_runner: ^2.4.11
  flutter_lints: ^4.0.0
```

---

## 1. PROJECT OVERVIEW

### 1.1 — Purpose & Context

Labour Party is a personal, fully offline operational tool built for a single user who manages daily labour-intensive fieldwork. The user oversees teams of labourers across multiple work sites, coordinates drivers and tractors, records sand transport trips, and needs to distribute daily wages fairly and automatically. The app replaces manual ledger books and scattered notes with a clean, fast, professional mobile interface.

The app is **not** intended for distribution on the Play Store, enterprise deployment, or multi-user access. It is a private productivity tool, optimised for daily use by one person.

### 1.2 — Core Problems Solved

The app solves five distinct operational pain points. First, it eliminates manual wage calculation — when a user enters a total daily amount and a labour count, the per-person wage is computed instantly. Second, it provides a permanent, searchable history of work records that a notebook cannot offer. Third, it tracks sand trip counts per driver and tractor, which directly affects driver accountability. Fourth, it consolidates all management entities (labours, drivers, tractors, places) into a single offline database rather than scattered contacts and notes. Fifth, it generates weekly and monthly financial summaries that give the user an instant picture of total expenditure without manual tallying.

---

## 2. TECHNICAL STACK

### 2.1 — Framework & Language

The entire application is written in **Dart** using the **Flutter** framework targeting Android exclusively. No platform channels to native Android code are required for the core feature set. The minimum Android API level is **26 (Android 8.0 Oreo)** and the target API level is **35 (Android 15)**.

### 2.2 — State Management

**BLoC (Business Logic Component)** pattern via the `flutter_bloc` package. Every feature domain has its own BLoC. UI widgets consume BLoC states via `BlocBuilder`, react to side effects via `BlocListener`, and combine both via `BlocConsumer` where both state rendering and side-effect handling are needed on the same widget.

### 2.3 — Local Database

**Hive** is the sole persistence layer. It is a lightweight, NoSQL, key-value store that runs entirely in memory and on local storage with no network calls. All Hive boxes are opened at app startup in `main.dart` before `runApp()` is called. TypeAdapters are generated via `hive_generator` and `build_runner`.

### 2.4 — Architecture Pattern

**Clean Architecture** with a feature-first folder structure. The three primary layers are:

- **Domain Layer** — Pure Dart. Contains entities, repository interfaces (abstract classes), and use cases. Zero dependency on Flutter SDK or Hive.
- **Data Layer** — Contains Hive model classes with TypeAdapters, concrete repository implementations, and local datasource classes.
- **Presentation Layer** — Contains BLoCs, screens, and widgets. Depends on domain use cases only.

### 2.5 — UI Libraries

Three UI libraries are used on top of Material Design 3:

**`glassmorphism_ui`** provides the frosted-glass card effect that defines the premium look of the app. It wraps child widgets in a blur-backed, semi-transparent container with a gradient border.

**`flutter_animate`** provides the declarative animation API. Every list item, card, page entry, and button uses `.animate()` extensions to define entry animations, fade effects, slide-ins, and scale transitions without boilerplate.

**`fl_chart`** provides production-quality charts for the Reports screen, replacing the generic placeholder approach. Bar charts for monthly totals and line charts for weekly trends are rendered from real aggregated Hive data.

---

## 3. APPLICATION CONFIGURATION

### 3.1 — `pubspec.yaml` Complete Configuration

```yaml
name: labour_party
description: A fully offline professional labour management app for personal use.
publish_to: 'none'  # Never publish to pub.dev

version: 1.0.0+1

environment:
  sdk: '>=3.3.0 <4.0.0'
  flutter: '>=3.22.0'

flutter:
  uses-material-design: true

  assets:
    - assets/lottie/
    - assets/images/

  fonts:
    - family: Outfit
      fonts:
        - asset: assets/fonts/Outfit-Regular.ttf
          weight: 400
        - asset: assets/fonts/Outfit-Medium.ttf
          weight: 500
        - asset: assets/fonts/Outfit-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Outfit-Bold.ttf
          weight: 700
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter-Regular.ttf
          weight: 400
        - asset: assets/fonts/Inter-Medium.ttf
          weight: 500
```

### 3.2 — `android/app/build.gradle` Configuration

```gradle
android {
    compileSdkVersion 35
    ndkVersion "25.1.8937393"

    defaultConfig {
        applicationId "com.roshan.labourparty"
        minSdkVersion 26
        targetSdkVersion 35
        versionCode 1
        versionName "1.0.0"
        multiDexEnabled true
    }

    buildTypes {
        release {
            signingConfig signingConfigs.debug
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }
}
```

### 3.3 — `AndroidManifest.xml` Configuration

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- Optional: For backup/export feature -->
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"
        android:maxSdkVersion="32" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
        android:maxSdkVersion="29" />

    <!-- For Android 13+ scoped storage -->
    <uses-permission android:name="android.permission.READ_MEDIA_DOCUMENTS" />

    <!-- Optional: For reminder notifications -->
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />

    <application
        android:label="Labour Party"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:enableOnBackInvokedCallback="true"
        android:hardwareAccelerated="true"
        android:largeHeap="false">

        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:screenOrientation="portrait"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
    </application>
</manifest>
```

### 3.4 — `proguard-rules.pro` for Hive

```pro
-keep class com.roshan.labourparty.** { *; }
-keep class * extends com.google.flatbuffers.Table { *; }
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception
```

---

## 4. DATABASE STRUCTURE (HIVE)

### 4.1 — Overview

Six Hive boxes are used. All boxes are opened at app launch. Each model class has a corresponding TypeAdapter generated by `hive_generator`. The `id` field in every model is a UUID v4 string generated by the `uuid` package at creation time — never auto-incremented integers.

### 4.2 — Box: `works`

This is the primary box. Each entry represents one complete daily work record.

```dart
@HiveType(typeId: 0)
class WorkModel extends HiveObject {
  @HiveField(0) String id;           // UUID v4
  @HiveField(1) DateTime date;       // Actual work date (not creation date)
  @HiveField(2) String workName;     // Descriptive name for the work
  @HiveField(3) String placeId;      // FK reference to places box
  @HiveField(4) double totalAmount;  // Total wage pool in INR
  @HiveField(5) int labourCount;     // Number of labourers who worked
  @HiveField(6) double amountPerLabour; // Computed: totalAmount / labourCount
  @HiveField(7) List<String> labourIds; // FK list referencing labours box
  @HiveField(8) String? driverId;    // FK reference to drivers box (nullable)
  @HiveField(9) String? tractorId;   // FK reference to tractors box (nullable)
  @HiveField(10) int sandTrips;      // Number of sand trips completed
  @HiveField(11) String? notes;      // Optional free-text notes
  @HiveField(12) DateTime createdAt; // System timestamp of record creation
  @HiveField(13) DateTime updatedAt; // System timestamp of last update
}
```

**Computed field rule:** `amountPerLabour` must always be computed as `totalAmount / labourCount` before saving. It is stored (not recomputed on read) to preserve historical accuracy if values are later edited.

### 4.3 — Box: `labours`

```dart
@HiveType(typeId: 1)
class LabourModel extends HiveObject {
  @HiveField(0) String id;           // UUID v4
  @HiveField(1) String name;         // Full name
  @HiveField(2) String? phone;       // Optional phone number (string, not int)
  @HiveField(3) String? address;     // Optional address
  @HiveField(4) bool isActive;       // Soft-delete flag (true = active)
  @HiveField(5) DateTime createdAt;
}
```

**Note:** `joinedWorks` and `totalEarned` are NOT stored in the labour box. They are computed at runtime by querying the `works` box and filtering records where `labourIds` contains this labour's `id`. This prevents data inconsistency.

### 4.4 — Box: `drivers`

```dart
@HiveType(typeId: 2)
class DriverModel extends HiveObject {
  @HiveField(0) String id;           // UUID v4
  @HiveField(1) String name;         // Driver's full name
  @HiveField(2) String? phone;       // Optional phone
  @HiveField(3) String? licenseNumber; // Optional license
  @HiveField(4) bool isActive;       // Soft-delete flag
  @HiveField(5) DateTime createdAt;
}
```

### 4.5 — Box: `tractors`

```dart
@HiveType(typeId: 3)
class TractorModel extends HiveObject {
  @HiveField(0) String id;           // UUID v4
  @HiveField(1) String name;         // Tractor identifier name
  @HiveField(2) String? registrationNumber;
  @HiveField(3) String? assignedDriverId; // FK to drivers box (nullable)
  @HiveField(4) bool isActive;
  @HiveField(5) DateTime createdAt;
}
```

### 4.6 — Box: `places`

```dart
@HiveType(typeId: 4)
class PlaceModel extends HiveObject {
  @HiveField(0) String id;           // UUID v4
  @HiveField(1) String name;         // Place/location name
  @HiveField(2) String? description; // Optional notes about location
  @HiveField(3) bool isActive;
  @HiveField(4) DateTime createdAt;
}
```

### 4.7 — Box: `settings`

```dart
@HiveType(typeId: 5)
class SettingsModel extends HiveObject {
  @HiveField(0) bool isDarkMode;        // Default: true
  @HiveField(1) bool animationsEnabled; // Default: true
  @HiveField(2) String currencySymbol;  // Default: "₹"
  @HiveField(3) String dateFormat;      // Default: "dd/MM/yyyy"
  @HiveField(4) String? userName;       // Optional: user's name for greeting
}
```

### 4.8 — Hive Box Keys & Registration Order

Open boxes in this exact order in `main.dart` to avoid TypeAdapter conflicts:

```dart
// Register adapters first
Hive.registerAdapter(WorkModelAdapter());     // typeId: 0
Hive.registerAdapter(LabourModelAdapter());   // typeId: 1
Hive.registerAdapter(DriverModelAdapter());   // typeId: 2
Hive.registerAdapter(TractorModelAdapter());  // typeId: 3
Hive.registerAdapter(PlaceModelAdapter());    // typeId: 4
Hive.registerAdapter(SettingsModelAdapter()); // typeId: 5

// Then open boxes
await Hive.openBox<WorkModel>('works');
await Hive.openBox<LabourModel>('labours');
await Hive.openBox<DriverModel>('drivers');
await Hive.openBox<TractorModel>('tractors');
await Hive.openBox<PlaceModel>('places');
await Hive.openBox<SettingsModel>('settings');
```

---

## 5. COMPLETE FOLDER STRUCTURE

```
lib/
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart          # Color palette constants
│   │   ├── app_typography.dart      # TextStyle definitions
│   │   ├── app_spacing.dart         # Spacing constants (8, 12, 16, 24, 32)
│   │   ├── app_strings.dart         # All user-visible strings
│   │   ├── app_durations.dart       # Animation duration constants
│   │   └── hive_box_names.dart      # Box name string constants
│   │
│   ├── errors/
│   │   ├── failures.dart            # Failure sealed class hierarchy
│   │   └── exceptions.dart          # Custom exception types
│   │
│   ├── theme/
│   │   ├── app_theme.dart           # ThemeData (light & dark)
│   │   ├── color_scheme.dart        # Material 3 ColorScheme definitions
│   │   └── text_theme.dart          # Complete TextTheme with Outfit/Inter
│   │
│   └── utils/
│       ├── date_formatter.dart      # Date formatting helpers
│       ├── currency_formatter.dart  # INR formatting helpers
│       ├── validators.dart          # Form validation functions
│       └── hive_helpers.dart        # Common Hive query helpers
│
├── data/
│   ├── datasources/
│   │   ├── work_local_datasource.dart
│   │   ├── labour_local_datasource.dart
│   │   ├── driver_local_datasource.dart
│   │   ├── tractor_local_datasource.dart
│   │   ├── place_local_datasource.dart
│   │   └── settings_local_datasource.dart
│   │
│   ├── models/
│   │   ├── work_model.dart          # + work_model.g.dart (generated)
│   │   ├── labour_model.dart        # + labour_model.g.dart (generated)
│   │   ├── driver_model.dart        # + driver_model.g.dart (generated)
│   │   ├── tractor_model.dart       # + tractor_model.g.dart (generated)
│   │   ├── place_model.dart         # + place_model.g.dart (generated)
│   │   └── settings_model.dart      # + settings_model.g.dart (generated)
│   │
│   └── repositories/
│       ├── work_repository_impl.dart
│       ├── labour_repository_impl.dart
│       ├── driver_repository_impl.dart
│       ├── tractor_repository_impl.dart
│       ├── place_repository_impl.dart
│       └── settings_repository_impl.dart
│
├── domain/
│   ├── entities/
│   │   ├── work_entity.dart         # Pure Dart class, no Hive annotations
│   │   ├── labour_entity.dart
│   │   ├── driver_entity.dart
│   │   ├── tractor_entity.dart
│   │   ├── place_entity.dart
│   │   └── settings_entity.dart
│   │
│   ├── repositories/
│   │   ├── work_repository.dart     # Abstract interface
│   │   ├── labour_repository.dart
│   │   ├── driver_repository.dart
│   │   ├── tractor_repository.dart
│   │   ├── place_repository.dart
│   │   └── settings_repository.dart
│   │
│   └── usecases/
│       ├── work/
│       │   ├── add_work_usecase.dart
│       │   ├── update_work_usecase.dart
│       │   ├── delete_work_usecase.dart
│       │   ├── get_all_works_usecase.dart
│       │   ├── get_work_by_id_usecase.dart
│       │   ├── get_works_by_date_range_usecase.dart
│       │   └── search_works_usecase.dart
│       ├── labour/
│       │   ├── add_labour_usecase.dart
│       │   ├── update_labour_usecase.dart
│       │   ├── delete_labour_usecase.dart
│       │   ├── get_all_labours_usecase.dart
│       │   └── get_labour_stats_usecase.dart
│       ├── driver/
│       │   ├── add_driver_usecase.dart
│       │   ├── update_driver_usecase.dart
│       │   ├── delete_driver_usecase.dart
│       │   └── get_all_drivers_usecase.dart
│       ├── tractor/
│       │   ├── add_tractor_usecase.dart
│       │   ├── update_tractor_usecase.dart
│       │   ├── delete_tractor_usecase.dart
│       │   └── get_all_tractors_usecase.dart
│       ├── place/
│       │   ├── add_place_usecase.dart
│       │   ├── delete_place_usecase.dart
│       │   └── get_all_places_usecase.dart
│       └── reports/
│           ├── get_daily_report_usecase.dart
│           ├── get_weekly_report_usecase.dart
│           └── get_monthly_report_usecase.dart
│
├── presentation/
│   ├── blocs/
│   │   ├── work/
│   │   │   ├── work_bloc.dart
│   │   │   ├── work_event.dart
│   │   │   └── work_state.dart
│   │   ├── labour/
│   │   │   ├── labour_bloc.dart
│   │   │   ├── labour_event.dart
│   │   │   └── labour_state.dart
│   │   ├── driver/
│   │   │   ├── driver_bloc.dart
│   │   │   ├── driver_event.dart
│   │   │   └── driver_state.dart
│   │   ├── tractor/
│   │   │   ├── tractor_bloc.dart
│   │   │   ├── tractor_event.dart
│   │   │   └── tractor_state.dart
│   │   ├── place/
│   │   │   ├── place_bloc.dart
│   │   │   ├── place_event.dart
│   │   │   └── place_state.dart
│   │   ├── reports/
│   │   │   ├── reports_bloc.dart
│   │   │   ├── reports_event.dart
│   │   │   └── reports_state.dart
│   │   └── settings/
│   │       ├── settings_bloc.dart
│   │       ├── settings_event.dart
│   │       └── settings_state.dart
│   │
│   ├── screens/
│   │   ├── splash/
│   │   │   └── splash_screen.dart
│   │   ├── main/
│   │   │   └── main_shell_screen.dart   # Shell with BottomNav + Drawer
│   │   ├── dashboard/
│   │   │   └── dashboard_screen.dart
│   │   ├── work/
│   │   │   ├── work_records_screen.dart
│   │   │   ├── add_work_screen.dart
│   │   │   ├── edit_work_screen.dart
│   │   │   └── work_detail_screen.dart
│   │   ├── labour/
│   │   │   ├── labour_screen.dart
│   │   │   ├── add_labour_screen.dart
│   │   │   └── edit_labour_screen.dart
│   │   ├── driver/
│   │   │   ├── drivers_screen.dart
│   │   │   ├── add_driver_screen.dart
│   │   │   └── edit_driver_screen.dart
│   │   ├── tractor/
│   │   │   ├── tractors_screen.dart
│   │   │   ├── add_tractor_screen.dart
│   │   │   └── edit_tractor_screen.dart
│   │   ├── place/
│   │   │   ├── places_screen.dart
│   │   │   └── add_place_screen.dart
│   │   ├── reports/
│   │   │   └── reports_screen.dart
│   │   ├── settings/
│   │   │   └── settings_screen.dart
│   │   └── about/
│   │       └── about_screen.dart
│   │
│   └── widgets/
│       ├── common/
│       │   ├── glass_card.dart            # Glassmorphism wrapper widget
│       │   ├── gradient_scaffold.dart     # Scaffold with gradient background
│       │   ├── app_drawer.dart            # Hamburger drawer widget
│       │   ├── app_bottom_nav.dart        # Bottom navigation bar
│       │   ├── primary_button.dart        # Styled primary CTA button
│       │   ├── secondary_button.dart      # Outlined secondary button
│       │   ├── danger_button.dart         # Red delete-action button
│       │   ├── custom_app_bar.dart        # App bar with back arrow
│       │   ├── section_header.dart        # Section title + subtitle
│       │   └── confirmation_dialog.dart   # Delete confirmation dialog
│       ├── states/
│       │   ├── empty_state_widget.dart    # Lottie + message + action
│       │   ├── error_state_widget.dart    # Error icon + message + retry
│       │   └── skeleton_loader.dart       # Shimmer skeleton variants
│       ├── forms/
│       │   ├── app_text_field.dart        # Styled Material 3 text field
│       │   ├── app_dropdown.dart          # Styled dropdown menu
│       │   ├── date_picker_field.dart     # Date picker with field display
│       │   ├── labour_multi_select.dart   # Multi-select labour chip picker
│       │   └── amount_display_card.dart   # Live amount-per-labour display
│       └── dashboard/
│           ├── stat_card.dart             # Glassmorphism stat card
│           ├── quick_action_button.dart   # Dashboard quick action grid button
│           └── activity_timeline.dart     # Recent activity timeline widget
│
├── routes/
│   ├── app_router.dart             # Named route definitions
│   └── route_names.dart            # String constants for route names
│
└── main.dart                       # Entry point, Hive init, app bootstrap
```

---

## 6. NAVIGATION STRUCTURE

### 6.1 — Route Map

```
SplashScreen (/)
    └──▶ MainShellScreen (/main) [replaces splash after 3s]
              │
              ├── BottomNavBar Tab 0 ──▶ DashboardScreen
              ├── BottomNavBar Tab 1 ──▶ WorkRecordsScreen
              ├── BottomNavBar Tab 2 ──▶ LabourScreen
              └── BottomNavBar Tab 3 ──▶ ReportsScreen

              Drawer (Hamburger) opens from MainShellScreen:
              ├── Dashboard         ──▶ Tab 0 (same as BottomNav)
              ├── All Works         ──▶ Tab 1 (same as BottomNav)
              ├── Labour            ──▶ Tab 2 (same as BottomNav)
              ├── Drivers           ──▶ /drivers
              ├── Tractors          ──▶ /tractors
              ├── Places            ──▶ /places
              ├── Reports           ──▶ Tab 3 (same as BottomNav)
              ├── Backup & Restore  ──▶ /settings (scrolls to backup section)
              ├── Settings          ──▶ /settings
              └── About             ──▶ /about

Secondary screens (all have back arrow, top-left):
/work/add          ──▶ AddWorkScreen
/work/edit/:id     ──▶ EditWorkScreen
/work/detail/:id   ──▶ WorkDetailScreen
/labour/add        ──▶ AddLabourScreen
/labour/edit/:id   ──▶ EditLabourScreen
/drivers           ──▶ DriversScreen
/drivers/add       ──▶ AddDriverScreen
/drivers/edit/:id  ──▶ EditDriverScreen
/tractors          ──▶ TractorsScreen
/tractors/add      ──▶ AddTractorScreen
/tractors/edit/:id ──▶ EditTractorScreen
/places            ──▶ PlacesScreen
/places/add        ──▶ AddPlaceScreen
/settings          ──▶ SettingsScreen
/about             ──▶ AboutScreen
```

### 6.2 — Back Navigation Behaviour

Every secondary screen wraps its `Scaffold` in a `PopScope` widget with `canPop: false` and an `onPopInvoked` callback. The callback checks: if a bottom sheet is open, close it first; if a dialog is open, dismiss it first; otherwise navigate back using `Navigator.of(context).pop()`. This prevents accidental data loss on forms and ensures overlay dismissal is handled gracefully.

---

## 7. COMPLETE APP WORKFLOW DIAGRAM

```
USER OPENS APP
      │
      ▼
[SPLASH SCREEN]
 Logo animation (2.5s)
 Hive boxes verify open
      │
      ▼
[MAIN SHELL] ◄──────────────────────────────────────┐
 BottomNav + Drawer                                  │
      │                                              │
      ├──[TAB: DASHBOARD]                            │
      │       │                                      │
      │       ├── View today's stats (real Hive data)│
      │       ├── Tap "Add Work" ──▶ [ADD WORK] ──┐  │
      │       ├── Tap "Add Labour" ─▶ [ADD LABOUR]│  │
      │       ├── Tap stat card ──▶ [WORK RECORDS]│  │
      │       └── View recent activity timeline   │  │
      │                                           │  │
      ├──[TAB: WORK RECORDS]  ◄───────────────────┘  │
      │       │                                       │
      │       ├── Search / filter by date/place/driver│
      │       ├── Tap record ──▶ [WORK DETAIL]        │
      │       │       ├── View full record             │
      │       │       ├── Edit ──▶ [EDIT WORK]         │
      │       │       └── Delete (with confirmation)   │
      │       ├── Swipe left ──▶ Delete               │
      │       ├── Swipe right ──▶ Edit                │
      │       └── FAB ──▶ [ADD WORK]                  │
      │                                               │
      ├──[TAB: LABOUR]                                │
      │       │                                       │
      │       ├── List all labours (active)            │
      │       ├── View stats (computed from works box) │
      │       ├── Tap labour ──▶ Labour detail sheet   │
      │       ├── Edit/Delete labour                   │
      │       └── FAB ──▶ [ADD LABOUR]                │
      │                                               │
      └──[TAB: REPORTS]                               │
              │                                       │
              ├── Daily / Weekly / Monthly tabs        │
              ├── Charts built from real Hive data     │
              └── Summary statistics                   │
                                                       │
[DRAWER NAVIGATION]                                    │
      ├── Drivers ──▶ [DRIVERS SCREEN]                 │
      │       └── FAB ──▶ [ADD DRIVER]                 │
      ├── Tractors ──▶ [TRACTORS SCREEN]               │
      │       └── FAB ──▶ [ADD TRACTOR]                │
      ├── Places ──▶ [PLACES SCREEN]                   │
      │       └── FAB ──▶ [ADD PLACE]                  │
      ├── Settings ──▶ [SETTINGS SCREEN] ──────────────┘
      └── About ──▶ [ABOUT SCREEN]

[ADD WORK SCREEN] (Key workflow)
      │
      ├── Enter: Work Name, Date, Place (dropdown from places box)
      ├── Select: Labourers (multi-select from labours box)
      │       └── labourCount auto-updates from selection count
      ├── Enter: Total Amount
      │       └── amountPerLabour auto-computes live (totalAmount / labourCount)
      ├── Select: Driver (dropdown from drivers box, optional)
      ├── Select: Tractor (dropdown from tractors box, optional)
      ├── Enter: Sand Trips (integer stepper)
      ├── Enter: Notes (optional)
      └── Save ──▶ WorkModel saved to Hive ──▶ back to Work Records
```

---

## 8. UI/UX DESIGN SYSTEM

### 8.1 — Color Palette

The design uses a rich, industrial dark theme as its primary mode, reflecting the professional, blue-collar nature of the app.

```dart
// Primary & Brand
const Color primaryDeepBlue    = Color(0xFF0D47A1);   // Deep royal blue
const Color primaryBrightBlue  = Color(0xFF1565C0);   // Slightly lighter blue
const Color accentCyan         = Color(0xFF00BCD4);   // Cyan accent
const Color accentCyanLight    = Color(0xFF4DD0E1);   // Light cyan

// Backgrounds (Dark Theme)
const Color backgroundDeep     = Color(0xFF060B18);   // Almost black with blue tint
const Color backgroundCard     = Color(0xFF0D1B2E);   // Dark blue-grey card bg
const Color backgroundSurface  = Color(0xFF112240);   // Elevated surface

// Glass Effect
const Color glassWhite         = Color(0x1AFFFFFF);   // 10% white — glass fill
const Color glassBorder        = Color(0x33FFFFFF);   // 20% white — glass border

// Status Colors
const Color successGreen       = Color(0xFF00E676);   // Bright green
const Color warningAmber       = Color(0xFFFFAB40);   // Amber
const Color errorRed           = Color(0xFFEF5350);   // Red
const Color infoBlue           = Color(0xFF40C4FF);   // Light blue

// Text Colors
const Color textPrimary        = Color(0xFFF0F4FF);   // Near-white
const Color textSecondary      = Color(0xFF90A4C0);   // Muted blue-grey
const Color textDisabled       = Color(0xFF445568);   // Dark muted

// Gradient definitions
const LinearGradient splashGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF060B18), Color(0xFF0D2040), Color(0xFF0A1628)],
);

const LinearGradient cardGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF1A2E4A), Color(0xFF0D1B2E)],
);

const LinearGradient accentGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [Color(0xFF0D47A1), Color(0xFF00BCD4)],
);
```

### 8.2 — Typography System

```dart
// Using Outfit for display/headers, Inter for body
const TextStyle displayLarge = TextStyle(
  fontFamily: 'Outfit',
  fontSize: 32, fontWeight: FontWeight.w700,
  letterSpacing: -0.5, color: textPrimary,
);
const TextStyle headlineLarge = TextStyle(
  fontFamily: 'Outfit',
  fontSize: 24, fontWeight: FontWeight.w700,
  letterSpacing: -0.3, color: textPrimary,
);
const TextStyle headlineMedium = TextStyle(
  fontFamily: 'Outfit',
  fontSize: 20, fontWeight: FontWeight.w600,
  letterSpacing: -0.2, color: textPrimary,
);
const TextStyle titleLarge = TextStyle(
  fontFamily: 'Outfit',
  fontSize: 18, fontWeight: FontWeight.w600,
  color: textPrimary,
);
const TextStyle bodyLarge = TextStyle(
  fontFamily: 'Inter',
  fontSize: 16, fontWeight: FontWeight.w400,
  color: textPrimary,
);
const TextStyle bodyMedium = TextStyle(
  fontFamily: 'Inter',
  fontSize: 14, fontWeight: FontWeight.w400,
  color: textSecondary,
);
const TextStyle labelLarge = TextStyle(
  fontFamily: 'Inter',
  fontSize: 14, fontWeight: FontWeight.w500,
  letterSpacing: 0.1, color: textPrimary,
);
const TextStyle moneyDisplay = TextStyle(
  fontFamily: 'Outfit',
  fontSize: 28, fontWeight: FontWeight.w700,
  color: accentCyan, letterSpacing: -1.0,
);
```

### 8.3 — Glass Card Component Specification

The `GlassCard` widget is the signature UI element of this app. It appears on every major screen.

```
Construction:
  └── Container
        ├── Background: Color(0x1AFFFFFF)  — semi-transparent white
        ├── BackdropFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12)
        ├── Border: Border.all(color: Color(0x33FFFFFF), width: 1.0)
        ├── BorderRadius: BorderRadius.circular(20)
        └── BoxShadow: [
              BoxShadow(
                color: Color(0x26000000),  // 15% black
                blurRadius: 20,
                spreadRadius: -4,
                offset: Offset(0, 8),
              ),
              BoxShadow(
                color: Color(0x1A0D47A1),  // 10% primary blue
                blurRadius: 30,
                spreadRadius: -8,
                offset: Offset(0, 12),
              )
            ]
```

### 8.4 — Spacing System

Use only these spacing values, defined as constants in `app_spacing.dart`:

- `xs` = 4.0
- `sm` = 8.0
- `md` = 12.0
- `lg` = 16.0
- `xl` = 20.0
- `xxl` = 24.0
- `xxxl` = 32.0

### 8.5 — Elevation & Depth Layers

Layer 0 — Background: gradient fill, no elevation.
Layer 1 — Glass cards: blur + 20px shadow, the primary content layer.
Layer 2 — Bottom sheets and dialogs: 40px shadow with dark overlay.
Layer 3 — FAB and action buttons: 24px shadow with accent glow.
Layer 4 — Snackbars and toasts: always on top, 8px shadow.

---

## 9. ANIMATION SYSTEM

### 9.1 — Duration Constants

```dart
const Duration animFast    = Duration(milliseconds: 200);
const Duration animNormal  = Duration(milliseconds: 350);
const Duration animSlow    = Duration(milliseconds: 500);
const Duration animVerySlow = Duration(milliseconds: 800);
const Duration pageTransit = Duration(milliseconds: 400);
```

### 9.2 — Standard Entry Animations (via flutter_animate)

Every list item that appears on screen uses a staggered entry pattern. Apply these animations consistently:

```dart
// List item entry (staggered by index)
widget
  .animate(delay: Duration(milliseconds: 80 * index))
  .fadeIn(duration: animNormal)
  .slideY(begin: 0.15, end: 0, duration: animNormal, curve: Curves.easeOutCubic);

// Card entry (dashboard stats)
widget
  .animate()
  .fadeIn(duration: animSlow)
  .scale(begin: const Offset(0.92, 0.92), end: const Offset(1, 1), duration: animNormal, curve: Curves.easeOutBack);

// Page entrance
widget
  .animate()
  .fadeIn(duration: animSlow)
  .slideY(begin: 0.05, end: 0, duration: animSlow, curve: Curves.easeOutCubic);
```

### 9.3 — Page Transitions

Use the `animations` package's `SharedAxisTransition` with `SharedAxisTransitionType.horizontal` for all named route pushes. Set this globally in `MaterialApp.onGenerateRoute`.

### 9.4 — Amount Calculation Animation

When the user types the total amount or changes the labour count on the Add Work screen, the `amountPerLabour` display card must animate its number change using a counter animation — the value counts up or down to the new computed value over 400ms.

### 9.5 — FAB Animation

The floating action button on list screens uses a `ScaleTransition` that appears after the list has loaded (300ms delay) to avoid visual competition with list item entry animations.

---

## 10. SCREEN-BY-SCREEN SPECIFICATION

---

### SCREEN 1 — Splash Screen

**Route:** `/` (initial route)
**File:** `lib/presentation/screens/splash/splash_screen.dart`
**Purpose:** Brand impression, Hive verification, navigation gating.

**Layout:**

The screen fills the entire display with the `splashGradient` background. A `Column` with `MainAxisAlignment.center` contains three elements: a Lottie animation widget, the app name text, and a tagline.

The Lottie animation (`assets/lottie/splash_logo.json`) plays at the center with dimensions 180×180. Below it, the text "Labour Party" is rendered in `displayLarge` style with a subtle glow effect achieved via a `Text` widget wrapped in a `ShaderMask` using `accentGradient`. Below the title, the tagline "Work Smart. Pay Fair." is rendered in `bodyMedium` with `textSecondary` colour.

At the very bottom of the screen (bottom-safe-area), the version string "v1.0.0" is shown in `bodyMedium`.

**Animations:**

The Lottie animation begins immediately. After 0ms delay: Lottie fades in. After 300ms delay: app name slides up from `Offset(0, 0.3)` with fade. After 500ms delay: tagline fades in. The total display lasts 2,800ms before navigation.

**Logic:**

During the 2,800ms display, the screen verifies that all Hive boxes are open and readable. If Hive initialisation has already completed in `main.dart` (which it always does before `runApp()`), this is a non-blocking check that takes < 5ms. After 2,800ms, navigate to `MainShellScreen` using `Navigator.pushReplacementNamed(context, RouteNames.main)` — this replaces the splash so the user cannot navigate back to it.

**No loading spinner is shown** — the Lottie animation itself provides the visual loading feedback.

---

### SCREEN 2 — Main Shell Screen

**Route:** `/main`
**File:** `lib/presentation/screens/main/main_shell_screen.dart`
**Purpose:** Host container for bottom navigation and drawer.

**Layout:**

This is a `Scaffold` with `drawer: AppDrawer()` and `bottomNavigationBar: AppBottomNav()`. The body is an `IndexedStack` containing four screens: `DashboardScreen`, `WorkRecordsScreen`, `LabourScreen`, and `ReportsScreen`. An `IndexedStack` is used (not `PageView`) to preserve the scroll position and BLoC state of each tab when the user switches tabs.

**Bottom Navigation Bar:**

Four tabs with icons and labels. Use `NavigationBar` (Material 3) — not `BottomNavigationBar` (Material 2).

- Tab 0: Icon `Icons.dashboard_rounded`, label "Dashboard"
- Tab 1: Icon `Icons.work_history_rounded`, label "Works"
- Tab 2: Icon `Icons.people_alt_rounded`, label "Labour"
- Tab 3: Icon `Icons.bar_chart_rounded`, label "Reports"

The `NavigationBar` uses `backgroundColor: backgroundCard` with `indicatorColor: accentCyan.withOpacity(0.2)` and `labelBehavior: NavigationDestinationLabelBehavior.alwaysShow`.

**Hamburger Drawer (AppDrawer):**

The drawer opens from the left with a `Drawer` widget. Its `child` is a `GradientScaffold` wrapping a `Column`:

- Header section: Lottie `splash_logo.json` (60×60), "Labour Party" title, "Personal Work Manager" subtitle. All on `backgroundDeep`.
- Divider.
- Navigation items (ListTile with leading Icon):
  - Dashboard (home_rounded)
  - All Works (work_history_rounded)
  - Labour (people_alt_rounded)
  - Drivers (drive_eta_rounded)
  - Tractors (agriculture_rounded)
  - Places (location_on_rounded)
  - Reports (analytics_rounded)
- Divider.
- Settings (settings_rounded)
- Backup & Restore (cloud_sync_rounded — even offline, the icon is appropriate)
- About (info_rounded)

Each drawer ListTile, when tapped, closes the drawer first with `Navigator.pop(context)`, then navigates to the appropriate screen/tab.

---

### SCREEN 3 — Dashboard Screen

**Route:** (no named route — loaded as Tab 0 in IndexedStack)
**File:** `lib/presentation/screens/dashboard/dashboard_screen.dart`
**BLoC:** `WorkBloc`, `LabourBloc`, `DriverBloc`
**Purpose:** Real-time operational overview of today's activities.

**App Bar:**

A custom `SliverAppBar` with `expandedHeight: 120`. The expanded portion shows a greeting: "Good [Morning/Afternoon/Evening]," followed by the user's name from settings (or "Boss" if not set), and today's date formatted as "Saturday, 16 May 2026". The collapsed portion shows just "Dashboard". The hamburger icon is placed at the leading position and opens the drawer.

**Data Loaded:**

All four stat cards pull from real Hive data queried through the `WorkBloc` with a `LoadDashboardDataEvent` that is dispatched in `initState`. The BLoC computes:

- Today's work count: `worksBox.values.where((w) => isSameDay(w.date, today)).length`
- Today's active labour count: union of all `labourIds` from today's work records
- Today's total sand trips: sum of `sandTrips` from today's work records
- Today's total amount: sum of `totalAmount` from today's work records
- Active drivers: unique `driverIds` from today's work records

**Skeleton Loading State:**

While the BLoC is in loading state, show four `ShimmerCard` widgets (same dimensions as stat cards) followed by shimmer rectangles for the quick action section and the activity timeline.

**Empty State:**

If no work records exist at all (not just today), show the empty state below the stat cards (which show zeros) with the `empty_work.json` Lottie, message "No work records yet", and an "Add First Work" button that navigates to `/work/add`.

**Stat Cards Section:**

Four `GlassCard` widgets arranged in a 2×2 `GridView` with `crossAxisCount: 2`, `crossAxisSpacing: 12`, `mainAxisSpacing: 12`, `childAspectRatio: 1.3`.

**Card 1 — Today's Works:**
Icon: `work_rounded` in cyan. Large number from real data. Subtitle: "Work entries today". Bottom: small bar showing percentage relative to this week's average (computed from real data).

**Card 2 — Sand Trips:**
Icon: `local_shipping_rounded` in amber. Total sand trips from today's records. Subtitle: "Trips recorded today".

**Card 3 — Total Amount:**
Icon: `currency_rupee_rounded` in green. Sum of all today's `totalAmount` values formatted as "₹X,XXX". Subtitle: "Total wages today".

**Card 4 — Labour Active:**
Icon: `people_alt_rounded` in blue. Unique labour count from today. Subtitle: "Labourers today".

**Quick Action Section:**

Section header: "Quick Actions". A horizontal `SingleChildScrollView` containing four `QuickActionButton` widgets. Each is a `GlassCard` containing an icon and label:

- Add Work → navigates to `/work/add`
- Add Labour → navigates to `/labour/add`
- Add Driver → navigates to `/drivers/add`
- View Reports → switches to Reports tab (index 3)

**Recent Activities Timeline:**

Section header: "Recent Activities". A `ListView.builder` (non-scrollable, `shrinkWrap: true`, inside the parent `CustomScrollView`) showing the last 8 work records sorted by `createdAt` descending. Each item is an `ActivityTimelineItem` widget with a vertical timeline connector line, a coloured dot, and a card showing work name, date, amount, and labour count. Tapping any item navigates to `WorkDetailScreen` with the work's ID.

---

### SCREEN 4 — Work Records Screen

**Route:** (Tab 1 in IndexedStack) + `/work` from drawer
**File:** `lib/presentation/screens/work/work_records_screen.dart`
**BLoC:** `WorkBloc`
**Purpose:** Browse, search, filter, and manage all work records.

**App Bar:**

A `SliverAppBar` with a search field in the bottom. The search field is an `AppTextField` that triggers `SearchWorksEvent` on every keystroke with 300ms debounce. The leading is the hamburger icon. A filter `IconButton` opens the filter bottom sheet.

**Filter Bottom Sheet:**

A `DraggableScrollableSheet` with `initialChildSize: 0.55`. Contains:

- Date range picker (start date, end date using `showDateRangePicker`)
- Place dropdown (all places from Hive)
- Driver dropdown (all drivers from Hive)
- "Apply Filter" primary button + "Clear Filter" text button

On apply, dispatches `FilterWorksEvent` to `WorkBloc` with the selected criteria. The BLoC filters the Hive results in-memory and emits a new `WorksLoadedState`.

**Work Record Card:**

Each work record is displayed as a `GlassCard` with the following content layout:

- Top row: Work name (titleLarge), Date formatted as "Mon, 12 May" (bodyMedium, right-aligned)
- Second row: Place icon + place name (bodyMedium)
- Divider
- Bottom row: Three chips: "₹X,XXX total", "N labour", "N trips"
- If driver assigned: Driver icon + driver name

**Swipe Actions:**

Each card is wrapped in a `Dismissible` widget:
- Swipe left (background: red) → shows confirmation dialog → if confirmed, dispatches `DeleteWorkEvent`
- Swipe right (background: blue) → navigates to `EditWorkScreen`

**FAB:**

A `FloatingActionButton.extended` with label "Add Work" and icon `add_rounded`. Navigates to `/work/add`. The FAB hides when the user scrolls down (using a `ScrollController` and `AnimatedSlide`) and reappears when scrolling up.

**Loading State:** Shimmer list of 6 skeleton cards.

**Empty State (no records at all):** `empty_work.json` Lottie, "No work records yet", "Add Work" button.

**Empty State (search returned nothing):** `empty_work.json` Lottie, "No results for '[query]'", "Clear Search" button.

**Error State:** Error icon, actual error message from BLoC state, "Retry" button that re-dispatches `LoadAllWorksEvent`.

---

### SCREEN 5 — Add Work Screen

**Route:** `/work/add`
**File:** `lib/presentation/screens/work/add_work_screen.dart`
**BLoC:** `WorkBloc`, `LabourBloc`, `DriverBloc`, `TractorBloc`, `PlaceBloc`
**Purpose:** Create a new work record with full validation and live calculation.

**App Bar:**

Custom app bar with back arrow (top-left, `Navigator.pop()`), title "Add Work Record", and no actions. Tapping back shows a `showDialog` confirmation if any field has been filled: "Discard changes? Your progress will be lost." with "Discard" and "Keep Editing" buttons.

**Form Layout:**

The entire screen is a `SingleChildScrollView` wrapping a `Form` with a `GlobalKey<FormState>`. The form is divided into visually separated `GlassCard` sections:

**Section 1 — Work Information Card:**
- `DatePickerField` labeled "Work Date" — opens Material 3 `showDatePicker`. Defaults to today. Required.
- `AppTextField` labeled "Work Name" — e.g., "Foundation digging - Plot 14". Required. MaxLength: 100.
- `AppDropdown` labeled "Place of Work" — loads all active `PlaceModel` values from `PlaceBloc`. Required. Has a "+" icon button that opens `AddPlaceScreen` as a modal bottom sheet (the work form stays open behind it). After adding a place, the dropdown refreshes.

**Section 2 — Labour Details Card:**

- `LabourMultiSelect` widget — a custom chip-based multi-select. It shows all active labours from `LabourBloc` as selectable chips in a Wrap layout. Selected labours are highlighted in `accentCyan`. Tapping a chip toggles selection. Required (at least 1 must be selected).
- `labourCount` display: A read-only field showing the count of currently selected labours (auto-updated as chips are toggled). Label: "Total Labourers".
- A "+" icon next to the section header opens `AddLabourScreen` as a modal bottom sheet for quick-adding a new labourer without leaving the form.

**Section 3 — Payment Details Card:**

- `AppTextField` labeled "Total Amount (₹)" — numeric keyboard, decimal allowed. Required. Minimum value: 1.
- `AmountDisplayCard` — a live-updating card below the amount field. Shows:
  - "₹[totalAmount] ÷ [labourCount] labourers = ₹[amountPerLabour] per person"
  - All three values animate their number display when they change.
  - If `labourCount` is 0, shows "Select at least 1 labourer to calculate" in amber.

**Section 4 — Vehicle Details Card (Optional):**

- `AppDropdown` labeled "Driver Name" — loads from `DriverBloc`. Optional. Has a "+" icon for quick-add driver.
- `AppDropdown` labeled "Tractor" — loads from `TractorBloc`. Optional. Has a "+" icon for quick-add tractor.

**Section 5 — Work Details Card:**

- Sand Trips row: Label "Sand Trips", a minus `IconButton`, the current count in large `titleLarge` style, a plus `IconButton`. The count starts at 0 and cannot go below 0.
- `AppTextField` labeled "Notes" — optional, multiline (maxLines: 4), 500 char max.

**Save Button:**

A full-width `PrimaryButton` labeled "Save Work Record" at the bottom (outside the scroll, pinned above the keyboard). On tap, `Form.validate()` is called. If valid, dispatches `AddWorkEvent` with a newly constructed `WorkModel` where `id` = `const Uuid().v4()`, `amountPerLabour` = `totalAmount / labourCount`, `createdAt` = `DateTime.now()`, `updatedAt` = `DateTime.now()`. The BLoC emits `WorkSavingState` (shows `CircularProgressIndicator` in the button), then either `WorkSavedState` (shows `success.json` Lottie for 1s, then pops back) or `WorkSaveErrorState` (shows error SnackBar).

**Validation Rules:**
- Work date: must not be in the future (future dates are disabled in the picker)
- Work name: minimum 3 characters
- Place: must be selected
- Labours: minimum 1 selected
- Total Amount: minimum 1.0, must be a valid decimal number

---

### SCREEN 6 — Edit Work Screen

**Route:** `/work/edit/:id`
**File:** `lib/presentation/screens/work/edit_work_screen.dart`
**BLoC:** `WorkBloc`, `LabourBloc`, `DriverBloc`, `TractorBloc`, `PlaceBloc`
**Purpose:** Modify an existing work record.

The layout is identical to Add Work Screen but all fields are pre-populated from the `WorkModel` fetched by ID from Hive. The `AmountDisplayCard` immediately shows the correct computed value upon loading. The app bar title is "Edit Work Record". On save, dispatches `UpdateWorkEvent` with the modified model and a new `updatedAt` timestamp.

---

### SCREEN 7 — Work Detail Screen

**Route:** `/work/detail/:id`
**File:** `lib/presentation/screens/work/work_detail_screen.dart`
**BLoC:** `WorkBloc`, `LabourBloc`
**Purpose:** Full read-only view of a single work record.

**App Bar:**

Back arrow (top-left). Title: work name (truncated with ellipsis if > 25 chars). Two action icons: `edit_rounded` (navigates to Edit Work) and `delete_rounded` (shows delete confirmation dialog).

**Layout:**

A `CustomScrollView` with `SliverList` children:

**Hero Section:** A `GlassCard` spanning full width with a gradient icon background. Shows the work name in `headlineMedium`, date in `bodyLarge`, and place with a `location_on` icon.

**Amount Section:** A `GlassCard` with three `Row` items: total amount (in `moneyDisplay` style), a divider line, and amount-per-labour in `headlineMedium` with the cyan accent colour.

**Labour List:** Section header "Labourers (N)". Each labourer who worked this job is shown as a `ListTile` with a circular avatar (initials from their name, coloured by first letter hash), their name, and their individual earning for this work entry.

**Vehicle Section (if assigned):** `GlassCard` with driver name, tractor name, and sand trips count displayed side by side with icons.

**Notes Section (if present):** `GlassCard` with a `notes_rounded` icon and the note text in `bodyLarge`.

**Metadata Section:** Small text showing "Created: [timestamp]" and "Last updated: [timestamp]" in `bodyMedium` with `textDisabled` colour.

---

### SCREEN 8 — Labour Screen

**Route:** (Tab 2 in IndexedStack)
**File:** `lib/presentation/screens/labour/labour_screen.dart`
**BLoC:** `LabourBloc`, `WorkBloc`
**Purpose:** Manage all labour workers and view their computed statistics.

**App Bar:**

Hamburger icon, title "Labour", search icon that expands an inline search field.

**Labour Card:**

Each active `LabourModel` is displayed as a `GlassCard`. The card shows:
- Circular avatar with initials (using a deterministic colour from name hash)
- Labour name (titleLarge)
- Phone number if available (bodyMedium)
- Two computed stats shown inline: "N works" and "₹X,XXX earned"

These stats are computed at the BLoC level by querying the `works` box for records that include this labour's ID in their `labourIds` list.

**Labour Detail Bottom Sheet:**

Tapping a labour card opens a `showModalBottomSheet` with `isScrollControlled: true`. Inside:
- Full labour profile card
- Earnings summary: total works, total earned, average per work
- Last 5 work records this labour appeared in (queried live from works box), shown as a timeline
- Edit button (navigates to EditLabourScreen)
- Delete button (with confirmation, sets `isActive = false` — soft delete)

**FAB:** "Add Labour" → navigates to `/labour/add`.

**Loading State:** Shimmer list of 5 skeleton labour cards.

**Empty State:** `empty_labour.json` Lottie, "No labourers added yet", "Add Labourer" button.

---

### SCREEN 9 — Add Labour Screen

**Route:** `/labour/add`
**File:** `lib/presentation/screens/labour/add_labour_screen.dart`
**BLoC:** `LabourBloc`

**App Bar:** Back arrow, title "Add Labourer".

**Form Fields (single `GlassCard`):**
- Name (required, min 2 chars)
- Phone number (optional, numeric keyboard, validated as 10-digit if provided)
- Address (optional, multiline)

**Save:** Full-width primary button. On success: show success Snackbar and pop back. The `LabourModel` is saved with `isActive: true` and `createdAt: DateTime.now()`.

---

### SCREEN 10 — Drivers Screen

**Route:** `/drivers` (from drawer)
**File:** `lib/presentation/screens/driver/drivers_screen.dart`
**BLoC:** `DriverBloc`, `WorkBloc`
**Purpose:** View and manage all drivers.

**App Bar:** Back arrow (top-left), title "Drivers", hamburger icon.

**Driver Card:**

Each `DriverModel` shown as `GlassCard` with:
- Driver icon `drive_eta_rounded` in a coloured circle
- Driver name
- Phone if available
- Computed: "N total trips" (sum of `sandTrips` from all works where this driver was assigned)

**Driver Detail Bottom Sheet:**

On card tap, opens modal sheet with:
- Full driver profile
- Total trips across all work records (computed from works box)
- List of last 5 works this driver was assigned to
- Assigned tractor (if any, resolved from tractors box)
- Edit/Delete buttons

**FAB:** "Add Driver".

**Loading/Empty/Error states:** As defined in Section 12–13.

---

### SCREEN 11 — Add Driver Screen

**Route:** `/drivers/add`
**File:** `lib/presentation/screens/driver/add_driver_screen.dart`
**BLoC:** `DriverBloc`, `TractorBloc`

**Fields:**
- Driver Name (required)
- Phone (optional)
- License Number (optional)
- Assigned Tractor — `AppDropdown` from tractors box (optional)

---

### SCREEN 12 — Tractors Screen

**Route:** `/tractors` (from drawer)
**File:** `lib/presentation/screens/tractor/tractors_screen.dart`
**BLoC:** `TractorBloc`, `WorkBloc`, `DriverBloc`
**Purpose:** Manage all tractors and view usage stats.

**Tractor Card:**

`GlassCard` with:
- Tractor icon `agriculture_rounded`
- Tractor name
- Registration number (if set)
- Assigned driver name (resolved from drivers box by FK)
- Computed: "N total works" (count of works where this tractorId was used)

**Detail sheet + CRUD + FAB** follow same pattern as Drivers screen.

---

### SCREEN 13 — Add Tractor Screen

**Route:** `/tractors/add`

**Fields:**
- Tractor Name (required)
- Registration Number (optional)
- Assign Driver — dropdown from active drivers (optional)

---

### SCREEN 14 — Places Screen

**Route:** `/places` (from drawer)
**File:** `lib/presentation/screens/place/places_screen.dart`
**BLoC:** `PlaceBloc`, `WorkBloc`

Displays all saved work locations. Each `PlaceModel` shown as a `ListTile`-style `GlassCard` with location icon, place name, description, and computed "N works done here". Supports delete (with check: if place is referenced in active works, show warning dialog before soft-deleting). FAB adds a new place.

---

### SCREEN 15 — Reports Screen

**Route:** (Tab 3 in IndexedStack)
**File:** `lib/presentation/screens/reports/reports_screen.dart`
**BLoC:** `ReportsBloc`
**Purpose:** Aggregated financial and operational analytics from real data.

**App Bar:** Hamburger icon, title "Reports". A `SegmentedButton` (Material 3) in the app bar bottom with three segments: "Daily", "Weekly", "Monthly".

**Shared Header Card:**

A `GlassCard` summarising the selected period: period label, total amount, total works, total labour days, total sand trips.

**Daily View:**

Three `GlassCard` sections:
1. Today's works listed as compact tiles.
2. Amount breakdown: a `PieChart` (from `fl_chart`) with one slice per labourer, sized by their earned amount. Tooltip shows name and amount on tap.
3. Trip summary: driver-wise trip count table.

**Weekly View:**

1. A `BarChart` (from `fl_chart`) with 7 bars (one per day of the week). Each bar height = total amount paid that day. Bar colour uses `accentCyan`. Bars for days with no data are shown at zero height — not omitted.
2. A `GlassCard` with the week's top 3 statistics: most used place, most active labourer, busiest driver.

**Monthly View:**

1. A `LineChart` (from `fl_chart`) showing daily totals for the entire current month. X-axis: day number. Y-axis: amount in INR.
2. A summary table card: total works, total amount, average daily amount, total sand trips for the month.

**All chart data is computed by the `ReportsBloc` from real Hive queries.** If there is no data for a period, the chart area shows the `no_report.json` Lottie empty state.

---

### SCREEN 16 — Settings Screen

**Route:** `/settings`
**File:** `lib/presentation/screens/settings/settings_screen.dart`
**BLoC:** `SettingsBloc`

**App Bar:** Back arrow, title "Settings".

**Sections (each in a `GlassCard`):**

**Appearance:**
- Dark Mode toggle (`SwitchListTile`) — updates `SettingsModel.isDarkMode` in Hive and dispatches `ToggleThemeEvent` to `SettingsBloc` which triggers app-wide theme change via `BlocProvider` at the root.
- Animations toggle (`SwitchListTile`) — disables all `flutter_animate` animations when off. Implement by checking a global settings flag before attaching `.animate()` chains.
- Currency symbol — currently locked to "₹" (displayed as read-only).
- Date format — `DropdownButton` with options: "dd/MM/yyyy", "MM/dd/yyyy", "yyyy-MM-dd".

**Personal:**
- Your Name — `AppTextField` for the greeting on dashboard. Saves on focus-lost.

**Data:**
- Backup section: "Export Backup" button — serialises all Hive boxes to JSON and saves to the device's `Downloads` folder (requires storage permission check first using `permission_handler` package). Shows a `SnackBar` with the saved file path.
- Restore section: "Import Backup" button — opens file picker (`file_picker` package), reads the JSON, validates structure, restores Hive boxes. Shows a confirmation dialog before overwriting: "This will replace all existing data. Continue?"
- Danger Zone: "Clear All Data" button styled with `DangerButton`. Shows a two-step confirmation: first dialog with confirmation checkbox, then final confirmation. Deletes all records from all boxes except settings.

---

### SCREEN 17 — About Screen

**Route:** `/about`
**File:** `lib/presentation/screens/about/about_screen.dart`

**Layout:**

A `GradientScaffold` with back arrow app bar titled "About".

A centred `Column` containing:
- Lottie `splash_logo.json` (120×120)
- App name "Labour Party" in `headlineLarge`
- Version "1.0.0" in `bodyLarge`
- Build date
- Divider
- Section: "Technology" listing Flutter version, Dart version, Hive version (read from package info if available)
- Section: "Developer" showing developer name "Roshan" and a note "Personal use only — not for distribution."
- Bottom tagline: "Built with dedication for daily use."

---

## 11. BLOC ARCHITECTURE SPECIFICATION

### 11.1 — WorkBloc

```dart
// Events
abstract class WorkEvent extends Equatable {}
class LoadAllWorksEvent extends WorkEvent {}
class LoadDashboardDataEvent extends WorkEvent {}
class SearchWorksEvent extends WorkEvent { final String query; }
class FilterWorksEvent extends WorkEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? placeId;
  final String? driverId;
}
class AddWorkEvent extends WorkEvent { final WorkModel work; }
class UpdateWorkEvent extends WorkEvent { final WorkModel work; }
class DeleteWorkEvent extends WorkEvent { final String workId; }
class LoadWorkByIdEvent extends WorkEvent { final String workId; }

// States
abstract class WorkState extends Equatable {}
class WorkInitialState extends WorkState {}
class WorkLoadingState extends WorkState {}
class WorksLoadedState extends WorkState { final List<WorkModel> works; }
class DashboardDataLoadedState extends WorkState {
  final int todayWorksCount;
  final int todayLabourCount;
  final int todaySandTrips;
  final double todayTotalAmount;
  final int activeDriversToday;
  final List<WorkModel> recentActivities; // last 8
}
class WorkDetailLoadedState extends WorkState { final WorkModel work; }
class WorkSavingState extends WorkState {}
class WorkSavedState extends WorkState {}
class WorkDeletedState extends WorkState {}
class WorkErrorState extends WorkState { final String message; }
class WorkEmptyState extends WorkState {}
```

### 11.2 — LabourBloc, DriverBloc, TractorBloc, PlaceBloc

Follow the same event/state pattern as `WorkBloc`. Each has: `Load[Entity]sEvent`, `Add[Entity]Event`, `Update[Entity]Event`, `Delete[Entity]Event`, `[Entity]LoadingState`, `[Entity]sLoadedState`, `[Entity]SavedState`, `[Entity]DeletedState`, `[Entity]ErrorState`, `[Entity]EmptyState`.

### 11.3 — ReportsBloc

```dart
// Events
class LoadDailyReportEvent extends ReportsEvent { final DateTime date; }
class LoadWeeklyReportEvent extends ReportsEvent { final DateTime weekStart; }
class LoadMonthlyReportEvent extends ReportsEvent { final int month; final int year; }

// States
class ReportsLoadingState extends ReportsState {}
class ReportsLoadedState extends ReportsState {
  final ReportPeriod period;
  final double totalAmount;
  final int totalWorks;
  final int totalSandTrips;
  final Map<String, double> amountByDay;   // For charts — real computed data
  final Map<String, int> tripsByDriver;    // Real computed data
}
class ReportsEmptyState extends ReportsState {}
class ReportsErrorState extends ReportsState { final String message; }
```

### 11.4 — SettingsBloc

```dart
// Events
class LoadSettingsEvent extends SettingsEvent {}
class ToggleThemeEvent extends SettingsEvent {}
class ToggleAnimationsEvent extends SettingsEvent {}
class UpdateUserNameEvent extends SettingsEvent { final String name; }
class UpdateDateFormatEvent extends SettingsEvent { final String format; }
class ExportBackupEvent extends SettingsEvent {}
class ImportBackupEvent extends SettingsEvent { final String filePath; }
class ClearAllDataEvent extends SettingsEvent {}

// States
class SettingsLoadedState extends SettingsState { final SettingsModel settings; }
class SettingsSavingState extends SettingsState {}
class BackupExportedState extends SettingsState { final String filePath; }
class BackupImportedState extends SettingsState {}
class DataClearedState extends SettingsState {}
class SettingsErrorState extends SettingsState { final String message; }
```

---

## 12. SKELETON LOADING SPECIFICATION

All skeleton loaders use the `shimmer` package with `Shimmer.fromColors()`. Base colour: `Color(0xFF1A2E4A)`. Highlight colour: `Color(0xFF2A4A6A)`.

**`SkeletonStatCard`:** Same dimensions as `StatCard`. Two horizontal shimmer rectangles (title + value) and one shorter one (subtitle).

**`SkeletonWorkCard`:** Same dimensions as work record card. Three horizontal shimmer rectangles (title, place, chips).

**`SkeletonLabourCard`:** Round shimmer circle (avatar) + two shimmer rectangles.

**`SkeletonListItem`:** Full-width shimmer rectangle with rounded corners, 68px height.

**`SkeletonChartPlaceholder`:** A shimmer rectangle filling the chart area dimensions, with no content inside.

**Implementation rule:** Skeleton loaders must have exactly the same dimensions as the real widget they replace. No layout shift should occur when data loads.

---

## 13. EMPTY AND ERROR STATE SPECIFICATION

### 13.1 — Empty State Widget

```dart
// Used on every screen when the box is empty or a search returns nothing
EmptyStateWidget({
  required String lottieAsset,   // e.g., 'assets/lottie/empty_work.json'
  required String title,         // e.g., 'No work records yet'
  required String subtitle,      // e.g., 'Tap the button below to add your first work entry.'
  String? actionLabel,           // e.g., 'Add Work'
  VoidCallback? onAction,        // Navigation or form open action
})
```

The widget renders: Lottie animation (200×200), title in `headlineMedium`, subtitle in `bodyMedium` with `textSecondary`, and optionally a `PrimaryButton` below. All elements are centred in a `Column` with `MainAxisAlignment.center`. Applied padding: 40px horizontal.

### 13.2 — Error State Widget

```dart
ErrorStateWidget({
  required String message,      // Actual error message from BLoC state
  required VoidCallback onRetry // Re-dispatches the load event
})
```

Renders: `error_rounded` icon (72px, `errorRed`), "Something went wrong" in `titleLarge`, the actual error message in `bodyMedium` with `textSecondary`, and a "Retry" `SecondaryButton`.

### 13.3 — Screen-Specific Empty States

| Screen | Lottie | Title | Action |
|---|---|---|---|
| Work Records | empty_work.json | "No work records yet" | "Add Work" |
| Labour | empty_labour.json | "No labourers added" | "Add Labourer" |
| Drivers | empty_driver.json | "No drivers added" | "Add Driver" |
| Tractors | empty_driver.json | "No tractors added" | "Add Tractor" |
| Places | empty_work.json | "No places added" | "Add Place" |
| Reports | no_report.json | "No data for this period" | none |
| Search | empty_work.json | "No results found" | "Clear Search" |

---

## 14. FORM VALIDATION REFERENCE

Every form field validates on the `validator` callback of `TextFormField`. Validation is also re-run on save attempt.

| Field | Required | Rule | Error Message |
|---|---|---|---|
| Work Name | Yes | Min 3 chars, max 100 | "Work name must be at least 3 characters" |
| Work Date | Yes | Not null, not in future | "Please select a valid date" |
| Place | Yes | Must select from dropdown | "Please select a work place" |
| Labour Selection | Yes | ≥ 1 selected | "Select at least one labourer" |
| Total Amount | Yes | > 0, valid decimal | "Enter a valid amount greater than 0" |
| Driver | No | — | — |
| Tractor | No | — | — |
| Sand Trips | No | ≥ 0 (stepper enforced) | — |
| Labour Name | Yes | Min 2 chars | "Name must be at least 2 characters" |
| Labour Phone | No | 10 digits if provided | "Enter a valid 10-digit phone number" |
| Driver Name | Yes | Min 2 chars | "Name must be at least 2 characters" |
| Tractor Name | Yes | Min 2 chars | "Name must be at least 2 characters" |
| Place Name | Yes | Min 2 chars | "Place name must be at least 2 characters" |

---

## 15. PERFORMANCE SPECIFICATIONS

### 15.1 — APK Size Budget

Target APK size: **10–18 MB** (within the 10–20 MB requirement).

- Lottie JSON files: use minified JSON, total < 2 MB for all animations combined.
- Images: use WebP format for all images, max 200 KB each.
- Fonts: include only the weights actually used (Regular 400, Medium 500, SemiBold 600, Bold 700).
- Enable `minifyEnabled true` and `shrinkResources true` in `build.gradle` for release builds.
- Use `flutter build apk --split-per-abi` to target only arm64-v8a for the main user device.

### 15.2 — Startup Performance

- All Hive boxes must be opened before `runApp()` — no deferred loading.
- The `main()` function must complete Hive init before showing any UI.
- The splash screen's 2.8 second duration is sufficient for any Hive init time on Android 8+.
- `BlocProvider` tree should be built once at the root — use `MultiBlocProvider`.

### 15.3 — Scroll Performance

- Use `ListView.builder` (not `ListView`) for all list screens.
- Do not use `shrinkWrap: true` on lists with many items — only use it for dashboard's recent activities section which is constrained to 8 items.
- Cache widget trees using `const` constructors wherever possible.
- Do not rebuild the entire widget tree on BLoC state changes — use `BlocBuilder` with `buildWhen` to limit rebuilds.

---

## 16. DEPENDENCY INJECTION PATTERN

Use `RepositoryProvider` at the root for repositories and `MultiBlocProvider` for BLoCs. Inject use cases manually in BLoC constructors (no `get_it` or `injectable` required for this app size).

```dart
// main.dart structure
MultiBlocProvider(
  providers: [
    RepositoryProvider<WorkRepository>(
      create: (_) => WorkRepositoryImpl(WorkLocalDatasource()),
    ),
    // ... other repositories
    BlocProvider<WorkBloc>(
      create: (ctx) => WorkBloc(
        addWork: AddWorkUseCase(ctx.read<WorkRepository>()),
        // ... other use cases
      )..add(LoadDashboardDataEvent()),
    ),
    BlocProvider<LabourBloc>(...),
    BlocProvider<DriverBloc>(...),
    BlocProvider<TractorBloc>(...),
    BlocProvider<PlaceBloc>(...),
    BlocProvider<ReportsBloc>(...),
    BlocProvider<SettingsBloc>(
      create: (ctx) => SettingsBloc(...)..add(LoadSettingsEvent()),
    ),
  ],
  child: BlocBuilder<SettingsBloc, SettingsState>(
    builder: (ctx, state) {
      final isDark = state is SettingsLoadedState ? state.settings.isDarkMode : true;
      return MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        // ...
      );
    },
  ),
);
```

---

## 17. MATERIAL 3 THEME CONFIGURATION

```dart
// AppTheme.darkTheme (primary theme — app defaults to dark)
ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF4FC3F7),         // Light blue — primary actions
    onPrimary: Color(0xFF003355),
    primaryContainer: Color(0xFF00497A),
    onPrimaryContainer: Color(0xFFCDE5FF),
    secondary: Color(0xFF4DD0E1),       // Cyan — secondary/accent
    onSecondary: Color(0xFF003740),
    secondaryContainer: Color(0xFF004E59),
    onSecondaryContainer: Color(0xFFB2EBF2),
    surface: Color(0xFF0D1B2E),         // Card surface
    onSurface: Color(0xFFF0F4FF),
    background: Color(0xFF060B18),      // App background
    onBackground: Color(0xFFF0F4FF),
    error: Color(0xFFEF5350),
    onError: Color(0xFF690005),
  ),
  textTheme: AppTypography.textTheme,
  cardTheme: CardTheme(
    color: Color(0xFF0D1B2E),
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    margin: EdgeInsets.zero,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFF112240),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Color(0xFF2A4A6A), width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Color(0xFF2A4A6A), width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Color(0xFF4DD0E1), width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Color(0xFFEF5350), width: 1),
    ),
    labelStyle: TextStyle(fontFamily: 'Inter', color: Color(0xFF90A4C0)),
    floatingLabelStyle: TextStyle(fontFamily: 'Inter', color: Color(0xFF4DD0E1)),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF4DD0E1),
    foregroundColor: Color(0xFF003740),
    elevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Color(0xFF0D1B2E),
    indicatorColor: Color(0x334DD0E1),
    labelTextStyle: MaterialStateProperty.all(
      TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500),
    ),
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: Color(0xFF0A1525),
    elevation: 16,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topRight: Radius.circular(24), bottomRight: Radius.circular(24)),
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Color(0xFF1A2E4A),
    contentTextStyle: TextStyle(fontFamily: 'Inter', color: Color(0xFFF0F4FF)),
    actionTextColor: Color(0xFF4DD0E1),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: Color(0xFF0D1B2E),
    elevation: 24,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: Color(0xFF112240),
    selectedColor: Color(0xFF004E59),
    labelStyle: TextStyle(fontFamily: 'Inter', fontSize: 13),
    side: BorderSide(color: Color(0xFF2A4A6A)),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),
);
```

---

## 18. FINAL BUILD CHECKLIST FOR AI CODING AGENT

Before marking the project complete, verify every item in this list:

**Architecture:**
- [ ] Zero cross-layer imports (domain has no Flutter/Hive, presentation has no Hive)
- [ ] All BLoCs emit Loading → Data/Empty/Error for every event
- [ ] All use cases have single responsibility
- [ ] TypeAdapters generated and registered in correct typeId order

**Data:**
- [ ] No mock, dummy, or hardcoded data anywhere in the codebase
- [ ] `amountPerLabour` is always computed before saving — never stored as a separate user input
- [ ] Labour stats (joinedWorks, totalEarned) are always computed from works box — never stored
- [ ] All delete actions perform soft-delete (`isActive = false`) for labours/drivers/tractors/places; hard-delete for work records only (after confirmation)

**UI:**
- [ ] Every screen has skeleton loader, empty state, and error state implemented
- [ ] All `GlassCard` widgets use blur ≥ 10
- [ ] Every secondary screen has back arrow in top-left
- [ ] All back navigations use `PopScope` with overlay-first dismissal
- [ ] All forms validate before save — no silent failures
- [ ] Amount calculation card shows live results as user types
- [ ] Labour multi-select updates `labourCount` and `amountPerLabour` in real time

**Navigation:**
- [ ] Splash navigates to main with `pushReplacement` (cannot navigate back to splash)
- [ ] Drawer closes before navigating to any screen
- [ ] All route names use `RouteNames` constants — no inline strings

**Performance:**
- [ ] `ListView.builder` used for all list screens (not `Column` with map)
- [ ] `BlocBuilder` uses `buildWhen` to minimise unnecessary rebuilds
- [ ] Lottie animations are disposed when screens unmount

**Build:**
- [ ] Release APK built with `--split-per-abi` for arm64
- [ ] `minifyEnabled` and `shrinkResources` enabled for release
- [ ] `publish_to: 'none'` in pubspec.yaml

---

*PRD Version 2.0 | Labour Party | com.roshan.labourparty | For Personal Use Only*
*Prepared for AI-assisted Flutter development — All specifications are production-ready*
