
plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}
java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(17))
    }
}


android {
    namespace = "com.example.d_m"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    dependencies {
        // Import the Firebase BoM
        implementation(platform("com.google.firebase:firebase-bom:33.10.0"))
        implementation("androidx.core:core-ktx:1.12.0")


        // TODO: Add the dependencies for Firebase products you want to use
        // When using the BoM, don't specify versions in Firebase dependencies
        implementation("com.google.firebase:firebase-analytics")
        coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")



        // Add the dependencies for any other desired Firebase products
        // https://firebase.google.com/docs/android/setup#available-libraries
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.d_m"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
         val mapsApiKey: String = project.findProperty("MAPS_API_KEY") as String? ?: ""
        manifestPlaceholders["MAPS_API_KEY"] = mapsApiKey


    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
