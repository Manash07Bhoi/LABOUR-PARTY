# Tech Stack

- **Framework:** Flutter (>=3.22.0)
- **Language:** Dart (>=3.3.0 <4.0.0)
- **State Management:** BLoC (`flutter_bloc: ^8.1.6`)
- **Local Storage:** Hive (`hive: ^2.2.3`, `hive_flutter: ^1.1.0`)
- **UI Design:** Material 3
- **Animations/UI Libraries:** `flutter_animate: ^4.5.0`, `lottie: ^3.1.2`, `glassmorphism_ui: ^0.3.0`, `animations: ^2.0.11`, `shimmer: ^3.0.0`
- **Charts:** `fl_chart: ^0.68.0`
- **Utilities:** `intl: ^0.19.0`, `uuid: ^4.4.2`, `shared_preferences: ^2.2.3`, `path_provider: ^2.1.3`
- **Code Generation:** `build_runner: ^2.4.9`, `hive_generator: ^2.0.1`
- **Offline Fonts:** `google_fonts: ^6.2.1` (configured offline)

## Execution Commands
- Get Dependencies: `flutter pub get`
- Build Code/Generators: `flutter pub run build_runner build --delete-conflicting-outputs`
- Build APK: `flutter build apk --release --split-per-abi --target-platform android-arm64`
- Analyze Code: `flutter analyze`
