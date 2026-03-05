plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.human_match_app"
    // Nota: Se o build falhar com compileSdk 36, altera para 35,
    // pois o 36 ainda é muito recente para alguns plugins de Ads.
    compileSdk = 36

    defaultConfig {
        applicationId = "com.example.human_match_app"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = 1
        versionName = "1.0"

        // ADICIONADO: Necessário para evitar o erro de limite de métodos (64k)
        // comum ao usar Firebase + Ads juntos.
        multiDexEnabled = true

        externalNativeBuild {
            cmake {
                cppFlags += ""
            }
        }

        ndk {
            abiFilters += listOf("arm64-v8a", "armeabi-v7a", "x86_64")
        }
    }

    externalNativeBuild {
        cmake {
            path = file("src/main/cpp/CMakeLists.txt")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// ADICIONADO: Bloco de dependências para o MultiDex
dependencies {
    implementation("androidx.multidex:multidex:2.0.1")
}