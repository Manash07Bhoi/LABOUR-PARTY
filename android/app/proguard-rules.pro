## Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class plugins.flutter.io.**  { *; }

## Hive Database
-keep class com.roshan.labourparty.** { *; }
-keepclassmembers class * extends hive.HiveObject {
    <init>();
}
-keep class * implements hive.TypeAdapter {
    <init>();
}

## Core Android
-dontwarn android.support.**
-keep class android.support.** { *; }
