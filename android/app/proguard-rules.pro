# Flutter ProGuard Rules
-dontwarn io.flutter.**
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class com.example.zet_gestor_orcamento.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep custom widget classes
-keep class * extends io.flutter.plugin.common.MethodChannel$MethodCallHandler { *; }
-keep class * extends io.flutter.plugin.common.MethodChannel$Result { *; }
-keep class * extends io.flutter.plugin.common.EventChannel$StreamHandler { *; }
-keep class * extends io.flutter.plugin.common.EventChannel$EventSink { *; }

# Keep reflection used by Flutter
-keep class * extends io.flutter.embedding.android.FlutterActivity { *; }
-keep class * extends io.flutter.embedding.android.FlutterFragment { *; }
-keep class * extends io.flutter.embedding.android.FlutterView { *; }

# Keep packages used by plugins
-keep class sqflite.** { *; }
-keep class com.tekartik.sqflite.** { *; }
-keep class path_provider.** { *; }
-keep class io.flutter.plugins.pathprovider.** { *; }
-keep class shared_preferences.** { *; }
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep class flutter_local_notifications.** { *; }
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep class flutter_secure_storage.** { *; }
-keep class com.it_nomads.fluttersecurestorage.** { *; }
-keep class printing.** { *; }
-keep class net.nfet.printing.** { *; }
-keep class pdf.** { *; }
-keep class com.example.zet_gestor_orcamento.** { *; }

# Keep JSON serialization classes
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep enum classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep custom exceptions
-keep public class * extends java.lang.Exception

# Keep annotation classes
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# Keep line numbers for debugging
-keepattributes SourceFile,LineNumberTable

# Remove logging in release builds
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int i(...);
    public static int w(...);
    public static int d(...);
    public static int e(...);
}

# Optimize
-optimizationpasses 5
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-dontpreverify
-verbose
-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*

# Keep Flutter wrapper
-keep class io.flutter.app.FlutterApplication { *; }
-keep class io.flutter.embedding.android.FlutterActivity { *; }
-keep class io.flutter.embedding.android.FlutterFragment { *; }
-keep class io.flutter.embedding.engine.FlutterEngine { *; }
-keep class io.flutter.embedding.engine.plugins.** { *; }
-keep class io.flutter.plugin.editing.** { *; }
-keep class io.flutter.plugin.platform.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.android.FlutterView { *; }
-keep class io.flutter.embedding.android.FlutterActivityAndFragmentDelegate { *; }

# Keep custom application class
-keep class com.example.zet_gestor_orcamento.MainActivity { *; }

# Keep database classes
-keep class * extends android.database.sqlite.SQLiteOpenHelper { *; }
-keep class * extends android.database.sqlite.SQLiteDatabase { *; }

# Keep provider classes
-keep class * extends android.content.ContentProvider { *; }

# Keep service classes
-keep class * extends android.app.Service { *; }

# Keep broadcast receiver classes
-keep class * extends android.content.BroadcastReceiver { *; }

# Keep notification classes
-keep class * extends android.app.Notification { *; }
-keep class * extends android.app.NotificationManager { *; }

# Keep security classes
-keep class * extends javax.crypto.** { *; }
-keep class * extends java.security.** { *; }

# Suppress warnings
-dontwarn android.support.**
-dontwarn com.google.android.**
-dontwarn io.flutter.embedding.**
-dontwarn javax.annotation.**
-dontwarn sun.misc.**
-dontwarn org.w3c.dom.**
-dontwarn org.joda.time.**