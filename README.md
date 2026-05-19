# Labour Party

> A fully offline professional labour management app for personal use.

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Hive](https://img.shields.io/badge/Hive-Local_Storage-yellow?style=for-the-badge)
![BLoC](https://img.shields.io/badge/BLoC-State_Management-blue?style=for-the-badge)
![Material 3](https://img.shields.io/badge/Material_3-UI_Design-orange?style=for-the-badge)

## Overview

**Labour Party** is a comprehensive, offline-first personal labour and work management tool designed for Android. It focuses on skilled labour management, daily work tracking, and precise financial record-keeping. The app leverages Clean Architecture principles with a robust BLoC state management pattern, ensuring high performance and predictability even without an internet connection.

## Features

- **Offline-First Capabilities:** Fully functional without internet access, ensuring data privacy and constant availability.
- **Labour Management:** Track labour attendance, work hours, and daily tasks efficiently.
- **Financial Precision:** Manage payments, advances, and keep a reliable offline ledger.
- **Clean Architecture:** Strict separation of concerns across Data, Domain, and Presentation layers.
- **Robust State Management:** Implements the BLoC pattern for predictable state transitions (Loading, Empty, Error, Data).
- **Fast Local Storage:** Uses Hive for high-speed, lightweight local database storage.

## Project Structure

The codebase is organized adhering to Clean Architecture principles:

- **`lib/core/`**: Core configurations, themes, constants, and utilities.
- **`lib/data/`**: Data layer, including Hive local storage models, repositories implementations, and data sources.
- **`lib/domain/`**: Business logic, including entities, abstract repositories, and use cases.
- **`lib/presentation/`**: UI layer, including screens, widgets, and BLoC state management.

## Setup & Build Instructions

1. **Prerequisites:** Ensure you have the Flutter SDK (>=3.22.0) installed and an Android environment configured.
2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```
3. **Generate Code (if Hive models or BLoC changes require it):**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. **Run the App:**
   ```bash
   flutter run
   ```

### Building the APK

To build a release APK targeted for Android ARM64 devices:

```bash
flutter build apk --release --split-per-abi --target-platform android-arm64
```

## Reference

This project is built following the strict requirements detailed in the `labour_party_PRD.md`. Key implementation decisions and deviations are documented in the `/memory-bank/` directory.

---

**Disclaimer:** This application is intended for personal use only and is not licensed for distribution.
