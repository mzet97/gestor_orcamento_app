import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load signing properties (keystore) from android/key.properties if present
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { stream ->
        keystoreProperties.load(stream)
    }
}

android {
    namespace = "br.zet.gestororcamento"
    compileSdk = flutter.compileSdkVersion
    // 16KB page size support - NDK r28 or higher required
    ndkVersion = "28.0.12433566"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
        // 16KB page size support for Google Play compatibility
        jniLibs {
            useLegacyPackaging = false
        }
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "br.zet.gestororcamento"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        multiDexEnabled = true
    }

    signingConfigs {
        create("release") {
            // Exige android/key.properties com: storeFile, storePassword, keyAlias, keyPassword
            val storeFileProp = keystoreProperties["storeFile"] as String?
            val storePasswordProp = keystoreProperties["storePassword"] as String?
            val keyAliasProp = keystoreProperties["keyAlias"] as String?
            val keyPasswordProp = keystoreProperties["keyPassword"] as String?

            if (storeFileProp != null && storePasswordProp != null && keyAliasProp != null && keyPasswordProp != null) {
                storeFile = file(storeFileProp)
                storePassword = storePasswordProp
                keyAlias = keyAliasProp
                keyPassword = keyPasswordProp
            }
        }
    }

    buildTypes {
        release {
            // You need to create a signing configuration to build for release.
            // See https://flutter.dev/to/android-signing for instructions.
            signingConfig = if (keystoreProperties.isNotEmpty()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
    implementation("androidx.appcompat:appcompat:1.6.1")
}
