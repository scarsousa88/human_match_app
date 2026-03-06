// lib/main.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'firebase_options.dart';

import 'places/places.dart'; // PlacesRepository + Place
import 'hd/swiss_ephemeris_service.dart';
import 'calc/human_design.dart';
import 'calc/numerology.dart';
import 'hd/human_design_section.dart';
import 'ai_actions.dart';
import 'app_terms.dart';
import 'l10n/app_localizations.dart';
import 'ui/loading_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  tz.initializeTimeZones();

  if (!kIsWeb) {
    // Ads only on mobile
    await MobileAds.instance.initialize();
  }

  runApp(const HumanMatchApp());
}

/// Helpers globais para Astrologia
String getZodiacSign(BuildContext context, double lon) {
  final l10n = AppLocalizations.of(context)!;
  final index = (lon ~/ 30).clamp(0, 11);
  final signs = [
    l10n.signAries, l10n.signTaurus, l10n.signGemini, l10n.signCancer,
    l10n.signLeo, l10n.signVirgo, l10n.signLibra, l10n.signScorpio,
    l10n.signSagittarius, l10n.signCapricorn, l10n.signAquarius, l10n.signPisces
  ];
  return signs[index];
}

double? findBodyLongitude(Map<String, dynamic>? hdBase, bool conscious, String body) {
  if (hdBase == null) return null;
  final acts = (hdBase['activations'] ?? []) as List;
  for (final a in acts) {
    final m = (a as Map).cast<String, dynamic>();
    if ((m['conscious'] == conscious) && (m['body'] == body)) {
      final lon = m['lon'];
      if (lon is num) return lon.toDouble();
    }
  }
  return null;
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
      // Definimos Inglês como o primeiro da lista para ser o idioma padrão (fallback)
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

class RootGate extends StatelessWidget {
  const RootGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: LoadingWidget());
        }
        if (snap.data == null) return const AuthScreen();
        return const ProfileGate();
      },
    );
  }
}

class ProfileGate extends StatelessWidget {
  const ProfileGate({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const AuthScreen();

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting && !snap.hasData) {
          return const Scaffold(body: LoadingWidget());
        }

        final data = snap.data?.data() ?? {};
        
        final acceptedVersion = data['acceptedTermsVersion']?.toString();
        if (acceptedVersion != AppTerms.currentVersion) {
          return const TermsConsentScreen();
        }

        final hasName = (data['name'] ?? '').toString().trim().isNotEmpty;
        final hasPlace = (data['place'] is Map) && (data['place']['tzId'] != null);
        final hasBirthDate = (data['birthDateStr'] ?? '').toString().trim().isNotEmpty;
        final hasBirthTime = (data['birthTimeStr'] ?? '').toString().trim().isNotEmpty;

        final complete = hasName && hasBirthDate && hasBirthTime && hasPlace;

        if (!complete) return const ProfileInputScreen();

        return const MainNavigationScreen();
      },
    );
  }
}

/// ---------------- TERMS CONSENT ----------------

class TermsConsentScreen extends StatefulWidget {
  const TermsConsentScreen({super.key});

  @override
  State<TermsConsentScreen> createState() => _TermsConsentScreenState();
}

class _TermsConsentScreenState extends State<TermsConsentScreen> {
  bool loading = false;

