import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'firebase_options.dart';
import 'hd/swiss_ephemeris_service.dart';
import 'l10n/app_localizations.dart';
import 'ui/navigation/root_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  tz.initializeTimeZones();

  if (!kIsWeb) {
    // Ads only on mobile
    await MobileAds.instance.initialize();
    
    // Initialize Swiss Ephemeris
    await SwissEphemerisService().init();
  }

  runApp(const HumanMatchApp());
}

class HumanMatchApp extends StatelessWidget {
  const HumanMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF3E1E4F),
      brightness: Brightness.dark,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Human Match',
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('pt', 'PT'),
        Locale('es', 'ES'),
        Locale('fr', 'FR'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFF3E1E4F),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF3E1E4F),
          foregroundColor: colorScheme.onSurface,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          elevation: 0.8,
          color: colorScheme.surfaceContainerLowest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: colorScheme.surfaceContainerLowest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: const RootGate(),
    );
  }
}
