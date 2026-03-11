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

  // Inicializa a Swiss Ephemeris em ambas as plataformas.
  await SwissEphemerisService().init();

  if (!kIsWeb) {
    await MobileAds.instance.initialize();
  }

  runApp(const HumanMatchApp());
}

class HumanMatchApp extends StatefulWidget {
  const HumanMatchApp({super.key});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_HumanMatchAppState>()?.restart();
  }

  @override
  State<HumanMatchApp> createState() => _HumanMatchAppState();
}

class _HumanMatchAppState extends State<HumanMatchApp> {
  Key key = UniqueKey();

  void restart() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    const cosmicBg = Color(0xFF0F0B1E);
    const goldColor = Color(0xFFE6B325);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF3E1E4F),
      brightness: Brightness.dark,
      surface: cosmicBg, // Substitui o canvasColor e background
      onSurface: Colors.white,
    );

    return KeyedSubtree(
      key: key,
      child: MaterialApp(
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
          brightness: Brightness.dark,
          colorScheme: colorScheme,
          scaffoldBackgroundColor: cosmicBg,
          // Removido canvasColor depreciado, o colorScheme.surface cuida disso no M3
          appBarTheme: const AppBarTheme(
            backgroundColor: cosmicBg,
            foregroundColor: Colors.white,
            centerTitle: true,
            elevation: 0,
          ),
          // Voltando para CardThemeData conforme exigido pelo seu compilador
          cardTheme: CardThemeData(
            elevation: 0,
            color: Colors.white.withOpacity(0.04),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(color: Colors.white.withOpacity(0.08)),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: goldColor),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: goldColor,
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              textStyle: const TextStyle(fontWeight: FontWeight.w700),
              foregroundColor: Colors.white,
            ),
          ),
          snackBarTheme: const SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
          ),
        ),
        home: const RootGate(),
      ),
    );
  }
}