  Future<void> _accept() async {
    setState(() => loading = true);
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'acceptTerms': true,
        'acceptedTermsVersion': AppTerms.currentVersion,
        'termsAcceptedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.termsTitle)),
      body: _Shell(
        child: Column(
          children: [
            Expanded(
              child: _PrimaryCard(
                child: SingleChildScrollView(
                  child: Text(l10n.termsContent, style: TextStyle(color: cs.onSurface)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loading ? null : _accept,
              child: loading ? const LoadingWidget(size: 24) : Text(l10n.acceptAndContinue),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              child: Text(l10n.cancelAndExit),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------- NAVIGATION ----------------

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<Widget> _screens = [
    const ProfileSummaryScreen(),
    const _PlaceholderTab(textKey: 'communitySoon'),
    const _PlaceholderTab(textKey: 'compareSoon'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? l10n.tabProfile : (_currentIndex == 1 ? l10n.tabCommunity : l10n.tabCompare)),
        actions: [
          IconButton(
            tooltip: l10n.logout,
            onPressed: () async => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.onSurfaceVariant,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: l10n.tabProfile,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people_outline),
            activeIcon: const Icon(Icons.people),
            label: l10n.tabCommunity,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.compare_arrows),
            activeIcon: const Icon(Icons.compare_arrows),
            label: l10n.tabCompare,
          ),
        ],
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final String textKey;
  const _PlaceholderTab({required this.textKey});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String getMsg() {
      if (textKey == 'communitySoon') return l10n.communitySoon;
      if (textKey == 'compareSoon') return l10n.compareSoon;
      return '';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icon/compare.png', width: 300),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              '${getMsg()}\n(${l10n.soonMessage})',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------- AUTH ----------------

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool loading = false;
  bool acceptTerms = false;

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  void _toast(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  String _authMsg(BuildContext context, FirebaseAuthException e) {
    final l10n = AppLocalizations.of(context)!;
    switch (e.code) {
      case 'user-not-found': return l10n.errorUserNotFound;
      case 'wrong-password': return l10n.errorWrongPassword;
      case 'invalid-email': return l10n.errorInvalidEmail;
      case 'email-already-in-use': return l10n.errorEmailAlreadyInUse;
      case 'weak-password': return l10n.errorWeakPassword;
      default: return l10n.errorGeneral(e.message ?? e.code);
    }
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    FocusScope.of(context).unfocus();
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text;

    if (email.isEmpty || pass.isEmpty) {
      _toast(l10n.errorFillEmailPassword);
      return;
    }

    if (!isLogin && !acceptTerms) {
      _toast(l10n.errorAcceptTerms);
      return;
    }

    setState(() => loading = true);
    try {
      if (isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass);
        final uid = FirebaseAuth.instance.currentUser!.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'email': email,
          'acceptTerms': true,
          'acceptedTermsVersion': AppTerms.currentVersion,
          'termsAcceptedAt': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) _toast(_authMsg(context, e));
    } catch (e) {
      if (mounted) _toast(l10n.errorGeneral(e.toString()));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _resetPassword() async {
    final l10n = AppLocalizations.of(context)!;
    FocusScope.of(context).unfocus();
    final email = emailCtrl.text.trim();
    if (email.isEmpty) {
      _toast(l10n.resetEmailError);
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) _toast(l10n.resetEmailSent);
    } on FirebaseAuthException catch (e) {
      if (mounted) _toast(_authMsg(context, e));
    } catch (e) {
      if (mounted) _toast(l10n.errorGeneral(e.toString()));
    }
  }

  void _showTerms() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.termsTitle),
        content: SingleChildScrollView(child: Text(l10n.termsContent)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.ok)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: _Shell(
        child: ListView(
          children: [
            const SizedBox(height: 18),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/icon/icon.png',
                    width: 46,
                    height: 46,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Human Match',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                      ),
                      Text(l10n.welcomeMessage, style: TextStyle(color: cs.onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _PrimaryCard(
              child: Column(
                children: [
                  TextField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: l10n.email),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passCtrl,
                    obscureText: true,
                    decoration: InputDecoration(labelText: l10n.password),
                  ),
                  if (!isLogin) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: acceptTerms,
                          onChanged: (v) => setState(() => acceptTerms = v ?? false),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: _showTerms,
                            child: Text(
                              l10n.acceptTerms,
                              style: TextStyle(
                                fontSize: 13,
                                color: cs.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: loading ? null : _submit,
                    child: loading ? const LoadingWidget(size: 24) : Text(isLogin ? l10n.login : l10n.register),
                  ),
                  const SizedBox(height: 8),
                  if (isLogin)
                    TextButton(
                      onPressed: loading ? null : _resetPassword,
                      child: Text(l10n.forgotPassword),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: loading ? null : () => setState(() => isLogin = !isLogin),
              child: Text(isLogin ? l10n.noAccount : l10n.hasAccount),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------- PROFILE INPUT ----------------

class ProfileInputScreen extends StatefulWidget {
  const ProfileInputScreen({super.key});

  @override
  State<ProfileInputScreen> createState() => _ProfileInputScreenState();
}

class _ProfileInputScreenState extends State<ProfileInputScreen> {
  final nameCtrl = TextEditingController();
  final _birthDateController = TextEditingController();
  final _birthTimeController = TextEditingController();

  DateTime? birthDate;
  TimeOfDay? birthTime;
  bool saving = false;

  List<Place> _places = [];
  String? _country;
  Place? _city;
  String? _tempCityName;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await _loadExistingProfile();
    await _loadPlaces();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    _birthDateController.dispose();
    _birthTimeController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snap = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (!snap.exists) return;

    final data = snap.data() ?? {};
    if (mounted) {
      setState(() {
        nameCtrl.text = (data['name'] ?? '').toString().trim();
        final birthDateStr = (data['birthDateStr'] ?? '').toString().trim();
        if (birthDateStr.isNotEmpty) {
          try {
            birthDate = DateTime.parse(birthDateStr);
            _birthDateController.text = _fmtDate(birthDate);
          } catch (_) {}
        }
        final birthTimeStr = (data['birthTimeStr'] ?? '').toString().trim();
        if (birthTimeStr.isNotEmpty) {
          try {
            final parts = birthTimeStr.split(':');
            birthTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
            _birthTimeController.text = birthTimeStr;
          } catch (_) {}
        }
        
        final placeData = data['place'] as Map?;
        if (placeData != null) {
          _country = placeData['country']?.toString();
          _tempCityName = placeData['city']?.toString();
        }
      });
    }
  }

  Future<void> _loadPlaces() async {
    final list = await PlacesRepository.loadEuropePlaces();
    if (!mounted) return;
    setState(() {
      _places = list;
      final countries = _countries();
      
      if (_country == null || !countries.contains(_country)) {
        _country = countries.isNotEmpty ? countries.first : null;
      }

      final cities = _citiesForCountry(_country);
      
      if (_tempCityName != null) {
        final match = cities.where((p) => p.city == _tempCityName).toList();
        if (match.isNotEmpty) {
          _city = match.first;
        } else {
          _city = cities.isNotEmpty ? cities.first : null;
        }
      } else {
        _city = cities.isNotEmpty ? cities.first : null;
      }
    });
  }

  List<String> _countries() {
    final s = <String>{};
    for (final p in _places) { s.add(p.country); }
    final out = s.toList()..sort();
    return out;
  }

  List<Place> _citiesForCountry(String? country) {
    if (country == null) return [];
    final out = _places.where((p) => p.country == country).toList()..sort((a, b) => a.city.compareTo(b.city));
    return out;
  }

  void _toast(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  String _p2(int n) => n.toString().padLeft(2, '0');

  String _fmtDate(DateTime? d) {
    if (d == null) return '...';
    return '${_p2(d.day)}/${_p2(d.month)}/${d.year}';
  }

  String _fmtTime(TimeOfDay? t) {
    if (t == null) return '...';
    return '${_p2(t.hour)}:${_p2(t.minute)}';
  }

  Future<void> _pickDateWheel() async {
    final now = DateTime.now();
    final initial = birthDate ?? DateTime(2000, 1, 1);
    DateTime temp = initial;
    final l10n = AppLocalizations.of(context)!;
    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      useSafeArea: true,
      builder: (context) {
        return _CupertinoPickerSheet(
          title: l10n.birthDate,
          onCancel: () => Navigator.pop(context),
          onDone: () => Navigator.pop(context, temp),
          child: SizedBox(
            height: 220,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              dateOrder: DatePickerDateOrder.dmy,
              initialDateTime: initial,
              minimumDate: DateTime(1900, 1, 1),
              maximumDate: now,
              onDateTimeChanged: (d) => temp = DateTime(d.year, d.month, d.day),
            ),
          ),
        );
      },
    );
    if (picked != null) setState(() => birthDate = picked);
  }

  Future<void> _pickTimeWheel() async {
    final initial = birthTime ?? TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      initialEntryMode: TimePickerEntryMode.dialOnly,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => birthTime = picked);
  }

  tz.TZDateTime _toLocalTz(DateTime d, TimeOfDay t, String tzId) {
    final loc = tz.getLocation(tzId);
    return tz.TZDateTime(loc, d.year, d.month, d.day, t.hour, t.minute);
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    FocusScope.of(context).unfocus();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final name = nameCtrl.text.trim();

    if (name.isEmpty || birthDate == null || birthTime == null || _city == null) {
      _toast(l10n.errorFillProfile);
      return;
    }

    final place = _city!;
    final birthLocal = _toLocalTz(birthDate!, birthTime!, place.tzId);
    final birthUtc = birthLocal.toUtc();

    setState(() => saving = true);
    try {
      final swe = SwissEphemerisService();
      await swe.init();
      final asc = swe.calcAscendantLongitudeUtc(birthUtc, lat: place.lat, lon: place.lon);
      final hd = HumanDesignCalculator(swe);
      final hdRes = await hd.calculate(birthUtc: birthUtc, lat: place.lat, lon: place.lon);
      final numRes = computeNumerology(fullName: name, birthDate: birthDate!);

      final hdData = hdRes.toJson();
      final sunLon = findBodyLongitude(hdData, true, 'Sun') ?? 0.0;

      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

      await userRef.set({
        'name': name,
        'birthPlaceLabel': place.label,
        'place': {
          'country': place.country,
          'city': place.city,
          'label': place.label,
          'lat': place.lat,
          'lon': place.lon,
          'tzId': place.tzId,
        },
        'birthDateStr': '${birthDate!.year}-${_p2(birthDate!.month)}-${_p2(birthDate!.day)}',
        'birthTimeStr': '${_p2(birthTime!.hour)}:${_p2(birthTime!.minute)}',
        'birthUtc': birthUtc.toIso8601String(),
        'birthTzId': place.tzId,
        'astro': {
          'ascendantDeg': asc,
          'ascendantSign': getZodiacSign(context, asc),
          'sunSign': getZodiacSign(context, sunLon),
          'sunDeg': sunLon,
        },
        'humanDesignBase': hdData,
        'numerology': numRes.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await userRef.collection('aiInsights').doc('latest').delete();
      final now = DateTime.now();
      final todayKey = '${now.year}-${_p2(now.month)}-${_p2(now.day)}';
      await userRef.collection('dailyTips').doc(todayKey).delete();
      await userRef.update({
        'aiGates.dailyTip': FieldValue.delete(),
        'aiGates.profile': FieldValue.delete(),
      });

      if (mounted) {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) _toast(l10n.errorSavingProfile(e.toString()));
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final countries = _countries();
    final cities = _citiesForCountry(_country);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.createProfile)),
      body: _Shell(
        child: ListView(
          children: [
            _PrimaryCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.baseData, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Text(l10n.baseDataDesc, style: TextStyle(color: cs.onSurfaceVariant)),
                  const SizedBox(height: 14),
                  TextField(controller: nameCtrl, decoration: InputDecoration(labelText: l10n.name)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickDateWheel,
                          icon: const Icon(Icons.cake_outlined),
                          label: Text(birthDate == null ? l10n.selectDate : _fmtDate(birthDate)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickTimeWheel,
                          icon: const Icon(Icons.schedule),
                          label: Text(birthTime == null ? l10n.selectTime : _fmtTime(birthTime)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_places.isEmpty)
                    const Center(child: Padding(padding: EdgeInsets.all(12), child: LoadingWidget()))
                  else ...[
                    DropdownButtonFormField<String>(
                      key: ValueKey('country_$_country'),
                      initialValue: _country, 
                      decoration: InputDecoration(labelText: l10n.country),
                      items: countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (v) {
                        setState(() {
                          _country = v;
                          final newCities = _citiesForCountry(_country);
                          _city = newCities.isNotEmpty ? newCities.first : null;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<Place>(
                      key: ValueKey('city_$_city'),
                      initialValue: _city, 
                      decoration: InputDecoration(labelText: l10n.city),
                      items: cities.map((p) => DropdownMenuItem(value: p, child: Text(p.city))).toList(),
                      onChanged: (v) => setState(() => _city = v),
                    ),
                  ],
                  const SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: saving ? null : _save,
                    child: saving ? const LoadingWidget(size: 24) : Text(l10n.saveProfile),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CupertinoPickerSheet extends StatelessWidget {
  final String title;
  final VoidCallback onCancel;
  final VoidCallback onDone;
  final Widget child;
  const _CupertinoPickerSheet({required this.title, required this.onCancel, required this.onDone, required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Material(
      color: cs.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
            child: Row(
              children: [
                TextButton(onPressed: onCancel, child: Text(l10n.cancel)),
                Expanded(child: Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900))),
                TextButton(onPressed: onDone, child: Text(l10n.ok)),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: child),
        ],
      ),
    );
  }
}

/// ---------------- SUMMARY ----------------

class ProfileSummaryScreen extends StatefulWidget {
  const ProfileSummaryScreen({super.key});
  @override
  State<ProfileSummaryScreen> createState() => _ProfileSummaryScreenState();
}

class _ProfileSummaryScreenState extends State<ProfileSummaryScreen> {
  bool _didAutoDaily = false;
  late AiActions _ai;

  bool _loadingInsights = false;
  bool _loadingTip = false;

  @override
  void initState() {
    super.initState();
    _ai = AiActions(context: context);
    _autoGenerateDailyTip();
  }

  Future<void> _autoGenerateDailyTip() async {
    if (_didAutoDaily) return;
    _didAutoDaily = true;
    if (mounted) setState(() => _loadingTip = true);
    try {
      final callable = FirebaseFunctions.instance.httpsCallable('generateDailyTipIfNeeded');
      await callable.call({
        'dateKey': _ai.todayKeyLocal(),
        'language': _ai.getLanguageCode(),
      });
    } catch (_) {} finally {
      if (mounted) setState(() => _loadingTip = false);
    }
  }

  String _firstName(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    return parts.isEmpty ? '' : parts.first;
  }

  String _formatDateStr(String? key, String defaultTitle) {
    if (key == null || !key.contains('-')) return defaultTitle;
    final parts = key.split('-');
    if (parts.length != 3) return key;
    return '${parts[2]}-${parts[1]}-${parts[0]}';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final insightsRef = userRef.collection('aiInsights').doc('latest');
    final lastTipQuery = userRef.collection('dailyTips').orderBy('dateKey', descending: true).limit(1);
    final l10n = AppLocalizations.of(context)!;

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: userRef.snapshots(),
      builder: (context, userSnap) {
        if (userSnap.connectionState == ConnectionState.waiting && !userSnap.hasData) {
          return const Center(child: LoadingWidget());
        }

        final u = userSnap.data?.data() ?? {};
        final fullName = (u['name'] ?? '').toString().trim();
        final first = _firstName(fullName);
        final birthDateStr = (u['birthDateStr'] ?? '').toString();
        final birthTimeStr = (u['birthTimeStr'] ?? '').toString();
        final birthDateText = [birthDateStr, birthTimeStr].where((s) => s.trim().isNotEmpty).join(' • ');
        final placeLabel = (u['birthPlaceLabel'] ?? (u['place'] as Map?)?['label'] ?? '').toString();

        final hdBase = (u['humanDesignBase'] as Map?)?.cast<String, dynamic>();
        final astro = (u['astro'] as Map?)?.cast<String, dynamic>() ?? {};

        final sunSign = astro['sunSign'] ?? (findBodyLongitude(hdBase, true, 'Sun') != null ? getZodiacSign(context, findBodyLongitude(hdBase, true, 'Sun')!) : '—');
        final ascSign = astro['ascendantSign'] ?? (astro['ascendantDeg'] != null ? getZodiacSign(context, (astro['ascendantDeg'] as num).toDouble()) : '—');

        final storedNum = u['numerology'] as Map?;
        final numerology = storedNum != null ? NumerologyResult(lifePath: storedNum['lifePath'], expression: storedNum['expression'], soul: storedNum['soul'], personality: storedNum['personality']) : null;

        return ListView(
          key: const PageStorageKey('profile_summary_list'),
          children: [
            _PrimaryCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.transparent,
                        child: Image(image: AssetImage('assets/icon/card.png')),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          first.isEmpty ? l10n.greetingEmpty : l10n.greeting(first),
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                        ),
                      ),
                      IconButton(
                        tooltip: l10n.update,
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileInputScreen())),
                        icon: const Icon(Icons.edit_outlined),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (birthDateText.isNotEmpty)
                        Expanded(child: _InfoRow(icon: Icons.cake_outlined, label: l10n.birthDate, value: birthDateText)),
                      if (birthDateText.isNotEmpty && placeLabel.isNotEmpty) const SizedBox(width: 12),
                      if (placeLabel.isNotEmpty)
                        Expanded(child: _InfoRow(icon: Icons.place_outlined, label: l10n.birthPlace, value: placeLabel, isRightAligned: true)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _PrimaryCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.hdTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 12),
                  if (hdBase == null) Text(l10n.hdCalculating) else HumanDesignSection(hd: hdBase),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _PrimaryCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.astroTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 12),
                  Card(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          _KeyValueRow(icon: Icons.wb_sunny_outlined, label: l10n.zodiacSign, value: sunSign),
                          const SizedBox(height: 10),
                          _KeyValueRow(icon: Icons.north_outlined, label: l10n.ascendant, value: ascSign),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _PrimaryCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.numTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 12),
                  if (numerology == null) const Text('—') else 
                    Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            _KeyValueRow(icon: Icons.tag_outlined, label: l10n.lifePath, value: numerology.lifePath.toString()),
                            const SizedBox(height: 10),
                            _KeyValueRow(icon: Icons.tag_outlined, label: l10n.expression, value: numerology.expression.toString()),
                            const SizedBox(height: 10),
                            _KeyValueRow(icon: Icons.tag_outlined, label: l10n.soul, value: numerology.soul.toString()),
                            const SizedBox(height: 10),
                            _KeyValueRow(icon: Icons.tag_outlined, label: l10n.personality, value: numerology.personality.toString()),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: insightsRef.snapshots(),
              builder: (context, insSnap) {
                final isLoading = _loadingInsights || (insSnap.connectionState == ConnectionState.waiting && !insSnap.hasData);
                final ins = insSnap.data?.data();
                final exists = insSnap.data?.exists ?? false;

                Widget inner;
                if (!exists) {
                  inner = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.profileInsights, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 10),
                      Text(l10n.noInsights),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: isLoading ? null : () async {
                          setState(() => _loadingInsights = true);
                          await _ai.runInsightsBehindRewardedAd();
                          if (mounted) setState(() => _loadingInsights = false);
                        },
                        child: Text(l10n.generateInsights),
                      ),
                    ],
                  );
                } else {
                  final data = ins ?? {};
                  inner = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(l10n.profileInsights, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900))),
                          TextButton.icon(
                            onPressed: isLoading ? null : () async {
                              setState(() => _loadingInsights = true);
                              await _ai.runInsightsBehindRewardedAd();
                              if (mounted) setState(() => _loadingInsights = false);
                            },
                            icon: const Icon(Icons.auto_awesome_outlined),
                            label: Text(l10n.update),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(data['summary']?.toString() ?? '—'),
                      const SizedBox(height: 12),
                      Text(l10n.profilePillars, style: const TextStyle(fontWeight: FontWeight.w900)),
                      _bullets(data['insights'] ?? []),
                    ],
                  );
                }

                return _PrimaryCard(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(opacity: isLoading ? 0.4 : 1.0, child: inner),
                      if (isLoading) const LoadingWidget(),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: lastTipQuery.snapshots(),
              builder: (context, tipsSnap) {
                final isLoading = _loadingTip || (tipsSnap.connectionState == ConnectionState.waiting && !tipsSnap.hasData);
                
                final tips = tipsSnap.data?.docs ?? [];
                final hasTodayTip = tips.isNotEmpty && tips.first.id == _ai.todayKeyLocal();
                final lastTipDoc = tips.isNotEmpty ? tips.first : null;
                final lastTipData = lastTipDoc?.data() ?? {};
                
                final formattedDate = lastTipDoc != null 
                    ? _formatDateStr(lastTipDoc.id, l10n.dailyTip) 
                    : _formatDateStr(_ai.todayKeyLocal(), l10n.dailyTip);

                final inner = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.dailyTip, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 10),
                    Text(formattedDate, style: const TextStyle(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 8),
                    
                    if (!hasTodayTip) ...[
                      ElevatedButton.icon(
                        onPressed: isLoading ? null : () async {
                          setState(() => _loadingTip = true);
                          await _ai.runTipsBehindRewardedAd();
                          if (mounted) setState(() => _loadingTip = false);
                        },
                        icon: const Icon(Icons.auto_awesome_outlined),
                        label: Text(l10n.getDailyTip),
                      ),
                      const SizedBox(height: 14),
                    ],

                    if (lastTipDoc != null)
                      Text(lastTipData['text']?.toString() ?? '—')
                    else
                      Text(l10n.watchAdForTip),
                  ],
                );

                return _PrimaryCard(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(opacity: isLoading ? 0.4 : 1.0, child: inner),
                      if (isLoading) const LoadingWidget(),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _bullets(List items) {
    if (items.isEmpty) return const Text('—');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((t) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('• '), Expanded(child: Text(t.toString()))]))).toList(),
    );
  }
}

class _Shell extends StatelessWidget {
  final Widget child;
  const _Shell({required this.child});
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 560), child: Padding(padding: const EdgeInsets.all(16), child: child))));
  }
}

class _PrimaryCard extends StatelessWidget {
  final Widget child;
  const _PrimaryCard({required this.child});
  @override
  Widget build(BuildContext context) {
    return Card(child: Padding(padding: const EdgeInsets.all(16), child: child));
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value, this.isRightAligned = false});
  final IconData icon; final String label; final String value; final bool isRightAligned;
  @override
  Widget build(BuildContext context) {
    final textCol = Column(
      crossAxisAlignment: isRightAligned ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 2),
        Text(value, style: Theme.of(context).textTheme.bodyMedium, textAlign: isRightAligned ? TextAlign.right : TextAlign.left),
      ],
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: isRightAligned ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 10),
        if (isRightAligned) textCol else Expanded(child: textCol),
      ],
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow({required this.icon, required this.label, required this.value});
  final IconData icon; final String label; final String value;
  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w600,
    );
    final valueStyle = Theme.of(context).textTheme.titleSmall;

    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Row(
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(label, style: labelStyle)),
            ],
          ),
        ),
        Expanded(
          flex: 7,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              value,
              style: valueStyle,
              textAlign: TextAlign.right,
            ),
          ),
        ),
      ],
    );
  }
}
